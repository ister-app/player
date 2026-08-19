import 'fragmentDevice.graphql.dart';

import 'package:gql/ast.dart';

class Query$myDevices {
  Query$myDevices({required this.myDevices, this.$__typename = 'Query'});

  factory Query$myDevices.fromJson(Map<String, dynamic> json) {
    final l$myDevices = json['myDevices'];
    final l$$__typename = json['__typename'];
    return Query$myDevices(
      myDevices: (l$myDevices as List<dynamic>)
          .map(
            (e) =>
                Fragment$fragmentDevice.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Fragment$fragmentDevice> myDevices;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$myDevices = myDevices;
    _resultData['myDevices'] = l$myDevices.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$myDevices = myDevices;
    final l$$__typename = $__typename;
    return Object.hashAll([
      Object.hashAll(l$myDevices.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$myDevices || runtimeType != other.runtimeType) {
      return false;
    }
    final l$myDevices = myDevices;
    final lOther$myDevices = other.myDevices;
    if (l$myDevices.length != lOther$myDevices.length) {
      return false;
    }
    for (int i = 0; i < l$myDevices.length; i++) {
      final l$myDevices$entry = l$myDevices[i];
      final lOther$myDevices$entry = lOther$myDevices[i];
      if (l$myDevices$entry != lOther$myDevices$entry) {
        return false;
      }
    }
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Query$myDevices on Query$myDevices {
  CopyWith$Query$myDevices<Query$myDevices> get copyWith =>
      CopyWith$Query$myDevices(this, (i) => i);
}

abstract class CopyWith$Query$myDevices<TRes> {
  factory CopyWith$Query$myDevices(
    Query$myDevices instance,
    TRes Function(Query$myDevices) then,
  ) = _CopyWithImpl$Query$myDevices;

  factory CopyWith$Query$myDevices.stub(TRes res) =
      _CopyWithStubImpl$Query$myDevices;

  TRes call({List<Fragment$fragmentDevice>? myDevices, String? $__typename});
  TRes myDevices(
    Iterable<Fragment$fragmentDevice> Function(
      Iterable<CopyWith$Fragment$fragmentDevice<Fragment$fragmentDevice>>,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$myDevices<TRes>
    implements CopyWith$Query$myDevices<TRes> {
  _CopyWithImpl$Query$myDevices(this._instance, this._then);

  final Query$myDevices _instance;

  final TRes Function(Query$myDevices) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? myDevices = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$myDevices(
      myDevices: myDevices == _undefined || myDevices == null
          ? _instance.myDevices
          : (myDevices as List<Fragment$fragmentDevice>),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes myDevices(
    Iterable<Fragment$fragmentDevice> Function(
      Iterable<CopyWith$Fragment$fragmentDevice<Fragment$fragmentDevice>>,
    )
    _fn,
  ) => call(
    myDevices: _fn(
      _instance.myDevices.map(
        (e) => CopyWith$Fragment$fragmentDevice(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Query$myDevices<TRes>
    implements CopyWith$Query$myDevices<TRes> {
  _CopyWithStubImpl$Query$myDevices(this._res);

  TRes _res;

  call({List<Fragment$fragmentDevice>? myDevices, String? $__typename}) => _res;

  myDevices(_fn) => _res;
}

const documentNodeQuerymyDevices = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'myDevices'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'myDevices'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'fragmentDevice'),
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
    fragmentDefinitionfragmentDevice,
  ],
);
