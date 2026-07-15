import 'fragmentCredit.graphql.dart';
import 'fragmentImages.graphql.dart';
import 'fragmentMetadata.graphql.dart';
import 'package:gql/ast.dart';

class Variables$Query$artistById {
  factory Variables$Query$artistById({String? id}) =>
      Variables$Query$artistById._({if (id != null) r'id': id});

  Variables$Query$artistById._(this._$data);

  factory Variables$Query$artistById.fromJson(Map<String, dynamic> data) {
    final result$data = <String, dynamic>{};
    if (data.containsKey('id')) {
      final l$id = data['id'];
      result$data['id'] = (l$id as String?);
    }
    return Variables$Query$artistById._(result$data);
  }

  Map<String, dynamic> _$data;

  String? get id => (_$data['id'] as String?);

  Map<String, dynamic> toJson() {
    final result$data = <String, dynamic>{};
    if (_$data.containsKey('id')) {
      final l$id = id;
      result$data['id'] = l$id;
    }
    return result$data;
  }

  CopyWith$Variables$Query$artistById<Variables$Query$artistById>
  get copyWith => CopyWith$Variables$Query$artistById(this, (i) => i);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Variables$Query$artistById ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$id = id;
    final lOther$id = other.id;
    if (_$data.containsKey('id') != other._$data.containsKey('id')) {
      return false;
    }
    if (l$id != lOther$id) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    final l$id = id;
    return Object.hashAll([_$data.containsKey('id') ? l$id : const {}]);
  }
}

abstract class CopyWith$Variables$Query$artistById<TRes> {
  factory CopyWith$Variables$Query$artistById(
    Variables$Query$artistById instance,
    TRes Function(Variables$Query$artistById) then,
  ) = _CopyWithImpl$Variables$Query$artistById;

  factory CopyWith$Variables$Query$artistById.stub(TRes res) =
      _CopyWithStubImpl$Variables$Query$artistById;

  TRes call({String? id});
}

class _CopyWithImpl$Variables$Query$artistById<TRes>
    implements CopyWith$Variables$Query$artistById<TRes> {
  _CopyWithImpl$Variables$Query$artistById(this._instance, this._then);

  final Variables$Query$artistById _instance;

  final TRes Function(Variables$Query$artistById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({Object? id = _undefined}) => _then(
    Variables$Query$artistById._({
      ..._instance._$data,
      if (id != _undefined) 'id': (id as String?),
    }),
  );
}

class _CopyWithStubImpl$Variables$Query$artistById<TRes>
    implements CopyWith$Variables$Query$artistById<TRes> {
  _CopyWithStubImpl$Variables$Query$artistById(this._res);

  TRes _res;

  call({String? id}) => _res;
}

class Query$artistById {
  Query$artistById({this.artistById, this.$__typename = 'Query'});

  factory Query$artistById.fromJson(Map<String, dynamic> json) {
    final l$artistById = json['artistById'];
    final l$$__typename = json['__typename'];
    return Query$artistById(
      artistById: l$artistById == null
          ? null
          : Query$artistById$artistById.fromJson(
              (l$artistById as Map<String, dynamic>),
            ),
      $__typename: (l$$__typename as String),
    );
  }

  final Query$artistById$artistById? artistById;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$artistById = artistById;
    _resultData['artistById'] = l$artistById?.toJson();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$artistById = artistById;
    final l$$__typename = $__typename;
    return Object.hashAll([l$artistById, l$$__typename]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$artistById || runtimeType != other.runtimeType) {
      return false;
    }
    final l$artistById = artistById;
    final lOther$artistById = other.artistById;
    if (l$artistById != lOther$artistById) {
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

extension UtilityExtension$Query$artistById on Query$artistById {
  CopyWith$Query$artistById<Query$artistById> get copyWith =>
      CopyWith$Query$artistById(this, (i) => i);
}

abstract class CopyWith$Query$artistById<TRes> {
  factory CopyWith$Query$artistById(
    Query$artistById instance,
    TRes Function(Query$artistById) then,
  ) = _CopyWithImpl$Query$artistById;

  factory CopyWith$Query$artistById.stub(TRes res) =
      _CopyWithStubImpl$Query$artistById;

  TRes call({Query$artistById$artistById? artistById, String? $__typename});
  CopyWith$Query$artistById$artistById<TRes> get artistById;
}

class _CopyWithImpl$Query$artistById<TRes>
    implements CopyWith$Query$artistById<TRes> {
  _CopyWithImpl$Query$artistById(this._instance, this._then);

  final Query$artistById _instance;

  final TRes Function(Query$artistById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? artistById = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$artistById(
      artistById: artistById == _undefined
          ? _instance.artistById
          : (artistById as Query$artistById$artistById?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );

  CopyWith$Query$artistById$artistById<TRes> get artistById {
    final local$artistById = _instance.artistById;
    return local$artistById == null
        ? CopyWith$Query$artistById$artistById.stub(_then(_instance))
        : CopyWith$Query$artistById$artistById(
            local$artistById,
            (e) => call(artistById: e),
          );
  }
}

class _CopyWithStubImpl$Query$artistById<TRes>
    implements CopyWith$Query$artistById<TRes> {
  _CopyWithStubImpl$Query$artistById(this._res);

  TRes _res;

  call({Query$artistById$artistById? artistById, String? $__typename}) => _res;

  CopyWith$Query$artistById$artistById<TRes> get artistById =>
      CopyWith$Query$artistById$artistById.stub(_res);
}

const documentNodeQueryartistById = DocumentNode(
  definitions: [
    OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'artistById'),
      variableDefinitions: [
        VariableDefinitionNode(
          variable: VariableNode(name: NameNode(value: 'id')),
          type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: false),
          defaultValue: DefaultValueNode(value: null),
          directives: [],
        ),
      ],
      directives: [],
      selectionSet: SelectionSetNode(
        selections: [
          FieldNode(
            name: NameNode(value: 'personById'),
            alias: NameNode(value: 'artistById'),
            arguments: [
              ArgumentNode(
                name: NameNode(value: 'id'),
                value: VariableNode(name: NameNode(value: 'id')),
              ),
            ],
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
                  name: NameNode(value: 'birthYear'),
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
                  name: NameNode(value: 'credits'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(
                    selections: [
                      FragmentSpreadNode(
                        name: NameNode(value: 'fragmentPersonCredit'),
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
    fragmentDefinitionfragmentImages,
    fragmentDefinitionfragmentMetadata,
    fragmentDefinitionfragmentPersonCredit,
  ],
);

class Query$artistById$artistById {
  Query$artistById$artistById({
    required this.id,
    required this.name,
    this.birthYear,
    this.images,
    this.metadata,
    this.credits,
    this.$__typename = 'Person',
  });

  factory Query$artistById$artistById.fromJson(Map<String, dynamic> json) {
    final l$id = json['id'];
    final l$name = json['name'];
    final l$birthYear = json['birthYear'];
    final l$images = json['images'];
    final l$metadata = json['metadata'];
    final l$credits = json['credits'];
    final l$$__typename = json['__typename'];
    return Query$artistById$artistById(
      id: (l$id as String),
      name: (l$name as String),
      birthYear: (l$birthYear as int?),
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
      credits: (l$credits as List<dynamic>?)
          ?.map(
            (e) => Fragment$fragmentPersonCredit.fromJson(
              (e as Map<String, dynamic>),
            ),
          )
          .toList(),
      $__typename: (l$$__typename as String),
    );
  }

  final String id;

  final String name;

  final int? birthYear;

  final List<Fragment$fragmentImages>? images;

  final List<Fragment$fragmentMetadata>? metadata;

  final List<Fragment$fragmentPersonCredit>? credits;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$id = id;
    _resultData['id'] = l$id;
    final l$name = name;
    _resultData['name'] = l$name;
    final l$birthYear = birthYear;
    _resultData['birthYear'] = l$birthYear;
    final l$images = images;
    _resultData['images'] = l$images?.map((e) => e.toJson()).toList();
    final l$metadata = metadata;
    _resultData['metadata'] = l$metadata?.map((e) => e.toJson()).toList();
    final l$credits = credits;
    _resultData['credits'] = l$credits?.map((e) => e.toJson()).toList();
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$id = id;
    final l$name = name;
    final l$birthYear = birthYear;
    final l$images = images;
    final l$metadata = metadata;
    final l$credits = credits;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$id,
      l$name,
      l$birthYear,
      l$images == null ? null : Object.hashAll(l$images.map((v) => v)),
      l$metadata == null ? null : Object.hashAll(l$metadata.map((v) => v)),
      l$credits == null ? null : Object.hashAll(l$credits.map((v) => v)),
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Query$artistById$artistById ||
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
    final l$birthYear = birthYear;
    final lOther$birthYear = other.birthYear;
    if (l$birthYear != lOther$birthYear) {
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
    final l$credits = credits;
    final lOther$credits = other.credits;
    if (l$credits != null && lOther$credits != null) {
      if (l$credits.length != lOther$credits.length) {
        return false;
      }
      for (int i = 0; i < l$credits.length; i++) {
        final l$credits$entry = l$credits[i];
        final lOther$credits$entry = lOther$credits[i];
        if (l$credits$entry != lOther$credits$entry) {
          return false;
        }
      }
    } else if (l$credits != lOther$credits) {
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

extension UtilityExtension$Query$artistById$artistById
    on Query$artistById$artistById {
  CopyWith$Query$artistById$artistById<Query$artistById$artistById>
  get copyWith => CopyWith$Query$artistById$artistById(this, (i) => i);
}

abstract class CopyWith$Query$artistById$artistById<TRes> {
  factory CopyWith$Query$artistById$artistById(
    Query$artistById$artistById instance,
    TRes Function(Query$artistById$artistById) then,
  ) = _CopyWithImpl$Query$artistById$artistById;

  factory CopyWith$Query$artistById$artistById.stub(TRes res) =
      _CopyWithStubImpl$Query$artistById$artistById;

  TRes call({
    String? id,
    String? name,
    int? birthYear,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentPersonCredit>? credits,
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
  TRes credits(
    Iterable<Fragment$fragmentPersonCredit>? Function(
      Iterable<
        CopyWith$Fragment$fragmentPersonCredit<Fragment$fragmentPersonCredit>
      >?,
    )
    _fn,
  );
}

class _CopyWithImpl$Query$artistById$artistById<TRes>
    implements CopyWith$Query$artistById$artistById<TRes> {
  _CopyWithImpl$Query$artistById$artistById(this._instance, this._then);

  final Query$artistById$artistById _instance;

  final TRes Function(Query$artistById$artistById) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? id = _undefined,
    Object? name = _undefined,
    Object? birthYear = _undefined,
    Object? images = _undefined,
    Object? metadata = _undefined,
    Object? credits = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Query$artistById$artistById(
      id: id == _undefined || id == null ? _instance.id : (id as String),
      name: name == _undefined || name == null
          ? _instance.name
          : (name as String),
      birthYear: birthYear == _undefined
          ? _instance.birthYear
          : (birthYear as int?),
      images: images == _undefined
          ? _instance.images
          : (images as List<Fragment$fragmentImages>?),
      metadata: metadata == _undefined
          ? _instance.metadata
          : (metadata as List<Fragment$fragmentMetadata>?),
      credits: credits == _undefined
          ? _instance.credits
          : (credits as List<Fragment$fragmentPersonCredit>?),
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

  TRes credits(
    Iterable<Fragment$fragmentPersonCredit>? Function(
      Iterable<
        CopyWith$Fragment$fragmentPersonCredit<Fragment$fragmentPersonCredit>
      >?,
    )
    _fn,
  ) => call(
    credits: _fn(
      _instance.credits?.map(
        (e) => CopyWith$Fragment$fragmentPersonCredit(e, (i) => i),
      ),
    )?.toList(),
  );
}

class _CopyWithStubImpl$Query$artistById$artistById<TRes>
    implements CopyWith$Query$artistById$artistById<TRes> {
  _CopyWithStubImpl$Query$artistById$artistById(this._res);

  TRes _res;

  call({
    String? id,
    String? name,
    int? birthYear,
    List<Fragment$fragmentImages>? images,
    List<Fragment$fragmentMetadata>? metadata,
    List<Fragment$fragmentPersonCredit>? credits,
    String? $__typename,
  }) => _res;

  images(_fn) => _res;

  metadata(_fn) => _res;

  credits(_fn) => _res;
}
