import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Query$recentlyWatched {
  Query$recentlyWatched({this.recentlyWatched, this.$__typename = 'Query'});

  factory Query$recentlyWatched.fromJson(Map<String, dynamic> json) {
    final l$recentlyWatched = json['recentlyWatched'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched(
      recentlyWatched: (l$recentlyWatched as List<dynamic>?)
          ?.map(
            (e) => Query$recentlyWatched$recentlyWatched.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final List<Query$recentlyWatched$recentlyWatched>? recentlyWatched;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$recentlyWatched = recentlyWatched;
    _resultData['recentlyWatched'] = l$recentlyWatched
        ?.map((e) => e.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$recentlyWatched = recentlyWatched;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$recentlyWatched == null
          ? null
          : Object.hashAll(l$recentlyWatched.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched || runtimeType != other.runtimeType) {
      return false;
    }
    final l$recentlyWatched = recentlyWatched;
    final lOther$recentlyWatched = other.recentlyWatched;
    if (l$recentlyWatched != null && lOther$recentlyWatched != null) {
      if (l$recentlyWatched.length != lOther$recentlyWatched.length) {
        return false;
      }
      for (int i = 0; i < l$recentlyWatched.length; i++) {
        final l$recentlyWatched$entry = l$recentlyWatched[i];
        final lOther$recentlyWatched$entry = lOther$recentlyWatched[i];
        if (l$recentlyWatched$entry != lOther$recentlyWatched$entry) {
          return false;
        }
      }
    } else if (l$recentlyWatched != lOther$recentlyWatched) {
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

extension UtilityExtension$Query$recentlyWatched on Query$recentlyWatched {
  CopyWith$Query$recentlyWatched<Query$recentlyWatched> get copyWith =>
      CopyWith$Query$recentlyWatched(this, (i) => i);
}

abstract class CopyWith$Query$recentlyWatched<TRes> {
  factory CopyWith$Query$recentlyWatched(
    Query$recentlyWatched instance,
    TRes Function(Query$recentlyWatched) then,
  ) = _CopyWithImpl$Query$recentlyWatched;

  factory CopyWith$Query$recentlyWatched.stub(TRes res) =
      _CopyWithStubImpl$Query$recentlyWatched;

  TRes call({
    List<Query$recentlyWatched$recentlyWatched>? recentlyWatched,
    String? $__typename,
  });
  TRes recentlyWatched(
    Iterable<Query$recentlyWatched$recentlyWatched>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched<
          Query$recentlyWatched$recentlyWatched
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$recentlyWatched<TRes>
    implements CopyWith$Query$recentlyWatched<TRes> {
  _CopyWithImpl$Query$recentlyWatched(this._instance, this._then);

  final Query$recentlyWatched _instance;

  final TRes Function(Query$recentlyWatched) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? recentlyWatched = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched(
      recentlyWatched: recentlyWatched == _undefined
          ? _instance.recentlyWatched
          : (recentlyWatched as List<Query$recentlyWatched$recentlyWatched>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes recentlyWatched(
    Iterable<Query$recentlyWatched$recentlyWatched>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched<
          Query$recentlyWatched$recentlyWatched
        >
      >?,
    )
    _fn,
  ) => call(
    recentlyWatched: _fn(
      _instance.recentlyWatched?.map(
        (e) => CopyWith$Query$recentlyWatched$recentlyWatched(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched<TRes>
    implements CopyWith$Query$recentlyWatched<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched(this._res);

  TRes _res;

  call({
    List<Query$recentlyWatched$recentlyWatched>? recentlyWatched,
    String? $__typename,
  }) => _res;

  recentlyWatched(_fn) => _res;
}

const documentNodeQueryrecentlyWatched = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'recentlyWatched'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'recentlyWatched'),
            alias: null,
            arguments: [],
            directives: [],
            selectionSet: SelectionSetNode(
              selections: [
                FieldNode(
                  name: NameNode(value: 'type'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null,
                ),
                FieldNode(
                  name: NameNode(value: 'episode'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'id'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'number'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'show'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'id'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'metadata'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: SelectionSetNode(
                                selections: [
                                  FragmentSpreadNode(
                                    name: NameNode(value: 'fragmentMetadata'),
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
                              name: NameNode(value: 'images'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: SelectionSetNode(
                                selections: [
                                  FragmentSpreadNode(
                                    name: NameNode(value: 'fragmentImages'),
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
                      FieldNode(
                        name: NameNode(value: 'season'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'number'),
                              alias: null,
                              arguments: [],
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
                      FieldNode(
                        name: NameNode(value: 'watchStatus'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'id'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'playQueueItemId'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'progressInMilliseconds'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'watched'),
                              alias: null,
                              arguments: [],
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
                      FieldNode(
                        name: NameNode(value: 'mediaFile'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'id'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'durationInMilliseconds'),
                              alias: null,
                              arguments: [],
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
                      FieldNode(
                        name: NameNode(value: 'metadata'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'fragmentMetadata'),
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
                        name: NameNode(value: 'images'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'fragmentImages'),
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
                FieldNode(
                  name: NameNode(value: 'movie'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'id'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'name'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'images'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'fragmentImages'),
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
                        name: NameNode(value: 'metadata'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'fragmentMetadata'),
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
                        name: NameNode(value: 'watchStatus'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'id'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'playQueueItemId'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'progressInMilliseconds'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'watched'),
                              alias: null,
                              arguments: [],
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
                      FieldNode(
                        name: NameNode(value: 'mediaFile'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'id'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'durationInMilliseconds'),
                              alias: null,
                              arguments: [],
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
                  name: NameNode(value: 'chapter'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'id'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'number'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'book'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'id'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'name'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'title'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'images'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: SelectionSetNode(
                                selections: [
                                  FragmentSpreadNode(
                                    name: NameNode(value: 'fragmentImages'),
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
                              name: NameNode(value: 'metadata'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: SelectionSetNode(
                                selections: [
                                  FragmentSpreadNode(
                                    name: NameNode(value: 'fragmentMetadata'),
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
                      FieldNode(
                        name: NameNode(value: 'metadata'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'fragmentMetadata'),
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
                        name: NameNode(value: 'watchStatus'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'id'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'playQueueItemId'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'progressInMilliseconds'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'watched'),
                              alias: null,
                              arguments: [],
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
                      FieldNode(
                        name: NameNode(value: 'mediaFile'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'id'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'durationInMilliseconds'),
                              alias: null,
                              arguments: [],
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
                  name: NameNode(value: 'book'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'id'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'name'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'title'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'series'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'id'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'name'),
                              alias: null,
                              arguments: [],
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
                      FieldNode(
                        name: NameNode(value: 'images'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'fragmentImages'),
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
                        name: NameNode(value: 'metadata'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'fragmentMetadata'),
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
                        name: NameNode(value: 'watchStatus'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'id'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'watched'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'readingLocation'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'readingProgress'),
                              alias: null,
                              arguments: [],
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
                      FieldNode(
                        name: NameNode(value: 'epubFiles'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'id'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'path'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'format'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'mediaOverlays'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'directory'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: SelectionSetNode(
                                selections: [
                                  FieldNode(
                                    name: NameNode(value: 'node'),
                                    alias: null,
                                    arguments: [],
                                    directives: [],
                                    selectionSet: SelectionSetNode(
                                      selections: [
                                        FieldNode(
                                          name: NameNode(value: 'url'),
                                          alias: null,
                                          arguments: [],
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
                  name: NameNode(value: 'podcastEpisode'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FieldNode(
                        name: NameNode(value: 'id'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'publishedAt'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null,
                      ),
                      FieldNode(
                        name: NameNode(value: 'podcast'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'id'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'title'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'images'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: SelectionSetNode(
                                selections: [
                                  FragmentSpreadNode(
                                    name: NameNode(value: 'fragmentImages'),
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
                      FieldNode(
                        name: NameNode(value: 'metadata'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FragmentSpreadNode(
                              name: NameNode(value: 'fragmentMetadata'),
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
                        name: NameNode(value: 'watchStatus'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'id'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'playQueueItemId'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'progressInMilliseconds'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'watched'),
                              alias: null,
                              arguments: [],
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
                      FieldNode(
                        name: NameNode(value: 'mediaFile'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: SelectionSetNode(
                          selections: [
                            FieldNode(
                              name: NameNode(value: 'id'),
                              alias: null,
                              arguments: [],
                              directives: [],
                              selectionSet: null,
                            ),
                            FieldNode(
                              name: NameNode(value: 'durationInMilliseconds'),
                              alias: null,
                              arguments: [],
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
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentImages,
  ],
);

class Query$recentlyWatched$recentlyWatched {
  Query$recentlyWatched$recentlyWatched({
    required this.type,
    this.episode,
    this.movie,
    this.chapter,
    this.book,
    this.podcastEpisode,
    this.$__typename = 'RecentlyWatched',
  });

  factory Query$recentlyWatched$recentlyWatched.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$type = json['type'];
    final l$episode = json['episode'];
    final l$movie = json['movie'];
    final l$chapter = json['chapter'];
    final l$book = json['book'];
    final l$podcastEpisode = json['podcastEpisode'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched(
      type: fromJson$Enum$MediaType((l$type as String)),
      episode: l$episode == null
          ? null
          : Query$recentlyWatched$recentlyWatched$episode.fromJson(
              (l$episode as Map<String, dynamic>),
            ),
      movie: l$movie == null
          ? null
          : Query$recentlyWatched$recentlyWatched$movie.fromJson(
              (l$movie as Map<String, dynamic>),
            ),
      chapter: l$chapter == null
          ? null
          : Query$recentlyWatched$recentlyWatched$chapter.fromJson(
              (l$chapter as Map<String, dynamic>),
            ),
      book: l$book == null
          ? null
          : Query$recentlyWatched$recentlyWatched$book.fromJson(
              (l$book as Map<String, dynamic>),
            ),
      podcastEpisode: l$podcastEpisode == null
          ? null
          : Query$recentlyWatched$recentlyWatched$podcastEpisode.fromJson(
              (l$podcastEpisode as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$MediaType type;

  final Query$recentlyWatched$recentlyWatched$episode? episode;

  final Query$recentlyWatched$recentlyWatched$movie? movie;

  final Query$recentlyWatched$recentlyWatched$chapter? chapter;

  final Query$recentlyWatched$recentlyWatched$book? book;

  final Query$recentlyWatched$recentlyWatched$podcastEpisode? podcastEpisode;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$type = type;
    _resultData['type'] = toJson$Enum$MediaType(l$type);
    final l$episode = episode;
    _resultData['episode'] = l$episode?.toJson();
    final l$movie = movie;
    _resultData['movie'] = l$movie?.toJson();
    final l$chapter = chapter;
    _resultData['chapter'] = l$chapter?.toJson();
    final l$book = book;
    _resultData['book'] = l$book?.toJson();
    final l$podcastEpisode = podcastEpisode;
    _resultData['podcastEpisode'] = l$podcastEpisode?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$type = type;
    final l$episode = episode;
    final l$movie = movie;
    final l$chapter = chapter;
    final l$book = book;
    final l$podcastEpisode = podcastEpisode;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$type,
      l$episode,
      l$movie,
      l$chapter,
      l$book,
      l$podcastEpisode,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$type = type;
    final lOther$type = other.type;
    if (l$type != lOther$type) {
      return false;
    }
    final l$episode = episode;
    final lOther$episode = other.episode;
    if (l$episode != lOther$episode) {
      return false;
    }
    final l$movie = movie;
    final lOther$movie = other.movie;
    if (l$movie != lOther$movie) {
      return false;
    }
    final l$chapter = chapter;
    final lOther$chapter = other.chapter;
    if (l$chapter != lOther$chapter) {
      return false;
    }
    final l$book = book;
    final lOther$book = other.book;
    if (l$book != lOther$book) {
      return false;
    }
    final l$podcastEpisode = podcastEpisode;
    final lOther$podcastEpisode = other.podcastEpisode;
    if (l$podcastEpisode != lOther$podcastEpisode) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched
    on Query$recentlyWatched$recentlyWatched {
  CopyWith$Query$recentlyWatched$recentlyWatched<
    Query$recentlyWatched$recentlyWatched
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched(this, (i) => i);
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched<TRes> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched(
    Query$recentlyWatched$recentlyWatched instance,
    TRes Function(Query$recentlyWatched$recentlyWatched) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched;

  factory CopyWith$Query$recentlyWatched$recentlyWatched.stub(TRes res) =
      _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched;

  TRes call({
    Enum$MediaType? type,
    Query$recentlyWatched$recentlyWatched$episode? episode,
    Query$recentlyWatched$recentlyWatched$movie? movie,
    Query$recentlyWatched$recentlyWatched$chapter? chapter,
    Query$recentlyWatched$recentlyWatched$book? book,
    Query$recentlyWatched$recentlyWatched$podcastEpisode? podcastEpisode,
    String? $__typename,
  });
  CopyWith$Query$recentlyWatched$recentlyWatched$episode<TRes> get episode;
  CopyWith$Query$recentlyWatched$recentlyWatched$movie<TRes> get movie;
  CopyWith$Query$recentlyWatched$recentlyWatched$chapter<TRes> get chapter;
  CopyWith$Query$recentlyWatched$recentlyWatched$book<TRes> get book;
  CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode<TRes>
  get podcastEpisode;
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched<TRes>
    implements CopyWith$Query$recentlyWatched$recentlyWatched<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? type = _undefined,
    Object? episode = _undefined,
    Object? movie = _undefined,
    Object? chapter = _undefined,
    Object? book = _undefined,
    Object? podcastEpisode = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched(
      type: type == _undefined || type == null
          ? _instance.type
          : (type as Enum$MediaType),
      episode: episode == _undefined
          ? _instance.episode
          : (episode as Query$recentlyWatched$recentlyWatched$episode?),
      movie: movie == _undefined
          ? _instance.movie
          : (movie as Query$recentlyWatched$recentlyWatched$movie?),
      chapter: chapter == _undefined
          ? _instance.chapter
          : (chapter as Query$recentlyWatched$recentlyWatched$chapter?),
      book: book == _undefined
          ? _instance.book
          : (book as Query$recentlyWatched$recentlyWatched$book?),
      podcastEpisode: podcastEpisode == _undefined
          ? _instance.podcastEpisode
          : (podcastEpisode
                as Query$recentlyWatched$recentlyWatched$podcastEpisode?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$recentlyWatched$recentlyWatched$episode<TRes> get episode {
    final local$episode = _instance.episode;
    return local$episode == null
        ? CopyWith$Query$recentlyWatched$recentlyWatched$episode.stub(
            _then(_instance),
          )
        : CopyWith$Query$recentlyWatched$recentlyWatched$episode(
            local$episode,
            (e) => call(episode: e),
          );
  }

  CopyWith$Query$recentlyWatched$recentlyWatched$movie<TRes> get movie {
    final local$movie = _instance.movie;
    return local$movie == null
        ? CopyWith$Query$recentlyWatched$recentlyWatched$movie.stub(
            _then(_instance),
          )
        : CopyWith$Query$recentlyWatched$recentlyWatched$movie(
            local$movie,
            (e) => call(movie: e),
          );
  }

  CopyWith$Query$recentlyWatched$recentlyWatched$chapter<TRes> get chapter {
    final local$chapter = _instance.chapter;
    return local$chapter == null
        ? CopyWith$Query$recentlyWatched$recentlyWatched$chapter.stub(
            _then(_instance),
          )
        : CopyWith$Query$recentlyWatched$recentlyWatched$chapter(
            local$chapter,
            (e) => call(chapter: e),
          );
  }

  CopyWith$Query$recentlyWatched$recentlyWatched$book<TRes> get book {
    final local$book = _instance.book;
    return local$book == null
        ? CopyWith$Query$recentlyWatched$recentlyWatched$book.stub(
            _then(_instance),
          )
        : CopyWith$Query$recentlyWatched$recentlyWatched$book(
            local$book,
            (e) => call(book: e),
          );
  }

  CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode<TRes>
  get podcastEpisode {
    final local$podcastEpisode = _instance.podcastEpisode;
    return local$podcastEpisode == null
        ? CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode.stub(
            _then(_instance),
          )
        : CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode(
            local$podcastEpisode,
            (e) => call(podcastEpisode: e),
          );
  }
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched<TRes>
    implements CopyWith$Query$recentlyWatched$recentlyWatched<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched(this._res);

  TRes _res;

  call({
    Enum$MediaType? type,
    Query$recentlyWatched$recentlyWatched$episode? episode,
    Query$recentlyWatched$recentlyWatched$movie? movie,
    Query$recentlyWatched$recentlyWatched$chapter? chapter,
    Query$recentlyWatched$recentlyWatched$book? book,
    Query$recentlyWatched$recentlyWatched$podcastEpisode? podcastEpisode,
    String? $__typename,
  }) => _res;

  CopyWith$Query$recentlyWatched$recentlyWatched$episode<TRes> get episode =>
      CopyWith$Query$recentlyWatched$recentlyWatched$episode.stub(_res);

  CopyWith$Query$recentlyWatched$recentlyWatched$movie<TRes> get movie =>
      CopyWith$Query$recentlyWatched$recentlyWatched$movie.stub(_res);

  CopyWith$Query$recentlyWatched$recentlyWatched$chapter<TRes> get chapter =>
      CopyWith$Query$recentlyWatched$recentlyWatched$chapter.stub(_res);

  CopyWith$Query$recentlyWatched$recentlyWatched$book<TRes> get book =>
      CopyWith$Query$recentlyWatched$recentlyWatched$book.stub(_res);

  CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode<TRes>
  get podcastEpisode =>
      CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode.stub(_res);
}

class Query$recentlyWatched$recentlyWatched$episode {
  Query$recentlyWatched$recentlyWatched$episode({
    required this.id,
    required this.number,
    this.$show,
    this.season,
    this.watchStatus,
    this.mediaFile,
    this.metadata,
    this.images,
    this.$__typename = 'Episode',
  });

  factory Query$recentlyWatched$recentlyWatched$episode.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$$show = json['show'];
    final l$season = json['season'];
    final l$watchStatus = json['watchStatus'];
    final l$mediaFile = json['mediaFile'];
    final l$metadata = json['metadata'];
    final l$images = json['images'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$episode(
      id: (l$id as String),
      number: (l$number as int),
      $show: l$$show == null
          ? null
          : Query$recentlyWatched$recentlyWatched$episode$show.fromJson(
              (l$$show as Map<String, dynamic>),
            ),
      season: l$season == null
          ? null
          : Query$recentlyWatched$recentlyWatched$episode$season.fromJson(
              (l$season as Map<String, dynamic>),
            ),
      watchStatus: (l$watchStatus as List<dynamic>?)
          ?.map(
            (e) =>
                Query$recentlyWatched$recentlyWatched$episode$watchStatus.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map(
            (e) =>
                Query$recentlyWatched$recentlyWatched$episode$mediaFile.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      images: (l$images as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int number;

  final Query$recentlyWatched$recentlyWatched$episode$show? $show;

  final Query$recentlyWatched$recentlyWatched$episode$season? season;

  final List<Query$recentlyWatched$recentlyWatched$episode$watchStatus>?
  watchStatus;

  final List<Query$recentlyWatched$recentlyWatched$episode$mediaFile>?
  mediaFile;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Fragment$fragmentImages>? images;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$number = number;
    _resultData['number'] = l$number;
    final l$$show = $show;
    _resultData['show'] = l$$show?.toJson();
    final l$season = season;
    _resultData['season'] = l$season?.toJson();
    final l$watchStatus = watchStatus;
    _resultData['watchStatus'] = l$watchStatus?.map((e) => e.toJson()).toList();
    final l$mediaFile = mediaFile;
    _resultData['mediaFile'] = l$mediaFile?.map((e) => e.toJson()).toList();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$number = number;
    final l$$show = $show;
    final l$season = season;
    final l$watchStatus = watchStatus;
    final l$mediaFile = mediaFile;
    final l$metadata = metadata;
    final l$images = images;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$number,
      l$$show,
      l$season,
      l$watchStatus == null
          ? null
          : Object.hashAll(l$watchStatus.map((v) => v)),
      l$mediaFile == null ? null : Object.hashAll(l$mediaFile.map((v) => v)),
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$episode ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$number = number;
    final lOther$number = other.number;
    if (l$number != lOther$number) {
      return false;
    }
    final l$$show = $show;
    final lOther$$show = other.$show;
    if (l$$show != lOther$$show) {
      return false;
    }
    final l$season = season;
    final lOther$season = other.season;
    if (l$season != lOther$season) {
      return false;
    }
    final l$watchStatus = watchStatus;
    final lOther$watchStatus = other.watchStatus;
    if (l$watchStatus != null && lOther$watchStatus != null) {
      if (l$watchStatus.length != lOther$watchStatus.length) {
        return false;
      }
      for (int i = 0; i < l$watchStatus.length; i++) {
        final l$watchStatus$entry = l$watchStatus[i];
        final lOther$watchStatus$entry = lOther$watchStatus[i];
        if (l$watchStatus$entry != lOther$watchStatus$entry) {
          return false;
        }
      }
    } else if (l$watchStatus != lOther$watchStatus) {
      return false;
    }
    final l$mediaFile = mediaFile;
    final lOther$mediaFile = other.mediaFile;
    if (l$mediaFile != null && lOther$mediaFile != null) {
      if (l$mediaFile.length != lOther$mediaFile.length) {
        return false;
      }
      for (int i = 0; i < l$mediaFile.length; i++) {
        final l$mediaFile$entry = l$mediaFile[i];
        final lOther$mediaFile$entry = lOther$mediaFile[i];
        if (l$mediaFile$entry != lOther$mediaFile$entry) {
          return false;
        }
      }
    } else if (l$mediaFile != lOther$mediaFile) {
      return false;
    }
    final l$metadata = metadata;
    final lOther$metadata = other.metadata;
    if (l$metadata != null && lOther$metadata != null) {
      if (l$metadata.length != lOther$metadata.length) {
        return false;
      }
      for (int i = 0; i < l$metadata.length; i++) {
        final l$metadata$entry = l$metadata[i];
        final lOther$metadata$entry = lOther$metadata[i];
        if (l$metadata$entry != lOther$metadata$entry) {
          return false;
        }
      }
    } else if (l$metadata != lOther$metadata) {
      return false;
    }
    final l$images = images;
    final lOther$images = other.images;
    if (l$images != null && lOther$images != null) {
      if (l$images.length != lOther$images.length) {
        return false;
      }
      for (int i = 0; i < l$images.length; i++) {
        final l$images$entry = l$images[i];
        final lOther$images$entry = lOther$images[i];
        if (l$images$entry != lOther$images$entry) {
          return false;
        }
      }
    } else if (l$images != lOther$images) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$episode
    on Query$recentlyWatched$recentlyWatched$episode {
  CopyWith$Query$recentlyWatched$recentlyWatched$episode<
    Query$recentlyWatched$recentlyWatched$episode
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$episode(this, (i) => i);
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$episode<TRes> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$episode(
    Query$recentlyWatched$recentlyWatched$episode instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$episode) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$episode.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode;

  TRes call({
    String? id,
    int? number,
    Query$recentlyWatched$recentlyWatched$episode$show? $show,
    Query$recentlyWatched$recentlyWatched$episode$season? season,
    List<Query$recentlyWatched$recentlyWatched$episode$watchStatus>?
    watchStatus,
    List<Query$recentlyWatched$recentlyWatched$episode$mediaFile>? mediaFile,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  });
  CopyWith$Query$recentlyWatched$recentlyWatched$episode$show<TRes> get $show;
  CopyWith$Query$recentlyWatched$recentlyWatched$episode$season<TRes>
  get season;
  TRes watchStatus(
    Iterable<Query$recentlyWatched$recentlyWatched$episode$watchStatus>?
    Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$watchStatus<
          Query$recentlyWatched$recentlyWatched$episode$watchStatus
        >
      >?,
    )
    _fn,
  );
  TRes mediaFile(
    Iterable<Query$recentlyWatched$recentlyWatched$episode$mediaFile>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$mediaFile<
          Query$recentlyWatched$recentlyWatched$episode$mediaFile
        >
      >?,
    )
    _fn,
  );
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode<TRes>
    implements CopyWith$Query$recentlyWatched$recentlyWatched$episode<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$episode _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$episode) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? number = _undefined,
    Object? $show = _undefined,
    Object? season = _undefined,
    Object? watchStatus = _undefined,
    Object? mediaFile = _undefined,
    Object? metadata = _undefined,
    Object? images = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$episode(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      $show: $show == _undefined
          ? _instance.$show
          : ($show as Query$recentlyWatched$recentlyWatched$episode$show?),
      season: season == _undefined
          ? _instance.season
          : (season as Query$recentlyWatched$recentlyWatched$episode$season?),
      watchStatus: watchStatus == _undefined
          ? _instance.watchStatus
          : (watchStatus
                as List<
                  Query$recentlyWatched$recentlyWatched$episode$watchStatus
                >?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile
                as List<
                  Query$recentlyWatched$recentlyWatched$episode$mediaFile
                >?),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$recentlyWatched$recentlyWatched$episode$show<TRes> get $show {
    final local$$show = _instance.$show;
    return local$$show == null
        ? CopyWith$Query$recentlyWatched$recentlyWatched$episode$show.stub(
            _then(_instance),
          )
        : CopyWith$Query$recentlyWatched$recentlyWatched$episode$show(
            local$$show,
            (e) => call($show: e),
          );
  }

  CopyWith$Query$recentlyWatched$recentlyWatched$episode$season<TRes>
  get season {
    final local$season = _instance.season;
    return local$season == null
        ? CopyWith$Query$recentlyWatched$recentlyWatched$episode$season.stub(
            _then(_instance),
          )
        : CopyWith$Query$recentlyWatched$recentlyWatched$episode$season(
            local$season,
            (e) => call(season: e),
          );
  }

  TRes watchStatus(
    Iterable<Query$recentlyWatched$recentlyWatched$episode$watchStatus>?
    Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$watchStatus<
          Query$recentlyWatched$recentlyWatched$episode$watchStatus
        >
      >?,
    )
    _fn,
  ) => call(
    watchStatus: _fn(
      _instance.watchStatus?.map(
        (e) =>
            CopyWith$Query$recentlyWatched$recentlyWatched$episode$watchStatus(
              e,
              (i) => i,
            ),
      ),
    )?.toList(),
  );

  TRes mediaFile(
    Iterable<Query$recentlyWatched$recentlyWatched$episode$mediaFile>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$mediaFile<
          Query$recentlyWatched$recentlyWatched$episode$mediaFile
        >
      >?,
    )
    _fn,
  ) => call(
    mediaFile: _fn(
      _instance.mediaFile?.map(
        (e) => CopyWith$Query$recentlyWatched$recentlyWatched$episode$mediaFile(
          e,
          (i) => i,
        ),
      ),
    )?.toList(),
  );

  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  ) => call(
    metadata: _fn(
      _instance.metadata?.map(
        (e) => CopyWith$Fragment$fragmentMetadata(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  ) => call(
    images: _fn(
      _instance.images?.map(
        (e) => CopyWith$Fragment$fragmentImages(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode<TRes>
    implements CopyWith$Query$recentlyWatched$recentlyWatched$episode<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode(this._res);

  TRes _res;

  call({
    String? id,
    int? number,
    Query$recentlyWatched$recentlyWatched$episode$show? $show,
    Query$recentlyWatched$recentlyWatched$episode$season? season,
    List<Query$recentlyWatched$recentlyWatched$episode$watchStatus>?
    watchStatus,
    List<Query$recentlyWatched$recentlyWatched$episode$mediaFile>? mediaFile,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  }) => _res;

  CopyWith$Query$recentlyWatched$recentlyWatched$episode$show<TRes> get $show =>
      CopyWith$Query$recentlyWatched$recentlyWatched$episode$show.stub(_res);

  CopyWith$Query$recentlyWatched$recentlyWatched$episode$season<TRes>
  get season =>
      CopyWith$Query$recentlyWatched$recentlyWatched$episode$season.stub(_res);

  watchStatus(_fn) => _res;

  mediaFile(_fn) => _res;

  metadata(_fn) => _res;

  images(_fn) => _res;
}

class Query$recentlyWatched$recentlyWatched$episode$show {
  Query$recentlyWatched$recentlyWatched$episode$show({
    required this.id,
    this.metadata,
    this.images,
    this.$__typename = 'Show',
  });

  factory Query$recentlyWatched$recentlyWatched$episode$show.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$metadata = json['metadata'];
    final l$images = json['images'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$episode$show(
      id: (l$id as String),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      images: (l$images as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Fragment$fragmentImages>? images;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$metadata = metadata;
    final l$images = images;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$episode$show ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$metadata = metadata;
    final lOther$metadata = other.metadata;
    if (l$metadata != null && lOther$metadata != null) {
      if (l$metadata.length != lOther$metadata.length) {
        return false;
      }
      for (int i = 0; i < l$metadata.length; i++) {
        final l$metadata$entry = l$metadata[i];
        final lOther$metadata$entry = lOther$metadata[i];
        if (l$metadata$entry != lOther$metadata$entry) {
          return false;
        }
      }
    } else if (l$metadata != lOther$metadata) {
      return false;
    }
    final l$images = images;
    final lOther$images = other.images;
    if (l$images != null && lOther$images != null) {
      if (l$images.length != lOther$images.length) {
        return false;
      }
      for (int i = 0; i < l$images.length; i++) {
        final l$images$entry = l$images[i];
        final lOther$images$entry = lOther$images[i];
        if (l$images$entry != lOther$images$entry) {
          return false;
        }
      }
    } else if (l$images != lOther$images) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$episode$show
    on Query$recentlyWatched$recentlyWatched$episode$show {
  CopyWith$Query$recentlyWatched$recentlyWatched$episode$show<
    Query$recentlyWatched$recentlyWatched$episode$show
  >
  get copyWith => CopyWith$Query$recentlyWatched$recentlyWatched$episode$show(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$episode$show<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$episode$show(
    Query$recentlyWatched$recentlyWatched$episode$show instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$episode$show) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$show;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$episode$show.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$show;

  TRes call({
    String? id,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  });
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$show<TRes>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$show<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$show(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$episode$show _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$episode$show) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? metadata = _undefined,
    Object? images = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$episode$show(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  ) => call(
    metadata: _fn(
      _instance.metadata?.map(
        (e) => CopyWith$Fragment$fragmentMetadata(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  ) => call(
    images: _fn(
      _instance.images?.map(
        (e) => CopyWith$Fragment$fragmentImages(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$show<TRes>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$show<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$show(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  }) => _res;

  metadata(_fn) => _res;

  images(_fn) => _res;
}

class Query$recentlyWatched$recentlyWatched$episode$season {
  Query$recentlyWatched$recentlyWatched$episode$season({
    required this.number,
    this.$__typename = 'Season',
  });

  factory Query$recentlyWatched$recentlyWatched$episode$season.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$number = json['number'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$episode$season(
      number: (l$number as int),
      $__typename: (l$$__typename as String),
    );
  }

  final int number;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$number = number;
    _resultData['number'] = l$number;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$number = number;
    final l$$__typename = $__typename;
    return Object.hashAll([l$number, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$episode$season ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$number = number;
    final lOther$number = other.number;
    if (l$number != lOther$number) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$episode$season
    on Query$recentlyWatched$recentlyWatched$episode$season {
  CopyWith$Query$recentlyWatched$recentlyWatched$episode$season<
    Query$recentlyWatched$recentlyWatched$episode$season
  >
  get copyWith => CopyWith$Query$recentlyWatched$recentlyWatched$episode$season(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$episode$season<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$episode$season(
    Query$recentlyWatched$recentlyWatched$episode$season instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$episode$season) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$season;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$episode$season.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$season;

  TRes call({int? number, String? $__typename});
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$season<TRes>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$season<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$season(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$episode$season _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$episode$season)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? number = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$recentlyWatched$recentlyWatched$episode$season(
          number: number == _undefined || number == null
              ? _instance.number
              : (number as int),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$season<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$season<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$season(
    this._res,
  );

  TRes _res;

  call({int? number, String? $__typename}) => _res;
}

class Query$recentlyWatched$recentlyWatched$episode$watchStatus {
  Query$recentlyWatched$recentlyWatched$episode$watchStatus({
    required this.id,
    required this.playQueueItemId,
    required this.progressInMilliseconds,
    required this.watched,
    this.$__typename = 'WatchStatus',
  });

  factory Query$recentlyWatched$recentlyWatched$episode$watchStatus.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$playQueueItemId = json['playQueueItemId'];
    final l$progressInMilliseconds = json['progressInMilliseconds'];
    final l$watched = json['watched'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$episode$watchStatus(
      id: (l$id as String),
      playQueueItemId: (l$playQueueItemId as String),
      progressInMilliseconds: (l$progressInMilliseconds as int),
      watched: (l$watched as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String playQueueItemId;

  final int progressInMilliseconds;

  final bool watched;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$playQueueItemId = playQueueItemId;
    _resultData['playQueueItemId'] = l$playQueueItemId;
    final l$progressInMilliseconds = progressInMilliseconds;
    _resultData['progressInMilliseconds'] = l$progressInMilliseconds;
    final l$watched = watched;
    _resultData['watched'] = l$watched;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$playQueueItemId = playQueueItemId;
    final l$progressInMilliseconds = progressInMilliseconds;
    final l$watched = watched;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$playQueueItemId,
      l$progressInMilliseconds,
      l$watched,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$episode$watchStatus ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$playQueueItemId = playQueueItemId;
    final lOther$playQueueItemId = other.playQueueItemId;
    if (l$playQueueItemId != lOther$playQueueItemId) {
      return false;
    }
    final l$progressInMilliseconds = progressInMilliseconds;
    final lOther$progressInMilliseconds = other.progressInMilliseconds;
    if (l$progressInMilliseconds != lOther$progressInMilliseconds) {
      return false;
    }
    final l$watched = watched;
    final lOther$watched = other.watched;
    if (l$watched != lOther$watched) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$episode$watchStatus
    on Query$recentlyWatched$recentlyWatched$episode$watchStatus {
  CopyWith$Query$recentlyWatched$recentlyWatched$episode$watchStatus<
    Query$recentlyWatched$recentlyWatched$episode$watchStatus
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$episode$watchStatus(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$episode$watchStatus<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$episode$watchStatus(
    Query$recentlyWatched$recentlyWatched$episode$watchStatus instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$episode$watchStatus)
    then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$watchStatus;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$episode$watchStatus.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$watchStatus;

  TRes call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$watchStatus<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$watchStatus<
          TRes
        > {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$watchStatus(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$episode$watchStatus _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$episode$watchStatus)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? playQueueItemId = _undefined,
    Object? progressInMilliseconds = _undefined,
    Object? watched = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$episode$watchStatus(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      playQueueItemId: playQueueItemId == _undefined || playQueueItemId == null
          ? _instance.playQueueItemId
          : (playQueueItemId as String),
      progressInMilliseconds:
          progressInMilliseconds == _undefined || progressInMilliseconds == null
          ? _instance.progressInMilliseconds
          : (progressInMilliseconds as int),
      watched: watched == _undefined || watched == null
          ? _instance.watched
          : (watched as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$watchStatus<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$watchStatus<
          TRes
        > {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$watchStatus(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  }) => _res;
}

class Query$recentlyWatched$recentlyWatched$episode$mediaFile {
  Query$recentlyWatched$recentlyWatched$episode$mediaFile({
    required this.id,
    this.durationInMilliseconds,
    this.$__typename = 'MediaFile',
  });

  factory Query$recentlyWatched$recentlyWatched$episode$mediaFile.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$durationInMilliseconds = json['durationInMilliseconds'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$episode$mediaFile(
      id: (l$id as String),
      durationInMilliseconds: (l$durationInMilliseconds as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int? durationInMilliseconds;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$durationInMilliseconds = durationInMilliseconds;
    _resultData['durationInMilliseconds'] = l$durationInMilliseconds;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$durationInMilliseconds = durationInMilliseconds;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$durationInMilliseconds, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$episode$mediaFile ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$durationInMilliseconds = durationInMilliseconds;
    final lOther$durationInMilliseconds = other.durationInMilliseconds;
    if (l$durationInMilliseconds != lOther$durationInMilliseconds) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$episode$mediaFile
    on Query$recentlyWatched$recentlyWatched$episode$mediaFile {
  CopyWith$Query$recentlyWatched$recentlyWatched$episode$mediaFile<
    Query$recentlyWatched$recentlyWatched$episode$mediaFile
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$episode$mediaFile(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$episode$mediaFile<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$episode$mediaFile(
    Query$recentlyWatched$recentlyWatched$episode$mediaFile instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$episode$mediaFile) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$mediaFile;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$episode$mediaFile.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$mediaFile;

  TRes call({String? id, int? durationInMilliseconds, String? $__typename});
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$mediaFile<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$mediaFile<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$episode$mediaFile(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$episode$mediaFile _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$episode$mediaFile)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? durationInMilliseconds = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$episode$mediaFile(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      durationInMilliseconds: durationInMilliseconds == _undefined
          ? _instance.durationInMilliseconds
          : (durationInMilliseconds as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$mediaFile<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$episode$mediaFile<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$episode$mediaFile(
    this._res,
  );

  TRes _res;

  call({String? id, int? durationInMilliseconds, String? $__typename}) => _res;
}

class Query$recentlyWatched$recentlyWatched$movie {
  Query$recentlyWatched$recentlyWatched$movie({
    required this.id,
    required this.name,
    this.images,
    this.metadata,
    this.watchStatus,
    this.mediaFile,
    this.$__typename = 'Movie',
  });

  factory Query$recentlyWatched$recentlyWatched$movie.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$watchStatus = json['watchStatus'];
    final l$mediaFile = json['mediaFile'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$movie(
      id: (l$id as String),
      name: (l$name as String),
      images: (l$images as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      watchStatus: (l$watchStatus as List<dynamic>?)
          ?.map(
            (e) =>
                Query$recentlyWatched$recentlyWatched$movie$watchStatus.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map(
            (e) =>
                Query$recentlyWatched$recentlyWatched$movie$mediaFile.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final List<Fragment$fragmentImages>? images;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Query$recentlyWatched$recentlyWatched$movie$watchStatus>?
  watchStatus;

  final List<Query$recentlyWatched$recentlyWatched$movie$mediaFile>? mediaFile;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$watchStatus = watchStatus;
    _resultData['watchStatus'] = l$watchStatus?.map((e) => e.toJson()).toList();
    final l$mediaFile = mediaFile;
    _resultData['mediaFile'] = l$mediaFile?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$images = images;
    final l$metadata = metadata;
    final l$watchStatus = watchStatus;
    final l$mediaFile = mediaFile;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$watchStatus == null
          ? null
          : Object.hashAll(l$watchStatus.map((v) => v)),
      l$mediaFile == null ? null : Object.hashAll(l$mediaFile.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$movie ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$images = images;
    final lOther$images = other.images;
    if (l$images != null && lOther$images != null) {
      if (l$images.length != lOther$images.length) {
        return false;
      }
      for (int i = 0; i < l$images.length; i++) {
        final l$images$entry = l$images[i];
        final lOther$images$entry = lOther$images[i];
        if (l$images$entry != lOther$images$entry) {
          return false;
        }
      }
    } else if (l$images != lOther$images) {
      return false;
    }
    final l$metadata = metadata;
    final lOther$metadata = other.metadata;
    if (l$metadata != null && lOther$metadata != null) {
      if (l$metadata.length != lOther$metadata.length) {
        return false;
      }
      for (int i = 0; i < l$metadata.length; i++) {
        final l$metadata$entry = l$metadata[i];
        final lOther$metadata$entry = lOther$metadata[i];
        if (l$metadata$entry != lOther$metadata$entry) {
          return false;
        }
      }
    } else if (l$metadata != lOther$metadata) {
      return false;
    }
    final l$watchStatus = watchStatus;
    final lOther$watchStatus = other.watchStatus;
    if (l$watchStatus != null && lOther$watchStatus != null) {
      if (l$watchStatus.length != lOther$watchStatus.length) {
        return false;
      }
      for (int i = 0; i < l$watchStatus.length; i++) {
        final l$watchStatus$entry = l$watchStatus[i];
        final lOther$watchStatus$entry = lOther$watchStatus[i];
        if (l$watchStatus$entry != lOther$watchStatus$entry) {
          return false;
        }
      }
    } else if (l$watchStatus != lOther$watchStatus) {
      return false;
    }
    final l$mediaFile = mediaFile;
    final lOther$mediaFile = other.mediaFile;
    if (l$mediaFile != null && lOther$mediaFile != null) {
      if (l$mediaFile.length != lOther$mediaFile.length) {
        return false;
      }
      for (int i = 0; i < l$mediaFile.length; i++) {
        final l$mediaFile$entry = l$mediaFile[i];
        final lOther$mediaFile$entry = lOther$mediaFile[i];
        if (l$mediaFile$entry != lOther$mediaFile$entry) {
          return false;
        }
      }
    } else if (l$mediaFile != lOther$mediaFile) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$movie
    on Query$recentlyWatched$recentlyWatched$movie {
  CopyWith$Query$recentlyWatched$recentlyWatched$movie<
    Query$recentlyWatched$recentlyWatched$movie
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$movie(this, (i) => i);
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$movie<TRes> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$movie(
    Query$recentlyWatched$recentlyWatched$movie instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$movie) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$movie;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$movie.stub(TRes res) =
      _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$movie;

  TRes call({
    String? id,
    String? name,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    List<Query$recentlyWatched$recentlyWatched$movie$watchStatus>? watchStatus,
    List<Query$recentlyWatched$recentlyWatched$movie$mediaFile>? mediaFile,
    String? $__typename,
  });
  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  );
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
  TRes watchStatus(
    Iterable<Query$recentlyWatched$recentlyWatched$movie$watchStatus>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$movie$watchStatus<
          Query$recentlyWatched$recentlyWatched$movie$watchStatus
        >
      >?,
    )
    _fn,
  );
  TRes mediaFile(
    Iterable<Query$recentlyWatched$recentlyWatched$movie$mediaFile>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$movie$mediaFile<
          Query$recentlyWatched$recentlyWatched$movie$mediaFile
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$movie<TRes>
    implements CopyWith$Query$recentlyWatched$recentlyWatched$movie<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$movie(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$movie _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$movie) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? watchStatus = _undefined,
    Object? mediaFile = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$movie(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      watchStatus: watchStatus == _undefined
          ? _instance.watchStatus
          : (watchStatus
                as List<
                  Query$recentlyWatched$recentlyWatched$movie$watchStatus
                >?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile
                as List<
                  Query$recentlyWatched$recentlyWatched$movie$mediaFile
                >?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  ) => call(
    images: _fn(
      _instance.images?.map(
        (e) => CopyWith$Fragment$fragmentImages(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  ) => call(
    metadata: _fn(
      _instance.metadata?.map(
        (e) => CopyWith$Fragment$fragmentMetadata(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes watchStatus(
    Iterable<Query$recentlyWatched$recentlyWatched$movie$watchStatus>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$movie$watchStatus<
          Query$recentlyWatched$recentlyWatched$movie$watchStatus
        >
      >?,
    )
    _fn,
  ) => call(
    watchStatus: _fn(
      _instance.watchStatus?.map(
        (e) => CopyWith$Query$recentlyWatched$recentlyWatched$movie$watchStatus(
          e,
          (i) => i,
        ),
      ),
    )?.toList(),
  );

  TRes mediaFile(
    Iterable<Query$recentlyWatched$recentlyWatched$movie$mediaFile>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$movie$mediaFile<
          Query$recentlyWatched$recentlyWatched$movie$mediaFile
        >
      >?,
    )
    _fn,
  ) => call(
    mediaFile: _fn(
      _instance.mediaFile?.map(
        (e) => CopyWith$Query$recentlyWatched$recentlyWatched$movie$mediaFile(
          e,
          (i) => i,
        ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$movie<TRes>
    implements CopyWith$Query$recentlyWatched$recentlyWatched$movie<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$movie(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    List<Query$recentlyWatched$recentlyWatched$movie$watchStatus>? watchStatus,
    List<Query$recentlyWatched$recentlyWatched$movie$mediaFile>? mediaFile,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;

  metadata(_fn) => _res;

  watchStatus(_fn) => _res;

  mediaFile(_fn) => _res;
}

class Query$recentlyWatched$recentlyWatched$movie$watchStatus {
  Query$recentlyWatched$recentlyWatched$movie$watchStatus({
    required this.id,
    required this.playQueueItemId,
    required this.progressInMilliseconds,
    required this.watched,
    this.$__typename = 'WatchStatus',
  });

  factory Query$recentlyWatched$recentlyWatched$movie$watchStatus.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$playQueueItemId = json['playQueueItemId'];
    final l$progressInMilliseconds = json['progressInMilliseconds'];
    final l$watched = json['watched'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$movie$watchStatus(
      id: (l$id as String),
      playQueueItemId: (l$playQueueItemId as String),
      progressInMilliseconds: (l$progressInMilliseconds as int),
      watched: (l$watched as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String playQueueItemId;

  final int progressInMilliseconds;

  final bool watched;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$playQueueItemId = playQueueItemId;
    _resultData['playQueueItemId'] = l$playQueueItemId;
    final l$progressInMilliseconds = progressInMilliseconds;
    _resultData['progressInMilliseconds'] = l$progressInMilliseconds;
    final l$watched = watched;
    _resultData['watched'] = l$watched;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$playQueueItemId = playQueueItemId;
    final l$progressInMilliseconds = progressInMilliseconds;
    final l$watched = watched;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$playQueueItemId,
      l$progressInMilliseconds,
      l$watched,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$movie$watchStatus ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$playQueueItemId = playQueueItemId;
    final lOther$playQueueItemId = other.playQueueItemId;
    if (l$playQueueItemId != lOther$playQueueItemId) {
      return false;
    }
    final l$progressInMilliseconds = progressInMilliseconds;
    final lOther$progressInMilliseconds = other.progressInMilliseconds;
    if (l$progressInMilliseconds != lOther$progressInMilliseconds) {
      return false;
    }
    final l$watched = watched;
    final lOther$watched = other.watched;
    if (l$watched != lOther$watched) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$movie$watchStatus
    on Query$recentlyWatched$recentlyWatched$movie$watchStatus {
  CopyWith$Query$recentlyWatched$recentlyWatched$movie$watchStatus<
    Query$recentlyWatched$recentlyWatched$movie$watchStatus
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$movie$watchStatus(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$movie$watchStatus<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$movie$watchStatus(
    Query$recentlyWatched$recentlyWatched$movie$watchStatus instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$movie$watchStatus) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$movie$watchStatus;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$movie$watchStatus.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$movie$watchStatus;

  TRes call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$movie$watchStatus<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$movie$watchStatus<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$movie$watchStatus(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$movie$watchStatus _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$movie$watchStatus)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? playQueueItemId = _undefined,
    Object? progressInMilliseconds = _undefined,
    Object? watched = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$movie$watchStatus(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      playQueueItemId: playQueueItemId == _undefined || playQueueItemId == null
          ? _instance.playQueueItemId
          : (playQueueItemId as String),
      progressInMilliseconds:
          progressInMilliseconds == _undefined || progressInMilliseconds == null
          ? _instance.progressInMilliseconds
          : (progressInMilliseconds as int),
      watched: watched == _undefined || watched == null
          ? _instance.watched
          : (watched as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$movie$watchStatus<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$movie$watchStatus<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$movie$watchStatus(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  }) => _res;
}

class Query$recentlyWatched$recentlyWatched$movie$mediaFile {
  Query$recentlyWatched$recentlyWatched$movie$mediaFile({
    required this.id,
    this.durationInMilliseconds,
    this.$__typename = 'MediaFile',
  });

  factory Query$recentlyWatched$recentlyWatched$movie$mediaFile.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$durationInMilliseconds = json['durationInMilliseconds'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$movie$mediaFile(
      id: (l$id as String),
      durationInMilliseconds: (l$durationInMilliseconds as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int? durationInMilliseconds;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$durationInMilliseconds = durationInMilliseconds;
    _resultData['durationInMilliseconds'] = l$durationInMilliseconds;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$durationInMilliseconds = durationInMilliseconds;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$durationInMilliseconds, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$movie$mediaFile ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$durationInMilliseconds = durationInMilliseconds;
    final lOther$durationInMilliseconds = other.durationInMilliseconds;
    if (l$durationInMilliseconds != lOther$durationInMilliseconds) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$movie$mediaFile
    on Query$recentlyWatched$recentlyWatched$movie$mediaFile {
  CopyWith$Query$recentlyWatched$recentlyWatched$movie$mediaFile<
    Query$recentlyWatched$recentlyWatched$movie$mediaFile
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$movie$mediaFile(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$movie$mediaFile<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$movie$mediaFile(
    Query$recentlyWatched$recentlyWatched$movie$mediaFile instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$movie$mediaFile) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$movie$mediaFile;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$movie$mediaFile.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$movie$mediaFile;

  TRes call({String? id, int? durationInMilliseconds, String? $__typename});
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$movie$mediaFile<TRes>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$movie$mediaFile<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$movie$mediaFile(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$movie$mediaFile _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$movie$mediaFile)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? durationInMilliseconds = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$movie$mediaFile(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      durationInMilliseconds: durationInMilliseconds == _undefined
          ? _instance.durationInMilliseconds
          : (durationInMilliseconds as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$movie$mediaFile<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$movie$mediaFile<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$movie$mediaFile(
    this._res,
  );

  TRes _res;

  call({String? id, int? durationInMilliseconds, String? $__typename}) => _res;
}

class Query$recentlyWatched$recentlyWatched$chapter {
  Query$recentlyWatched$recentlyWatched$chapter({
    required this.id,
    required this.number,
    required this.book,
    this.metadata,
    this.watchStatus,
    this.mediaFile,
    this.$__typename = 'Chapter',
  });

  factory Query$recentlyWatched$recentlyWatched$chapter.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$book = json['book'];
    final l$metadata = json['metadata'];
    final l$watchStatus = json['watchStatus'];
    final l$mediaFile = json['mediaFile'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$chapter(
      id: (l$id as String),
      number: (l$number as int),
      book: Query$recentlyWatched$recentlyWatched$chapter$book.fromJson(
        (l$book as Map<String, dynamic>),
      ),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      watchStatus: (l$watchStatus as List<dynamic>?)
          ?.map(
            (e) =>
                Query$recentlyWatched$recentlyWatched$chapter$watchStatus.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map(
            (e) =>
                Query$recentlyWatched$recentlyWatched$chapter$mediaFile.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int number;

  final Query$recentlyWatched$recentlyWatched$chapter$book book;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Query$recentlyWatched$recentlyWatched$chapter$watchStatus>?
  watchStatus;

  final List<Query$recentlyWatched$recentlyWatched$chapter$mediaFile>?
  mediaFile;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$number = number;
    _resultData['number'] = l$number;
    final l$book = book;
    _resultData['book'] = l$book.toJson();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$watchStatus = watchStatus;
    _resultData['watchStatus'] = l$watchStatus?.map((e) => e.toJson()).toList();
    final l$mediaFile = mediaFile;
    _resultData['mediaFile'] = l$mediaFile?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$number = number;
    final l$book = book;
    final l$metadata = metadata;
    final l$watchStatus = watchStatus;
    final l$mediaFile = mediaFile;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$number,
      l$book,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$watchStatus == null
          ? null
          : Object.hashAll(l$watchStatus.map((v) => v)),
      l$mediaFile == null ? null : Object.hashAll(l$mediaFile.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$chapter ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$number = number;
    final lOther$number = other.number;
    if (l$number != lOther$number) {
      return false;
    }
    final l$book = book;
    final lOther$book = other.book;
    if (l$book != lOther$book) {
      return false;
    }
    final l$metadata = metadata;
    final lOther$metadata = other.metadata;
    if (l$metadata != null && lOther$metadata != null) {
      if (l$metadata.length != lOther$metadata.length) {
        return false;
      }
      for (int i = 0; i < l$metadata.length; i++) {
        final l$metadata$entry = l$metadata[i];
        final lOther$metadata$entry = lOther$metadata[i];
        if (l$metadata$entry != lOther$metadata$entry) {
          return false;
        }
      }
    } else if (l$metadata != lOther$metadata) {
      return false;
    }
    final l$watchStatus = watchStatus;
    final lOther$watchStatus = other.watchStatus;
    if (l$watchStatus != null && lOther$watchStatus != null) {
      if (l$watchStatus.length != lOther$watchStatus.length) {
        return false;
      }
      for (int i = 0; i < l$watchStatus.length; i++) {
        final l$watchStatus$entry = l$watchStatus[i];
        final lOther$watchStatus$entry = lOther$watchStatus[i];
        if (l$watchStatus$entry != lOther$watchStatus$entry) {
          return false;
        }
      }
    } else if (l$watchStatus != lOther$watchStatus) {
      return false;
    }
    final l$mediaFile = mediaFile;
    final lOther$mediaFile = other.mediaFile;
    if (l$mediaFile != null && lOther$mediaFile != null) {
      if (l$mediaFile.length != lOther$mediaFile.length) {
        return false;
      }
      for (int i = 0; i < l$mediaFile.length; i++) {
        final l$mediaFile$entry = l$mediaFile[i];
        final lOther$mediaFile$entry = lOther$mediaFile[i];
        if (l$mediaFile$entry != lOther$mediaFile$entry) {
          return false;
        }
      }
    } else if (l$mediaFile != lOther$mediaFile) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$chapter
    on Query$recentlyWatched$recentlyWatched$chapter {
  CopyWith$Query$recentlyWatched$recentlyWatched$chapter<
    Query$recentlyWatched$recentlyWatched$chapter
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$chapter(this, (i) => i);
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$chapter<TRes> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$chapter(
    Query$recentlyWatched$recentlyWatched$chapter instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$chapter) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$chapter;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$chapter.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$chapter;

  TRes call({
    String? id,
    int? number,
    Query$recentlyWatched$recentlyWatched$chapter$book? book,
    List<Fragment$fragmentMetadata>? metadata,
    List<Query$recentlyWatched$recentlyWatched$chapter$watchStatus>?
    watchStatus,
    List<Query$recentlyWatched$recentlyWatched$chapter$mediaFile>? mediaFile,
    String? $__typename,
  });
  CopyWith$Query$recentlyWatched$recentlyWatched$chapter$book<TRes> get book;
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
  TRes watchStatus(
    Iterable<Query$recentlyWatched$recentlyWatched$chapter$watchStatus>?
    Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$chapter$watchStatus<
          Query$recentlyWatched$recentlyWatched$chapter$watchStatus
        >
      >?,
    )
    _fn,
  );
  TRes mediaFile(
    Iterable<Query$recentlyWatched$recentlyWatched$chapter$mediaFile>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$chapter$mediaFile<
          Query$recentlyWatched$recentlyWatched$chapter$mediaFile
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$chapter<TRes>
    implements CopyWith$Query$recentlyWatched$recentlyWatched$chapter<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$chapter(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$chapter _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$chapter) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? number = _undefined,
    Object? book = _undefined,
    Object? metadata = _undefined,
    Object? watchStatus = _undefined,
    Object? mediaFile = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$chapter(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      book: book == _undefined || book == null
          ? _instance.book
          : (book as Query$recentlyWatched$recentlyWatched$chapter$book),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      watchStatus: watchStatus == _undefined
          ? _instance.watchStatus
          : (watchStatus
                as List<
                  Query$recentlyWatched$recentlyWatched$chapter$watchStatus
                >?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile
                as List<
                  Query$recentlyWatched$recentlyWatched$chapter$mediaFile
                >?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$recentlyWatched$recentlyWatched$chapter$book<TRes> get book {
    final local$book = _instance.book;
    return CopyWith$Query$recentlyWatched$recentlyWatched$chapter$book(
      local$book,
      (e) => call(book: e),
    );
  }

  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  ) => call(
    metadata: _fn(
      _instance.metadata?.map(
        (e) => CopyWith$Fragment$fragmentMetadata(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes watchStatus(
    Iterable<Query$recentlyWatched$recentlyWatched$chapter$watchStatus>?
    Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$chapter$watchStatus<
          Query$recentlyWatched$recentlyWatched$chapter$watchStatus
        >
      >?,
    )
    _fn,
  ) => call(
    watchStatus: _fn(
      _instance.watchStatus?.map(
        (e) =>
            CopyWith$Query$recentlyWatched$recentlyWatched$chapter$watchStatus(
              e,
              (i) => i,
            ),
      ),
    )?.toList(),
  );

  TRes mediaFile(
    Iterable<Query$recentlyWatched$recentlyWatched$chapter$mediaFile>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$chapter$mediaFile<
          Query$recentlyWatched$recentlyWatched$chapter$mediaFile
        >
      >?,
    )
    _fn,
  ) => call(
    mediaFile: _fn(
      _instance.mediaFile?.map(
        (e) => CopyWith$Query$recentlyWatched$recentlyWatched$chapter$mediaFile(
          e,
          (i) => i,
        ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$chapter<TRes>
    implements CopyWith$Query$recentlyWatched$recentlyWatched$chapter<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$chapter(this._res);

  TRes _res;

  call({
    String? id,
    int? number,
    Query$recentlyWatched$recentlyWatched$chapter$book? book,
    List<Fragment$fragmentMetadata>? metadata,
    List<Query$recentlyWatched$recentlyWatched$chapter$watchStatus>?
    watchStatus,
    List<Query$recentlyWatched$recentlyWatched$chapter$mediaFile>? mediaFile,
    String? $__typename,
  }) => _res;

  CopyWith$Query$recentlyWatched$recentlyWatched$chapter$book<TRes> get book =>
      CopyWith$Query$recentlyWatched$recentlyWatched$chapter$book.stub(_res);

  metadata(_fn) => _res;

  watchStatus(_fn) => _res;

  mediaFile(_fn) => _res;
}

class Query$recentlyWatched$recentlyWatched$chapter$book {
  Query$recentlyWatched$recentlyWatched$chapter$book({
    required this.id,
    required this.name,
    required this.title,
    this.images,
    this.metadata,
    this.$__typename = 'Book',
  });

  factory Query$recentlyWatched$recentlyWatched$chapter$book.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$title = json['title'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$chapter$book(
      id: (l$id as String),
      name: (l$name as String),
      title: (l$title as String),
      images: (l$images as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String title;

  final List<Fragment$fragmentImages>? images;

  final List<Fragment$fragmentMetadata>? metadata;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$title = title;
    final l$images = images;
    final l$metadata = metadata;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$title,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$chapter$book ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$images = images;
    final lOther$images = other.images;
    if (l$images != null && lOther$images != null) {
      if (l$images.length != lOther$images.length) {
        return false;
      }
      for (int i = 0; i < l$images.length; i++) {
        final l$images$entry = l$images[i];
        final lOther$images$entry = lOther$images[i];
        if (l$images$entry != lOther$images$entry) {
          return false;
        }
      }
    } else if (l$images != lOther$images) {
      return false;
    }
    final l$metadata = metadata;
    final lOther$metadata = other.metadata;
    if (l$metadata != null && lOther$metadata != null) {
      if (l$metadata.length != lOther$metadata.length) {
        return false;
      }
      for (int i = 0; i < l$metadata.length; i++) {
        final l$metadata$entry = l$metadata[i];
        final lOther$metadata$entry = lOther$metadata[i];
        if (l$metadata$entry != lOther$metadata$entry) {
          return false;
        }
      }
    } else if (l$metadata != lOther$metadata) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$chapter$book
    on Query$recentlyWatched$recentlyWatched$chapter$book {
  CopyWith$Query$recentlyWatched$recentlyWatched$chapter$book<
    Query$recentlyWatched$recentlyWatched$chapter$book
  >
  get copyWith => CopyWith$Query$recentlyWatched$recentlyWatched$chapter$book(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$chapter$book<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$chapter$book(
    Query$recentlyWatched$recentlyWatched$chapter$book instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$chapter$book) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$chapter$book;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$chapter$book.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$chapter$book;

  TRes call({
    String? id,
    String? name,
    String? title,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    String? $__typename,
  });
  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  );
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$chapter$book<TRes>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$chapter$book<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$chapter$book(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$chapter$book _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$chapter$book) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? title = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$chapter$book(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  ) => call(
    images: _fn(
      _instance.images?.map(
        (e) => CopyWith$Fragment$fragmentImages(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  ) => call(
    metadata: _fn(
      _instance.metadata?.map(
        (e) => CopyWith$Fragment$fragmentMetadata(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$chapter$book<TRes>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$chapter$book<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$chapter$book(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? name,
    String? title,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;

  metadata(_fn) => _res;
}

class Query$recentlyWatched$recentlyWatched$chapter$watchStatus {
  Query$recentlyWatched$recentlyWatched$chapter$watchStatus({
    required this.id,
    required this.playQueueItemId,
    required this.progressInMilliseconds,
    required this.watched,
    this.$__typename = 'WatchStatus',
  });

  factory Query$recentlyWatched$recentlyWatched$chapter$watchStatus.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$playQueueItemId = json['playQueueItemId'];
    final l$progressInMilliseconds = json['progressInMilliseconds'];
    final l$watched = json['watched'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$chapter$watchStatus(
      id: (l$id as String),
      playQueueItemId: (l$playQueueItemId as String),
      progressInMilliseconds: (l$progressInMilliseconds as int),
      watched: (l$watched as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String playQueueItemId;

  final int progressInMilliseconds;

  final bool watched;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$playQueueItemId = playQueueItemId;
    _resultData['playQueueItemId'] = l$playQueueItemId;
    final l$progressInMilliseconds = progressInMilliseconds;
    _resultData['progressInMilliseconds'] = l$progressInMilliseconds;
    final l$watched = watched;
    _resultData['watched'] = l$watched;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$playQueueItemId = playQueueItemId;
    final l$progressInMilliseconds = progressInMilliseconds;
    final l$watched = watched;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$playQueueItemId,
      l$progressInMilliseconds,
      l$watched,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$chapter$watchStatus ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$playQueueItemId = playQueueItemId;
    final lOther$playQueueItemId = other.playQueueItemId;
    if (l$playQueueItemId != lOther$playQueueItemId) {
      return false;
    }
    final l$progressInMilliseconds = progressInMilliseconds;
    final lOther$progressInMilliseconds = other.progressInMilliseconds;
    if (l$progressInMilliseconds != lOther$progressInMilliseconds) {
      return false;
    }
    final l$watched = watched;
    final lOther$watched = other.watched;
    if (l$watched != lOther$watched) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$chapter$watchStatus
    on Query$recentlyWatched$recentlyWatched$chapter$watchStatus {
  CopyWith$Query$recentlyWatched$recentlyWatched$chapter$watchStatus<
    Query$recentlyWatched$recentlyWatched$chapter$watchStatus
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$chapter$watchStatus(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$chapter$watchStatus<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$chapter$watchStatus(
    Query$recentlyWatched$recentlyWatched$chapter$watchStatus instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$chapter$watchStatus)
    then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$chapter$watchStatus;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$chapter$watchStatus.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$chapter$watchStatus;

  TRes call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$chapter$watchStatus<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$chapter$watchStatus<
          TRes
        > {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$chapter$watchStatus(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$chapter$watchStatus _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$chapter$watchStatus)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? playQueueItemId = _undefined,
    Object? progressInMilliseconds = _undefined,
    Object? watched = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$chapter$watchStatus(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      playQueueItemId: playQueueItemId == _undefined || playQueueItemId == null
          ? _instance.playQueueItemId
          : (playQueueItemId as String),
      progressInMilliseconds:
          progressInMilliseconds == _undefined || progressInMilliseconds == null
          ? _instance.progressInMilliseconds
          : (progressInMilliseconds as int),
      watched: watched == _undefined || watched == null
          ? _instance.watched
          : (watched as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$chapter$watchStatus<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$chapter$watchStatus<
          TRes
        > {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$chapter$watchStatus(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  }) => _res;
}

class Query$recentlyWatched$recentlyWatched$chapter$mediaFile {
  Query$recentlyWatched$recentlyWatched$chapter$mediaFile({
    required this.id,
    this.durationInMilliseconds,
    this.$__typename = 'MediaFile',
  });

  factory Query$recentlyWatched$recentlyWatched$chapter$mediaFile.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$durationInMilliseconds = json['durationInMilliseconds'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$chapter$mediaFile(
      id: (l$id as String),
      durationInMilliseconds: (l$durationInMilliseconds as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int? durationInMilliseconds;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$durationInMilliseconds = durationInMilliseconds;
    _resultData['durationInMilliseconds'] = l$durationInMilliseconds;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$durationInMilliseconds = durationInMilliseconds;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$durationInMilliseconds, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$chapter$mediaFile ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$durationInMilliseconds = durationInMilliseconds;
    final lOther$durationInMilliseconds = other.durationInMilliseconds;
    if (l$durationInMilliseconds != lOther$durationInMilliseconds) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$chapter$mediaFile
    on Query$recentlyWatched$recentlyWatched$chapter$mediaFile {
  CopyWith$Query$recentlyWatched$recentlyWatched$chapter$mediaFile<
    Query$recentlyWatched$recentlyWatched$chapter$mediaFile
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$chapter$mediaFile(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$chapter$mediaFile<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$chapter$mediaFile(
    Query$recentlyWatched$recentlyWatched$chapter$mediaFile instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$chapter$mediaFile) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$chapter$mediaFile;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$chapter$mediaFile.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$chapter$mediaFile;

  TRes call({String? id, int? durationInMilliseconds, String? $__typename});
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$chapter$mediaFile<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$chapter$mediaFile<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$chapter$mediaFile(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$chapter$mediaFile _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$chapter$mediaFile)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? durationInMilliseconds = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$chapter$mediaFile(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      durationInMilliseconds: durationInMilliseconds == _undefined
          ? _instance.durationInMilliseconds
          : (durationInMilliseconds as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$chapter$mediaFile<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$chapter$mediaFile<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$chapter$mediaFile(
    this._res,
  );

  TRes _res;

  call({String? id, int? durationInMilliseconds, String? $__typename}) => _res;
}

class Query$recentlyWatched$recentlyWatched$book {
  Query$recentlyWatched$recentlyWatched$book({
    required this.id,
    required this.name,
    required this.title,
    this.series,
    this.images,
    this.metadata,
    this.watchStatus,
    this.epubFiles,
    this.$__typename = 'Book',
  });

  factory Query$recentlyWatched$recentlyWatched$book.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$title = json['title'];
    final l$series = json['series'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$watchStatus = json['watchStatus'];
    final l$epubFiles = json['epubFiles'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$book(
      id: (l$id as String),
      name: (l$name as String),
      title: (l$title as String),
      series: l$series == null
          ? null
          : Query$recentlyWatched$recentlyWatched$book$series.fromJson(
              (l$series as Map<String, dynamic>),
            ),
      images: (l$images as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      watchStatus: (l$watchStatus as List<dynamic>?)
          ?.map(
            (e) =>
                Query$recentlyWatched$recentlyWatched$book$watchStatus.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      epubFiles: (l$epubFiles as List<dynamic>?)
          ?.map(
            (e) =>
                Query$recentlyWatched$recentlyWatched$book$epubFiles.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String title;

  final Query$recentlyWatched$recentlyWatched$book$series? series;

  final List<Fragment$fragmentImages>? images;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Query$recentlyWatched$recentlyWatched$book$watchStatus>?
  watchStatus;

  final List<Query$recentlyWatched$recentlyWatched$book$epubFiles>? epubFiles;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$series = series;
    _resultData['series'] = l$series?.toJson();
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$watchStatus = watchStatus;
    _resultData['watchStatus'] = l$watchStatus?.map((e) => e.toJson()).toList();
    final l$epubFiles = epubFiles;
    _resultData['epubFiles'] = l$epubFiles?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$title = title;
    final l$series = series;
    final l$images = images;
    final l$metadata = metadata;
    final l$watchStatus = watchStatus;
    final l$epubFiles = epubFiles;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$title,
      l$series,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$watchStatus == null
          ? null
          : Object.hashAll(l$watchStatus.map((v) => v)),
      l$epubFiles == null ? null : Object.hashAll(l$epubFiles.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$book ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$series = series;
    final lOther$series = other.series;
    if (l$series != lOther$series) {
      return false;
    }
    final l$images = images;
    final lOther$images = other.images;
    if (l$images != null && lOther$images != null) {
      if (l$images.length != lOther$images.length) {
        return false;
      }
      for (int i = 0; i < l$images.length; i++) {
        final l$images$entry = l$images[i];
        final lOther$images$entry = lOther$images[i];
        if (l$images$entry != lOther$images$entry) {
          return false;
        }
      }
    } else if (l$images != lOther$images) {
      return false;
    }
    final l$metadata = metadata;
    final lOther$metadata = other.metadata;
    if (l$metadata != null && lOther$metadata != null) {
      if (l$metadata.length != lOther$metadata.length) {
        return false;
      }
      for (int i = 0; i < l$metadata.length; i++) {
        final l$metadata$entry = l$metadata[i];
        final lOther$metadata$entry = lOther$metadata[i];
        if (l$metadata$entry != lOther$metadata$entry) {
          return false;
        }
      }
    } else if (l$metadata != lOther$metadata) {
      return false;
    }
    final l$watchStatus = watchStatus;
    final lOther$watchStatus = other.watchStatus;
    if (l$watchStatus != null && lOther$watchStatus != null) {
      if (l$watchStatus.length != lOther$watchStatus.length) {
        return false;
      }
      for (int i = 0; i < l$watchStatus.length; i++) {
        final l$watchStatus$entry = l$watchStatus[i];
        final lOther$watchStatus$entry = lOther$watchStatus[i];
        if (l$watchStatus$entry != lOther$watchStatus$entry) {
          return false;
        }
      }
    } else if (l$watchStatus != lOther$watchStatus) {
      return false;
    }
    final l$epubFiles = epubFiles;
    final lOther$epubFiles = other.epubFiles;
    if (l$epubFiles != null && lOther$epubFiles != null) {
      if (l$epubFiles.length != lOther$epubFiles.length) {
        return false;
      }
      for (int i = 0; i < l$epubFiles.length; i++) {
        final l$epubFiles$entry = l$epubFiles[i];
        final lOther$epubFiles$entry = lOther$epubFiles[i];
        if (l$epubFiles$entry != lOther$epubFiles$entry) {
          return false;
        }
      }
    } else if (l$epubFiles != lOther$epubFiles) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$book
    on Query$recentlyWatched$recentlyWatched$book {
  CopyWith$Query$recentlyWatched$recentlyWatched$book<
    Query$recentlyWatched$recentlyWatched$book
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$book(this, (i) => i);
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$book<TRes> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$book(
    Query$recentlyWatched$recentlyWatched$book instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$book) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$book;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$book.stub(TRes res) =
      _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$book;

  TRes call({
    String? id,
    String? name,
    String? title,
    Query$recentlyWatched$recentlyWatched$book$series? series,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    List<Query$recentlyWatched$recentlyWatched$book$watchStatus>? watchStatus,
    List<Query$recentlyWatched$recentlyWatched$book$epubFiles>? epubFiles,
    String? $__typename,
  });
  CopyWith$Query$recentlyWatched$recentlyWatched$book$series<TRes> get series;
  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  );
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
  TRes watchStatus(
    Iterable<Query$recentlyWatched$recentlyWatched$book$watchStatus>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$book$watchStatus<
          Query$recentlyWatched$recentlyWatched$book$watchStatus
        >
      >?,
    )
    _fn,
  );
  TRes epubFiles(
    Iterable<Query$recentlyWatched$recentlyWatched$book$epubFiles>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles<
          Query$recentlyWatched$recentlyWatched$book$epubFiles
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$book<TRes>
    implements CopyWith$Query$recentlyWatched$recentlyWatched$book<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$book(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$book _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$book) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? title = _undefined,
    Object? series = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? watchStatus = _undefined,
    Object? epubFiles = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$book(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      series: series == _undefined
          ? _instance.series
          : (series as Query$recentlyWatched$recentlyWatched$book$series?),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      watchStatus: watchStatus == _undefined
          ? _instance.watchStatus
          : (watchStatus
                as List<
                  Query$recentlyWatched$recentlyWatched$book$watchStatus
                >?),
      epubFiles: epubFiles == _undefined
          ? _instance.epubFiles
          : (epubFiles
                as List<Query$recentlyWatched$recentlyWatched$book$epubFiles>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$recentlyWatched$recentlyWatched$book$series<TRes> get series {
    final local$series = _instance.series;
    return local$series == null
        ? CopyWith$Query$recentlyWatched$recentlyWatched$book$series.stub(
            _then(_instance),
          )
        : CopyWith$Query$recentlyWatched$recentlyWatched$book$series(
            local$series,
            (e) => call(series: e),
          );
  }

  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  ) => call(
    images: _fn(
      _instance.images?.map(
        (e) => CopyWith$Fragment$fragmentImages(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  ) => call(
    metadata: _fn(
      _instance.metadata?.map(
        (e) => CopyWith$Fragment$fragmentMetadata(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes watchStatus(
    Iterable<Query$recentlyWatched$recentlyWatched$book$watchStatus>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$book$watchStatus<
          Query$recentlyWatched$recentlyWatched$book$watchStatus
        >
      >?,
    )
    _fn,
  ) => call(
    watchStatus: _fn(
      _instance.watchStatus?.map(
        (e) => CopyWith$Query$recentlyWatched$recentlyWatched$book$watchStatus(
          e,
          (i) => i,
        ),
      ),
    )?.toList(),
  );

  TRes epubFiles(
    Iterable<Query$recentlyWatched$recentlyWatched$book$epubFiles>? Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles<
          Query$recentlyWatched$recentlyWatched$book$epubFiles
        >
      >?,
    )
    _fn,
  ) => call(
    epubFiles: _fn(
      _instance.epubFiles?.map(
        (e) => CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles(
          e,
          (i) => i,
        ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$book<TRes>
    implements CopyWith$Query$recentlyWatched$recentlyWatched$book<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$book(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    String? title,
    Query$recentlyWatched$recentlyWatched$book$series? series,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    List<Query$recentlyWatched$recentlyWatched$book$watchStatus>? watchStatus,
    List<Query$recentlyWatched$recentlyWatched$book$epubFiles>? epubFiles,
    String? $__typename,
  }) => _res;

  CopyWith$Query$recentlyWatched$recentlyWatched$book$series<TRes> get series =>
      CopyWith$Query$recentlyWatched$recentlyWatched$book$series.stub(_res);

  images(_fn) => _res;

  metadata(_fn) => _res;

  watchStatus(_fn) => _res;

  epubFiles(_fn) => _res;
}

class Query$recentlyWatched$recentlyWatched$book$series {
  Query$recentlyWatched$recentlyWatched$book$series({
    required this.id,
    required this.name,
    this.$__typename = 'Series',
  });

  factory Query$recentlyWatched$recentlyWatched$book$series.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$book$series(
      id: (l$id as String),
      name: (l$name as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$name, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$book$series ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$name = name;
    final lOther$name = other.name;
    if (l$name != lOther$name) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$book$series
    on Query$recentlyWatched$recentlyWatched$book$series {
  CopyWith$Query$recentlyWatched$recentlyWatched$book$series<
    Query$recentlyWatched$recentlyWatched$book$series
  >
  get copyWith => CopyWith$Query$recentlyWatched$recentlyWatched$book$series(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$book$series<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$book$series(
    Query$recentlyWatched$recentlyWatched$book$series instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$book$series) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$book$series;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$book$series.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$book$series;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$book$series<TRes>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$book$series<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$book$series(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$book$series _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$book$series) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$book$series(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$book$series<TRes>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$book$series<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$book$series(
    this._res,
  );

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Query$recentlyWatched$recentlyWatched$book$watchStatus {
  Query$recentlyWatched$recentlyWatched$book$watchStatus({
    required this.id,
    required this.watched,
    this.readingLocation,
    this.readingProgress,
    this.$__typename = 'WatchStatus',
  });

  factory Query$recentlyWatched$recentlyWatched$book$watchStatus.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$watched = json['watched'];
    final l$readingLocation = json['readingLocation'];
    final l$readingProgress = json['readingProgress'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$book$watchStatus(
      id: (l$id as String),
      watched: (l$watched as bool),
      readingLocation: (l$readingLocation as String?),
      readingProgress: (l$readingProgress as num?)?.toDouble(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final bool watched;

  final String? readingLocation;

  final double? readingProgress;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$watched = watched;
    _resultData['watched'] = l$watched;
    final l$readingLocation = readingLocation;
    _resultData['readingLocation'] = l$readingLocation;
    final l$readingProgress = readingProgress;
    _resultData['readingProgress'] = l$readingProgress;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$watched = watched;
    final l$readingLocation = readingLocation;
    final l$readingProgress = readingProgress;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$watched,
      l$readingLocation,
      l$readingProgress,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$book$watchStatus ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$watched = watched;
    final lOther$watched = other.watched;
    if (l$watched != lOther$watched) {
      return false;
    }
    final l$readingLocation = readingLocation;
    final lOther$readingLocation = other.readingLocation;
    if (l$readingLocation != lOther$readingLocation) {
      return false;
    }
    final l$readingProgress = readingProgress;
    final lOther$readingProgress = other.readingProgress;
    if (l$readingProgress != lOther$readingProgress) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$book$watchStatus
    on Query$recentlyWatched$recentlyWatched$book$watchStatus {
  CopyWith$Query$recentlyWatched$recentlyWatched$book$watchStatus<
    Query$recentlyWatched$recentlyWatched$book$watchStatus
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$book$watchStatus(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$book$watchStatus<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$book$watchStatus(
    Query$recentlyWatched$recentlyWatched$book$watchStatus instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$book$watchStatus) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$book$watchStatus;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$book$watchStatus.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$book$watchStatus;

  TRes call({
    String? id,
    bool? watched,
    String? readingLocation,
    double? readingProgress,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$book$watchStatus<TRes>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$book$watchStatus<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$book$watchStatus(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$book$watchStatus _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$book$watchStatus)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? watched = _undefined,
    Object? readingLocation = _undefined,
    Object? readingProgress = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$book$watchStatus(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      watched: watched == _undefined || watched == null
          ? _instance.watched
          : (watched as bool),
      readingLocation: readingLocation == _undefined
          ? _instance.readingLocation
          : (readingLocation as String?),
      readingProgress: readingProgress == _undefined
          ? _instance.readingProgress
          : (readingProgress as double?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$book$watchStatus<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$book$watchStatus<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$book$watchStatus(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    bool? watched,
    String? readingLocation,
    double? readingProgress,
    String? $__typename,
  }) => _res;
}

class Query$recentlyWatched$recentlyWatched$book$epubFiles {
  Query$recentlyWatched$recentlyWatched$book$epubFiles({
    required this.id,
    required this.path,
    this.format,
    this.mediaOverlays,
    required this.directory,
    this.$__typename = 'MediaFile',
  });

  factory Query$recentlyWatched$recentlyWatched$book$epubFiles.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$path = json['path'];
    final l$format = json['format'];
    final l$mediaOverlays = json['mediaOverlays'];
    final l$directory = json['directory'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$book$epubFiles(
      id: (l$id as String),
      path: (l$path as String),
      format: (l$format as String?),
      mediaOverlays: (l$mediaOverlays as bool?),
      directory:
          Query$recentlyWatched$recentlyWatched$book$epubFiles$directory.fromJson(
            (l$directory as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String path;

  final String? format;

  final bool? mediaOverlays;

  final Query$recentlyWatched$recentlyWatched$book$epubFiles$directory
  directory;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$path = path;
    _resultData['path'] = l$path;
    final l$format = format;
    _resultData['format'] = l$format;
    final l$mediaOverlays = mediaOverlays;
    _resultData['mediaOverlays'] = l$mediaOverlays;
    final l$directory = directory;
    _resultData['directory'] = l$directory.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$path = path;
    final l$format = format;
    final l$mediaOverlays = mediaOverlays;
    final l$directory = directory;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$path,
      l$format,
      l$mediaOverlays,
      l$directory,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$book$epubFiles ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$path = path;
    final lOther$path = other.path;
    if (l$path != lOther$path) {
      return false;
    }
    final l$format = format;
    final lOther$format = other.format;
    if (l$format != lOther$format) {
      return false;
    }
    final l$mediaOverlays = mediaOverlays;
    final lOther$mediaOverlays = other.mediaOverlays;
    if (l$mediaOverlays != lOther$mediaOverlays) {
      return false;
    }
    final l$directory = directory;
    final lOther$directory = other.directory;
    if (l$directory != lOther$directory) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$book$epubFiles
    on Query$recentlyWatched$recentlyWatched$book$epubFiles {
  CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles<
    Query$recentlyWatched$recentlyWatched$book$epubFiles
  >
  get copyWith => CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles(
    Query$recentlyWatched$recentlyWatched$book$epubFiles instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$book$epubFiles) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$book$epubFiles;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$book$epubFiles;

  TRes call({
    String? id,
    String? path,
    String? format,
    bool? mediaOverlays,
    Query$recentlyWatched$recentlyWatched$book$epubFiles$directory? directory,
    String? $__typename,
  });
  CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory<TRes>
  get directory;
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$book$epubFiles<TRes>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$book$epubFiles(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$book$epubFiles _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$book$epubFiles)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? path = _undefined,
    Object? format = _undefined,
    Object? mediaOverlays = _undefined,
    Object? directory = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$book$epubFiles(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      path: path == _undefined || path == null
          ? _instance.path
          : (path as String),
      format: format == _undefined ? _instance.format : (format as String?),
      mediaOverlays: mediaOverlays == _undefined
          ? _instance.mediaOverlays
          : (mediaOverlays as bool?),
      directory: directory == _undefined || directory == null
          ? _instance.directory
          : (directory
                as Query$recentlyWatched$recentlyWatched$book$epubFiles$directory),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory<TRes>
  get directory {
    final local$directory = _instance.directory;
    return CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory(
      local$directory,
      (e) => call(directory: e),
    );
  }
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$book$epubFiles<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$book$epubFiles(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? path,
    String? format,
    bool? mediaOverlays,
    Query$recentlyWatched$recentlyWatched$book$epubFiles$directory? directory,
    String? $__typename,
  }) => _res;

  CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory<TRes>
  get directory =>
      CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory.stub(
        _res,
      );
}

class Query$recentlyWatched$recentlyWatched$book$epubFiles$directory {
  Query$recentlyWatched$recentlyWatched$book$epubFiles$directory({
    required this.node,
    this.$__typename = 'Directory',
  });

  factory Query$recentlyWatched$recentlyWatched$book$epubFiles$directory.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$node = json['node'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$book$epubFiles$directory(
      node:
          Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node.fromJson(
            (l$node as Map<String, dynamic>),
          ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node
  node;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$node = node;
    _resultData['node'] = l$node.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$node = node;
    final l$$__typename = $__typename;
    return Object.hashAll([l$node, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$recentlyWatched$recentlyWatched$book$epubFiles$directory ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$node = node;
    final lOther$node = other.node;
    if (l$node != lOther$node) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory
    on Query$recentlyWatched$recentlyWatched$book$epubFiles$directory {
  CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory<
    Query$recentlyWatched$recentlyWatched$book$epubFiles$directory
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory(
    Query$recentlyWatched$recentlyWatched$book$epubFiles$directory instance,
    TRes Function(
      Query$recentlyWatched$recentlyWatched$book$epubFiles$directory,
    )
    then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory;

  TRes call({
    Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node? node,
    String? $__typename,
  });
  CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node<
    TRes
  >
  get node;
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory<
          TRes
        > {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$book$epubFiles$directory
  _instance;

  final TRes Function(
    Query$recentlyWatched$recentlyWatched$book$epubFiles$directory,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? node = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$book$epubFiles$directory(
      node: node == _undefined || node == null
          ? _instance.node
          : (node
                as Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node<
    TRes
  >
  get node {
    final local$node = _instance.node;
    return CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node(
      local$node,
      (e) => call(node: e),
    );
  }
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory<
          TRes
        > {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory(
    this._res,
  );

  TRes _res;

  call({
    Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node? node,
    String? $__typename,
  }) => _res;

  CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node<
    TRes
  >
  get node =>
      CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node.stub(
        _res,
      );
}

class Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node {
  Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node({
    required this.url,
    this.$__typename = 'Node',
  });

  factory Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$url = json['url'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node(
      url: (l$url as String),
      $__typename: (l$$__typename as String),
    );
  }

  final String url;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$url = url;
    _resultData['url'] = l$url;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$url = url;
    final l$$__typename = $__typename;
    return Object.hashAll([l$url, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$url = url;
    final lOther$url = other.url;
    if (l$url != lOther$url) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node
    on Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node {
  CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node<
    Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node(
    Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node
    instance,
    TRes Function(
      Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node,
    )
    then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node;

  TRes call({String? url, String? $__typename});
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node<
          TRes
        > {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node
  _instance;

  final TRes Function(
    Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? url = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node(
          url: url == _undefined || url == null
              ? _instance.url
              : (url as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node<
          TRes
        > {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$book$epubFiles$directory$node(
    this._res,
  );

  TRes _res;

  call({String? url, String? $__typename}) => _res;
}

class Query$recentlyWatched$recentlyWatched$podcastEpisode {
  Query$recentlyWatched$recentlyWatched$podcastEpisode({
    required this.id,
    this.publishedAt,
    required this.podcast,
    this.metadata,
    this.watchStatus,
    this.mediaFile,
    this.$__typename = 'PodcastEpisode',
  });

  factory Query$recentlyWatched$recentlyWatched$podcastEpisode.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$publishedAt = json['publishedAt'];
    final l$podcast = json['podcast'];
    final l$metadata = json['metadata'];
    final l$watchStatus = json['watchStatus'];
    final l$mediaFile = json['mediaFile'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$podcastEpisode(
      id: (l$id as String),
      publishedAt: (l$publishedAt as String?),
      podcast:
          Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast.fromJson(
            (l$podcast as Map<String, dynamic>),
          ),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      watchStatus: (l$watchStatus as List<dynamic>?)
          ?.map(
            (e) =>
                Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map(
            (e) =>
                Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile.fromJson(
                  (e as Map<String, dynamic>),
                ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? publishedAt;

  final Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast podcast;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus>?
  watchStatus;

  final List<Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile>?
  mediaFile;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$publishedAt = publishedAt;
    _resultData['publishedAt'] = l$publishedAt;
    final l$podcast = podcast;
    _resultData['podcast'] = l$podcast.toJson();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$watchStatus = watchStatus;
    _resultData['watchStatus'] = l$watchStatus?.map((e) => e.toJson()).toList();
    final l$mediaFile = mediaFile;
    _resultData['mediaFile'] = l$mediaFile?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$publishedAt = publishedAt;
    final l$podcast = podcast;
    final l$metadata = metadata;
    final l$watchStatus = watchStatus;
    final l$mediaFile = mediaFile;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$publishedAt,
      l$podcast,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$watchStatus == null
          ? null
          : Object.hashAll(l$watchStatus.map((v) => v)),
      l$mediaFile == null ? null : Object.hashAll(l$mediaFile.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$recentlyWatched$recentlyWatched$podcastEpisode ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$publishedAt = publishedAt;
    final lOther$publishedAt = other.publishedAt;
    if (l$publishedAt != lOther$publishedAt) {
      return false;
    }
    final l$podcast = podcast;
    final lOther$podcast = other.podcast;
    if (l$podcast != lOther$podcast) {
      return false;
    }
    final l$metadata = metadata;
    final lOther$metadata = other.metadata;
    if (l$metadata != null && lOther$metadata != null) {
      if (l$metadata.length != lOther$metadata.length) {
        return false;
      }
      for (int i = 0; i < l$metadata.length; i++) {
        final l$metadata$entry = l$metadata[i];
        final lOther$metadata$entry = lOther$metadata[i];
        if (l$metadata$entry != lOther$metadata$entry) {
          return false;
        }
      }
    } else if (l$metadata != lOther$metadata) {
      return false;
    }
    final l$watchStatus = watchStatus;
    final lOther$watchStatus = other.watchStatus;
    if (l$watchStatus != null && lOther$watchStatus != null) {
      if (l$watchStatus.length != lOther$watchStatus.length) {
        return false;
      }
      for (int i = 0; i < l$watchStatus.length; i++) {
        final l$watchStatus$entry = l$watchStatus[i];
        final lOther$watchStatus$entry = lOther$watchStatus[i];
        if (l$watchStatus$entry != lOther$watchStatus$entry) {
          return false;
        }
      }
    } else if (l$watchStatus != lOther$watchStatus) {
      return false;
    }
    final l$mediaFile = mediaFile;
    final lOther$mediaFile = other.mediaFile;
    if (l$mediaFile != null && lOther$mediaFile != null) {
      if (l$mediaFile.length != lOther$mediaFile.length) {
        return false;
      }
      for (int i = 0; i < l$mediaFile.length; i++) {
        final l$mediaFile$entry = l$mediaFile[i];
        final lOther$mediaFile$entry = lOther$mediaFile[i];
        if (l$mediaFile$entry != lOther$mediaFile$entry) {
          return false;
        }
      }
    } else if (l$mediaFile != lOther$mediaFile) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$podcastEpisode
    on Query$recentlyWatched$recentlyWatched$podcastEpisode {
  CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode<
    Query$recentlyWatched$recentlyWatched$podcastEpisode
  >
  get copyWith => CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode(
    this,
    (i) => i,
  );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode(
    Query$recentlyWatched$recentlyWatched$podcastEpisode instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$podcastEpisode) then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode;

  TRes call({
    String? id,
    String? publishedAt,
    Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast? podcast,
    List<Fragment$fragmentMetadata>? metadata,
    List<Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus>?
    watchStatus,
    List<Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile>?
    mediaFile,
    String? $__typename,
  });
  CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast<TRes>
  get podcast;
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
  TRes watchStatus(
    Iterable<Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus>?
    Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus<
          Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus
        >
      >?,
    )
    _fn,
  );
  TRes mediaFile(
    Iterable<Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile>?
    Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile<
          Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode<TRes>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode<TRes> {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$podcastEpisode _instance;

  final TRes Function(Query$recentlyWatched$recentlyWatched$podcastEpisode)
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? publishedAt = _undefined,
    Object? podcast = _undefined,
    Object? metadata = _undefined,
    Object? watchStatus = _undefined,
    Object? mediaFile = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$podcastEpisode(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      publishedAt: publishedAt == _undefined
          ? _instance.publishedAt
          : (publishedAt as String?),
      podcast: podcast == _undefined || podcast == null
          ? _instance.podcast
          : (podcast
                as Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      watchStatus: watchStatus == _undefined
          ? _instance.watchStatus
          : (watchStatus
                as List<
                  Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus
                >?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile
                as List<
                  Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile
                >?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast<TRes>
  get podcast {
    final local$podcast = _instance.podcast;
    return CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast(
      local$podcast,
      (e) => call(podcast: e),
    );
  }

  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  ) => call(
    metadata: _fn(
      _instance.metadata?.map(
        (e) => CopyWith$Fragment$fragmentMetadata(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes watchStatus(
    Iterable<Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus>?
    Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus<
          Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus
        >
      >?,
    )
    _fn,
  ) => call(
    watchStatus: _fn(
      _instance.watchStatus?.map(
        (e) =>
            CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus(
              e,
              (i) => i,
            ),
      ),
    )?.toList(),
  );

  TRes mediaFile(
    Iterable<Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile>?
    Function(
      Iterable<
        CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile<
          Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile
        >
      >?,
    )
    _fn,
  ) => call(
    mediaFile: _fn(
      _instance.mediaFile?.map(
        (e) =>
            CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile(
              e,
              (i) => i,
            ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode<TRes> {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? publishedAt,
    Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast? podcast,
    List<Fragment$fragmentMetadata>? metadata,
    List<Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus>?
    watchStatus,
    List<Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile>?
    mediaFile,
    String? $__typename,
  }) => _res;

  CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast<TRes>
  get podcast =>
      CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast.stub(
        _res,
      );

  metadata(_fn) => _res;

  watchStatus(_fn) => _res;

  mediaFile(_fn) => _res;
}

class Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast {
  Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast({
    required this.id,
    required this.title,
    this.images,
    this.$__typename = 'Podcast',
  });

  factory Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$title = json['title'];
    final l$images = json['images'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast(
      id: (l$id as String),
      title: (l$title as String),
      images: (l$images as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentImages.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String title;

  final List<Fragment$fragmentImages>? images;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$title = title;
    final l$images = images;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$title,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$images = images;
    final lOther$images = other.images;
    if (l$images != null && lOther$images != null) {
      if (l$images.length != lOther$images.length) {
        return false;
      }
      for (int i = 0; i < l$images.length; i++) {
        final l$images$entry = l$images[i];
        final lOther$images$entry = lOther$images[i];
        if (l$images$entry != lOther$images$entry) {
          return false;
        }
      }
    } else if (l$images != lOther$images) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast
    on Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast {
  CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast<
    Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast(
    Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast instance,
    TRes Function(Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast)
    then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast;

  TRes call({
    String? id,
    String? title,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  });
  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast<
          TRes
        > {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast _instance;

  final TRes Function(
    Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? title = _undefined,
    Object? images = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      title: title == _undefined || title == null
          ? _instance.title
          : (title as String),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes images(
    Iterable<Fragment$fragmentImages>? Function(
      Iterable<CopyWith$Fragment$fragmentImages<Fragment$fragmentImages>>?,
    )
    _fn,
  ) => call(
    images: _fn(
      _instance.images?.map(
        (e) => CopyWith$Fragment$fragmentImages(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast<
          TRes
        > {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode$podcast(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? title,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;
}

class Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus {
  Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus({
    required this.id,
    required this.playQueueItemId,
    required this.progressInMilliseconds,
    required this.watched,
    this.$__typename = 'WatchStatus',
  });

  factory Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$playQueueItemId = json['playQueueItemId'];
    final l$progressInMilliseconds = json['progressInMilliseconds'];
    final l$watched = json['watched'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus(
      id: (l$id as String),
      playQueueItemId: (l$playQueueItemId as String),
      progressInMilliseconds: (l$progressInMilliseconds as int),
      watched: (l$watched as bool),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String playQueueItemId;

  final int progressInMilliseconds;

  final bool watched;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$playQueueItemId = playQueueItemId;
    _resultData['playQueueItemId'] = l$playQueueItemId;
    final l$progressInMilliseconds = progressInMilliseconds;
    _resultData['progressInMilliseconds'] = l$progressInMilliseconds;
    final l$watched = watched;
    _resultData['watched'] = l$watched;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$playQueueItemId = playQueueItemId;
    final l$progressInMilliseconds = progressInMilliseconds;
    final l$watched = watched;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$playQueueItemId,
      l$progressInMilliseconds,
      l$watched,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$playQueueItemId = playQueueItemId;
    final lOther$playQueueItemId = other.playQueueItemId;
    if (l$playQueueItemId != lOther$playQueueItemId) {
      return false;
    }
    final l$progressInMilliseconds = progressInMilliseconds;
    final lOther$progressInMilliseconds = other.progressInMilliseconds;
    if (l$progressInMilliseconds != lOther$progressInMilliseconds) {
      return false;
    }
    final l$watched = watched;
    final lOther$watched = other.watched;
    if (l$watched != lOther$watched) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus
    on Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus {
  CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus<
    Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus(
    Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus instance,
    TRes Function(
      Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus,
    )
    then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus;

  TRes call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  });
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus<
          TRes
        > {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus
  _instance;

  final TRes Function(
    Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? playQueueItemId = _undefined,
    Object? progressInMilliseconds = _undefined,
    Object? watched = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      playQueueItemId: playQueueItemId == _undefined || playQueueItemId == null
          ? _instance.playQueueItemId
          : (playQueueItemId as String),
      progressInMilliseconds:
          progressInMilliseconds == _undefined || progressInMilliseconds == null
          ? _instance.progressInMilliseconds
          : (progressInMilliseconds as int),
      watched: watched == _undefined || watched == null
          ? _instance.watched
          : (watched as bool),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus<
          TRes
        > {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode$watchStatus(
    this._res,
  );

  TRes _res;

  call({
    String? id,
    String? playQueueItemId,
    int? progressInMilliseconds,
    bool? watched,
    String? $__typename,
  }) => _res;
}

class Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile {
  Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile({
    required this.id,
    this.durationInMilliseconds,
    this.$__typename = 'MediaFile',
  });

  factory Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$durationInMilliseconds = json['durationInMilliseconds'];
    final l$$__typename = json['__typename'];
    return Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile(
      id: (l$id as String),
      durationInMilliseconds: (l$durationInMilliseconds as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int? durationInMilliseconds;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$durationInMilliseconds = durationInMilliseconds;
    _resultData['durationInMilliseconds'] = l$durationInMilliseconds;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$durationInMilliseconds = durationInMilliseconds;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$durationInMilliseconds, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other
            is! Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$durationInMilliseconds = durationInMilliseconds;
    final lOther$durationInMilliseconds = other.durationInMilliseconds;
    if (l$durationInMilliseconds != lOther$durationInMilliseconds) {
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

extension UtilityExtension$Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile
    on Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile {
  CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile<
    Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile
  >
  get copyWith =>
      CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile(
        this,
        (i) => i,
      );
}

abstract class CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile<
  TRes
> {
  factory CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile(
    Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile instance,
    TRes Function(
      Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile,
    )
    then,
  ) = _CopyWithImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile;

  factory CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile.stub(
    TRes res,
  ) = _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile;

  TRes call({String? id, int? durationInMilliseconds, String? $__typename});
}

class _CopyWithImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile<
          TRes
        > {
  _CopyWithImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile(
    this._instance,
    this._then,
  );

  final Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile
  _instance;

  final TRes Function(
    Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile,
  )
  _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? durationInMilliseconds = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      durationInMilliseconds: durationInMilliseconds == _undefined
          ? _instance.durationInMilliseconds
          : (durationInMilliseconds as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile<
  TRes
>
    implements
        CopyWith$Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile<
          TRes
        > {
  _CopyWithStubImpl$Query$recentlyWatched$recentlyWatched$podcastEpisode$mediaFile(
    this._res,
  );

  TRes _res;

  call({String? id, int? durationInMilliseconds, String? $__typename}) => _res;
}
