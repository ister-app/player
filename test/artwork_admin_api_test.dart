import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/artwork/ArtworkAdminApi.dart';
import 'package:player/utils/artwork/ArtworkTarget.dart';

void main() {
  test(
    'upload posts the raw body with the bearer token, type and one target id',
    () async {
      http.Request? seen;
      final client = MockClient((request) async {
        seen = request;
        return http.Response(
          json.encode({'imageId': 'img-9', 'type': 'COVER'}),
          200,
          headers: {'content-type': 'application/json'},
        );
      });
      final api = ArtworkAdminApi(
        'srv',
        httpClient: client,
        bearer: (_) async => 'Bearer t0k',
      );

      final id = await api.upload(
        'https://host/api/',
        const ArtworkTarget(ArtworkTargetKind.album, 'alb-1'),
        ImageTypes.cover,
        Uint8List.fromList([1, 2, 3]),
        contentType: 'image/png',
      );

      expect(id, 'img-9');
      expect(seen!.method, 'POST');
      expect(seen!.url.path, '/api/artwork/upload');
      expect(seen!.url.queryParameters, {'type': 'COVER', 'albumId': 'alb-1'});
      expect(seen!.headers['Authorization'], 'Bearer t0k');
      expect(seen!.headers['Content-Type'], startsWith('image/png'));
      expect(seen!.bodyBytes, [1, 2, 3]);
    },
  );

  test('a refused upload surfaces the server detail', () async {
    final client = MockClient(
      (_) async => http.Response(
        json.encode({'detail': 'Image larger than 20971520 bytes'}),
        400,
        headers: {'content-type': 'application/problem+json'},
      ),
    );
    final api = ArtworkAdminApi(
      'srv',
      httpClient: client,
      bearer: (_) async => 'Bearer t',
    );

    expect(
      () => api.upload(
        'https://host',
        const ArtworkTarget(ArtworkTargetKind.movie, 'm'),
        ImageTypes.background,
        Uint8List(1),
        contentType: 'image/jpeg',
      ),
      throwsA(
        isA<ArtworkUploadException>()
            .having((e) => e.statusCode, 'status', 400)
            .having((e) => e.message, 'message', contains('larger')),
      ),
    );
  });

  test(
    'content types follow the extension; unsupported formats are refused',
    () {
      expect(artworkContentTypeFor('Poster.JPG'), 'image/jpeg');
      expect(artworkContentTypeFor('a.jpeg'), 'image/jpeg');
      expect(artworkContentTypeFor('a.png'), 'image/png');
      expect(artworkContentTypeFor('a.webp'), 'image/webp');
      expect(artworkContentTypeFor('a.gif'), isNull);
    },
  );

  test('the target round-trips through a route and maps to one input id', () {
    final target = ArtworkTarget.parse('episode', 'ep-1')!;
    expect(target.hasVideo, isTrue);
    expect(target.queryParamName, 'episodeId');
    final input = target.toInput().toJson();
    expect(input['episodeId'], 'ep-1');
    expect(input.values.where((v) => v != null), hasLength(1));
    expect(ArtworkTarget.parse('nope', 'x'), isNull);
    expect(const ArtworkTarget(ArtworkTargetKind.album, 'a').hasVideo, isFalse);
  });
}
