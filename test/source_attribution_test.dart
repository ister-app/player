import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/SourceAttribution.dart';
import 'package:player/graphql/fragmentImages.graphql.dart';
import 'package:player/graphql/fragmentMetadata.graphql.dart';
import 'package:player/l10n/app_localizations.dart';

Fragment$fragmentMetadata _metadata(String? source) =>
    Fragment$fragmentMetadata.fromJson({
      '__typename': 'Metadata',
      'id': 'meta-1',
      'language': 'eng',
      'description': 'A description',
      'source': source,
    });

Fragment$fragmentImages _image(String? source) =>
    Fragment$fragmentImages.fromJson({
      '__typename': 'Image',
      'type': 'COVER',
      'id': 'image-1',
      'source': source,
      'directory': {
        '__typename': 'Directory',
        'node': {'__typename': 'Node', 'url': 'http://localhost'},
      },
    });

Widget _app(Widget child) => MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

void main() {
  testWidgets('names the metadata and image sources once each',
      (tester) async {
    await tester.pumpWidget(_app(SourceAttribution(
      metadata: [_metadata('MUSICBRAINZ')],
      images: [_image('COVER_ART_ARCHIVE'), _image('COVER_ART_ARCHIVE')],
    )));

    expect(find.text('Source: MusicBrainz · Cover Art Archive'), findsOneWidget);
  });

  testWidgets('renders nothing for local or unknown sources', (tester) async {
    await tester.pumpWidget(_app(SourceAttribution(
      metadata: [_metadata('LOCAL_FILE'), _metadata(null)],
      images: [_image('PODCAST_FEED'), _image(null)],
    )));

    expect(find.byType(Text), findsNothing);
  });
}
