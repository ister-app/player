import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Fragment$fragmentBookProgress {
  Fragment$fragmentBookProgress({
    required this.mode,
    required this.progress,
    required this.finished,
    this.durationInMilliseconds,
    this.positionInMilliseconds,
    this.$__typename = 'BookProgress',
  });

  factory Fragment$fragmentBookProgress.fromJson(Map<String, dynamic> json) {
    final l$mode = json['mode'];
    final l$progress = json['progress'];
    final l$finished = json['finished'];
    final l$durationInMilliseconds = json['durationInMilliseconds'];
    final l$positionInMilliseconds = json['positionInMilliseconds'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentBookProgress(
      mode: fromJson$Enum$BookProgressMode((l$mode as String)),
      progress: (l$progress as num).toDouble(),
      finished: (l$finished as bool),
      durationInMilliseconds: (l$durationInMilliseconds as int?),
      positionInMilliseconds: (l$positionInMilliseconds as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$BookProgressMode mode;

  final double progress;

  final bool finished;

  final int? durationInMilliseconds;

  final int? positionInMilliseconds;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$mode = mode;
    _resultData['mode'] = toJson$Enum$BookProgressMode(l$mode);
    final l$progress = progress;
    _resultData['progress'] = l$progress;
    final l$finished = finished;
    _resultData['finished'] = l$finished;
    final l$durationInMilliseconds = durationInMilliseconds;
    _resultData['durationInMilliseconds'] = l$durationInMilliseconds;
    final l$positionInMilliseconds = positionInMilliseconds;
    _resultData['positionInMilliseconds'] = l$positionInMilliseconds;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$mode = mode;
    final l$progress = progress;
    final l$finished = finished;
    final l$durationInMilliseconds = durationInMilliseconds;
    final l$positionInMilliseconds = positionInMilliseconds;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$mode,
      l$progress,
      l$finished,
      l$durationInMilliseconds,
      l$positionInMilliseconds,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentBookProgress ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$mode = mode;
    final lOther$mode = other.mode;
    if (l$mode != lOther$mode) {
      return false;
    }
    final l$progress = progress;
    final lOther$progress = other.progress;
    if (l$progress != lOther$progress) {
      return false;
    }
    final l$finished = finished;
    final lOther$finished = other.finished;
    if (l$finished != lOther$finished) {
      return false;
    }
    final l$durationInMilliseconds = durationInMilliseconds;
    final lOther$durationInMilliseconds = other.durationInMilliseconds;
    if (l$durationInMilliseconds != lOther$durationInMilliseconds) {
      return false;
    }
    final l$positionInMilliseconds = positionInMilliseconds;
    final lOther$positionInMilliseconds = other.positionInMilliseconds;
    if (l$positionInMilliseconds != lOther$positionInMilliseconds) {
      return false;
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$fragmentBookProgress
    on Fragment$fragmentBookProgress {
  CopyWith$Fragment$fragmentBookProgress<Fragment$fragmentBookProgress>
  get copyWith => CopyWith$Fragment$fragmentBookProgress(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentBookProgress<TRes> {
  factory CopyWith$Fragment$fragmentBookProgress(
    Fragment$fragmentBookProgress instance,
    TRes Function(Fragment$fragmentBookProgress) then,
  ) = _CopyWithImpl$Fragment$fragmentBookProgress;

  factory CopyWith$Fragment$fragmentBookProgress.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentBookProgress;

  TRes call({
    Enum$BookProgressMode? mode,
    double? progress,
    bool? finished,
    int? durationInMilliseconds,
    int? positionInMilliseconds,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentBookProgress<TRes>
    implements CopyWith$Fragment$fragmentBookProgress<TRes> {
  _CopyWithImpl$Fragment$fragmentBookProgress(this._instance, this._then);

  final Fragment$fragmentBookProgress _instance;

  final TRes Function(Fragment$fragmentBookProgress) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? mode = _undefined,
    Object? progress = _undefined,
    Object? finished = _undefined,
    Object? durationInMilliseconds = _undefined,
    Object? positionInMilliseconds = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentBookProgress(
      mode: mode == _undefined || mode == null
          ? _instance.mode
          : (mode as Enum$BookProgressMode),
      progress: progress == _undefined || progress == null
          ? _instance.progress
          : (progress as double),
      finished: finished == _undefined || finished == null
          ? _instance.finished
          : (finished as bool),
      durationInMilliseconds: durationInMilliseconds == _undefined
          ? _instance.durationInMilliseconds
          : (durationInMilliseconds as int?),
      positionInMilliseconds: positionInMilliseconds == _undefined
          ? _instance.positionInMilliseconds
          : (positionInMilliseconds as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentBookProgress<TRes>
    implements CopyWith$Fragment$fragmentBookProgress<TRes> {
  _CopyWithStubImpl$Fragment$fragmentBookProgress(this._res);

  TRes _res;

  call({
    Enum$BookProgressMode? mode,
    double? progress,
    bool? finished,
    int? durationInMilliseconds,
    int? positionInMilliseconds,
    String? $__typename,
  }) => _res;
}

const fragmentDefinitionfragmentBookProgress = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentBookProgress'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'BookProgress'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'mode'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'progress'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'finished'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'durationInMilliseconds'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'positionInMilliseconds'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentfragmentBookProgress = DocumentNode(
  definitions: [fragmentDefinitionfragmentBookProgress],
);
