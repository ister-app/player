import 'fragmentServerActivity.graphql.dart';
import 'package:gql/ast.dart';

class Subscription$nowPlaying {
  Subscription$nowPlaying({required this.nowPlaying});

  factory Subscription$nowPlaying.fromJson(Map<String, dynamic> json) {
    final l$nowPlaying = json['nowPlaying'];
    return Subscription$nowPlaying(
      nowPlaying: (l$nowPlaying as List<dynamic>)
          .map(
            (e) => Fragment$fragmentPlaybackSession.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
    );
  }

  final List<Fragment$fragmentPlaybackSession> nowPlaying;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$nowPlaying = nowPlaying;
    _resultData['nowPlaying'] = l$nowPlaying.map((e) => e.toJson()).toList();
    return _resultData;
  }

  @override
  int get hashCode {
    final l$nowPlaying = nowPlaying;
    return Object.hashAll([Object.hashAll(l$nowPlaying.map((v) => v))]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Subscription$nowPlaying || runtimeType != other.runtimeType) {
      return false;
    }
    final l$nowPlaying = nowPlaying;
    final lOther$nowPlaying = other.nowPlaying;
    if (l$nowPlaying.length != lOther$nowPlaying.length) {
      return false;
    }
    for (int i = 0; i < l$nowPlaying.length; i++) {
      final l$nowPlaying$entry = l$nowPlaying[i];
      final lOther$nowPlaying$entry = lOther$nowPlaying[i];
      if (l$nowPlaying$entry != lOther$nowPlaying$entry) {
        return false;
      }
    }
    return true;
  }
}

extension UtilityExtension$Subscription$nowPlaying on Subscription$nowPlaying {
  CopyWith$Subscription$nowPlaying<Subscription$nowPlaying> get copyWith =>
      CopyWith$Subscription$nowPlaying(this, (i) => i);
}

abstract class CopyWith$Subscription$nowPlaying<TRes> {
  factory CopyWith$Subscription$nowPlaying(
    Subscription$nowPlaying instance,
    TRes Function(Subscription$nowPlaying) then,
  ) = _CopyWithImpl$Subscription$nowPlaying;

  factory CopyWith$Subscription$nowPlaying.stub(TRes res) =
      _CopyWithStubImpl$Subscription$nowPlaying;

  TRes call({List<Fragment$fragmentPlaybackSession>? nowPlaying});
  TRes nowPlaying(
    Iterable<Fragment$fragmentPlaybackSession> Function(
      Iterable<
        CopyWith$Fragment$fragmentPlaybackSession<
          Fragment$fragmentPlaybackSession
        >
      >,
    )
    _fn,
  );
}

class _CopyWithImpl$Subscription$nowPlaying<TRes>
    implements CopyWith$Subscription$nowPlaying<TRes> {
  _CopyWithImpl$Subscription$nowPlaying(this._instance, this._then);

  final Subscription$nowPlaying _instance;

  final TRes Function(Subscription$nowPlaying) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? nowPlaying = _undefined}) => _then(
    Subscription$nowPlaying(
      nowPlaying: nowPlaying == _undefined || nowPlaying == null
          ? _instance.nowPlaying
          : (nowPlaying as List<Fragment$fragmentPlaybackSession>),
    ),
  );

  TRes nowPlaying(
    Iterable<Fragment$fragmentPlaybackSession> Function(
      Iterable<
        CopyWith$Fragment$fragmentPlaybackSession<
          Fragment$fragmentPlaybackSession
        >
      >,
    )
    _fn,
  ) => call(
    nowPlaying: _fn(
      _instance.nowPlaying.map(
        (e) => CopyWith$Fragment$fragmentPlaybackSession(e, (i) => i),
      ),
    ).toList(),
  );
}

class _CopyWithStubImpl$Subscription$nowPlaying<TRes>
    implements CopyWith$Subscription$nowPlaying<TRes> {
  _CopyWithStubImpl$Subscription$nowPlaying(this._res);

  TRes _res;

  call({List<Fragment$fragmentPlaybackSession>? nowPlaying}) => _res;

  nowPlaying(_fn) => _res;
}

const documentNodeSubscriptionnowPlaying = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.subscription,
      name: NameNode(value: 'nowPlaying'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'nowPlaying'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FragmentSpreadNode(
                  name: NameNode(value: 'fragmentPlaybackSession'),
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
    fragmentDefinitionfragmentPlaybackSession,
  ],
);
