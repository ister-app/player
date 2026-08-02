import 'dart:convert';

import 'package:player/graphql/schema.graphql.dart';

/// One row of the filter builder: field + operator + (usually) a value.
/// Mutable on purpose — the builder sheet edits rows in place.
class FilterConditionModel {
  Enum$FilterField field;
  Enum$FilterOperator operator;
  String? value;

  FilterConditionModel({
    required this.field,
    required this.operator,
    this.value,
  });

  Map<String, dynamic> toJson() => {
        'field': field.name,
        'operator': operator.name,
        if (value != null) 'value': value,
      };

  static FilterConditionModel? fromJson(Map<String, dynamic> json) {
    final field = Enum$FilterField.values
        .cast<Enum$FilterField?>()
        .firstWhere((f) => f!.name == json['field'], orElse: () => null);
    final operator = Enum$FilterOperator.values
        .cast<Enum$FilterOperator?>()
        .firstWhere((o) => o!.name == json['operator'], orElse: () => null);
    if (field == null || operator == null) return null;
    return FilterConditionModel(
        field: field, operator: operator, value: json['value'] as String?);
  }

  Input$FilterConditionInput toInput() => Input$FilterConditionInput(
      field: field, $operator: operator, value: value);
}

/// A filter group: conditions and nested subgroups combined with ALL/ANY, plus
/// an optional total-result limit (top-level group only, like the server).
///
/// The JSON shape matches the GraphQL input (enum names as strings), so one
/// format serves SharedPreferences, the URL query param and the builder's
/// round-trip from a saved view's `filter` tree.
class MediaFilterModel {
  Enum$FilterMatch match;
  List<FilterConditionModel> conditions;
  List<MediaFilterModel> groups;
  int? limit;

  MediaFilterModel({
    this.match = Enum$FilterMatch.ALL,
    List<FilterConditionModel>? conditions,
    List<MediaFilterModel>? groups,
    this.limit,
  })  : conditions = conditions ?? [],
        groups = groups ?? [];

  bool get isEmpty =>
      conditions.isEmpty && groups.every((g) => g.isEmpty);

  /// Conditions across the whole tree, for the "Filter (N)" chip.
  int get conditionCount =>
      conditions.length +
      groups.fold(0, (sum, g) => sum + g.conditionCount);

  Map<String, dynamic> toJson() => {
        'match': match.name,
        if (conditions.isNotEmpty)
          'conditions': conditions.map((c) => c.toJson()).toList(),
        if (groups.isNotEmpty)
          'groups': groups.map((g) => g.toJson()).toList(),
        if (limit != null) 'limit': limit,
      };

  /// Lenient parse: unknown fields/operators (an older app against a newer
  /// server, or a hand-edited URL) drop out instead of failing the whole tree.
  static MediaFilterModel fromJson(Map<String, dynamic> json) {
    final match = Enum$FilterMatch.values
        .cast<Enum$FilterMatch?>()
        .firstWhere((m) => m!.name == json['match'],
            orElse: () => null);
    return MediaFilterModel(
      match: match ?? Enum$FilterMatch.ALL,
      conditions: ((json['conditions'] as List<dynamic>?) ?? [])
          .whereType<Map<String, dynamic>>()
          .map(FilterConditionModel.fromJson)
          .whereType<FilterConditionModel>()
          .toList(),
      groups: ((json['groups'] as List<dynamic>?) ?? [])
          .whereType<Map<String, dynamic>>()
          .map(MediaFilterModel.fromJson)
          .toList(),
      limit: json['limit'] as int?,
    );
  }

  String encode() => jsonEncode(toJson());

  static MediaFilterModel? decode(String? encoded) {
    if (encoded == null || encoded.isEmpty) return null;
    try {
      final json = jsonDecode(encoded);
      if (json is! Map<String, dynamic>) return null;
      final model = MediaFilterModel.fromJson(json);
      return model.isEmpty && model.limit == null ? null : model;
    } catch (_) {
      return null;
    }
  }

  Input$MediaFilterInput toInput() => Input$MediaFilterInput(
        match: match,
        conditions: conditions.map((c) => c.toInput()).toList(),
        groups: groups.map((g) => g.toInput()).toList(),
        limit: limit,
      );

  MediaFilterModel copy() => MediaFilterModel.fromJson(toJson());
}
