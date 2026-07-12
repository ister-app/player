import 'package:gql/ast.dart';

class Variables$Mutation$unsubscribePodcast {
  factory Variables$Mutation$unsubscribePodcast({required String id}) =>
      Variables$Mutation$unsubscribePodcast._({r'id': id});

  Variables$Mutation$unsubscribePodcast._(this._$data);

  factory Variables$Mutation$unsubscribePodcast.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$id = data['id'];
    result$data['id'] = (l$id as String);
    return Variables$Mutation$unsubscribePodcast._(result$data);
  }

  Map<String, dynamic> _$data;

  String get id => (_$data['id'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$id = id;
    result$data['id'] = l$id;
    return result$data;
  }

  CopyWith$Variables$Mutation$unsubscribePodcast<
    Variables$Mutation$unsubscribePodcast
  >
  get copyWith =>
      CopyWith$Variables$Mutation$unsubscribePodcast(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$unsubscribePodcast ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    return Object.hashAll([l$id]);
  }
}

abstract class CopyWith$Variables$Mutation$unsubscribePodcast<TRes> {
  factory CopyWith$Variables$Mutation$unsubscribePodcast(
    Variables$Mutation$unsubscribePodcast instance,
    TRes Function(Variables$Mutation$unsubscribePodcast) then,
  ) = _CopyWithImpl$Variables$Mutation$unsubscribePodcast;

  factory CopyWith$Variables$Mutation$unsubscribePodcast.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$unsubscribePodcast;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Mutation$unsubscribePodcast<TRes>
    implements CopyWith$Variables$Mutation$unsubscribePodcast<TRes> {
  _CopyWithImpl$Variables$Mutation$unsubscribePodcast(
    this._instance,
    this._then,
  );

  final Variables$Mutation$unsubscribePodcast _instance;

  final TRes Function(Variables$Mutation$unsubscribePodcast) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Mutation$unsubscribePodcast._({
      ..._instance._$data,
      if (id != _undefined && id != null) 'id': (id as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$unsubscribePodcast<TRes>
    implements CopyWith$Variables$Mutation$unsubscribePodcast<TRes> {
  _CopyWithStubImpl$Variables$Mutation$unsubscribePodcast(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Mutation$unsubscribePodcast {
  Mutation$unsubscribePodcast({
    required this.unsubscribePodcast,
    this.$__typename = 'Mutation',
  });

  factory Mutation$unsubscribePodcast.fromJson(Map<String, dynamic> json) {
    final l$unsubscribePodcast = json['unsubscribePodcast'];
    final l$$__typename = json['__typename'];
    return Mutation$unsubscribePodcast(
      unsubscribePodcast: (l$unsubscribePodcast as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool unsubscribePodcast;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$unsubscribePodcast = unsubscribePodcast;
    _resultData['unsubscribePodcast'] = l$unsubscribePodcast;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$unsubscribePodcast = unsubscribePodcast;
    final l$$__typename = $__typename;
    return Object.hashAll([l$unsubscribePodcast, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$unsubscribePodcast ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$unsubscribePodcast = unsubscribePodcast;
    final lOther$unsubscribePodcast = other.unsubscribePodcast;
    if (l$unsubscribePodcast != lOther$unsubscribePodcast) {
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

extension UtilityExtension$Mutation$unsubscribePodcast
    on Mutation$unsubscribePodcast {
  CopyWith$Mutation$unsubscribePodcast<Mutation$unsubscribePodcast>
  get copyWith => CopyWith$Mutation$unsubscribePodcast(this, (i) => i);
}

abstract class CopyWith$Mutation$unsubscribePodcast<TRes> {
  factory CopyWith$Mutation$unsubscribePodcast(
    Mutation$unsubscribePodcast instance,
    TRes Function(Mutation$unsubscribePodcast) then,
  ) = _CopyWithImpl$Mutation$unsubscribePodcast;

  factory CopyWith$Mutation$unsubscribePodcast.stub(TRes res) =
      _CopyWithStubImpl$Mutation$unsubscribePodcast;

  TRes call({bool? unsubscribePodcast, String? $__typename});
}

class _CopyWithImpl$Mutation$unsubscribePodcast<TRes>
    implements CopyWith$Mutation$unsubscribePodcast<TRes> {
  _CopyWithImpl$Mutation$unsubscribePodcast(this._instance, this._then);

  final Mutation$unsubscribePodcast _instance;

  final TRes Function(Mutation$unsubscribePodcast) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? unsubscribePodcast = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$unsubscribePodcast(
      unsubscribePodcast:
          unsubscribePodcast == _undefined || unsubscribePodcast == null
          ? _instance.unsubscribePodcast
          : (unsubscribePodcast as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$unsubscribePodcast<TRes>
    implements CopyWith$Mutation$unsubscribePodcast<TRes> {
  _CopyWithStubImpl$Mutation$unsubscribePodcast(this._res);

  TRes _res;

  call({bool? unsubscribePodcast, String? $__typename}) => _res;
}

const documentNodeMutationunsubscribePodcast = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'unsubscribePodcast'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'unsubscribePodcast'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'id')),
              ),
            ],
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
