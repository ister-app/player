import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Mutation$setPodcastEpisodeOrder {
  factory Variables$Mutation$setPodcastEpisodeOrder({
    required String podcastId,
    required Enum$SortingOrder order,
  }) => Variables$Mutation$setPodcastEpisodeOrder._({
    r'podcastId': podcastId,
    r'order': order,
  });

  Variables$Mutation$setPodcastEpisodeOrder._(this._$data);

  factory Variables$Mutation$setPodcastEpisodeOrder.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$podcastId = data['podcastId'];
    result$data['podcastId'] = (l$podcastId as String);
    final l$order = data['order'];
    result$data['order'] = fromJson$Enum$SortingOrder((l$order as String));
    return Variables$Mutation$setPodcastEpisodeOrder._(result$data);
  }

  Map<String, dynamic> _$data;

  String get podcastId => (_$data['podcastId'] as String);

  Enum$SortingOrder get order => (_$data['order'] as Enum$SortingOrder);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$podcastId = podcastId;
    result$data['podcastId'] = l$podcastId;
    final l$order = order;
    result$data['order'] = toJson$Enum$SortingOrder(l$order);
    return result$data;
  }

  CopyWith$Variables$Mutation$setPodcastEpisodeOrder<
    Variables$Mutation$setPodcastEpisodeOrder
  >
  get copyWith =>
      CopyWith$Variables$Mutation$setPodcastEpisodeOrder(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$setPodcastEpisodeOrder ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$podcastId = podcastId;
    final lOther$podcastId = other.podcastId;
    if (l$podcastId != lOther$podcastId) {
      return false;
    }
    final l$order = order;
    final lOther$order = other.order;
    if (l$order != lOther$order) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$podcastId = podcastId;
    final l$order = order;
    return Object.hashAll([l$podcastId, l$order]);
  }
}

abstract class CopyWith$Variables$Mutation$setPodcastEpisodeOrder<TRes> {
  factory CopyWith$Variables$Mutation$setPodcastEpisodeOrder(
    Variables$Mutation$setPodcastEpisodeOrder instance,
    TRes Function(Variables$Mutation$setPodcastEpisodeOrder) then,
  ) = _CopyWithImpl$Variables$Mutation$setPodcastEpisodeOrder;

  factory CopyWith$Variables$Mutation$setPodcastEpisodeOrder.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$setPodcastEpisodeOrder;

  TRes call({String? podcastId, Enum$SortingOrder? order});
}

class _CopyWithImpl$Variables$Mutation$setPodcastEpisodeOrder<TRes>
    implements CopyWith$Variables$Mutation$setPodcastEpisodeOrder<TRes> {
  _CopyWithImpl$Variables$Mutation$setPodcastEpisodeOrder(
    this._instance,
    this._then,
  );

  final Variables$Mutation$setPodcastEpisodeOrder _instance;

  final TRes Function(Variables$Mutation$setPodcastEpisodeOrder) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? podcastId = _undefined, Object? order = _undefined}) =>
      _then(
        Variables$Mutation$setPodcastEpisodeOrder._({
          ..._instance._$data,
          if (podcastId != _undefined && podcastId != null)
            'podcastId': (podcastId as String),
          if (order != _undefined && order != null)
            'order': (order as Enum$SortingOrder),
        }),
      );
}

class _CopyWithStubImpl$Variables$Mutation$setPodcastEpisodeOrder<TRes>
    implements CopyWith$Variables$Mutation$setPodcastEpisodeOrder<TRes> {
  _CopyWithStubImpl$Variables$Mutation$setPodcastEpisodeOrder(this._res);

  TRes _res;

  call({String? podcastId, Enum$SortingOrder? order}) => _res;
}

class Mutation$setPodcastEpisodeOrder {
  Mutation$setPodcastEpisodeOrder({
    required this.setPodcastEpisodeOrder,
    this.$__typename = 'Mutation',
  });

  factory Mutation$setPodcastEpisodeOrder.fromJson(Map<String, dynamic> json) {
    final l$setPodcastEpisodeOrder = json['setPodcastEpisodeOrder'];
    final l$$__typename = json['__typename'];
    return Mutation$setPodcastEpisodeOrder(
      setPodcastEpisodeOrder: (l$setPodcastEpisodeOrder as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool setPodcastEpisodeOrder;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$setPodcastEpisodeOrder = setPodcastEpisodeOrder;
    _resultData['setPodcastEpisodeOrder'] = l$setPodcastEpisodeOrder;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$setPodcastEpisodeOrder = setPodcastEpisodeOrder;
    final l$$__typename = $__typename;
    return Object.hashAll([l$setPodcastEpisodeOrder, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$setPodcastEpisodeOrder ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$setPodcastEpisodeOrder = setPodcastEpisodeOrder;
    final lOther$setPodcastEpisodeOrder = other.setPodcastEpisodeOrder;
    if (l$setPodcastEpisodeOrder != lOther$setPodcastEpisodeOrder) {
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

extension UtilityExtension$Mutation$setPodcastEpisodeOrder
    on Mutation$setPodcastEpisodeOrder {
  CopyWith$Mutation$setPodcastEpisodeOrder<Mutation$setPodcastEpisodeOrder>
  get copyWith => CopyWith$Mutation$setPodcastEpisodeOrder(this, (i) => i);
}

abstract class CopyWith$Mutation$setPodcastEpisodeOrder<TRes> {
  factory CopyWith$Mutation$setPodcastEpisodeOrder(
    Mutation$setPodcastEpisodeOrder instance,
    TRes Function(Mutation$setPodcastEpisodeOrder) then,
  ) = _CopyWithImpl$Mutation$setPodcastEpisodeOrder;

  factory CopyWith$Mutation$setPodcastEpisodeOrder.stub(TRes res) =
      _CopyWithStubImpl$Mutation$setPodcastEpisodeOrder;

  TRes call({bool? setPodcastEpisodeOrder, String? $__typename});
}

class _CopyWithImpl$Mutation$setPodcastEpisodeOrder<TRes>
    implements CopyWith$Mutation$setPodcastEpisodeOrder<TRes> {
  _CopyWithImpl$Mutation$setPodcastEpisodeOrder(this._instance, this._then);

  final Mutation$setPodcastEpisodeOrder _instance;

  final TRes Function(Mutation$setPodcastEpisodeOrder) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? setPodcastEpisodeOrder = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$setPodcastEpisodeOrder(
      setPodcastEpisodeOrder:
          setPodcastEpisodeOrder == _undefined || setPodcastEpisodeOrder == null
          ? _instance.setPodcastEpisodeOrder
          : (setPodcastEpisodeOrder as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$setPodcastEpisodeOrder<TRes>
    implements CopyWith$Mutation$setPodcastEpisodeOrder<TRes> {
  _CopyWithStubImpl$Mutation$setPodcastEpisodeOrder(this._res);

  TRes _res;

  call({bool? setPodcastEpisodeOrder, String? $__typename}) => _res;
}

const documentNodeMutationsetPodcastEpisodeOrder = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'setPodcastEpisodeOrder'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'podcastId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'order')),
          type: NamedTypeNode(
            name: NameNode(value: 'SortingOrder'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'setPodcastEpisodeOrder'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'podcastId'),
                value: VariableNode(name: NameNode(value: 'podcastId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'order'),
                value: VariableNode(name: NameNode(value: 'order')),
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
