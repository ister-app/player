import 'package:gql/ast.dart';

class Mutation$refreshPodcasts {
  Mutation$refreshPodcasts({
    required this.refreshPodcasts,
    this.$__typename = 'Mutation',
  });

  factory Mutation$refreshPodcasts.fromJson(Map<String, dynamic> json) {
    final l$refreshPodcasts = json['refreshPodcasts'];
    final l$$__typename = json['__typename'];
    return Mutation$refreshPodcasts(
      refreshPodcasts: (l$refreshPodcasts as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool refreshPodcasts;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$refreshPodcasts = refreshPodcasts;
    _resultData['refreshPodcasts'] = l$refreshPodcasts;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$refreshPodcasts = refreshPodcasts;
    final l$$__typename = $__typename;
    return Object.hashAll([l$refreshPodcasts, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$refreshPodcasts ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$refreshPodcasts = refreshPodcasts;
    final lOther$refreshPodcasts = other.refreshPodcasts;
    if (l$refreshPodcasts != lOther$refreshPodcasts) {
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

extension UtilityExtension$Mutation$refreshPodcasts
    on Mutation$refreshPodcasts {
  CopyWith$Mutation$refreshPodcasts<Mutation$refreshPodcasts> get copyWith =>
      CopyWith$Mutation$refreshPodcasts(this, (i) => i);
}

abstract class CopyWith$Mutation$refreshPodcasts<TRes> {
  factory CopyWith$Mutation$refreshPodcasts(
    Mutation$refreshPodcasts instance,
    TRes Function(Mutation$refreshPodcasts) then,
  ) = _CopyWithImpl$Mutation$refreshPodcasts;

  factory CopyWith$Mutation$refreshPodcasts.stub(TRes res) =
      _CopyWithStubImpl$Mutation$refreshPodcasts;

  TRes call({bool? refreshPodcasts, String? $__typename});
}

class _CopyWithImpl$Mutation$refreshPodcasts<TRes>
    implements CopyWith$Mutation$refreshPodcasts<TRes> {
  _CopyWithImpl$Mutation$refreshPodcasts(this._instance, this._then);

  final Mutation$refreshPodcasts _instance;

  final TRes Function(Mutation$refreshPodcasts) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? refreshPodcasts = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$refreshPodcasts(
      refreshPodcasts: refreshPodcasts == _undefined || refreshPodcasts == null
          ? _instance.refreshPodcasts
          : (refreshPodcasts as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$refreshPodcasts<TRes>
    implements CopyWith$Mutation$refreshPodcasts<TRes> {
  _CopyWithStubImpl$Mutation$refreshPodcasts(this._res);

  TRes _res;

  call({bool? refreshPodcasts, String? $__typename}) => _res;
}

const documentNodeMutationrefreshPodcasts = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'refreshPodcasts'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'refreshPodcasts'),
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
    ),
  ],
);
