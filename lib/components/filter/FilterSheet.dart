import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/fragmentSavedView.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/SavedViewService.dart';
import '../../utils/filter/FilterCatalog.dart';
import '../../utils/filter/MediaFilterModel.dart';

/// Opens the custom-filter builder for the current browse kind. Calls
/// [onApply] with the edited filter (null when cleared/empty) when the user
/// applies it — directly or by saving/loading a view.
Future<void> showFilterSheet(
  BuildContext context, {
  required Enum$FilterKind kind,
  String? libraryId,
  MediaFilterModel? initial,
  required void Function(MediaFilterModel?) onApply,
}) {
  final client = GraphQLProvider.of(context).value;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: FilterSheet(
        client: client,
        kind: kind,
        libraryId: libraryId,
        initial: initial,
        onApply: onApply,
      ),
    ),
  );
}

class FilterSheet extends StatefulWidget {
  final GraphQLClient client;
  final Enum$FilterKind kind;
  final String? libraryId;
  final MediaFilterModel? initial;
  final void Function(MediaFilterModel?) onApply;

  const FilterSheet({
    super.key,
    required this.client,
    required this.kind,
    this.libraryId,
    this.initial,
    required this.onApply,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late MediaFilterModel _model;
  late final TextEditingController _limitController;
  Future<List<Fragment$fragmentSavedView>?>? _savedViews;

  @override
  void initState() {
    super.initState();
    _model = widget.initial?.copy() ?? MediaFilterModel();
    if (_model.conditions.isEmpty && _model.groups.isEmpty) {
      _model.conditions.add(_defaultCondition());
    }
    _limitController =
        TextEditingController(text: _model.limit?.toString() ?? '');
    _savedViews = SavedViewService.list(widget.client,
        libraryId: widget.libraryId, kind: widget.kind);
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  FilterConditionModel _defaultCondition() {
    final field = FilterCatalog.fieldsFor(widget.kind).first;
    return FilterConditionModel(
        field: field, operator: FilterCatalog.operatorsFor(field).first);
  }

  void _apply() {
    _model.limit = int.tryParse(_limitController.text.trim());
    // Rows whose operator wants a value but got none are dropped rather than
    // sent as invalid conditions.
    _prune(_model);
    final result = _model.isEmpty && _model.limit == null ? null : _model;
    widget.onApply(result);
    Navigator.of(context).pop();
  }

  void _prune(MediaFilterModel group) {
    group.conditions.removeWhere((c) =>
        FilterCatalog.operatorNeedsValue(c.operator) &&
        (c.value == null || c.value!.trim().isEmpty));
    for (final sub in group.groups) {
      _prune(sub);
    }
    group.groups.removeWhere((g) => g.isEmpty);
  }

  Future<void> _saveAsView() async {
    final loc = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final nameController = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.filterSaveAsView),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: InputDecoration(labelText: loc.filterViewNameLabel),
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(nameController.text),
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      ),
    );
    if (name == null || name.trim().isEmpty || !mounted) return;
    _model.limit = int.tryParse(_limitController.text.trim());
    _prune(_model);
    final view = await SavedViewService.create(
      widget.client,
      name: name.trim(),
      kind: widget.kind,
      libraryId: widget.libraryId,
      filter: _model,
    );
    if (!mounted) return;
    if (view == null) {
      messenger.showSnackBar(SnackBar(content: Text(loc.filterViewSaveFailed)));
      return;
    }
    setState(() {
      _savedViews = SavedViewService.list(widget.client,
          libraryId: widget.libraryId, kind: widget.kind);
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _groupHeader(context, _model, topLevel: true),
            const SizedBox(height: 4),
            ..._groupRows(context, _model),
            for (final sub in _model.groups) _subgroupCard(context, sub),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(loc.filterLimitTo.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(letterSpacing: 1.2)),
                const SizedBox(width: 12),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: _limitController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(isDense: true),
                  ),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: _apply,
                  child: Text(loc.filterApply),
                ),
              ],
            ),
            _savedViewsSection(context),
          ],
        ),
      ),
    );
  }

  /// Match-mode dropdown plus the +/⋮ controls, for the top group and for
  /// each subgroup (subgroups get a remove action instead of the menu).
  Widget _groupHeader(BuildContext context, MediaFilterModel group,
      {required bool topLevel}) {
    final loc = AppLocalizations.of(context)!;
    return Row(
      children: [
        DropdownButton<Enum$FilterMatch>(
          value: group.match == Enum$FilterMatch.ANY
              ? Enum$FilterMatch.ANY
              : Enum$FilterMatch.ALL,
          isDense: true,
          items: [
            DropdownMenuItem(
                value: Enum$FilterMatch.ALL, child: Text(loc.filterMatchAll)),
            DropdownMenuItem(
                value: Enum$FilterMatch.ANY, child: Text(loc.filterMatchAny)),
          ],
          onChanged: (value) =>
              setState(() => group.match = value ?? Enum$FilterMatch.ALL),
        ),
        const SizedBox(width: 4),
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: loc.filterAddCondition,
          onPressed: () =>
              setState(() => group.conditions.add(_defaultCondition())),
        ),
        if (topLevel)
          MenuAnchor(
            menuChildren: [
              MenuItemButton(
                leadingIcon: const Icon(Icons.account_tree_outlined),
                onPressed: () => setState(() => _model.groups
                    .add(MediaFilterModel(conditions: [_defaultCondition()]))),
                child: Text(loc.filterAddSubgroup),
              ),
              MenuItemButton(
                leadingIcon: const Icon(Icons.bookmark_add_outlined),
                onPressed: _saveAsView,
                child: Text(loc.filterSaveAsView),
              ),
              MenuItemButton(
                leadingIcon: const Icon(Icons.filter_alt_off_outlined),
                onPressed: () {
                  widget.onApply(null);
                  Navigator.of(context).pop();
                },
                child: Text(loc.filterClear),
              ),
            ],
            builder: (context, controller, child) => IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () =>
                  controller.isOpen ? controller.close() : controller.open(),
            ),
          )
        else
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () => setState(() => _model.groups.remove(group)),
          ),
      ],
    );
  }

  List<Widget> _groupRows(BuildContext context, MediaFilterModel group) {
    return [
      for (final condition in group.conditions)
        _ConditionRow(
          // Rebuild the row when its field/operator identity changes; text
          // edits stay local to the row's own controller.
          key: ObjectKey(condition),
          kind: widget.kind,
          condition: condition,
          onChanged: () => setState(() {}),
          onRemove: () => setState(() => group.conditions.remove(condition)),
        ),
    ];
  }

  Widget _subgroupCard(BuildContext context, MediaFilterModel sub) {
    return Card(
      margin: const EdgeInsets.only(top: 8, left: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _groupHeader(context, sub, topLevel: false),
            ..._groupRows(context, sub),
          ],
        ),
      ),
    );
  }

  Widget _savedViewsSection(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return FutureBuilder<List<Fragment$fragmentSavedView>?>(
      future: _savedViews,
      builder: (context, snapshot) {
        final views = snapshot.data;
        if (views == null || views.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(loc.filterSavedViews,
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final view in views)
                  InputChip(
                    label: Text(view.name),
                    onPressed: () {
                      widget.onApply(SavedViewService.filterOf(view));
                      Navigator.of(context).pop();
                    },
                    deleteButtonTooltipMessage: loc.filterDeleteView,
                    onDeleted: () async {
                      await SavedViewService.delete(widget.client, view.id);
                      if (!mounted) return;
                      setState(() {
                        _savedViews = SavedViewService.list(widget.client,
                            libraryId: widget.libraryId, kind: widget.kind);
                      });
                    },
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// One condition row: field, operator and a value editor matching the field's
/// value kind. Owns its text controller so typing doesn't rebuild the sheet.
class _ConditionRow extends StatefulWidget {
  final Enum$FilterKind kind;
  final FilterConditionModel condition;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  const _ConditionRow({
    super.key,
    required this.kind,
    required this.condition,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  State<_ConditionRow> createState() => _ConditionRowState();
}

class _ConditionRowState extends State<_ConditionRow> {
  late final TextEditingController _valueController;

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController(
        text: FilterCatalog.decodeValue(widget.condition.field,
            widget.condition.operator, widget.condition.value));
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  void _setField(Enum$FilterField? field) {
    if (field == null) return;
    final condition = widget.condition;
    condition.field = field;
    final operators = FilterCatalog.operatorsFor(field);
    if (!operators.contains(condition.operator)) {
      condition.operator = operators.first;
    }
    condition.value = null;
    _valueController.clear();
    widget.onChanged();
  }

  void _setOperator(Enum$FilterOperator? operator) {
    if (operator == null) return;
    widget.condition.operator = operator;
    _storeValue();
    widget.onChanged();
  }

  void _storeValue() {
    final condition = widget.condition;
    condition.value = FilterCatalog.operatorNeedsValue(condition.operator)
        ? FilterCatalog.encodeValue(
            condition.field, condition.operator, _valueController.text)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final condition = widget.condition;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: DropdownButton<Enum$FilterField>(
              value: condition.field,
              isExpanded: true,
              isDense: true,
              items: [
                for (final field in FilterCatalog.fieldsFor(widget.kind))
                  DropdownMenuItem(
                      value: field, child: Text(filterFieldLabel(loc, field))),
              ],
              onChanged: _setField,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: DropdownButton<Enum$FilterOperator>(
              value: condition.operator,
              isExpanded: true,
              isDense: true,
              items: [
                for (final op in FilterCatalog.operatorsFor(condition.field))
                  DropdownMenuItem(
                      value: op, child: Text(filterOperatorLabel(loc, op))),
              ],
              onChanged: _setOperator,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(flex: 3, child: _valueEditor(context, loc, condition)),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: widget.onRemove,
          ),
        ],
      ),
    );
  }

  Widget _valueEditor(BuildContext context, AppLocalizations loc,
      FilterConditionModel condition) {
    if (!FilterCatalog.operatorNeedsValue(condition.operator)) {
      return const SizedBox.shrink();
    }
    final valueKind = FilterCatalog.valueKindOf(condition.field);
    if (valueKind == FilterValueKind.boolean) {
      final isTrue = condition.value != 'false';
      condition.value ??= 'true';
      return DropdownButton<bool>(
        value: isTrue,
        isExpanded: true,
        isDense: true,
        items: [
          DropdownMenuItem(value: true, child: Text(loc.filterValueTrue)),
          DropdownMenuItem(value: false, child: Text(loc.filterValueFalse)),
        ],
        onChanged: (value) {
          condition.value = (value ?? true).toString();
          widget.onChanged();
        },
      );
    }
    final numeric = valueKind == FilterValueKind.number ||
        condition.operator == Enum$FilterOperator.IN_LAST_DAYS;
    final dateLike = valueKind == FilterValueKind.date &&
        condition.operator != Enum$FilterOperator.IN_LAST_DAYS;
    return TextField(
      controller: _valueController,
      keyboardType: numeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        isDense: true,
        hintText: dateLike ? loc.filterDateHint : loc.filterValueHint,
      ),
      onChanged: (_) => _storeValue(),
    );
  }
}

String filterFieldLabel(AppLocalizations loc, Enum$FilterField field) {
  switch (field) {
    case Enum$FilterField.TITLE:
      return loc.filterFieldTitle;
    case Enum$FilterField.ARTIST_NAME:
      return loc.filterFieldArtistName;
    case Enum$FilterField.ALBUM_NAME:
      return loc.filterFieldAlbumName;
    case Enum$FilterField.RELEASE_YEAR:
      return loc.filterFieldReleaseYear;
    case Enum$FilterField.BIRTH_YEAR:
      return loc.filterFieldBirthYear;
    case Enum$FilterField.GENRE:
      return loc.filterFieldGenre;
    case Enum$FilterField.RATING:
      return loc.filterFieldRating;
    case Enum$FilterField.PLAY_COUNT:
      return loc.filterFieldPlayCount;
    case Enum$FilterField.LAST_PLAYED_AT:
      return loc.filterFieldLastPlayedAt;
    case Enum$FilterField.DURATION:
      return loc.filterFieldDuration;
    case Enum$FilterField.WATCHED:
      return loc.filterFieldWatched;
    case Enum$FilterField.DATE_ADDED:
      return loc.filterFieldDateAdded;
    case Enum$FilterField.$unknown:
      return field.name;
  }
}

String filterOperatorLabel(AppLocalizations loc, Enum$FilterOperator op) {
  switch (op) {
    case Enum$FilterOperator.CONTAINS:
      return loc.filterOpContains;
    case Enum$FilterOperator.NOT_CONTAINS:
      return loc.filterOpNotContains;
    case Enum$FilterOperator.EQUALS:
      return loc.filterOpEquals;
    case Enum$FilterOperator.NOT_EQUALS:
      return loc.filterOpNotEquals;
    case Enum$FilterOperator.LESS_THAN:
      return loc.filterOpLessThan;
    case Enum$FilterOperator.GREATER_THAN:
      return loc.filterOpGreaterThan;
    case Enum$FilterOperator.BEFORE:
      return loc.filterOpBefore;
    case Enum$FilterOperator.AFTER:
      return loc.filterOpAfter;
    case Enum$FilterOperator.IN_LAST_DAYS:
      return loc.filterOpInLastDays;
    case Enum$FilterOperator.IS_SET:
      return loc.filterOpIsSet;
    case Enum$FilterOperator.IS_NOT_SET:
      return loc.filterOpIsNotSet;
    case Enum$FilterOperator.$unknown:
      return op.name;
  }
}
