import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Variables$Mutation$setSeriesReadingDirection {
  factory Variables$Mutation$setSeriesReadingDirection({
    required String seriesId,
    Enum$ReadingDirection? direction,
  }) => Variables$Mutation$setSeriesReadingDirection._({
    r'seriesId': seriesId,
    if (direction != null) r'direction': direction,
  });

  Variables$Mutation$setSeriesReadingDirection._(this._$data);

  factory Variables$Mutation$setSeriesReadingDirection.fromJson(
    Map<String, dynamic> data,
  ) {
    final result$data = <String, dynamic>{};
    final l$seriesId = data['seriesId'];
    result$data['seriesId'] = (l$seriesId as String);
    if (data.containsKey('direction')) {
      final l$direction = data['direction'];
      result$data['direction'] = l$direction == null
          ? null
          : fromJson$Enum$ReadingDirection((l$direction as String));
    }
    return Variables$Mutation$setSeriesReadingDirection._(result$data);
  }

  Map<String, dynamic> _$data;

  String get seriesId => (_$data['seriesId'] as String);

  Enum$ReadingDirection? get direction =>
      (_$data['direction'] as Enum$ReadingDirection?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    final l$seriesId = seriesId;
    result$data['seriesId'] = l$seriesId;
    if (_$data.containsKey('direction')) {
      final l$direction = direction;
      result$data['direction'] = l$direction == null
          ? null
          : toJson$Enum$ReadingDirection(l$direction);
    }
    return result$data;
  }

  CopyWith$Variables$Mutation$setSeriesReadingDirection<
    Variables$Mutation$setSeriesReadingDirection
  >
  get copyWith =>
      CopyWith$Variables$Mutation$setSeriesReadingDirection(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Mutation$setSeriesReadingDirection ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$seriesId = seriesId;
    final lOther$seriesId = other.seriesId;
    if (l$seriesId != lOther$seriesId) {
      return false;
    }
    final l$direction = direction;
    final lOther$direction = other.direction;
    if (_$data.containsKey('direction') !=
        other._$data.containsKey('direction')) {
      return false;
    }
    if (l$direction != lOther$direction) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$seriesId = seriesId;
    final l$direction = direction;
    return Object.hashAll([
      l$seriesId,
      _$data.containsKey('direction') ? l$direction : const {},
    ]);
  }
}

abstract class CopyWith$Variables$Mutation$setSeriesReadingDirection<TRes> {
  factory CopyWith$Variables$Mutation$setSeriesReadingDirection(
    Variables$Mutation$setSeriesReadingDirection instance,
    TRes Function(Variables$Mutation$setSeriesReadingDirection) then,
  ) = _CopyWithImpl$Variables$Mutation$setSeriesReadingDirection;

  factory CopyWith$Variables$Mutation$setSeriesReadingDirection.stub(TRes res) =
      _CopyWithStubImpl$Variables$Mutation$setSeriesReadingDirection;

  TRes call({String? seriesId, Enum$ReadingDirection? direction});
}

class _CopyWithImpl$Variables$Mutation$setSeriesReadingDirection<TRes>
    implements CopyWith$Variables$Mutation$setSeriesReadingDirection<TRes> {
  _CopyWithImpl$Variables$Mutation$setSeriesReadingDirection(
    this._instance,
    this._then,
  );

  final Variables$Mutation$setSeriesReadingDirection _instance;

  final TRes Function(Variables$Mutation$setSeriesReadingDirection) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? seriesId = _undefined, Object? direction = _undefined}) =>
      _then(
        Variables$Mutation$setSeriesReadingDirection._({
          ..._instance._$data,
          if (seriesId != _undefined && seriesId != null)
            'seriesId': (seriesId as String),
          if (direction != _undefined)
            'direction': (direction as Enum$ReadingDirection?),
        }),
      );
}

class _CopyWithStubImpl$Variables$Mutation$setSeriesReadingDirection<TRes>
    implements CopyWith$Variables$Mutation$setSeriesReadingDirection<TRes> {
  _CopyWithStubImpl$Variables$Mutation$setSeriesReadingDirection(this._res);

  TRes _res;

  call({String? seriesId, Enum$ReadingDirection? direction}) => _res;
}

class Mutation$setSeriesReadingDirection {
  Mutation$setSeriesReadingDirection({
    required this.setSeriesReadingDirection,
    this.$__typename = 'Mutation',
  });

  factory Mutation$setSeriesReadingDirection.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$setSeriesReadingDirection = json['setSeriesReadingDirection'];
    final l$$__typename = json['__typename'];
    return Mutation$setSeriesReadingDirection(
      setSeriesReadingDirection: (l$setSeriesReadingDirection as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final bool setSeriesReadingDirection;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$setSeriesReadingDirection = setSeriesReadingDirection;
    _resultData['setSeriesReadingDirection'] = l$setSeriesReadingDirection;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$setSeriesReadingDirection = setSeriesReadingDirection;
    final l$$__typename = $__typename;
    return Object.hashAll([l$setSeriesReadingDirection, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Mutation$setSeriesReadingDirection ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$setSeriesReadingDirection = setSeriesReadingDirection;
    final lOther$setSeriesReadingDirection = other.setSeriesReadingDirection;
    if (l$setSeriesReadingDirection != lOther$setSeriesReadingDirection) {
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

extension UtilityExtension$Mutation$setSeriesReadingDirection
    on Mutation$setSeriesReadingDirection {
  CopyWith$Mutation$setSeriesReadingDirection<
    Mutation$setSeriesReadingDirection
  >
  get copyWith => CopyWith$Mutation$setSeriesReadingDirection(this, (i) => i);
}

abstract class CopyWith$Mutation$setSeriesReadingDirection<TRes> {
  factory CopyWith$Mutation$setSeriesReadingDirection(
    Mutation$setSeriesReadingDirection instance,
    TRes Function(Mutation$setSeriesReadingDirection) then,
  ) = _CopyWithImpl$Mutation$setSeriesReadingDirection;

  factory CopyWith$Mutation$setSeriesReadingDirection.stub(TRes res) =
      _CopyWithStubImpl$Mutation$setSeriesReadingDirection;

  TRes call({bool? setSeriesReadingDirection, String? $__typename});
}

class _CopyWithImpl$Mutation$setSeriesReadingDirection<TRes>
    implements CopyWith$Mutation$setSeriesReadingDirection<TRes> {
  _CopyWithImpl$Mutation$setSeriesReadingDirection(this._instance, this._then);

  final Mutation$setSeriesReadingDirection _instance;

  final TRes Function(Mutation$setSeriesReadingDirection) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? setSeriesReadingDirection = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Mutation$setSeriesReadingDirection(
      setSeriesReadingDirection:
          setSeriesReadingDirection == _undefined ||
              setSeriesReadingDirection == null
          ? _instance.setSeriesReadingDirection
          : (setSeriesReadingDirection as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Mutation$setSeriesReadingDirection<TRes>
    implements CopyWith$Mutation$setSeriesReadingDirection<TRes> {
  _CopyWithStubImpl$Mutation$setSeriesReadingDirection(this._res);

  TRes _res;

  call({bool? setSeriesReadingDirection, String? $__typename}) => _res;
}

const documentNodeMutationsetSeriesReadingDirection = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.mutation,
      name: NameNode(value: 'setSeriesReadingDirection'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'seriesId')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'direction')),
          type: NamedTypeNode(
            name: NameNode(value: 'ReadingDirection'),
            isNonNull: false,
          ),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'setSeriesReadingDirection'),
            alias: null,
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'seriesId'),
                value: VariableNode(name: NameNode(value: 'seriesId')),
              ),
              ArgumentNode(
                name: NameNode(value: 'direction'),
                value: VariableNode(name: NameNode(value: 'direction')),
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
