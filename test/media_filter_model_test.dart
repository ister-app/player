import 'package:flutter_test/flutter_test.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/utils/BrowseKind.dart';
import 'package:player/utils/filter/FilterCatalog.dart';
import 'package:player/utils/filter/MediaFilterModel.dart';

void main() {
  group('MediaFilterModel', () {
    test('JSON round-trips the full tree including subgroups and limit', () {
      final model = MediaFilterModel(
        match: Enum$FilterMatch.ALL,
        conditions: [
          FilterConditionModel(
              field: Enum$FilterField.RELEASE_YEAR,
              operator: Enum$FilterOperator.LESS_THAN,
              value: '2010'),
        ],
        groups: [
          MediaFilterModel(match: Enum$FilterMatch.ANY, conditions: [
            FilterConditionModel(
                field: Enum$FilterField.GENRE,
                operator: Enum$FilterOperator.CONTAINS,
                value: 'rock'),
            FilterConditionModel(
                field: Enum$FilterField.PLAY_COUNT,
                operator: Enum$FilterOperator.IS_NOT_SET,
                value: null),
          ]),
        ],
        limit: 25,
      );

      final decoded = MediaFilterModel.decode(model.encode())!;

      expect(decoded.match, Enum$FilterMatch.ALL);
      expect(decoded.conditions.single.field, Enum$FilterField.RELEASE_YEAR);
      expect(decoded.conditions.single.value, '2010');
      expect(decoded.groups.single.match, Enum$FilterMatch.ANY);
      expect(decoded.groups.single.conditions, hasLength(2));
      expect(decoded.groups.single.conditions.last.value, isNull);
      expect(decoded.limit, 25);
      expect(decoded.conditionCount, 3);
    });

    test('toInput mirrors the tree into the GraphQL input type', () {
      final model = MediaFilterModel(conditions: [
        FilterConditionModel(
            field: Enum$FilterField.TITLE,
            operator: Enum$FilterOperator.CONTAINS,
            value: 'glass'),
      ], limit: 10);

      final input = model.toInput().toJson();

      expect(input['match'], 'ALL');
      expect(input['limit'], 10);
      final conditions = input['conditions'] as List<dynamic>;
      expect(conditions.single['field'], 'TITLE');
      expect(conditions.single['operator'], 'CONTAINS');
      expect(conditions.single['value'], 'glass');
    });

    test('decode is lenient: garbage and unknown enum names drop out', () {
      expect(MediaFilterModel.decode(null), isNull);
      expect(MediaFilterModel.decode('not json'), isNull);
      expect(MediaFilterModel.decode('{"match":"ALL"}'), isNull,
          reason: 'an empty filter decodes to null');
      final decoded = MediaFilterModel.decode(
          '{"match":"ALL","conditions":[{"field":"NO_SUCH","operator":"EQUALS","value":"x"},'
          '{"field":"TITLE","operator":"CONTAINS","value":"ok"}]}');
      expect(decoded!.conditions, hasLength(1),
          reason: 'the unknown field is dropped, the valid one survives');
    });
  });

  group('FilterCatalog', () {
    test('maps library type + browse kind to the filter kind', () {
      expect(FilterCatalog.kindFor(Enum$LibraryType.MUSIC, BrowseKind.albums),
          Enum$FilterKind.ALBUM);
      expect(FilterCatalog.kindFor(Enum$LibraryType.MUSIC, BrowseKind.tracks),
          Enum$FilterKind.TRACK);
      expect(FilterCatalog.kindFor(Enum$LibraryType.MUSIC, BrowseKind.artists),
          Enum$FilterKind.ARTIST);
      expect(FilterCatalog.kindFor(Enum$LibraryType.SHOW, BrowseKind.shows),
          Enum$FilterKind.SHOW);
      expect(FilterCatalog.kindFor(Enum$LibraryType.SHOW, BrowseKind.episodes),
          Enum$FilterKind.EPISODE);
      expect(FilterCatalog.kindFor(Enum$LibraryType.MOVIE, null),
          Enum$FilterKind.MOVIE);
      expect(FilterCatalog.kindFor(Enum$LibraryType.BOOK, null), isNull);
      expect(FilterCatalog.kindFor(Enum$LibraryType.PODCAST, null), isNull);
    });

    test('only track/movie/episode filters are playable', () {
      expect(FilterCatalog.isPlayable(Enum$FilterKind.TRACK), isTrue);
      expect(FilterCatalog.isPlayable(Enum$FilterKind.MOVIE), isTrue);
      expect(FilterCatalog.isPlayable(Enum$FilterKind.EPISODE), isTrue);
      expect(FilterCatalog.isPlayable(Enum$FilterKind.ALBUM), isFalse);
      expect(FilterCatalog.isPlayable(Enum$FilterKind.ARTIST), isFalse);
      expect(FilterCatalog.isPlayable(Enum$FilterKind.SHOW), isFalse);
    });

    test('operators follow the field value kind, like the server', () {
      expect(FilterCatalog.operatorsFor(Enum$FilterField.TITLE),
          contains(Enum$FilterOperator.CONTAINS));
      expect(FilterCatalog.operatorsFor(Enum$FilterField.TITLE),
          isNot(contains(Enum$FilterOperator.LESS_THAN)));
      expect(FilterCatalog.operatorsFor(Enum$FilterField.RATING),
          contains(Enum$FilterOperator.GREATER_THAN));
      expect(FilterCatalog.operatorsFor(Enum$FilterField.LAST_PLAYED_AT),
          contains(Enum$FilterOperator.IN_LAST_DAYS));
      expect(FilterCatalog.operatorsFor(Enum$FilterField.WATCHED),
          [Enum$FilterOperator.EQUALS]);
    });

    test('duration values are entered in minutes and travel as milliseconds',
        () {
      expect(
          FilterCatalog.encodeValue(Enum$FilterField.DURATION,
              Enum$FilterOperator.GREATER_THAN, '5'),
          '300000');
      expect(
          FilterCatalog.decodeValue(Enum$FilterField.DURATION,
              Enum$FilterOperator.GREATER_THAN, '300000'),
          '5');
      expect(
          FilterCatalog.encodeValue(
              Enum$FilterField.RELEASE_YEAR, Enum$FilterOperator.EQUALS, ' 2010 '),
          '2010');
    });
  });
}
