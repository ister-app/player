import 'package:gql/ast.dart';

class Variables$Mutation$downloadPodcastEpisode {
  factory Variables$Mutation$downloadPodcastEpisode({
    required String episodeId,
  }) => Variables$Mutation$downloadPodcastEpisode._({r'episodeId': episodeId});

  Variables$Mutation$downloadPodcastEpisode._(this._$data);

  factory Variables$Mutation$downloadPodcastEpisode.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$episodeId = data['episodeId'];
    result$data['episodeId'] = (l$episodeId as String);
    return Variables$Mutation$downloadPodcastEpisode._(result$data);
  }

  Map<String, dynamic> _$data;

  String get episodeId => (_$data['episodeId'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$episodeId = episodeId;
    result$data['episodeId'] = l$episodeId;
    return result$data;
  }

  CopyWith$Variables$Mutation$downloadPodcastEpisode<
    Variables$Mutation$downloadPodcastEpisode
  >
  get copyWith =>
      CopyWith$Variables$Mutation$downloadPodcastEpisode(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$downloadPodcastEpisode ||
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

abstract class CopyWith$Variables$Mutation$downloadPodcastEpisode<TRes> {
  factory CopyWith$Variables$Mutation$downloadPodcastEpisode(
    Variables$Mutation$downloadPodcastEpisode instance,
    TRes Function(Variables$Mutation$downloadPodcastEpisode) then,
  ) = _CopyWithImpl$Variables$Mutation$downloadPodcastEpisode;

  factory CopyWith$Variables$Mutation$downloadPodcastEpisode.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$downloadPodcastEpisode;

  TRes call({String? episodeId});
}

class _CopyWithImpl$Variables$Mutation$downloadPodcastEpisode<TRes>
    implements CopyWith$Variables$Mutation$downloadPodcastEpisode<TRes> {
  _CopyWithImpl$Variables$Mutation$downloadPodcastEpisode(
    this._instance,
    this._then,
  );

  final Variables$Mutation$downloadPodcastEpisode _instance;

  final TRes Function(Variables$Mutation$downloadPodcastEpisode) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? episodeId = _undefined}) => _then(
    Variables$Mutation$downloadPodcastEpisode._({
      ..._instance._$data,
      if (episodeId != _undefined && episodeId != null)
        'episodeId': (episodeId as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$downloadPodcastEpisode<TRes>
    implements CopyWith$Variables$Mutation$downloadPodcastEpisode<TRes> {
  _CopyWithStubImpl$Variables$Mutation$downloadPodcastEpisode(this._res);

  TRes _res;

  call({String? episodeId}) => _res;
}

class Mutation$downloadPodcastEpisode {
  Mutation$downloadPodcastEpisode({
    required this.downloadPodcastEpisode,
    this.$__typename = 'Mutation',
  });

  factory Mutation$downloadPodcastEpisode.fromJson(Map<String, dynamic> json) {
    final l$downloadPodcastEpisode = json['downloadPodcastEpisode'];
    final l$$__typename = json['__typename'];
    return Mutation$downloadPodcastEpisode(
      downloadPodcastEpisode: (l$downloadPodcastEpisode as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool downloadPodcastEpisode;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$downloadPodcastEpisode = downloadPodcastEpisode;
    _resultData['downloadPodcastEpisode'] = l$downloadPodcastEpisode;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$downloadPodcastEpisode = downloadPodcastEpisode;
    final l$$__typename = $__typename;
    return Object.hashAll([l$downloadPodcastEpisode, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$downloadPodcastEpisode ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$downloadPodcastEpisode = downloadPodcastEpisode;
    final lOther$downloadPodcastEpisode = other.downloadPodcastEpisode;
    if (l$downloadPodcastEpisode != lOther$downloadPodcastEpisode) {
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

extension UtilityExtension$Mutation$downloadPodcastEpisode
    on Mutation$downloadPodcastEpisode {
  CopyWith$Mutation$downloadPodcastEpisode<Mutation$downloadPodcastEpisode>
  get copyWith => CopyWith$Mutation$downloadPodcastEpisode(this, (i) => i);
}

abstract class CopyWith$Mutation$downloadPodcastEpisode<TRes> {
  factory CopyWith$Mutation$downloadPodcastEpisode(
    Mutation$downloadPodcastEpisode instance,
    TRes Function(Mutation$downloadPodcastEpisode) then,
  ) = _CopyWithImpl$Mutation$downloadPodcastEpisode;

  factory CopyWith$Mutation$downloadPodcastEpisode.stub(TRes res) =
      _CopyWithStubImpl$Mutation$downloadPodcastEpisode;

  TRes call({bool? downloadPodcastEpisode, String? $__typename});
}

class _CopyWithImpl$Mutation$downloadPodcastEpisode<TRes>
    implements CopyWith$Mutation$downloadPodcastEpisode<TRes> {
  _CopyWithImpl$Mutation$downloadPodcastEpisode(this._instance, this._then);

  final Mutation$downloadPodcastEpisode _instance;

  final TRes Function(Mutation$downloadPodcastEpisode) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? downloadPodcastEpisode = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$downloadPodcastEpisode(
      downloadPodcastEpisode:
          downloadPodcastEpisode == _undefined || downloadPodcastEpisode == null
          ? _instance.downloadPodcastEpisode
          : (downloadPodcastEpisode as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$downloadPodcastEpisode<TRes>
    implements CopyWith$Mutation$downloadPodcastEpisode<TRes> {
  _CopyWithStubImpl$Mutation$downloadPodcastEpisode(this._res);

  TRes _res;

  call({bool? downloadPodcastEpisode, String? $__typename}) => _res;
}

const documentNodeMutationdownloadPodcastEpisode = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'downloadPodcastEpisode'),
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
            name: NameNode(value: 'downloadPodcastEpisode'),
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
