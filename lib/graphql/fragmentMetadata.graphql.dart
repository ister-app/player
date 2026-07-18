import 'package:gql/ast.dart';
import 'schema.graphql.dart';

class Fragment$fragmentMetadata {
  Fragment$fragmentMetadata({
    this.description,
    required this.id,
    this.language,
    this.sourceUri,
    this.source,
    this.title,
    this.released,
    this.genre,
    this.$__typename = 'Metadata',
  });

  factory Fragment$fragmentMetadata.fromJson(Map<String, dynamic> json) {
    final l$description = json['description'];
    final l$id = json['id'];
    final l$language = json['language'];
    final l$sourceUri = json['sourceUri'];
    final l$source = json['source'];
    final l$title = json['title'];
    final l$released = json['released'];
    final l$genre = json['genre'];
    final l$$__typename = json['__typename'];
    return Fragment$fragmentMetadata(
      description: (l$description as String?),
      id: (l$id as String),
      language: (l$language as String?),
      sourceUri: (l$sourceUri as String?),
      source: l$source == null
          ? null
          : fromJson$Enum$MetadataSource((l$source as String)),
      title: (l$title as String?),
      released: (l$released as String?),
      genre: (l$genre as String?),
      $__typename: (l$$__typename as String),
    );
  }

  final String? description;

  final String id;

  final String? language;

  final String? sourceUri;

  final Enum$MetadataSource? source;

  final String? title;

  final String? released;

  final String? genre;

  final String $__typename;

  Map<String, dynamic> toJson() {
    final _resultData = <String, dynamic>{};
    final l$description = description;
    _resultData['description'] = l$description;
    final l$id = id;
    _resultData['id'] = l$id;
    final l$language = language;
    _resultData['language'] = l$language;
    final l$sourceUri = sourceUri;
    _resultData['sourceUri'] = l$sourceUri;
    final l$source = source;
    _resultData['source'] = l$source == null
        ? null
        : toJson$Enum$MetadataSource(l$source);
    final l$title = title;
    _resultData['title'] = l$title;
    final l$released = released;
    _resultData['released'] = l$released;
    final l$genre = genre;
    _resultData['genre'] = l$genre;
    final l$$__typename = $__typename;
    _resultData['__typename'] = l$$__typename;
    return _resultData;
  }

  @override
  int get hashCode {
    final l$description = description;
    final l$id = id;
    final l$language = language;
    final l$sourceUri = sourceUri;
    final l$source = source;
    final l$title = title;
    final l$released = released;
    final l$genre = genre;
    final l$$__typename = $__typename;
    return Object.hashAll([
      l$description,
      l$id,
      l$language,
      l$sourceUri,
      l$source,
      l$title,
      l$released,
      l$genre,
      l$$__typename,
    ]);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! Fragment$fragmentMetadata ||
        runtimeType != other.runtimeType) {
      return false;
    }
    final l$description = description;
    final lOther$description = other.description;
    if (l$description != lOther$description) {
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
    final l$sourceUri = sourceUri;
    final lOther$sourceUri = other.sourceUri;
    if (l$sourceUri != lOther$sourceUri) {
      return false;
    }
    final l$source = source;
    final lOther$source = other.source;
    if (l$source != lOther$source) {
      return false;
    }
    final l$title = title;
    final lOther$title = other.title;
    if (l$title != lOther$title) {
      return false;
    }
    final l$released = released;
    final lOther$released = other.released;
    if (l$released != lOther$released) {
      return false;
    }
    final l$genre = genre;
    final lOther$genre = other.genre;
    if (l$genre != lOther$genre) {
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

extension UtilityExtension$Fragment$fragmentMetadata
    on Fragment$fragmentMetadata {
  CopyWith$Fragment$fragmentMetadata<Fragment$fragmentMetadata> get copyWith =>
      CopyWith$Fragment$fragmentMetadata(this, (i) => i);
}

abstract class CopyWith$Fragment$fragmentMetadata<TRes> {
  factory CopyWith$Fragment$fragmentMetadata(
    Fragment$fragmentMetadata instance,
    TRes Function(Fragment$fragmentMetadata) then,
  ) = _CopyWithImpl$Fragment$fragmentMetadata;

  factory CopyWith$Fragment$fragmentMetadata.stub(TRes res) =
      _CopyWithStubImpl$Fragment$fragmentMetadata;

  TRes call({
    String? description,
    String? id,
    String? language,
    String? sourceUri,
    Enum$MetadataSource? source,
    String? title,
    String? released,
    String? genre,
    String? $__typename,
  });
}

class _CopyWithImpl$Fragment$fragmentMetadata<TRes>
    implements CopyWith$Fragment$fragmentMetadata<TRes> {
  _CopyWithImpl$Fragment$fragmentMetadata(this._instance, this._then);

  final Fragment$fragmentMetadata _instance;

  final TRes Function(Fragment$fragmentMetadata) _then;

  static const _undefined = <dynamic, dynamic>{};

  TRes call({
    Object? description = _undefined,
    Object? id = _undefined,
    Object? language = _undefined,
    Object? sourceUri = _undefined,
    Object? source = _undefined,
    Object? title = _undefined,
    Object? released = _undefined,
    Object? genre = _undefined,
    Object? $__typename = _undefined,
  }) => _then(
    Fragment$fragmentMetadata(
      description: description == _undefined
          ? _instance.description
          : (description as String?),
      id: id == _undefined || id == null ? _instance.id : (id as String),
      language: language == _undefined
          ? _instance.language
          : (language as String?),
      sourceUri: sourceUri == _undefined
          ? _instance.sourceUri
          : (sourceUri as String?),
      source: source == _undefined
          ? _instance.source
          : (source as Enum$MetadataSource?),
      title: title == _undefined ? _instance.title : (title as String?),
      released: released == _undefined
          ? _instance.released
          : (released as String?),
      genre: genre == _undefined ? _instance.genre : (genre as String?),
      $__typename: $__typename == _undefined || $__typename == null
          ? _instance.$__typename
          : ($__typename as String),
    ),
  );
}

class _CopyWithStubImpl$Fragment$fragmentMetadata<TRes>
    implements CopyWith$Fragment$fragmentMetadata<TRes> {
  _CopyWithStubImpl$Fragment$fragmentMetadata(this._res);

  TRes _res;

  call({
    String? description,
    String? id,
    String? language,
    String? sourceUri,
    Enum$MetadataSource? source,
    String? title,
    String? released,
    String? genre,
    String? $__typename,
  }) => _res;
}

const fragmentDefinitionfragmentMetadata = FragmentDefinitionNode(
  name: NameNode(value: 'fragmentMetadata'),
  typeCondition: TypeConditionNode(
    on: NamedTypeNode(name: NameNode(value: 'Metadata'), isNonNull: false),
  ),
  directives: [],
  selectionSet: SelectionSetNode(
    selections: [
      FieldNode(
        name: NameNode(value: 'description'),
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
        name: NameNode(value: 'sourceUri'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'source'),
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
        name: NameNode(value: 'released'),
        alias: null,
        arguments: [],
        directives: [],
        selectionSet: null,
      ),
      FieldNode(
        name: NameNode(value: 'genre'),
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
const documentNodeFragmentfragmentMetadata = DocumentNode(
  definitions: [fragmentDefinitionfragmentMetadata],
);
