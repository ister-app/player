import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'fragmentPodcast.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Mutation$subscribePodcast {
  factory Variables$Mutation$subscribePodcast({required String feedUrl}) =>
      Variables$Mutation$subscribePodcast._({r'feedUrl': feedUrl});

  Variables$Mutation$subscribePodcast._(this._$data);

  factory Variables$Mutation$subscribePodcast.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$feedUrl = data['feedUrl'];
    result$data['feedUrl'] = (l$feedUrl as String);
    return Variables$Mutation$subscribePodcast._(result$data);
  }

  Map<String, dynamic> _$data;

  String get feedUrl => (_$data['feedUrl'] as String);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$feedUrl = feedUrl;
    result$data['feedUrl'] = l$feedUrl;
    return result$data;
  }

  CopyWith$Variables$Mutation$subscribePodcast<
    Variables$Mutation$subscribePodcast
  >
  get copyWith => CopyWith$Variables$Mutation$subscribePodcast(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$subscribePodcast ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$feedUrl = feedUrl;
    final lOther$feedUrl = other.feedUrl;
    if (l$feedUrl != lOther$feedUrl) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$feedUrl = feedUrl;
    return Object.hashAll([l$feedUrl]);
  }
}

abstract class CopyWith$Variables$Mutation$subscribePodcast<TRes> {
  factory CopyWith$Variables$Mutation$subscribePodcast(
    Variables$Mutation$subscribePodcast instance,
    TRes Function(Variables$Mutation$subscribePodcast) then,
  ) = _CopyWithImpl$Variables$Mutation$subscribePodcast;

  factory CopyWith$Variables$Mutation$subscribePodcast.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$subscribePodcast;

  TRes call({String? feedUrl});
}

class _CopyWithImpl$Variables$Mutation$subscribePodcast<TRes>
    implements CopyWith$Variables$Mutation$subscribePodcast<TRes> {
  _CopyWithImpl$Variables$Mutation$subscribePodcast(this._instance, this._then);

  final Variables$Mutation$subscribePodcast _instance;

  final TRes Function(Variables$Mutation$subscribePodcast) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? feedUrl = _undefined}) => _then(
    Variables$Mutation$subscribePodcast._({
      ..._instance._$data,
      if (feedUrl != _undefined && feedUrl != null)
        'feedUrl': (feedUrl as String),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$subscribePodcast<TRes>
    implements CopyWith$Variables$Mutation$subscribePodcast<TRes> {
  _CopyWithStubImpl$Variables$Mutation$subscribePodcast(this._res);

  TRes _res;

  call({String? feedUrl}) => _res;
}

class Mutation$subscribePodcast {
  Mutation$subscribePodcast({
    required this.subscribePodcast,
    this.$__typename = 'Mutation',
  });

  factory Mutation$subscribePodcast.fromJson(Map<String, dynamic> json) {
    final l$subscribePodcast = json['subscribePodcast'];
    final l$$__typename = json['__typename'];
    return Mutation$subscribePodcast(
      subscribePodcast: Fragment$fragmentPodcast.fromJson(
        (l$subscribePodcast as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentPodcast subscribePodcast;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$subscribePodcast = subscribePodcast;
    _resultData['subscribePodcast'] = l$subscribePodcast.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$subscribePodcast = subscribePodcast;
    final l$$__typename = $__typename;
    return Object.hashAll([l$subscribePodcast, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$subscribePodcast ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$subscribePodcast = subscribePodcast;
    final lOther$subscribePodcast = other.subscribePodcast;
    if (l$subscribePodcast != lOther$subscribePodcast) {
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

extension UtilityExtension$Mutation$subscribePodcast
    on Mutation$subscribePodcast {
  CopyWith$Mutation$subscribePodcast<Mutation$subscribePodcast> get copyWith =>
      CopyWith$Mutation$subscribePodcast(this, (i) => i);
}

abstract class CopyWith$Mutation$subscribePodcast<TRes> {
  factory CopyWith$Mutation$subscribePodcast(
    Mutation$subscribePodcast instance,
    TRes Function(Mutation$subscribePodcast) then,
  ) = _CopyWithImpl$Mutation$subscribePodcast;

  factory CopyWith$Mutation$subscribePodcast.stub(TRes res) =
      _CopyWithStubImpl$Mutation$subscribePodcast;

  TRes call({Fragment$fragmentPodcast? subscribePodcast, String? $__typename});
  CopyWith$Fragment$fragmentPodcast<TRes> get subscribePodcast;
}

class _CopyWithImpl$Mutation$subscribePodcast<TRes>
    implements CopyWith$Mutation$subscribePodcast<TRes> {
  _CopyWithImpl$Mutation$subscribePodcast(this._instance, this._then);

  final Mutation$subscribePodcast _instance;

  final TRes Function(Mutation$subscribePodcast) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? subscribePodcast = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$subscribePodcast(
      subscribePodcast:
          subscribePodcast == _undefined || subscribePodcast == null
          ? _instance.subscribePodcast
          : (subscribePodcast as Fragment$fragmentPodcast),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentPodcast<TRes> get subscribePodcast {
    final local$subscribePodcast = _instance.subscribePodcast;
    return CopyWith$Fragment$fragmentPodcast(
      local$subscribePodcast,
      (e) => call(subscribePodcast: e),
    );
  }
}

class _CopyWithStubImpl$Mutation$subscribePodcast<TRes>
    implements CopyWith$Mutation$subscribePodcast<TRes> {
  _CopyWithStubImpl$Mutation$subscribePodcast(this._res);

  TRes _res;

  call({Fragment$fragmentPodcast? subscribePodcast, String? $__typename}) =>
      _res;

  CopyWith$Fragment$fragmentPodcast<TRes> get subscribePodcast =>
      CopyWith$Fragment$fragmentPodcast.stub(_res);
}

const documentNodeMutationsubscribePodcast = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'subscribePodcast'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'feedUrl')),
          type: NamedTypeNode(name: NameNode(value: 'String'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'subscribePodcast'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'feedUrl'),
                value: VariableNode(name: NameNode(value: 'feedUrl')),
              ),
            ],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'fragmentPodcast'),
                  directives: [],
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
    fragmentDefinitionfragmentPodcast,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
  ],
);
