import 'fragmentMetadata.graphql.dart';

import 'package:gql/ast.dart';

import 'schema.graphql.dart';

class Fragment$fragmentTrack {
  Fragment$fragmentTrack({
    required this.id,
    required this.number,
    required this.discNumber,
    required this.artist,
    required this.artists,
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
    final l$artists = json['artists'];
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
      artists: (l$artists as List<dynamic>)
          .map(
            (e) => Fragment$fragmentTrack$artists.fromJson(
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

  final List<Fragment$fragmentTrack$artists> artists;

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
    final l$artists = artists;
    _resultData['artists'] = l$artists.map((e) => e.toJson()).toList();
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
    final l$artists = artists;
    final l$metadata = metadata;
    final l$mediaFile = mediaFile;
    final l$rating = rating;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$number,
      l$discNumber,
      l$artist,
      Object.hashAll(l$artists.map((v) => v)),
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
    final l$artists = artists;
    final lOther$artists = other.artists;
    if (l$artists.length != lOther$artists.length) {
      return false;
    }
    for (int i = 0; i < l$artists.length; i++) {
      final l$artists$entry = l$artists[i];
      final lOther$artists$entry = lOther$artists[i];
      if (l$artists$entry != lOther$artists$entry) {
        return false;
      }
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
    List<Fragment$fragmentTrack$artists>? artists,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentTrack$mediaFile>? mediaFile,
    int? rating,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentTrack$artist<TRes> get artist;
  TRes artists(
    Iterable<Fragment$fragmentTrack$artists> Function(
      Iterable<
        CopyWith$Fragment$fragmentTrack$artists<Fragment$fragmentTrack$artists>
      >,
    )
    _fn,
  );
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
    Object? artists = _undefined,
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
      artists: artists == _undefined || artists == null
          ? _instance.artists
          : (artists as List<Fragment$fragmentTrack$artists>),
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

  TRes artists(
    Iterable<Fragment$fragmentTrack$artists> Function(
      Iterable<
        CopyWith$Fragment$fragmentTrack$artists<Fragment$fragmentTrack$artists>
      >,
    )
    _fn,
  ) => call(
    artists: _fn(
      _instance.artists.map(
        (e) => CopyWith$Fragment$fragmentTrack$artists(e, (i) => i),
      ),
    ).toList(),
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
    List<Fragment$fragmentTrack$artists>? artists,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentTrack$mediaFile>? mediaFile,
    int? rating,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentTrack$artist<TRes> get artist =>
      CopyWith$Fragment$fragmentTrack$artist.stub(_res);

  artists(_fn) => _res;

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
        name: NameNode(value: 'artists'),
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
              name: NameNode(value: 'position'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'person'),
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

class Fragment$fragmentTrack$artists {
  Fragment$fragmentTrack$artists({
    required this.type,
    required this.position,
    required this.person,
    this.$__typename = 'TrackCredit',
  });

  factory Fragment$fragmentTrack$artists.fromJson(Map<String, dynamic> json) {
    final l$type = json['type'];
    final l$position = json['position'];
    final l$person = json['person'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentTrack$artists(
      type: fromJson$Enum$TrackCreditType((l$type as String)),
      position: (l$position as int),
      person: Fragment$fragmentTrack$artists$person.fromJson(
        (l$person as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final Enum$TrackCreditType type;

  final int position;

  final Fragment$fragmentTrack$artists$person person;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$type = type;
    _resultData['type'] = toJson$Enum$TrackCreditType(l$type);
    final l$position = position;
    _resultData['position'] = l$position;
    final l$person = person;
    _resultData['person'] = l$person.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$type = type;
    final l$position = position;
    final l$person = person;
    final l$$__typename = $__typename;
    return Object.hashAll([l$type, l$position, l$person, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentTrack$artists ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$type = type;
    final lOther$type = other.type;
    if (l$type != lOther$type) {
      return false;
    }
    final l$position = position;
    final lOther$position = other.position;
    if (l$position != lOther$position) {
      return false;
    }
    final l$person = person;
    final lOther$person = other.person;
    if (l$person != lOther$person) {
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

extension UtilityExtension$Fragment$fragmentTrack$artists
    on Fragment$fragmentTrack$artists {
  CopyWith$Fragment$fragmentTrack$artists<Fragment$fragmentTrack$artists>
  get copyWith => CopyWith$Fragment$fragmentTrack$artists(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentTrack$artists<TRes> {
  factory CopyWith$Fragment$fragmentTrack$artists(
    Fragment$fragmentTrack$artists instance,
    TRes Function(Fragment$fragmentTrack$artists) then,
  ) = _CopyWithImpl$Fragment$fragmentTrack$artists;

  factory CopyWith$Fragment$fragmentTrack$artists.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentTrack$artists;

  TRes call({
    Enum$TrackCreditType? type,
    int? position,
    Fragment$fragmentTrack$artists$person? person,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentTrack$artists$person<TRes> get person;
}

class _CopyWithImpl$Fragment$fragmentTrack$artists<TRes>
    implements CopyWith$Fragment$fragmentTrack$artists<TRes> {
  _CopyWithImpl$Fragment$fragmentTrack$artists(this._instance, this._then);

  final Fragment$fragmentTrack$artists _instance;

  final TRes Function(Fragment$fragmentTrack$artists) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? type = _undefined,
    Object? position = _undefined,
    Object? person = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentTrack$artists(
      type: type == _undefined || type == null
          ? _instance.type
          : (type as Enum$TrackCreditType),
      position: position == _undefined || position == null
          ? _instance.position
          : (position as int),
      person: person == _undefined || person == null
          ? _instance.person
          : (person as Fragment$fragmentTrack$artists$person),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentTrack$artists$person<TRes> get person {
    final local$person = _instance.person;
    return CopyWith$Fragment$fragmentTrack$artists$person(
      local$person,
      (e) => call(person: e),
    );
  }
}

class _CopyWithStubImpl$Fragment$fragmentTrack$artists<TRes>
    implements CopyWith$Fragment$fragmentTrack$artists<TRes> {
  _CopyWithStubImpl$Fragment$fragmentTrack$artists(this._res);

  TRes _res;

  call({
    Enum$TrackCreditType? type,
    int? position,
    Fragment$fragmentTrack$artists$person? person,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentTrack$artists$person<TRes> get person =>
      CopyWith$Fragment$fragmentTrack$artists$person.stub(_res);
}

class Fragment$fragmentTrack$artists$person {
  Fragment$fragmentTrack$artists$person({
    required this.id,
    required this.name,
    this.$__typename = 'Person',
  });

  factory Fragment$fragmentTrack$artists$person.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentTrack$artists$person(
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
    if (other is! Fragment$fragmentTrack$artists$person ||
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

extension UtilityExtension$Fragment$fragmentTrack$artists$person
    on Fragment$fragmentTrack$artists$person {
  CopyWith$Fragment$fragmentTrack$artists$person<
    Fragment$fragmentTrack$artists$person
  >
  get copyWith =>
      CopyWith$Fragment$fragmentTrack$artists$person(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentTrack$artists$person<TRes> {
  factory CopyWith$Fragment$fragmentTrack$artists$person(
    Fragment$fragmentTrack$artists$person instance,
    TRes Function(Fragment$fragmentTrack$artists$person) then,
  ) = _CopyWithImpl$Fragment$fragmentTrack$artists$person;

  factory CopyWith$Fragment$fragmentTrack$artists$person.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentTrack$artists$person;

  TRes call({String? id, String? name, String? $__typename});
}

class _CopyWithImpl$Fragment$fragmentTrack$artists$person<TRes>
    implements CopyWith$Fragment$fragmentTrack$artists$person<TRes> {
  _CopyWithImpl$Fragment$fragmentTrack$artists$person(
    this._instance,
    this._then,
  );

  final Fragment$fragmentTrack$artists$person _instance;

  final TRes Function(Fragment$fragmentTrack$artists$person) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentTrack$artists$person(
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

class _CopyWithStubImpl$Fragment$fragmentTrack$artists$person<TRes>
    implements CopyWith$Fragment$fragmentTrack$artists$person<TRes> {
  _CopyWithStubImpl$Fragment$fragmentTrack$artists$person(this._res);

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
