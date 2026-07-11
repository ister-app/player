import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Mutation$setRating {
  factory Variables$Mutation$setRating({
    required Enum$RatingMediaType mediaType,
    required String mediaId,
    int? rating,
  }) => Variables$Mutation$setRating._({
    r'mediaType': mediaType,
    r'mediaId': mediaId,
    if (rating != null) r'rating': rating,
  });

  Variables$Mutation$setRating._(this._$data);

  factory Variables$Mutation$setRating.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    final l$mediaType = data['mediaType'];
    result$data['mediaType'] = fromJson$Enum$RatingMediaType(
      (l$mediaType as String),
    );
    final l$mediaId = data['mediaId'];
    result$data['mediaId'] = (l$mediaId as String);
    if (data.containsKey('rating')) {
      final l$rating = data['rating'];
      result$data['rating'] = (l$rating as int?);
    }
    return Variables$Mutation$setRating._(result$data);
  }

  Map<String, dynamic> _$data;

  Enum$RatingMediaType get mediaType =>
      (_$data['mediaType'] as Enum$RatingMediaType);

  String get mediaId => (_$data['mediaId'] as String);

  int? get rating => (_$data['rating'] as int?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$mediaType = mediaType;
    result$data['mediaType'] = toJson$Enum$RatingMediaType(l$mediaType);
    final l$mediaId = mediaId;
    result$data['mediaId'] = l$mediaId;
    if (_$data.containsKey('rating')) {
      final l$rating = rating;
      result$data['rating'] = l$rating;
    }
    return result$data;
  }

  CopyWith$Variables$Mutation$setRating<Variables$Mutation$setRating>
  get copyWith => CopyWith$Variables$Mutation$setRating(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$setRating ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$mediaType = mediaType;
    final lOther$mediaType = other.mediaType;
    if (l$mediaType != lOther$mediaType) {
      return false;
    }
    final l$mediaId = mediaId;
    final lOther$mediaId = other.mediaId;
    if (l$mediaId != lOther$mediaId) {
      return false;
    }
    final l$rating = rating;
    final lOther$rating = other.rating;
    if (_$data.containsKey('rating') != other._$data.containsKey('rating')) {
      return false;
    }
    if (l$rating != lOther$rating) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$mediaType = mediaType;
    final l$mediaId = mediaId;
    final l$rating = rating;
    return Object.hashAll([
      l$mediaType,
      l$mediaId,
      _$data.containsKey('rating') ? l$rating : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$setRating<TRes> {
  factory CopyWith$Variables$Mutation$setRating(
    Variables$Mutation$setRating instance,
    TRes Function(Variables$Mutation$setRating) then,
  ) = _CopyWithImpl$Variables$Mutation$setRating;

  factory CopyWith$Variables$Mutation$setRating.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$setRating;

  TRes call({Enum$RatingMediaType? mediaType, String? mediaId, int? rating});
}

class _CopyWithImpl$Variables$Mutation$setRating<TRes>
    implements CopyWith$Variables$Mutation$setRating<TRes> {
  _CopyWithImpl$Variables$Mutation$setRating(this._instance, this._then);

  final Variables$Mutation$setRating _instance;

  final TRes Function(Variables$Mutation$setRating) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? mediaType = _undefined,
    Object? mediaId = _undefined,
    Object? rating = _undefined,
  }) => _then(
    Variables$Mutation$setRating._({
      ..._instance._$data,
      if (mediaType != _undefined && mediaType != null)
        'mediaType': (mediaType as Enum$RatingMediaType),
      if (mediaId != _undefined && mediaId != null)
        'mediaId': (mediaId as String),
      if (rating != _undefined) 'rating': (rating as int?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Mutation$setRating<TRes>
    implements CopyWith$Variables$Mutation$setRating<TRes> {
  _CopyWithStubImpl$Variables$Mutation$setRating(this._res);

  TRes _res;

  call({Enum$RatingMediaType? mediaType, String? mediaId, int? rating}) => _res;
}

class Mutation$setRating {
  Mutation$setRating({required this.setRating, this.$__typename = 'Mutation'});

  factory Mutation$setRating.fromJson(Map<String, dynamic> json) {
    final l$setRating = json['setRating'];
    final l$$__typename = json['__typename'];
    return Mutation$setRating(
      setRating: (l$setRating as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool setRating;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$setRating = setRating;
    _resultData['setRating'] = l$setRating;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$setRating = setRating;
    final l$$__typename = $__typename;
    return Object.hashAll([l$setRating, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$setRating || runtimeType != other.runtimeType) {
      return false;
    }
    final l$setRating = setRating;
    final lOther$setRating = other.setRating;
    if (l$setRating != lOther$setRating) {
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

extension UtilityExtension$Mutation$setRating on Mutation$setRating {
  CopyWith$Mutation$setRating<Mutation$setRating> get copyWith =>
      CopyWith$Mutation$setRating(this, (i) => i);
}

abstract class CopyWith$Mutation$setRating<TRes> {
  factory CopyWith$Mutation$setRating(
    Mutation$setRating instance,
    TRes Function(Mutation$setRating) then,
  ) = _CopyWithImpl$Mutation$setRating;

  factory CopyWith$Mutation$setRating.stub(TRes res) =
      _CopyWithStubImpl$Mutation$setRating;

  TRes call({bool? setRating, String? $__typename});
}

class _CopyWithImpl$Mutation$setRating<TRes>
    implements CopyWith$Mutation$setRating<TRes> {
  _CopyWithImpl$Mutation$setRating(this._instance, this._then);

  final Mutation$setRating _instance;

  final TRes Function(Mutation$setRating) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? setRating = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$setRating(
      setRating: setRating == _undefined || setRating == null
          ? _instance.setRating
          : (setRating as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$setRating<TRes>
    implements CopyWith$Mutation$setRating<TRes> {
  _CopyWithStubImpl$Mutation$setRating(this._res);

  TRes _res;

  call({bool? setRating, String? $__typename}) => _res;
}

const documentNodeMutationsetRating = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'setRating'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'mediaType')),
          type: NamedTypeNode(
            name: NameNode(value: 'RatingMediaType'),
            isNonNull: true,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'mediaId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'rating')),
          type: NamedTypeNode(name: NameNode(value: 'Int'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'setRating'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'mediaType'),
                value: VariableNode(name: NameNode(value: 'mediaType')),
              ),
              ArgumentNode(
                name: NameNode(value: 'mediaId'),
                value: VariableNode(name: NameNode(value: 'mediaId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'rating'),
                value: VariableNode(name: NameNode(value: 'rating')),
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
