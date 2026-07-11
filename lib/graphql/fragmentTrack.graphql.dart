import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';

class Fragment$fragmentTrack {
  Fragment$fragmentTrack({
    required this.id,
    required this.number,
    required this.discNumber,
    required this.artist,
    this.metadata,
    this.mediaFile,
    this.rating,
    this.$__typename = 'Track',
  });

  factory Fragment$fragmentTrack.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$discNumber = json['discNumber'];
    final l$artist = json['artist'];
    final l$metadata = json['metadata'];
    final l$mediaFile = json['mediaFile'];
    final l$rating = json['rating'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentTrack(
      id: (l$id as String),
      number: (l$number as int),
      discNumber: (l$discNumber as int),
      artist: Fragment$fragmentTrack$artist.fromJson(
        (l$artist as Map<String, dynamic>),
      ),
      metadata: (l$metadata as List<dynamic>?)
          ?.map(
            (e) =>
                Fragment$fragmentMetadata.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      mediaFile: (l$mediaFile as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentTrack$mediaFile.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      rating: (l$rating as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int number;

  final int discNumber;

  final Fragment$fragmentTrack$artist artist;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Fragment$fragmentTrack$mediaFile>? mediaFile;

  final int? rating;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$number = number;
    _resultData['number'] = l$number;
    final l$discNumber = discNumber;
    _resultData['discNumber'] = l$discNumber;
    final l$artist = artist;
    _resultData['artist'] = l$artist.toJson();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$mediaFile = mediaFile;
    _resultData['mediaFile'] = l$mediaFile?.map((e) => e.toJson()).toList();
    final l$rating = rating;
    _resultData['rating'] = l$rating;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$number = number;
    final l$discNumber = discNumber;
    final l$artist = artist;
    final l$metadata = metadata;
    final l$mediaFile = mediaFile;
    final l$rating = rating;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$number,
      l$discNumber,
      l$artist,
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$mediaFile == null ? null : Object.hashAll(l$mediaFile.map((v) => v)),
      l$rating,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentTrack || runtimeType != other.runtimeType) {
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
    final l$discNumber = discNumber;
    final lOther$discNumber = other.discNumber;
    if (l$discNumber != lOther$discNumber) {
      return false;
    }
    final l$artist = artist;
    final lOther$artist = other.artist;
    if (l$artist != lOther$artist) {
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
    final l$rating = rating;
    final lOther$rating = other.rating;
    if (l$rating != lOther$rating) {
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

extension UtilityExtension$Fragment$fragmentTrack on Fragment$fragmentTrack {
  CopyWith$Fragment$fragmentTrack<Fragment$fragmentTrack> get copyWith =>
      CopyWith$Fragment$fragmentTrack(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentTrack<TRes> {
  factory CopyWith$Fragment$fragmentTrack(
    Fragment$fragmentTrack instance,
    TRes Function(Fragment$fragmentTrack) then,
  ) = _CopyWithImpl$Fragment$fragmentTrack;

  factory CopyWith$Fragment$fragmentTrack.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentTrack;

  TRes call({
    String? id,
    int? number,
    int? discNumber,
    Fragment$fragmentTrack$artist? artist,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentTrack$mediaFile>? mediaFile,
    int? rating,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentTrack$artist<TRes> get artist;
  TRes metadata(
    Iterable<Fragment$fragmentMetadata>? Function(
      Iterable<CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata>>?,
    )
    _fn,
  );
  TRes mediaFile(
    Iterable<Fragment$fragmentTrack$mediaFile>? Function(
      Iterable<
        CopyWith$Fragment$fragmentTrack$mediaFile<
          Fragment$fragmentTrack$mediaFile
        >
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Fragment$fragmentTrack<TRes>
    implements CopyWith$Fragment$fragmentTrack<TRes> {
  _CopyWithImpl$Fragment$fragmentTrack(this._instance, this._then);

  final Fragment$fragmentTrack _instance;

  final TRes Function(Fragment$fragmentTrack) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? number = _undefined,
    Object? discNumber = _undefined,
    Object? artist = _undefined,
    Object? metadata = _undefined,
    Object? mediaFile = _undefined,
    Object? rating = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentTrack(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      discNumber: discNumber == _undefined || discNumber == null
          ? _instance.discNumber
          : (discNumber as int),
      artist: artist == _undefined || artist == null
          ? _instance.artist
          : (artist as Fragment$fragmentTrack$artist),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      mediaFile: mediaFile == _undefined
          ? _instance.mediaFile
          : (mediaFile as List<Fragment$fragmentTrack$mediaFile>?),
      rating: rating == _undefined ? _instance.rating : (rating as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentTrack$artist<TRes> get artist {
    final local$artist = _instance.artist;
    return CopyWith$Fragment$fragmentTrack$artist(
      local$artist,
      (e) => call(artist: e),
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

  TRes mediaFile(
    Iterable<Fragment$fragmentTrack$mediaFile>? Function(
      Iterable<
        CopyWith$Fragment$fragmentTrack$mediaFile<
          Fragment$fragmentTrack$mediaFile
        >
      >?,
    )
    _fn,
  ) => call(
    mediaFile: _fn(
      _instance.mediaFile?.map(
        (e) => CopyWith$Fragment$fragmentTrack$mediaFile(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Fragment$fragmentTrack<TRes>
    implements CopyWith$Fragment$fragmentTrack<TRes> {
  _CopyWithStubImpl$Fragment$fragmentTrack(this._res);

  TRes _res;

  call({
    String? id,
    int? number,
    int? discNumber,
    Fragment$fragmentTrack$artist? artist,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentTrack$mediaFile>? mediaFile,
    int? rating,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentTrack$artist<TRes> get artist =>
      CopyWith$Fragment$fragmentTrack$artist.stub(_res);

  metadata(_fn) => _res;

  mediaFile(_fn) => _res;
}

const fragmentDefinitionfragmentTrack = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentTrack'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Track'), isNonNull: false),
  ),
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
        name: NameNode(value: 'discNumber'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'artist'),
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
        name: NameNode(value: 'mediaFile'),
        alias: null,
        arguments: [],
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
        name: NameNode(value: 'rating'),
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
);
const documentNodeFragmentfragmentTrack = DocumentNode(
  definitions: [
    fragmentDefinitionfragmentTrack,
    fragmentDefinitionfragmentMetadata,
  ],
);

class Fragment$fragmentTrack$artist {
  Fragment$fragmentTrack$artist({
    required this.id,
    required this.name,
    this.$__typename = 'Person',
  });

  factory Fragment$fragmentTrack$artist.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentTrack$artist(
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
    if (other is! Fragment$fragmentTrack$artist ||
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

extension UtilityExtension$Fragment$fragmentTrack$artist
    on Fragment$fragmentTrack$artist {
  CopyWith$Fragment$fragmentTrack$artist<Fragment$fragmentTrack$artist>
  get copyWith => CopyWith$Fragment$fragmentTrack$artist(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentTrack$artist<TRes> {
  factory CopyWith$Fragment$fragmentTrack$artist(
    Fragment$fragmentTrack$artist instance,
    TRes Function(Fragment$fragmentTrack$artist) then,
  ) = _CopyWithImpl$Fragment$fragmentTrack$artist;

  factory CopyWith$Fragment$fragmentTrack$artist.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentTrack$artist;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Fragment$fragmentTrack$artist<TRes>
    implements CopyWith$Fragment$fragmentTrack$artist<TRes> {
  _CopyWithImpl$Fragment$fragmentTrack$artist(this._instance, this._then);

  final Fragment$fragmentTrack$artist _instance;

  final TRes Function(Fragment$fragmentTrack$artist) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentTrack$artist(
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

class _CopyWithStubImpl$Fragment$fragmentTrack$artist<TRes>
    implements CopyWith$Fragment$fragmentTrack$artist<TRes> {
  _CopyWithStubImpl$Fragment$fragmentTrack$artist(this._res);

  TRes _res;

  call({String? id, String? name, String? $__typename}) => _res;
}

class Fragment$fragmentTrack$mediaFile {
  Fragment$fragmentTrack$mediaFile({
    this.durationInMilliseconds,
    this.$__typename = 'MediaFile',
  });

  factory Fragment$fragmentTrack$mediaFile.fromJson(Map<String, dynamic> json) {
    final l$durationInMilliseconds = json['durationInMilliseconds'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentTrack$mediaFile(
      durationInMilliseconds: (l$durationInMilliseconds as int?),
      $__typename: (l$$__typename as String),
    );
  }

  final int? durationInMilliseconds;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$durationInMilliseconds = durationInMilliseconds;
    _resultData['durationInMilliseconds'] = l$durationInMilliseconds;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$durationInMilliseconds = durationInMilliseconds;
    final l$$__typename = $__typename;
    return Object.hashAll([l$durationInMilliseconds, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentTrack$mediaFile ||
        runtimeType != other.runtimeType) {
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

extension UtilityExtension$Fragment$fragmentTrack$mediaFile
    on Fragment$fragmentTrack$mediaFile {
  CopyWith$Fragment$fragmentTrack$mediaFile<Fragment$fragmentTrack$mediaFile>
  get copyWith => CopyWith$Fragment$fragmentTrack$mediaFile(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentTrack$mediaFile<TRes> {
  factory CopyWith$Fragment$fragmentTrack$mediaFile(
    Fragment$fragmentTrack$mediaFile instance,
    TRes Function(Fragment$fragmentTrack$mediaFile) then,
  ) = _CopyWithImpl$Fragment$fragmentTrack$mediaFile;

  factory CopyWith$Fragment$fragmentTrack$mediaFile.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentTrack$mediaFile;

  TRes call({int? durationInMilliseconds, String? $__typename});
}

class _CopyWithImpl$Fragment$fragmentTrack$mediaFile<TRes>
    implements CopyWith$Fragment$fragmentTrack$mediaFile<TRes> {
  _CopyWithImpl$Fragment$fragmentTrack$mediaFile(this._instance, this._then);

  final Fragment$fragmentTrack$mediaFile _instance;

  final TRes Function(Fragment$fragmentTrack$mediaFile) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? durationInMilliseconds = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentTrack$mediaFile(
      durationInMilliseconds: durationInMilliseconds == _undefined
          ? _instance.durationInMilliseconds
          : (durationInMilliseconds as int?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentTrack$mediaFile<TRes>
    implements CopyWith$Fragment$fragmentTrack$mediaFile<TRes> {
  _CopyWithStubImpl$Fragment$fragmentTrack$mediaFile(this._res);

  TRes _res;

  call({int? durationInMilliseconds, String? $__typename}) => _res;
}
