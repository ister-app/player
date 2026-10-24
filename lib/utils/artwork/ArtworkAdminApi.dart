import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:player/utils/LoginManager.dart';

import '../ImageTypes.dart';
import 'ArtworkTarget.dart';

/// An image file the admin picked: bytes (the web has no path) plus the
/// content type the server accepts.
class PickedArtwork {
  const PickedArtwork({
    required this.bytes,
    required this.contentType,
    required this.name,
  });
  final Uint8List bytes;
  final String contentType;
  final String name;
}

/// The content type for a picked file by extension; null for a format the
/// server does not store (gif, bmp, …).
String? artworkContentTypeFor(String fileName) {
  final lower = fileName.toLowerCase();
  if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
  if (lower.endsWith('.png')) return 'image/png';
  if (lower.endsWith('.webp')) return 'image/webp';
  return null;
}

/// Opens the platform file picker for one image. Null when cancelled or when
/// the picked format is not one the server stores.
Future<PickedArtwork?> pickArtworkFile() async {
  final file = await FilePicker.pickFile(
    type: FileType.custom,
    allowedExtensions: const ['jpg', 'jpeg', 'png', 'webp'],
  );
  if (file == null) return null;
  final contentType = artworkContentTypeFor(file.name);
  if (contentType == null) return null;
  // Bytes rather than a path: the web has no path, and the server wants the body anyway.
  final bytes = await file.readAsBytes();
  return PickedArtwork(bytes: bytes, contentType: contentType, name: file.name);
}

class ArtworkUploadException implements Exception {
  ArtworkUploadException(this.statusCode, this.message);
  final int statusCode;
  final String message;

  @override
  String toString() => 'ArtworkUploadException($statusCode): $message';
}

/// The one REST call of the admin artwork feature: `POST /artwork/upload`
/// with the image as the raw body. Everything else is GraphQL. Bearer token,
/// like [UploadApi] — the server does not take a stream token for writes —
/// and only `Authorization`/`Content-Type`, which the server's CORS allows.
class ArtworkAdminApi {
  ArtworkAdminApi(
    this.serverName, {
    http.Client? httpClient,
    Future<String?> Function(String)? bearer,
  }) : _http = httpClient ?? http.Client(),
       _bearer = bearer ?? LoginManager.getToken;

  final String serverName;
  final http.Client _http;
  final Future<String?> Function(String serverName) _bearer;

  /// Stores [bytes] as the selected image of [type] for [target]; returns the
  /// new image id.
  Future<String> upload(
    String serverUrl,
    ArtworkTarget target,
    ImageTypes type,
    Uint8List bytes, {
    required String contentType,
  }) async {
    final base = serverUrl.endsWith('/')
        ? serverUrl.substring(0, serverUrl.length - 1)
        : serverUrl;
    final uri = Uri.parse('$base/artwork/upload').replace(
      queryParameters: {
        'type': type == ImageTypes.cover ? 'COVER' : 'BACKGROUND',
        target.queryParamName: target.id,
      },
    );
    final token = await _bearer(serverName);
    final response = await _http
        .post(
          uri,
          headers: {'Authorization': ?token, 'Content-Type': contentType},
          body: bytes,
        )
        .timeout(const Duration(minutes: 2));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      String message = response.reasonPhrase ?? 'HTTP ${response.statusCode}';
      try {
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        if (body is Map && body['detail'] is String) {
          message = body['detail'] as String;
        }
      } catch (_) {
        // not JSON: keep the status line
      }
      throw ArtworkUploadException(response.statusCode, message);
    }
    final body =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return body['imageId'] as String;
  }
}
