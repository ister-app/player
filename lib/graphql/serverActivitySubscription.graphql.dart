import 'fragmentServerActivity.graphql.dart';
import 'package:gql/ast.dart';

class Subscription$serverActivity {
  Subscription$serverActivity({required this.serverActivity});

  factory Subscription$serverActivity.fromJson(Map<String, dynamic> json) {
    final l$serverActivity = json['serverActivity'];
    return Subscription$serverActivity(
      serverActivity: Fragment$fragmentServerActivityEvent.fromJson(
        (l$serverActivity as Map<String, dynamic>),
      ),
    );
  }

  final Fragment$fragmentServerActivityEvent serverActivity;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$serverActivity = serverActivity;
    _resultData['serverActivity'] = l$serverActivity.toJson();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$serverActivity = serverActivity;
    return Object.hashAll([l$serverActivity]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Subscription$serverActivity ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$serverActivity = serverActivity;
    final lOther$serverActivity = other.serverActivity;
    if (l$serverActivity != lOther$serverActivity) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Subscription$serverActivity
    on Subscription$serverActivity {
  CopyWith$Subscription$serverActivity<Subscription$serverActivity>
  get copyWith => CopyWith$Subscription$serverActivity(this, (i) => i);
}

abstract class CopyWith$Subscription$serverActivity<TRes> {
  factory CopyWith$Subscription$serverActivity(
    Subscription$serverActivity instance,
    TRes Function(Subscription$serverActivity) then,
  ) = _CopyWithImpl$Subscription$serverActivity;

  factory CopyWith$Subscription$serverActivity.stub(TRes res) =
      _CopyWithStubImpl$Subscription$serverActivity;

  TRes call({Fragment$fragmentServerActivityEvent? serverActivity});
  CopyWith$Fragment$fragmentServerActivityEvent<TRes> get serverActivity;
}

class _CopyWithImpl$Subscription$serverActivity<TRes>
    implements CopyWith$Subscription$serverActivity<TRes> {
  _CopyWithImpl$Subscription$serverActivity(this._instance, this._then);

  final Subscription$serverActivity _instance;

  final TRes Function(Subscription$serverActivity) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? serverActivity = _undefined}) => _then(
    Subscription$serverActivity(
      serverActivity: serverActivity == _undefined || serverActivity == null
          ? _instance.serverActivity
          : (serverActivity as Fragment$fragmentServerActivityEvent),
    ),
  );

  CopyWith$Fragment$fragmentServerActivityEvent<TRes> get serverActivity {
    final local$serverActivity = _instance.serverActivity;
    return CopyWith$Fragment$fragmentServerActivityEvent(
      local$serverActivity,
      (e) => call(serverActivity: e),
    );
  }
}

class _CopyWithStubImpl$Subscription$serverActivity<TRes>
    implements CopyWith$Subscription$serverActivity<TRes> {
  _CopyWithStubImpl$Subscription$serverActivity(this._res);

  TRes _res;

  call({Fragment$fragmentServerActivityEvent? serverActivity}) => _res;

  CopyWith$Fragment$fragmentServerActivityEvent<TRes> get serverActivity =>
      CopyWith$Fragment$fragmentServerActivityEvent.stub(_res);
}

const documentNodeSubscriptionserverActivity = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.subscription,
      name: NameNode(value: 'serverActivity'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'serverActivity'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'fragmentServerActivityEvent'),
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
        ],
      ),
    ),
    fragmentDefinitionfragmentServerActivityEvent,
    fragmentDefinitionfragmentQueueStat,
    fragmentDefinitionfragmentEventFailure,
  ],
);
