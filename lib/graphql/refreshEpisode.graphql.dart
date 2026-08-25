import 'package:gql/ast.dart';

class Variables$Mutation$refreshEpisode {
  factory Variables$Mutation$refreshEpisode({required String episodeId}) =>
      Variables$Mutation$refreshEpisode._({r'episodeId': episodeId});

  Variables$Mutation$refreshEpisode._(this._$data);

  factory Variables$Mutation$refreshEpisode.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$episodeId = data['episodeId'];
    result$data['episodeId'] = (l$episodeId as String);
    return Variables$Mutation$refreshEpisode._(result$data);
  }

  Map<String, dynamic> _$data;

  String get episodeId => (_$data['episodeId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$episodeId = episodeId;
    result$data['episodeId'] = l$episodeId;
    return result$data;
  }

  CopyWith$Variables$Mutation$refreshEpisode<Variables$Mutation$refreshEpisode>
  get copyWith => CopyWith$Variables$Mutation$refreshEpisode(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$refreshEpisode ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$episodeId = episodeId;
    final lOther$episodeId = other.episodeId;
    if (l$episodeId != lOther$episodeId) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$episodeId = episodeId;
    return Object.hashAll([l$episodeId]);
  }
}

abstract class CopyWith$Variables$Mutation$refreshEpisode<TRes> {
  factory CopyWith$Variables$Mutation$refreshEpisode(
    Variables$Mutation$refreshEpisode instance,
    TRes Function(Variables$Mutation$refreshEpisode) then,
  ) = _CopyWithImpl$Variables$Mutation$refreshEpisode;

  factory CopyWith$Variables$Mutation$refreshEpisode.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$refreshEpisode;

  TRes call({String? episodeId});
}

class _CopyWithImpl$Variables$Mutation$refreshEpisode<TRes>
    implements CopyWith$Variables$Mutation$refreshEpisode<TRes> {
  _CopyWithImpl$Variables$Mutation$refreshEpisode(this._instance, this._then);

  final Variables$Mutation$refreshEpisode _instance;

  final TRes Function(Variables$Mutation$refreshEpisode) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? episodeId = _undefined}) => _then(
    Variables$Mutation$refreshEpisode._({
      ..._instance._$data,
      if (episodeId != _undefined && episodeId != null)
        'episodeId': (episodeId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$refreshEpisode<TRes>
    implements CopyWith$Variables$Mutation$refreshEpisode<TRes> {
  _CopyWithStubImpl$Variables$Mutation$refreshEpisode(this._res);

  TRes _res;

  call({String? episodeId}) => _res;
}

class Mutation$refreshEpisode {
  Mutation$refreshEpisode({
    required this.refreshEpisode,
    this.$__typename = 'Mutation',
  });

  factory Mutation$refreshEpisode.fromJson(Map<String, dynamic> json) {
    final l$refreshEpisode = json['refreshEpisode'];
    final l$$__typename = json['__typename'];
    return Mutation$refreshEpisode(
      refreshEpisode: (l$refreshEpisode as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool refreshEpisode;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$refreshEpisode = refreshEpisode;
    _resultData['refreshEpisode'] = l$refreshEpisode;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$refreshEpisode = refreshEpisode;
    final l$$__typename = $__typename;
    return Object.hashAll([l$refreshEpisode, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$refreshEpisode || runtimeType != other.runtimeType) {
      return false;
    }
    final l$refreshEpisode = refreshEpisode;
    final lOther$refreshEpisode = other.refreshEpisode;
    if (l$refreshEpisode != lOther$refreshEpisode) {
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

extension UtilityExtension$Mutation$refreshEpisode on Mutation$refreshEpisode {
  CopyWith$Mutation$refreshEpisode<Mutation$refreshEpisode> get copyWith =>
      CopyWith$Mutation$refreshEpisode(this, (i) => i);
}

abstract class CopyWith$Mutation$refreshEpisode<TRes> {
  factory CopyWith$Mutation$refreshEpisode(
    Mutation$refreshEpisode instance,
    TRes Function(Mutation$refreshEpisode) then,
  ) = _CopyWithImpl$Mutation$refreshEpisode;

  factory CopyWith$Mutation$refreshEpisode.stub(TRes res) =
      _CopyWithStubImpl$Mutation$refreshEpisode;

  TRes call({bool? refreshEpisode, String? $__typename});
}

class _CopyWithImpl$Mutation$refreshEpisode<TRes>
    implements CopyWith$Mutation$refreshEpisode<TRes> {
  _CopyWithImpl$Mutation$refreshEpisode(this._instance, this._then);

  final Mutation$refreshEpisode _instance;

  final TRes Function(Mutation$refreshEpisode) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? refreshEpisode = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$refreshEpisode(
      refreshEpisode: refreshEpisode == _undefined || refreshEpisode == null
          ? _instance.refreshEpisode
          : (refreshEpisode as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$refreshEpisode<TRes>
    implements CopyWith$Mutation$refreshEpisode<TRes> {
  _CopyWithStubImpl$Mutation$refreshEpisode(this._res);

  TRes _res;

  call({bool? refreshEpisode, String? $__typename}) => _res;
}

const documentNodeMutationrefreshEpisode = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'refreshEpisode'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'episodeId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'refreshEpisode'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'episodeId'),
                value: VariableNode(name: NameNode(value: 'episodeId')),
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
