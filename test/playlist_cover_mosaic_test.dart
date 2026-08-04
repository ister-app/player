import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/PlaylistCoverMosaic.dart';
import 'package:player/graphql/fragmentImages.graphql.dart';

Fragment$fragmentImages _image(String id) => Fragment$fragmentImages(
      id: id,
      type: 'COVER',
      directory: Fragment$fragmentImages$directory(
        node: Fragment$fragmentImages$directory$node(url: 'http://node.example'),
      ),
    );

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(body: Center(child: SizedBox(width: 200, child: child))),
    );

void main() {
  group('PlaylistCoverMosaic.layout', () {
    test('repeats what few covers there are over the four cells', () {
      expect(PlaylistCoverMosaic.layout(<String>[]), isEmpty);
      expect(PlaylistCoverMosaic.layout(['a']), ['a', 'a', 'a', 'a']);
      // Two covers go diagonally, so both touch both rows and columns.
      expect(PlaylistCoverMosaic.layout(['a', 'b']), ['a', 'b', 'b', 'a']);
      expect(PlaylistCoverMosaic.layout(['a', 'b', 'c']), ['a', 'b', 'c', 'a']);
      expect(PlaylistCoverMosaic.layout(['a', 'b', 'c', 'd']),
          ['a', 'b', 'c', 'd']);
      expect(PlaylistCoverMosaic.layout(['a', 'b', 'c', 'd', 'e']),
          ['a', 'b', 'c', 'd'],
          reason: "the server's extras are ignored");
    });
  });

  group('PlaylistCoverMosaic', () {
    testWidgets('draws four cells from two covers', (tester) async {
      await tester.pumpWidget(_wrap(PlaylistCoverMosaic(
        serverName: 'test-server',
        covers: [_image('img-1'), _image('img-2')],
        placeholderIcon: Icons.queue_music,
      )));
      await tester.pump();

      final images = tester
          .widgetList<CachedNetworkImage>(find.byType(CachedNetworkImage))
          .map((image) => image.imageUrl)
          .toList();
      expect(images.length, 4);
      expect(images.where((url) => url.contains('img-1')).length, 2);
      expect(images.where((url) => url.contains('img-2')).length, 2);
    });

    testWidgets('falls back to the placeholder without any cover',
        (tester) async {
      await tester.pumpWidget(_wrap(const PlaylistCoverMosaic(
        serverName: 'test-server',
        covers: [],
        placeholderIcon: Icons.queue_music,
      )));
      await tester.pump();

      expect(find.byType(CachedNetworkImage), findsNothing);
      expect(find.byIcon(Icons.queue_music), findsOneWidget);
    });
  });
}
