import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Fragment$fragmentCastMember {
  Fragment$fragmentCastMember({
    required this.id,
    this.characterName,
    required this.creditType,
    this.castOrder,
    required this.person,
    this.$__typename = 'Credit',
  });

  factory Fragment$fragmentCastMember.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$characterName = json['characterName'];
    final l$creditType = json['creditType'];
    final l$castOrder = json['castOrder'];
    final l$person = json['person'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentCastMember(
      id: (l$id as String),
      characterName: (l$characterName as String?),
      creditType: fromJson$Enum$CreditType((l$creditType as String)),
      castOrder: (l$castOrder as int?),
      person: Fragment$fragmentCastMember$person.fromJson(
        (l$person as Map<String, dynamic>),
      ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? characterName;

  final Enum$CreditType creditType;

  final int? castOrder;

  final Fragment$fragmentCastMember$person person;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$characterName = characterName;
    _resultData['characterName'] = l$characterName;
    final l$creditType = creditType;
    _resultData['creditType'] = toJson$Enum$CreditType(l$creditType);
    final l$castOrder = castOrder;
    _resultData['castOrder'] = l$castOrder;
    final l$person = person;
    _resultData['person'] = l$person.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$characterName = characterName;
    final l$creditType = creditType;
    final l$castOrder = castOrder;
    final l$person = person;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$characterName,
      l$creditType,
      l$castOrder,
      l$person,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentCastMember ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$characterName = characterName;
    final lOther$characterName = other.characterName;
    if (l$characterName != lOther$characterName) {
      return false;
    }
    final l$creditType = creditType;
    final lOther$creditType = other.creditType;
    if (l$creditType != lOther$creditType) {
      return false;
    }
    final l$castOrder = castOrder;
    final lOther$castOrder = other.castOrder;
    if (l$castOrder != lOther$castOrder) {
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

extension UtilityExtension$Fragment$fragmentCastMember
    on Fragment$fragmentCastMember {
  CopyWith$Fragment$fragmentCastMember<Fragment$fragmentCastMember>
  get copyWith => CopyWith$Fragment$fragmentCastMember(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentCastMember<TRes> {
  factory CopyWith$Fragment$fragmentCastMember(
    Fragment$fragmentCastMember instance,
    TRes Function(Fragment$fragmentCastMember) then,
  ) = _CopyWithImpl$Fragment$fragmentCastMember;

  factory CopyWith$Fragment$fragmentCastMember.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentCastMember;

  TRes call({
    String? id,
    String? characterName,
    Enum$CreditType? creditType,
    int? castOrder,
    Fragment$fragmentCastMember$person? person,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentCastMember$person<TRes> get person;
}

class _CopyWithImpl$Fragment$fragmentCastMember<TRes>
    implements CopyWith$Fragment$fragmentCastMember<TRes> {
  _CopyWithImpl$Fragment$fragmentCastMember(this._instance, this._then);

  final Fragment$fragmentCastMember _instance;

  final TRes Function(Fragment$fragmentCastMember) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? characterName = _undefined,
    Object? creditType = _undefined,
    Object? castOrder = _undefined,
    Object? person = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentCastMember(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      characterName: characterName == _undefined
          ? _instance.characterName
          : (characterName as String?),
      creditType: creditType == _undefined || creditType == null
          ? _instance.creditType
          : (creditType as Enum$CreditType),
      castOrder: castOrder == _undefined
          ? _instance.castOrder
          : (castOrder as int?),
      person: person == _undefined || person == null
          ? _instance.person
          : (person as Fragment$fragmentCastMember$person),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentCastMember$person<TRes> get person {
    final local$person = _instance.person;
    return CopyWith$Fragment$fragmentCastMember$person(
      local$person,
      (e) => call(person: e),
    );
  }
}

class _CopyWithStubImpl$Fragment$fragmentCastMember<TRes>
    implements CopyWith$Fragment$fragmentCastMember<TRes> {
  _CopyWithStubImpl$Fragment$fragmentCastMember(this._res);

  TRes _res;

  call({
    String? id,
    String? characterName,
    Enum$CreditType? creditType,
    int? castOrder,
    Fragment$fragmentCastMember$person? person,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentCastMember$person<TRes> get person =>
      CopyWith$Fragment$fragmentCastMember$person.stub(_res);
}

const fragmentDefinitionfragmentCastMember = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentCastMember'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Credit'), isNonNull: false),
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
        name: NameNode(value: 'characterName'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'creditType'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'castOrder'),
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
        name: NameNode(value: '__typename'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
    ],
  ),
);
const documentNodeFragmentfragmentCastMember = DocumentNode(
  definitions: [
    fragmentDefinitionfragmentCastMember,
    fragmentDefinitionfragmentImages,
  ],
);

class Fragment$fragmentCastMember$person {
  Fragment$fragmentCastMember$person({
    required this.id,
    required this.name,
    this.images,
    this.$__typename = 'Person',
  });

  factory Fragment$fragmentCastMember$person.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$images = json['images'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentCastMember$person(
      id: (l$id as String),
      name: (l$name as String),
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

  final String name;

  final List<Fragment$fragmentImages>? images;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$images = images;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentCastMember$person ||
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
    final l$$__typename = $__typename;
    final lOther$$__typename = other.$__typename;
    if (l$$__typename != lOther$$__typename) {
      return false;
    }
    return true;
  }
}

extension UtilityExtension$Fragment$fragmentCastMember$person
    on Fragment$fragmentCastMember$person {
  CopyWith$Fragment$fragmentCastMember$person<
    Fragment$fragmentCastMember$person
  >
  get copyWith => CopyWith$Fragment$fragmentCastMember$person(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentCastMember$person<TRes> {
  factory CopyWith$Fragment$fragmentCastMember$person(
    Fragment$fragmentCastMember$person instance,
    TRes Function(Fragment$fragmentCastMember$person) then,
  ) = _CopyWithImpl$Fragment$fragmentCastMember$person;

  factory CopyWith$Fragment$fragmentCastMember$person.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentCastMember$person;

  TRes call({
    String? id,
    String? name,
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

class _CopyWithImpl$Fragment$fragmentCastMember$person<TRes>
    implements CopyWith$Fragment$fragmentCastMember$person<TRes> {
  _CopyWithImpl$Fragment$fragmentCastMember$person(this._instance, this._then);

  final Fragment$fragmentCastMember$person _instance;

  final TRes Function(Fragment$fragmentCastMember$person) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? images = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentCastMember$person(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
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

class _CopyWithStubImpl$Fragment$fragmentCastMember$person<TRes>
    implements CopyWith$Fragment$fragmentCastMember$person<TRes> {
  _CopyWithStubImpl$Fragment$fragmentCastMember$person(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;
}

class Fragment$fragmentPersonCredit {
  Fragment$fragmentPersonCredit({
    required this.id,
    this.characterName,
    required this.creditType,
    this.castOrder,
    this.movie,
    this.$show,
    this.episode,
    this.$__typename = 'Credit',
  });

  factory Fragment$fragmentPersonCredit.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$characterName = json['characterName'];
    final l$creditType = json['creditType'];
    final l$castOrder = json['castOrder'];
    final l$movie = json['movie'];
    final l$$show = json['show'];
    final l$episode = json['episode'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPersonCredit(
      id: (l$id as String),
      characterName: (l$characterName as String?),
      creditType: fromJson$Enum$CreditType((l$creditType as String)),
      castOrder: (l$castOrder as int?),
      movie: l$movie == null
          ? null
          : Fragment$fragmentPersonCredit$movie.fromJson(
              (l$movie as Map<String, dynamic>),
            ),
      $show: l$$show == null
          ? null
          : Fragment$fragmentPersonCredit$show.fromJson(
              (l$$show as Map<String, dynamic>),
            ),
      episode: l$episode == null
          ? null
          : Fragment$fragmentPersonCredit$episode.fromJson(
              (l$episode as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String? characterName;

  final Enum$CreditType creditType;

  final int? castOrder;

  final Fragment$fragmentPersonCredit$movie? movie;

  final Fragment$fragmentPersonCredit$show? $show;

  final Fragment$fragmentPersonCredit$episode? episode;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$characterName = characterName;
    _resultData['characterName'] = l$characterName;
    final l$creditType = creditType;
    _resultData['creditType'] = toJson$Enum$CreditType(l$creditType);
    final l$castOrder = castOrder;
    _resultData['castOrder'] = l$castOrder;
    final l$movie = movie;
    _resultData['movie'] = l$movie?.toJson();
    final l$$show = $show;
    _resultData['show'] = l$$show?.toJson();
    final l$episode = episode;
    _resultData['episode'] = l$episode?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$characterName = characterName;
    final l$creditType = creditType;
    final l$castOrder = castOrder;
    final l$movie = movie;
    final l$$show = $show;
    final l$episode = episode;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$characterName,
      l$creditType,
      l$castOrder,
      l$movie,
      l$$show,
      l$episode,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPersonCredit ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (l$id != lOther$id) {
      return false;
    }
    final l$characterName = characterName;
    final lOther$characterName = other.characterName;
    if (l$characterName != lOther$characterName) {
      return false;
    }
    final l$creditType = creditType;
    final lOther$creditType = other.creditType;
    if (l$creditType != lOther$creditType) {
      return false;
    }
    final l$castOrder = castOrder;
    final lOther$castOrder = other.castOrder;
    if (l$castOrder != lOther$castOrder) {
      return false;
    }
    final l$movie = movie;
    final lOther$movie = other.movie;
    if (l$movie != lOther$movie) {
      return false;
    }
    final l$$show = $show;
    final lOther$$show = other.$show;
    if (l$$show != lOther$$show) {
      return false;
    }
    final l$episode = episode;
    final lOther$episode = other.episode;
    if (l$episode != lOther$episode) {
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

extension UtilityExtension$Fragment$fragmentPersonCredit
    on Fragment$fragmentPersonCredit {
  CopyWith$Fragment$fragmentPersonCredit<Fragment$fragmentPersonCredit>
  get copyWith => CopyWith$Fragment$fragmentPersonCredit(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPersonCredit<TRes> {
  factory CopyWith$Fragment$fragmentPersonCredit(
    Fragment$fragmentPersonCredit instance,
    TRes Function(Fragment$fragmentPersonCredit) then,
  ) = _CopyWithImpl$Fragment$fragmentPersonCredit;

  factory CopyWith$Fragment$fragmentPersonCredit.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPersonCredit;

  TRes call({
    String? id,
    String? characterName,
    Enum$CreditType? creditType,
    int? castOrder,
    Fragment$fragmentPersonCredit$movie? movie,
    Fragment$fragmentPersonCredit$show? $show,
    Fragment$fragmentPersonCredit$episode? episode,
    String? $__typename,
  });
  CopyWith$Fragment$fragmentPersonCredit$movie<TRes> get movie;
  CopyWith$Fragment$fragmentPersonCredit$show<TRes> get $show;
  CopyWith$Fragment$fragmentPersonCredit$episode<TRes> get episode;
}

class _CopyWithImpl$Fragment$fragmentPersonCredit<TRes>
    implements CopyWith$Fragment$fragmentPersonCredit<TRes> {
  _CopyWithImpl$Fragment$fragmentPersonCredit(this._instance, this._then);

  final Fragment$fragmentPersonCredit _instance;

  final TRes Function(Fragment$fragmentPersonCredit) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? characterName = _undefined,
    Object? creditType = _undefined,
    Object? castOrder = _undefined,
    Object? movie = _undefined,
    Object? $show = _undefined,
    Object? episode = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPersonCredit(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      characterName: characterName == _undefined
          ? _instance.characterName
          : (characterName as String?),
      creditType: creditType == _undefined || creditType == null
          ? _instance.creditType
          : (creditType as Enum$CreditType),
      castOrder: castOrder == _undefined
          ? _instance.castOrder
          : (castOrder as int?),
      movie: movie == _undefined
          ? _instance.movie
          : (movie as Fragment$fragmentPersonCredit$movie?),
      $show: $show == _undefined
          ? _instance.$show
          : ($show as Fragment$fragmentPersonCredit$show?),
      episode: episode == _undefined
          ? _instance.episode
          : (episode as Fragment$fragmentPersonCredit$episode?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Fragment$fragmentPersonCredit$movie<TRes> get movie {
    final local$movie = _instance.movie;
    return local$movie == null
        ? CopyWith$Fragment$fragmentPersonCredit$movie.stub(_then(_instance))
        : CopyWith$Fragment$fragmentPersonCredit$movie(
            local$movie,
            (e) => call(movie: e),
          );
  }

  CopyWith$Fragment$fragmentPersonCredit$show<TRes> get $show {
    final local$$show = _instance.$show;
    return local$$show == null
        ? CopyWith$Fragment$fragmentPersonCredit$show.stub(_then(_instance))
        : CopyWith$Fragment$fragmentPersonCredit$show(
            local$$show,
            (e) => call($show: e),
          );
  }

  CopyWith$Fragment$fragmentPersonCredit$episode<TRes> get episode {
    final local$episode = _instance.episode;
    return local$episode == null
        ? CopyWith$Fragment$fragmentPersonCredit$episode.stub(_then(_instance))
        : CopyWith$Fragment$fragmentPersonCredit$episode(
            local$episode,
            (e) => call(episode: e),
          );
  }
}

class _CopyWithStubImpl$Fragment$fragmentPersonCredit<TRes>
    implements CopyWith$Fragment$fragmentPersonCredit<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPersonCredit(this._res);

  TRes _res;

  call({
    String? id,
    String? characterName,
    Enum$CreditType? creditType,
    int? castOrder,
    Fragment$fragmentPersonCredit$movie? movie,
    Fragment$fragmentPersonCredit$show? $show,
    Fragment$fragmentPersonCredit$episode? episode,
    String? $__typename,
  }) => _res;

  CopyWith$Fragment$fragmentPersonCredit$movie<TRes> get movie =>
      CopyWith$Fragment$fragmentPersonCredit$movie.stub(_res);

  CopyWith$Fragment$fragmentPersonCredit$show<TRes> get $show =>
      CopyWith$Fragment$fragmentPersonCredit$show.stub(_res);

  CopyWith$Fragment$fragmentPersonCredit$episode<TRes> get episode =>
      CopyWith$Fragment$fragmentPersonCredit$episode.stub(_res);
}

const fragmentDefinitionfragmentPersonCredit = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentPersonCredit'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Credit'), isNonNull: false),
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
        name: NameNode(value: 'characterName'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'creditType'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'castOrder'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
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
              name: NameNode(value: 'releaseYear'),
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
              name: NameNode(value: 'name'),
              alias: null,
              arguments: [],
              directives: [],
              selectionSet: null,
            ),
            FieldNode(
              name: NameNode(value: 'releaseYear'),
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
              name: NameNode(value: 'season'),
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
                    name: NameNode(value: 'name'),
                    alias: null,
                    arguments: [],
                    directives: [],
                    selectionSet: null,
                  ),
                  FieldNode(
                    name: NameNode(value: 'releaseYear'),
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
const documentNodeFragmentfragmentPersonCredit = DocumentNode(
  definitions: [
    fragmentDefinitionfragmentPersonCredit,
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
  ],
);

class Fragment$fragmentPersonCredit$movie {
  Fragment$fragmentPersonCredit$movie({
    required this.id,
    required this.name,
    required this.releaseYear,
    this.images,
    this.$__typename = 'Movie',
  });

  factory Fragment$fragmentPersonCredit$movie.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$releaseYear = json['releaseYear'];
    final l$images = json['images'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPersonCredit$movie(
      id: (l$id as String),
      name: (l$name as String),
      releaseYear: (l$releaseYear as int),
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

  final String name;

  final int releaseYear;

  final List<Fragment$fragmentImages>? images;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$releaseYear = releaseYear;
    _resultData['releaseYear'] = l$releaseYear;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$releaseYear = releaseYear;
    final l$images = images;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$releaseYear,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPersonCredit$movie ||
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
    final l$releaseYear = releaseYear;
    final lOther$releaseYear = other.releaseYear;
    if (l$releaseYear != lOther$releaseYear) {
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

extension UtilityExtension$Fragment$fragmentPersonCredit$movie
    on Fragment$fragmentPersonCredit$movie {
  CopyWith$Fragment$fragmentPersonCredit$movie<
    Fragment$fragmentPersonCredit$movie
  >
  get copyWith => CopyWith$Fragment$fragmentPersonCredit$movie(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPersonCredit$movie<TRes> {
  factory CopyWith$Fragment$fragmentPersonCredit$movie(
    Fragment$fragmentPersonCredit$movie instance,
    TRes Function(Fragment$fragmentPersonCredit$movie) then,
  ) = _CopyWithImpl$Fragment$fragmentPersonCredit$movie;

  factory CopyWith$Fragment$fragmentPersonCredit$movie.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPersonCredit$movie;

  TRes call({
    String? id,
    String? name,
    int? releaseYear,
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

class _CopyWithImpl$Fragment$fragmentPersonCredit$movie<TRes>
    implements CopyWith$Fragment$fragmentPersonCredit$movie<TRes> {
  _CopyWithImpl$Fragment$fragmentPersonCredit$movie(this._instance, this._then);

  final Fragment$fragmentPersonCredit$movie _instance;

  final TRes Function(Fragment$fragmentPersonCredit$movie) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? releaseYear = _undefined,
    Object? images = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPersonCredit$movie(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      releaseYear: releaseYear == _undefined || releaseYear == null
          ? _instance.releaseYear
          : (releaseYear as int),
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

class _CopyWithStubImpl$Fragment$fragmentPersonCredit$movie<TRes>
    implements CopyWith$Fragment$fragmentPersonCredit$movie<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPersonCredit$movie(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    int? releaseYear,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;
}

class Fragment$fragmentPersonCredit$show {
  Fragment$fragmentPersonCredit$show({
    required this.id,
    required this.name,
    required this.releaseYear,
    this.images,
    this.$__typename = 'Show',
  });

  factory Fragment$fragmentPersonCredit$show.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$releaseYear = json['releaseYear'];
    final l$images = json['images'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPersonCredit$show(
      id: (l$id as String),
      name: (l$name as String),
      releaseYear: (l$releaseYear as int),
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

  final String name;

  final int releaseYear;

  final List<Fragment$fragmentImages>? images;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$releaseYear = releaseYear;
    _resultData['releaseYear'] = l$releaseYear;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$releaseYear = releaseYear;
    final l$images = images;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$releaseYear,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPersonCredit$show ||
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
    final l$releaseYear = releaseYear;
    final lOther$releaseYear = other.releaseYear;
    if (l$releaseYear != lOther$releaseYear) {
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

extension UtilityExtension$Fragment$fragmentPersonCredit$show
    on Fragment$fragmentPersonCredit$show {
  CopyWith$Fragment$fragmentPersonCredit$show<
    Fragment$fragmentPersonCredit$show
  >
  get copyWith => CopyWith$Fragment$fragmentPersonCredit$show(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPersonCredit$show<TRes> {
  factory CopyWith$Fragment$fragmentPersonCredit$show(
    Fragment$fragmentPersonCredit$show instance,
    TRes Function(Fragment$fragmentPersonCredit$show) then,
  ) = _CopyWithImpl$Fragment$fragmentPersonCredit$show;

  factory CopyWith$Fragment$fragmentPersonCredit$show.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPersonCredit$show;

  TRes call({
    String? id,
    String? name,
    int? releaseYear,
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

class _CopyWithImpl$Fragment$fragmentPersonCredit$show<TRes>
    implements CopyWith$Fragment$fragmentPersonCredit$show<TRes> {
  _CopyWithImpl$Fragment$fragmentPersonCredit$show(this._instance, this._then);

  final Fragment$fragmentPersonCredit$show _instance;

  final TRes Function(Fragment$fragmentPersonCredit$show) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? releaseYear = _undefined,
    Object? images = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPersonCredit$show(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      releaseYear: releaseYear == _undefined || releaseYear == null
          ? _instance.releaseYear
          : (releaseYear as int),
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

class _CopyWithStubImpl$Fragment$fragmentPersonCredit$show<TRes>
    implements CopyWith$Fragment$fragmentPersonCredit$show<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPersonCredit$show(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    int? releaseYear,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;
}

class Fragment$fragmentPersonCredit$episode {
  Fragment$fragmentPersonCredit$episode({
    required this.id,
    required this.number,
    this.images,
    this.metadata,
    this.season,
    this.$show,
    this.$__typename = 'Episode',
  });

  factory Fragment$fragmentPersonCredit$episode.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$season = json['season'];
    final l$$show = json['show'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPersonCredit$episode(
      id: (l$id as String),
      number: (l$number as int),
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
      season: l$season == null
          ? null
          : Fragment$fragmentPersonCredit$episode$season.fromJson(
              (l$season as Map<String, dynamic>),
            ),
      $show: l$$show == null
          ? null
          : Fragment$fragmentPersonCredit$episode$show.fromJson(
              (l$$show as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final int number;

  final List<Fragment$fragmentImages>? images;

  final List<Fragment$fragmentMetadata>? metadata;

  final Fragment$fragmentPersonCredit$episode$season? season;

  final Fragment$fragmentPersonCredit$episode$show? $show;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$number = number;
    _resultData['number'] = l$number;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$season = season;
    _resultData['season'] = l$season?.toJson();
    final l$$show = $show;
    _resultData['show'] = l$$show?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$number = number;
    final l$images = images;
    final l$metadata = metadata;
    final l$season = season;
    final l$$show = $show;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$number,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$season,
      l$$show,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPersonCredit$episode ||
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
    final l$season = season;
    final lOther$season = other.season;
    if (l$season != lOther$season) {
      return false;
    }
    final l$$show = $show;
    final lOther$$show = other.$show;
    if (l$$show != lOther$$show) {
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

extension UtilityExtension$Fragment$fragmentPersonCredit$episode
    on Fragment$fragmentPersonCredit$episode {
  CopyWith$Fragment$fragmentPersonCredit$episode<
    Fragment$fragmentPersonCredit$episode
  >
  get copyWith =>
      CopyWith$Fragment$fragmentPersonCredit$episode(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPersonCredit$episode<TRes> {
  factory CopyWith$Fragment$fragmentPersonCredit$episode(
    Fragment$fragmentPersonCredit$episode instance,
    TRes Function(Fragment$fragmentPersonCredit$episode) then,
  ) = _CopyWithImpl$Fragment$fragmentPersonCredit$episode;

  factory CopyWith$Fragment$fragmentPersonCredit$episode.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPersonCredit$episode;

  TRes call({
    String? id,
    int? number,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    Fragment$fragmentPersonCredit$episode$season? season,
    Fragment$fragmentPersonCredit$episode$show? $show,
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
  CopyWith$Fragment$fragmentPersonCredit$episode$season<TRes> get season;
  CopyWith$Fragment$fragmentPersonCredit$episode$show<TRes> get $show;
}

class _CopyWithImpl$Fragment$fragmentPersonCredit$episode<TRes>
    implements CopyWith$Fragment$fragmentPersonCredit$episode<TRes> {
  _CopyWithImpl$Fragment$fragmentPersonCredit$episode(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPersonCredit$episode _instance;

  final TRes Function(Fragment$fragmentPersonCredit$episode) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? number = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? season = _undefined,
    Object? $show = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPersonCredit$episode(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      number: number == _undefined || number == null
          ? _instance.number
          : (number as int),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      season: season == _undefined
          ? _instance.season
          : (season as Fragment$fragmentPersonCredit$episode$season?),
      $show: $show == _undefined
          ? _instance.$show
          : ($show as Fragment$fragmentPersonCredit$episode$show?),
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

  CopyWith$Fragment$fragmentPersonCredit$episode$season<TRes> get season {
    final local$season = _instance.season;
    return local$season == null
        ? CopyWith$Fragment$fragmentPersonCredit$episode$season.stub(
            _then(_instance),
          )
        : CopyWith$Fragment$fragmentPersonCredit$episode$season(
            local$season,
            (e) => call(season: e),
          );
  }

  CopyWith$Fragment$fragmentPersonCredit$episode$show<TRes> get $show {
    final local$$show = _instance.$show;
    return local$$show == null
        ? CopyWith$Fragment$fragmentPersonCredit$episode$show.stub(
            _then(_instance),
          )
        : CopyWith$Fragment$fragmentPersonCredit$episode$show(
            local$$show,
            (e) => call($show: e),
          );
  }
}

class _CopyWithStubImpl$Fragment$fragmentPersonCredit$episode<TRes>
    implements CopyWith$Fragment$fragmentPersonCredit$episode<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPersonCredit$episode(this._res);

  TRes _res;

  call({
    String? id,
    int? number,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    Fragment$fragmentPersonCredit$episode$season? season,
    Fragment$fragmentPersonCredit$episode$show? $show,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;

  metadata(_fn) => _res;

  CopyWith$Fragment$fragmentPersonCredit$episode$season<TRes> get season =>
      CopyWith$Fragment$fragmentPersonCredit$episode$season.stub(_res);

  CopyWith$Fragment$fragmentPersonCredit$episode$show<TRes> get $show =>
      CopyWith$Fragment$fragmentPersonCredit$episode$show.stub(_res);
}

class Fragment$fragmentPersonCredit$episode$season {
  Fragment$fragmentPersonCredit$episode$season({
    required this.id,
    required this.number,
    this.$__typename = 'Season',
  });

  factory Fragment$fragmentPersonCredit$episode$season.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$number = json['number'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPersonCredit$episode$season(
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
    if (other is! Fragment$fragmentPersonCredit$episode$season ||
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

extension UtilityExtension$Fragment$fragmentPersonCredit$episode$season
    on Fragment$fragmentPersonCredit$episode$season {
  CopyWith$Fragment$fragmentPersonCredit$episode$season<
    Fragment$fragmentPersonCredit$episode$season
  >
  get copyWith =>
      CopyWith$Fragment$fragmentPersonCredit$episode$season(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPersonCredit$episode$season<TRes> {
  factory CopyWith$Fragment$fragmentPersonCredit$episode$season(
    Fragment$fragmentPersonCredit$episode$season instance,
    TRes Function(Fragment$fragmentPersonCredit$episode$season) then,
  ) = _CopyWithImpl$Fragment$fragmentPersonCredit$episode$season;

  factory CopyWith$Fragment$fragmentPersonCredit$episode$season.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPersonCredit$episode$season;

  TRes call({String? id, int? number, String? $__typename});
}

class _CopyWithImpl$Fragment$fragmentPersonCredit$episode$season<TRes>
    implements CopyWith$Fragment$fragmentPersonCredit$episode$season<TRes> {
  _CopyWithImpl$Fragment$fragmentPersonCredit$episode$season(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPersonCredit$episode$season _instance;

  final TRes Function(Fragment$fragmentPersonCredit$episode$season) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? number = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPersonCredit$episode$season(
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

class _CopyWithStubImpl$Fragment$fragmentPersonCredit$episode$season<TRes>
    implements CopyWith$Fragment$fragmentPersonCredit$episode$season<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPersonCredit$episode$season(this._res);

  TRes _res;

  call({String? id, int? number, String? $__typename}) => _res;
}

class Fragment$fragmentPersonCredit$episode$show {
  Fragment$fragmentPersonCredit$episode$show({
    required this.id,
    required this.name,
    required this.releaseYear,
    this.images,
    this.$__typename = 'Show',
  });

  factory Fragment$fragmentPersonCredit$episode$show.fromJson(
    Map<String, dynamic> json,
  ) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$releaseYear = json['releaseYear'];
    final l$images = json['images'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentPersonCredit$episode$show(
      id: (l$id as String),
      name: (l$name as String),
      releaseYear: (l$releaseYear as int),
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

  final String name;

  final int releaseYear;

  final List<Fragment$fragmentImages>? images;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$releaseYear = releaseYear;
    _resultData['releaseYear'] = l$releaseYear;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$releaseYear = releaseYear;
    final l$images = images;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$releaseYear,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentPersonCredit$episode$show ||
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
    final l$releaseYear = releaseYear;
    final lOther$releaseYear = other.releaseYear;
    if (l$releaseYear != lOther$releaseYear) {
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

extension UtilityExtension$Fragment$fragmentPersonCredit$episode$show
    on Fragment$fragmentPersonCredit$episode$show {
  CopyWith$Fragment$fragmentPersonCredit$episode$show<
    Fragment$fragmentPersonCredit$episode$show
  >
  get copyWith =>
      CopyWith$Fragment$fragmentPersonCredit$episode$show(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentPersonCredit$episode$show<TRes> {
  factory CopyWith$Fragment$fragmentPersonCredit$episode$show(
    Fragment$fragmentPersonCredit$episode$show instance,
    TRes Function(Fragment$fragmentPersonCredit$episode$show) then,
  ) = _CopyWithImpl$Fragment$fragmentPersonCredit$episode$show;

  factory CopyWith$Fragment$fragmentPersonCredit$episode$show.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentPersonCredit$episode$show;

  TRes call({
    String? id,
    String? name,
    int? releaseYear,
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

class _CopyWithImpl$Fragment$fragmentPersonCredit$episode$show<TRes>
    implements CopyWith$Fragment$fragmentPersonCredit$episode$show<TRes> {
  _CopyWithImpl$Fragment$fragmentPersonCredit$episode$show(
    this._instance,
    this._then,
  );

  final Fragment$fragmentPersonCredit$episode$show _instance;

  final TRes Function(Fragment$fragmentPersonCredit$episode$show) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? releaseYear = _undefined,
    Object? images = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentPersonCredit$episode$show(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      releaseYear: releaseYear == _undefined || releaseYear == null
          ? _instance.releaseYear
          : (releaseYear as int),
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

class _CopyWithStubImpl$Fragment$fragmentPersonCredit$episode$show<TRes>
    implements CopyWith$Fragment$fragmentPersonCredit$episode$show<TRes> {
  _CopyWithStubImpl$Fragment$fragmentPersonCredit$episode$show(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    int? releaseYear,
    List<Fragment$fragmentImages>? images,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;
}
