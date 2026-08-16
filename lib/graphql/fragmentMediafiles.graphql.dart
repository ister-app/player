import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Fragment$fragmentMediaFiles {
  Fragment$fragmentMediaFiles({
    this.durationInMilliseconds,
    required this.id,
    required this.path,
    required this.size,
    this.episodes,
    required this.directory,
    this.segments,
    this.mediaFileStreams,
    this.$__typename = 'MediaFile',
  });

  factory Fragment$fragmentMediaFiles.fromJson(Map<String, dynamic> json) {
    final l$durationInMilliseconds = json['durationInMilliseconds'];
    final l$id = json['id'];
    final l$path = json['path'];
    final l$size = json['size'];
    final l$episodes = json['episodes'];
    final l$directory = json['directory'];
    final l$segments = json['segments'];
    final l$mediaFileStreams = json['mediaFileStreams'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentMediaFiles(
      durationInMilliseconds: (l$durationInMilliseconds as int?),
      id: (l$id as String),
      path: (l$path as String),
      size: (l$size as num).toDouble(),
      episodes: (l$episodes as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentMediaFiles$episodes.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      directory: Fragment$fragmentMediaFiles$directory.fromJson(
        (l$directory as Map<String, dynamic>),
      ),
      segments: (l$segments as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentMediaFiles$segments.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      mediaFileStreams: (l$mediaFileStreams as List<dynamic>?)
          ?.map(
            (e) => e == null
                ? null
                : Fragment$fragmentMediaFiles$mediaFileStreams.fromJson(
                    (e as Map<String, dynamic>),
                  ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final int? durationInMilliseconds;

  final String id;

  final String path;

  final double size;

  final List<Fragment$fragmentMediaFiles$episodes>? episodes;

  final Fragment$fragmentMediaFiles$directory directory;

  final List<Fragment$fragmentMediaFiles$segments>? segments;

  final List<Fragment$fragmentMediaFiles$mediaFileStreams?>? mediaFileStreams;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$durationInMilliseconds = durationInMilliseconds;
    _resultData['durationInMilliseconds'] = l$durationInMilliseconds;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$path = path;
    _resultData['path'] = l$path;
    final l$size = size;
    _resultData['size'] = l$size;
    final l$episodes = episodes;
    _resultData['episodes'] = l$episodes?.map((e) => e.toJson()).toList();
    final l$directory = directory;
    _resultData['directory'] = l$directory.toJson();
    final l$segments = segments;
    _resultData['segments'] = l$segments?.map((e) => e.toJson()).toList();
    final l$mediaFileStreams = mediaFileStreams;
    _resultData['mediaFileStreams'] = l$mediaFileStreams
        ?.map((e) => e?.toJson())
        .toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$durationInMilliseconds = durationInMilliseconds;
    final l$id = id;
    final l$path = path;
    final l$size = size;
    final l$episodes = episodes;
    final l$directory = directory;
    final l$segments = segments;
    final l$mediaFileStreams = mediaFileStreams;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$durationInMilliseconds,
      l$id,
      l$path,
      l$size,
      l$episodes == null ? null : Object.hashAll(l$episodes.map((v) => v)),
      l$directory,
      l$segments == null ? null : Object.hashAll(l$segments.map((v) => v)),
      l$mediaFileStreams == null
          ? null
          : Object.hashAll(l$mediaFileStreams.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentMediaFiles ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$durationInMilliseconds = durationInMilliseconds;
    final lOther$durationInMilliseconds = other.durationInMilliseconds;
    if (l$durationInMilliseconds != lOther$durationInMilliseconds) {
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
    final l$size = size;
    final lOther$size = other.size;
    if (l$size != lOther$size) {
      return false;
    }
    final l$episodes = episodes;
    final lOther$episodes = other.episodes;
    if (l$episodes != null && lOther$episodes != null) {
      if (l$episodes.length != lOther$episodes.length) {
        return false;
      }
      for (int i = 0; i < l$episodes.length; i++) {
        final l$episodes$entry = l$episodes[i];
        final lOther$episodes$entry = lOther$episodes[i];
        if (l$episodes$entry != lOther$episodes$entry) {
          return false;
        }
      }
    } else if (l$episodes != lOther$episodes) {
      return false;
    }
    final l$directory = directory;
    final lOther$directory = other.directory;
    if (l$directory != lOther$directory) {
      return false;
    }
    final l$segments = segments;
    final lOther$segments = other.segments;
    if (l$segments != null && lOther$segments != null) {
      if (l$segments.length != lOther$segments.length) {
        return false;
      }
      for (int i = 0; i < l$segments.length; i++) {
        final l$segments$entry = l$segments[i];
        final lOther$segments$entry = lOther$segments[i];
        if (l$segments$entry != lOther$segments$entry) {
          return false;
        }
      }
    } else if (l$segments != lOther$segments) {
      return false;
    }
    final l$mediaFileStreams = mediaFileStreams;
    final lOther$mediaFileStreams = other.mediaFileStreams;
    if (l$mediaFileStreams != null && lOther$mediaFileStreams != null) {
      if (l$mediaFileStreams.length != lOther$mediaFileStreams.length) {
        return false;
      }
      for (int i = 0; i < l$mediaFileStreams.length; i++) {
        final l$mediaFileStreams$entry = l$mediaFileStreams[i];
        final lOther$mediaFileStreams$entry = lOther$mediaFileStreams[i];
        if (l$mediaFileStreams$entry != lOther$mediaFileStreams$entry) {
          return false;
        }
      }
    } else if (l$mediaFileStreams != lOther$mediaFileStreams) {
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

extension UtilityExtension$Fragment$fragmentMediaFiles
    on Fragment$fragmentMediaFiles {
  CopyWith$Fragment$fragmentMediaFiles<Fragment$fragmentMediaFiles>
  get copyWith => CopyWith$Fragment$fragmentMediaFiles(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentMediaFiles<TRes> {
  factory CopyWith$Fragment$fragmentMediaFiles(
    Fragment$fragmentMediaFiles instance,
    TRes Function(Fragment$fragmentMediaFiles) then,
  ) = _CopyWithImpl$Fragment$fragmentMediaFiles;

  factory CopyWith$Fragment$fragmentMediaFiles.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentMediaFiles;

  TRes call({
    int? durationInMilliseconds,
    String? id,
    String? path,
    double? size,
    List<Fragment$fragmentMediaFiles$episodes>? episodes,
    Fragment$fragmentMediaFiles$directory? directory,
    List<Fragment$fragmentMediaFiles$segments>? segments,
    List<Fragment$fragmentMediaFiles$mediaFileStreams?>? mediaFileStreams,
    String? $__typename,
  });
  TRes episodes(
    Iterable<Fragment$fragmentMediaFiles$episodes>? Function(
      Iterable<
        CopyWith$Fragment$fragmentMediaFiles$episodes<
          Fragment$fragmentMediaFiles$episodes
        >
      >?,
    )
    _fn,
  );
  CopyWith$Fragment$fragmentMediaFiles$directory<TRes> get directory;
  TRes segments(
    Iterable<Fragment$fragmentMediaFiles$segments>? Function(
      Iterable<
        CopyWith$Fragment$fragmentMediaFiles$segments<
          Fragment$fragmentMediaFiles$segments
        >
      >?,
    )
    _fn,
  );
  TRes mediaFileStreams(
    Iterable<Fragment$fragmentMediaFiles$mediaFileStreams?>? Function(
      Iterable<
        CopyWith$Fragment$fragmentMediaFiles$mediaFileStreams<
          Fragment$fragmentMediaFiles$mediaFileStreams
        >?
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentMediaFiles<TRes>
    implements CopyWith$Fragment$fragmentMediaFiles<TRes> {
  _CopyWithImpl$Fragment$fragmentMediaFiles(this._instance, this._then);

  final Fragment$fragmentMediaFiles _instance;

  final TRes Function(Fragment$fragmentMediaFiles) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? durationInMilliseconds = _undefined,
    Object? id = _undefined,
    Object? path = _undefined,
    Object? size = _undefined,
    Object? episodes = _undefined,
    Object? directory = _undefined,
    Object? segments = _undefined,
    Object? mediaFileStreams = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentMediaFiles(
      durationInMilliseconds: durationInMilliseconds == _undefined
          ? _instance.durationInMilliseconds
          : (durationInMilliseconds as int?),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      path: path == _undefined || path == null
          ? _instance.path
          : (path as String),
      size: size == _undefined || size == null
          ? _instance.size
          : (size as double),
      episodes: episodes == _undefined
          ? _instance.episodes
          : (episodes as List<Fragment$fragmentMediaFiles$episodes>?),
      directory: directory == _undefined || directory == null
          ? _instance.directory
          : (directory as Fragment$fragmentMediaFiles$directory),
      segments: segments == _undefined
          ? _instance.segments
          : (segments as List<Fragment$fragmentMediaFiles$segments>?),
      mediaFileStreams: mediaFileStreams == _undefined
          ? _instance.mediaFileStreams
          : (mediaFileStreams
                as List<Fragment$fragmentMediaFiles$mediaFileStreams?>?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  TRes episodes(
    Iterable<Fragment$fragmentMediaFiles$episodes>? Function(
      Iterable<
        CopyWith$Fragment$fragmentMediaFiles$episodes<
          Fragment$fragmentMediaFiles$episodes
        >
      >?,
    )
    _fn,
  ) => call(
    episodes: _fn(
      _instance.episodes?.map(
        (e) => CopyWith$Fragment$fragmentMediaFiles$episodes(e, (i) => i),
      ),
    )?.toList(),
  );

  CopyWith$Fragment$fragmentMediaFiles$directory<TRes> get directory {
    final local$directory = _instance.directory;
    return CopyWith$Fragment$fragmentMediaFiles$directory(
      local$directory,
      (e) => call(directory: e),
    );
  }

  TRes segments(
    Iterable<Fragment$fragmentMediaFiles$segments>? Function(
      Iterable<
        CopyWith$Fragment$fragmentMediaFiles$segments<
          Fragment$fragmentMediaFiles$segments
        >
      >?,
    )
    _fn,
  ) => call(
    segments: _fn(
      _instance.segments?.map(
        (e) => CopyWith$Fragment$fragmentMediaFiles$segments(e, (i) => i),
      ),
    )?.toList(),
  );

  TRes mediaFileStreams(
    Iterable<Fragment$fragmentMediaFiles$mediaFileStreams?>? Function(
      Iterable<
        CopyWith$Fragment$fragmentMediaFiles$mediaFileStreams<
          Fragment$fragmentMediaFiles$mediaFileStreams
        >?
      >?,
    )
    _fn,
  ) => call(
    mediaFileStreams: _fn(
      _instance.mediaFileStreams?.map(
        (e) => e == null
            ? null
            : CopyWith$Fragment$fragmentMediaFiles$mediaFileStreams(
                e,
                (i) => i,
              ),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Fragment$fragmentMediaFiles<TRes>
    implements CopyWith$Fragment$fragmentMediaFiles<TRes> {
  _CopyWithStubImpl$Fragment$fragmentMediaFiles(this._res);

  TRes _res;

  call({
    int? durationInMilliseconds,
    String? id,
    String? path,
    double? size,
    List<Fragment$fragmentMediaFiles$episodes>? episodes,
    Fragment$fragmentMediaFiles$directory? directory,
    List<Fragment$fragmentMediaFiles$segments>? segments,
    List<Fragment$fragmentMediaFiles$mediaFileStreams?>? mediaFileStreams,
    String? $__typename,
  }) => _res;

  episodes(_fn) => _res;

  CopyWith$Fragment$fragmentMediaFiles$directory<TRes> get directory =>
      CopyWith$Fragment$fragmentMediaFiles$directory.stub(_res);

  segments(_fn) => _res;

  mediaFileStreams(_fn) => _res;
}

const fragmentDefinitionfragmentMediaFiles = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentMediaFiles'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'MediaFile'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'durationInMilliseconds'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
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
        name: NameNode(value: 'size'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'episodes'),
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
        name: NameNode(value: 'segments'),
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
              name: NameNode(value: 'type'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'startInMilliseconds'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'endInMilliseconds'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'episodeId'),
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
        name: NameNode(value: 'mediaFileStreams'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: SelectionSetNode(
          selections: [
            FieldNode(
              name: NameNode(value: 'codecName'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'codecType'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'cropHeight'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'cropWidth'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'cropX'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'cropY'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'height'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'id'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'language'),
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
              name: NameNode(value: 'streamIndex'),
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
              name: NameNode(value: 'width'),
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
);
const documentNodeFragmentfragmentMediaFiles = DocumentNode(
  definitions: [fragmentDefinitionfragmentMediaFiles],
);

class Fragment$fragmentMediaFiles$episodes {
  Fragment$fragmentMediaFiles$episodes({
    required this.id,
    required this.number,
    this.$__typename = 'Episode',
  });

  factory Fragment$fragmentMediaFiles$episodes.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentMediaFiles$episodes(
      id: (l$id as String),
      number: (l$number as int),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int number;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$number = number;
    _resultData['number'] = l$number;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$number = number;
    final l$$__typename = $__typename;
    return Object.hashAll([l$id, l$number, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentMediaFiles$episodes ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$fragmentMediaFiles$episodes
    on Fragment$fragmentMediaFiles$episodes {
  CopyWith$Fragment$fragmentMediaFiles$episodes<
    Fragment$fragmentMediaFiles$episodes
  >
  get copyWith => CopyWith$Fragment$fragmentMediaFiles$episodes(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentMediaFiles$episodes<TRes> {
  factory CopyWith$Fragment$fragmentMediaFiles$episodes(
    Fragment$fragmentMediaFiles$episodes instance,
    TRes Function(Fragment$fragmentMediaFiles$episodes) then,
  ) = _CopyWithImpl$Fragment$fragmentMediaFiles$episodes;

  factory CopyWith$Fragment$fragmentMediaFiles$episodes.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentMediaFiles$episodes;

  TRes call({String? id, int? number, String? $__typename});
}

class _CopyWithImpl$Fragment$fragmentMediaFiles$episodes<TRes>
    implements CopyWith$Fragment$fragmentMediaFiles$episodes<TRes> {
  _CopyWithImpl$Fragment$fragmentMediaFiles$episodes(
    this._instance,
    this._then,
  );

  final Fragment$fragmentMediaFiles$episodes _instance;

  final TRes Function(Fragment$fragmentMediaFiles$episodes) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? number = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentMediaFiles$episodes(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentMediaFiles$episodes<TRes>
    implements CopyWith$Fragment$fragmentMediaFiles$episodes<TRes> {
  _CopyWithStubImpl$Fragment$fragmentMediaFiles$episodes(this._res);

  TRes _res;

  call({String? id, int? number, String? $__typename}) => _res;
}

class Fragment$fragmentMediaFiles$directory {
  Fragment$fragmentMediaFiles$directory({
    required this.node,
    this.$__typename = 'Directory',
  });

  factory Fragment$fragmentMediaFiles$directory.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$node = json['node'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentMediaFiles$directory(
      node: Fragment$fragmentMediaFiles$directory$node.fromJson(
        (l$node as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Fragment$fragmentMediaFiles$directory$node node;

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
    if (other is! Fragment$fragmentMediaFiles$directory ||
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

extension UtilityExtension$Fragment$fragmentMediaFiles$directory
    on Fragment$fragmentMediaFiles$directory {
  CopyWith$Fragment$fragmentMediaFiles$directory<
    Fragment$fragmentMediaFiles$directory
  >
  get copyWith =>
      CopyWith$Fragment$fragmentMediaFiles$directory(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentMediaFiles$directory<TRes> {
  factory CopyWith$Fragment$fragmentMediaFiles$directory(
    Fragment$fragmentMediaFiles$directory instance,
    TRes Function(Fragment$fragmentMediaFiles$directory) then,
  ) = _CopyWithImpl$Fragment$fragmentMediaFiles$directory;

  factory CopyWith$Fragment$fragmentMediaFiles$directory.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentMediaFiles$directory;

  TRes call({
    Fragment$fragmentMediaFiles$directory$node? node,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentMediaFiles$directory$node<TRes> get node;
}

class _CopyWithImpl$Fragment$fragmentMediaFiles$directory<TRes>
    implements CopyWith$Fragment$fragmentMediaFiles$directory<TRes> {
  _CopyWithImpl$Fragment$fragmentMediaFiles$directory(
    this._instance,
    this._then,
  );

  final Fragment$fragmentMediaFiles$directory _instance;

  final TRes Function(Fragment$fragmentMediaFiles$directory) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? node = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Fragment$fragmentMediaFiles$directory(
          node: node == _undefined || node == null
              ? _instance.node
              : (node as Fragment$fragmentMediaFiles$directory$node),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );

  CopyWith$Fragment$fragmentMediaFiles$directory$node<TRes> get node {
    final local$node = _instance.node;
    return CopyWith$Fragment$fragmentMediaFiles$directory$node(
      local$node,
      (e) => call(node: e),
    );
  }
}

class _CopyWithStubImpl$Fragment$fragmentMediaFiles$directory<TRes>
    implements CopyWith$Fragment$fragmentMediaFiles$directory<TRes> {
  _CopyWithStubImpl$Fragment$fragmentMediaFiles$directory(this._res);

  TRes _res;

  call({
    Fragment$fragmentMediaFiles$directory$node? node,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentMediaFiles$directory$node<TRes> get node =>
      CopyWith$Fragment$fragmentMediaFiles$directory$node.stub(_res);
}

class Fragment$fragmentMediaFiles$directory$node {
  Fragment$fragmentMediaFiles$directory$node({
    required this.url,
    this.$__typename = 'Node',
  });

  factory Fragment$fragmentMediaFiles$directory$node.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$url = json['url'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentMediaFiles$directory$node(
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
    if (other is! Fragment$fragmentMediaFiles$directory$node ||
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

extension UtilityExtension$Fragment$fragmentMediaFiles$directory$node
    on Fragment$fragmentMediaFiles$directory$node {
  CopyWith$Fragment$fragmentMediaFiles$directory$node<
    Fragment$fragmentMediaFiles$directory$node
  >
  get copyWith =>
      CopyWith$Fragment$fragmentMediaFiles$directory$node(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentMediaFiles$directory$node<TRes> {
  factory CopyWith$Fragment$fragmentMediaFiles$directory$node(
    Fragment$fragmentMediaFiles$directory$node instance,
    TRes Function(Fragment$fragmentMediaFiles$directory$node) then,
  ) = _CopyWithImpl$Fragment$fragmentMediaFiles$directory$node;

  factory CopyWith$Fragment$fragmentMediaFiles$directory$node.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentMediaFiles$directory$node;

  TRes call({String? url, String? $__typename});
}

class _CopyWithImpl$Fragment$fragmentMediaFiles$directory$node<TRes>
    implements CopyWith$Fragment$fragmentMediaFiles$directory$node<TRes> {
  _CopyWithImpl$Fragment$fragmentMediaFiles$directory$node(
    this._instance,
    this._then,
  );

  final Fragment$fragmentMediaFiles$directory$node _instance;

  final TRes Function(Fragment$fragmentMediaFiles$directory$node) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? url = _undefined, Object? $__typename = _undefined}) =>
      _then(
        Fragment$fragmentMediaFiles$directory$node(
          url: url == _undefined || url == null
              ? _instance.url
              : (url as String),
          $__typename: $__typename == _undefined || $__typename == null
              ? _instance.$__typename
              : ($__typename as String),
        ),
      );
}

class _CopyWithStubImpl$Fragment$fragmentMediaFiles$directory$node<TRes>
    implements CopyWith$Fragment$fragmentMediaFiles$directory$node<TRes> {
  _CopyWithStubImpl$Fragment$fragmentMediaFiles$directory$node(this._res);

  TRes _res;

  call({String? url, String? $__typename}) => _res;
}

class Fragment$fragmentMediaFiles$segments {
  Fragment$fragmentMediaFiles$segments({
    required this.id,
    required this.type,
    required this.startInMilliseconds,
    required this.endInMilliseconds,
    this.episodeId,
    this.$__typename = 'MediaSegment',
  });

  factory Fragment$fragmentMediaFiles$segments.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$type = json['type'];
    final l$startInMilliseconds = json['startInMilliseconds'];
    final l$endInMilliseconds = json['endInMilliseconds'];
    final l$episodeId = json['episodeId'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentMediaFiles$segments(
      id: (l$id as String),
      type: fromJson$Enum$MediaSegmentType((l$type as String)),
      startInMilliseconds: (l$startInMilliseconds as num).toDouble(),
      endInMilliseconds: (l$endInMilliseconds as num).toDouble(),
      episodeId: (l$episodeId as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final Enum$MediaSegmentType type;

  final double startInMilliseconds;

  final double endInMilliseconds;

  final String? episodeId;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$type = type;
    _resultData['type'] = toJson$Enum$MediaSegmentType(l$type);
    final l$startInMilliseconds = startInMilliseconds;
    _resultData['startInMilliseconds'] = l$startInMilliseconds;
    final l$endInMilliseconds = endInMilliseconds;
    _resultData['endInMilliseconds'] = l$endInMilliseconds;
    final l$episodeId = episodeId;
    _resultData['episodeId'] = l$episodeId;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$type = type;
    final l$startInMilliseconds = startInMilliseconds;
    final l$endInMilliseconds = endInMilliseconds;
    final l$episodeId = episodeId;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$type,
      l$startInMilliseconds,
      l$endInMilliseconds,
      l$episodeId,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentMediaFiles$segments ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$type = type;
    final lOther$type = other.type;
    if (l$type != lOther$type) {
      return false;
    }
    final l$startInMilliseconds = startInMilliseconds;
    final lOther$startInMilliseconds = other.startInMilliseconds;
    if (l$startInMilliseconds != lOther$startInMilliseconds) {
      return false;
    }
    final l$endInMilliseconds = endInMilliseconds;
    final lOther$endInMilliseconds = other.endInMilliseconds;
    if (l$endInMilliseconds != lOther$endInMilliseconds) {
      return false;
    }
    final l$episodeId = episodeId;
    final lOther$episodeId = other.episodeId;
    if (l$episodeId != lOther$episodeId) {
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

extension UtilityExtension$Fragment$fragmentMediaFiles$segments
    on Fragment$fragmentMediaFiles$segments {
  CopyWith$Fragment$fragmentMediaFiles$segments<
    Fragment$fragmentMediaFiles$segments
  >
  get copyWith => CopyWith$Fragment$fragmentMediaFiles$segments(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentMediaFiles$segments<TRes> {
  factory CopyWith$Fragment$fragmentMediaFiles$segments(
    Fragment$fragmentMediaFiles$segments instance,
    TRes Function(Fragment$fragmentMediaFiles$segments) then,
  ) = _CopyWithImpl$Fragment$fragmentMediaFiles$segments;

  factory CopyWith$Fragment$fragmentMediaFiles$segments.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentMediaFiles$segments;

  TRes call({
    String? id,
    Enum$MediaSegmentType? type,
    double? startInMilliseconds,
    double? endInMilliseconds,
    String? episodeId,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentMediaFiles$segments<TRes>
    implements CopyWith$Fragment$fragmentMediaFiles$segments<TRes> {
  _CopyWithImpl$Fragment$fragmentMediaFiles$segments(
    this._instance,
    this._then,
  );

  final Fragment$fragmentMediaFiles$segments _instance;

  final TRes Function(Fragment$fragmentMediaFiles$segments) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? type = _undefined,
    Object? startInMilliseconds = _undefined,
    Object? endInMilliseconds = _undefined,
    Object? episodeId = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentMediaFiles$segments(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      type: type == _undefined || type == null
          ? _instance.type
          : (type as Enum$MediaSegmentType),
      startInMilliseconds:
          startInMilliseconds == _undefined || startInMilliseconds == null
          ? _instance.startInMilliseconds
          : (startInMilliseconds as double),
      endInMilliseconds:
          endInMilliseconds == _undefined || endInMilliseconds == null
          ? _instance.endInMilliseconds
          : (endInMilliseconds as double),
      episodeId: episodeId == _undefined
          ? _instance.episodeId
          : (episodeId as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentMediaFiles$segments<TRes>
    implements CopyWith$Fragment$fragmentMediaFiles$segments<TRes> {
  _CopyWithStubImpl$Fragment$fragmentMediaFiles$segments(this._res);

  TRes _res;

  call({
    String? id,
    Enum$MediaSegmentType? type,
    double? startInMilliseconds,
    double? endInMilliseconds,
    String? episodeId,
    String? $__typename,
  }) => _res;
}

class Fragment$fragmentMediaFiles$mediaFileStreams {
  Fragment$fragmentMediaFiles$mediaFileStreams({
    required this.codecName,
    required this.codecType,
    this.cropHeight,
    this.cropWidth,
    this.cropX,
    this.cropY,
    required this.height,
    required this.id,
    this.language,
    required this.path,
    this.streamIndex,
    this.title,
    required this.width,
    this.$__typename = 'MediaFileStream',
  });

  factory Fragment$fragmentMediaFiles$mediaFileStreams.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$codecName = json['codecName'];
    final l$codecType = json['codecType'];
    final l$cropHeight = json['cropHeight'];
    final l$cropWidth = json['cropWidth'];
    final l$cropX = json['cropX'];
    final l$cropY = json['cropY'];
    final l$height = json['height'];
    final l$id = json['id'];
    final l$language = json['language'];
    final l$path = json['path'];
    final l$streamIndex = json['streamIndex'];
    final l$title = json['title'];
    final l$width = json['width'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentMediaFiles$mediaFileStreams(
      codecName: (l$codecName as String),
      codecType: (l$codecType as String),
      cropHeight: (l$cropHeight as int?),
      cropWidth: (l$cropWidth as int?),
      cropX: (l$cropX as int?),
      cropY: (l$cropY as int?),
      height: (l$height as int),
      id: (l$id as String),
      language: (l$language as String?),
      path: (l$path as String),
      streamIndex: (l$streamIndex as int?),
      title: (l$title as String?),
      width: (l$width as int),
      $__typename: (l$$__typename as String),
    );
  }

  final String codecName;

  final String codecType;

  final int? cropHeight;

  final int? cropWidth;

  final int? cropX;

  final int? cropY;

  final int height;

  final String id;

  final String? language;

  final String path;

  final int? streamIndex;

  final String? title;

  final int width;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$codecName = codecName;
    _resultData['codecName'] = l$codecName;
    final l$codecType = codecType;
    _resultData['codecType'] = l$codecType;
    final l$cropHeight = cropHeight;
    _resultData['cropHeight'] = l$cropHeight;
    final l$cropWidth = cropWidth;
    _resultData['cropWidth'] = l$cropWidth;
    final l$cropX = cropX;
    _resultData['cropX'] = l$cropX;
    final l$cropY = cropY;
    _resultData['cropY'] = l$cropY;
    final l$height = height;
    _resultData['height'] = l$height;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$language = language;
    _resultData['language'] = l$language;
    final l$path = path;
    _resultData['path'] = l$path;
    final l$streamIndex = streamIndex;
    _resultData['streamIndex'] = l$streamIndex;
    final l$title = title;
    _resultData['title'] = l$title;
    final l$width = width;
    _resultData['width'] = l$width;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$codecName = codecName;
    final l$codecType = codecType;
    final l$cropHeight = cropHeight;
    final l$cropWidth = cropWidth;
    final l$cropX = cropX;
    final l$cropY = cropY;
    final l$height = height;
    final l$id = id;
    final l$language = language;
    final l$path = path;
    final l$streamIndex = streamIndex;
    final l$title = title;
    final l$width = width;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$codecName,
      l$codecType,
      l$cropHeight,
      l$cropWidth,
      l$cropX,
      l$cropY,
      l$height,
      l$id,
      l$language,
      l$path,
      l$streamIndex,
      l$title,
      l$width,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentMediaFiles$mediaFileStreams ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$codecName = codecName;
    final lOther$codecName = other.codecName;
    if (l$codecName != lOther$codecName) {
      return false;
    }
    final l$codecType = codecType;
    final lOther$codecType = other.codecType;
    if (l$codecType != lOther$codecType) {
      return false;
    }
    final l$cropHeight = cropHeight;
    final lOther$cropHeight = other.cropHeight;
    if (l$cropHeight != lOther$cropHeight) {
      return false;
    }
    final l$cropWidth = cropWidth;
    final lOther$cropWidth = other.cropWidth;
    if (l$cropWidth != lOther$cropWidth) {
      return false;
    }
    final l$cropX = cropX;
    final lOther$cropX = other.cropX;
    if (l$cropX != lOther$cropX) {
      return false;
    }
    final l$cropY = cropY;
    final lOther$cropY = other.cropY;
    if (l$cropY != lOther$cropY) {
      return false;
    }
    final l$height = height;
    final lOther$height = other.height;
    if (l$height != lOther$height) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$language = language;
    final lOther$language = other.language;
    if (l$language != lOther$language) {
      return false;
    }
    final l$path = path;
    final lOther$path = other.path;
    if (l$path != lOther$path) {
      return false;
    }
    final l$streamIndex = streamIndex;
    final lOther$streamIndex = other.streamIndex;
    if (l$streamIndex != lOther$streamIndex) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$width = width;
    final lOther$width = other.width;
    if (l$width != lOther$width) {
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

extension UtilityExtension$Fragment$fragmentMediaFiles$mediaFileStreams
    on Fragment$fragmentMediaFiles$mediaFileStreams {
  CopyWith$Fragment$fragmentMediaFiles$mediaFileStreams<
    Fragment$fragmentMediaFiles$mediaFileStreams
  >
  get copyWith =>
      CopyWith$Fragment$fragmentMediaFiles$mediaFileStreams(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentMediaFiles$mediaFileStreams<TRes> {
  factory CopyWith$Fragment$fragmentMediaFiles$mediaFileStreams(
    Fragment$fragmentMediaFiles$mediaFileStreams instance,
    TRes Function(Fragment$fragmentMediaFiles$mediaFileStreams) then,
  ) = _CopyWithImpl$Fragment$fragmentMediaFiles$mediaFileStreams;

  factory CopyWith$Fragment$fragmentMediaFiles$mediaFileStreams.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentMediaFiles$mediaFileStreams;

  TRes call({
    String? codecName,
    String? codecType,
    int? cropHeight,
    int? cropWidth,
    int? cropX,
    int? cropY,
    int? height,
    String? id,
    String? language,
    String? path,
    int? streamIndex,
    String? title,
    int? width,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentMediaFiles$mediaFileStreams<TRes>
    implements CopyWith$Fragment$fragmentMediaFiles$mediaFileStreams<TRes> {
  _CopyWithImpl$Fragment$fragmentMediaFiles$mediaFileStreams(
    this._instance,
    this._then,
  );

  final Fragment$fragmentMediaFiles$mediaFileStreams _instance;

  final TRes Function(Fragment$fragmentMediaFiles$mediaFileStreams) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? codecName = _undefined,
    Object? codecType = _undefined,
    Object? cropHeight = _undefined,
    Object? cropWidth = _undefined,
    Object? cropX = _undefined,
    Object? cropY = _undefined,
    Object? height = _undefined,
    Object? id = _undefined,
    Object? language = _undefined,
    Object? path = _undefined,
    Object? streamIndex = _undefined,
    Object? title = _undefined,
    Object? width = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentMediaFiles$mediaFileStreams(
      codecName: codecName == _undefined || codecName == null
          ? _instance.codecName
          : (codecName as String),
      codecType: codecType == _undefined || codecType == null
          ? _instance.codecType
          : (codecType as String),
      cropHeight: cropHeight == _undefined
          ? _instance.cropHeight
          : (cropHeight as int?),
      cropWidth: cropWidth == _undefined
          ? _instance.cropWidth
          : (cropWidth as int?),
      cropX: cropX == _undefined ? _instance.cropX : (cropX as int?),
      cropY: cropY == _undefined ? _instance.cropY : (cropY as int?),
      height: height == _undefined || height == null
          ? _instance.height
          : (height as int),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      language: language == _undefined
          ? _instance.language
          : (language as String?),
      path: path == _undefined || path == null
          ? _instance.path
          : (path as String),
      streamIndex: streamIndex == _undefined
          ? _instance.streamIndex
          : (streamIndex as int?),
      title: title == _undefined ? _instance.title : (title as String?),
      width: width == _undefined || width == null
          ? _instance.width
          : (width as int),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentMediaFiles$mediaFileStreams<TRes>
    implements CopyWith$Fragment$fragmentMediaFiles$mediaFileStreams<TRes> {
  _CopyWithStubImpl$Fragment$fragmentMediaFiles$mediaFileStreams(this._res);

  TRes _res;

  call({
    String? codecName,
    String? codecType,
    int? cropHeight,
    int? cropWidth,
    int? cropX,
    int? cropY,
    int? height,
    String? id,
    String? language,
    String? path,
    int? streamIndex,
    String? title,
    int? width,
    String? $__typename,
  }) => _res;
}
