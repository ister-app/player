/// Pure M3U8 helpers for mirroring the server's HLS tree: no I/O.
///
/// The server emits a master playlist with `#EXT-X-MEDIA` renditions (audio
/// per language and quality group, text subtitles) and `#EXT-X-STREAM-INF`
/// variants, and VOD media playlists with relative segment names. Every URI
/// the server hands out carries a `?token=` that must not end up on disk.
library;

class HlsMedia {
  const HlsMedia({
    required this.type,
    required this.groupId,
    required this.uri,
    this.language,
    this.name,
    this.isDefault = false,
    required this.rawLine,
  });

  final String type; // AUDIO / SUBTITLES / …
  final String groupId;
  final String uri;
  final String? language;
  final String? name;
  final bool isDefault;
  final String rawLine;
}

class HlsVariant {
  const HlsVariant({
    required this.uri,
    required this.rawInf,
    this.bandwidth,
    this.height,
    this.audioGroup,
    this.subtitlesGroup,
  });

  final String uri;
  final String rawInf;
  final int? bandwidth;
  final int? height;
  final String? audioGroup;
  final String? subtitlesGroup;
}

class HlsMaster {
  const HlsMaster({required this.media, required this.variants});

  final List<HlsMedia> media;
  final List<HlsVariant> variants;
}

class M3u8 {
  M3u8._();

  static final RegExp _tokenParam = RegExp(r'([?&])token=[^&"\s]*');

  /// Removes the `token` query parameter from a playlist line — both a bare
  /// URI line and a `URI="…"` attribute — leaving other parameters intact.
  static String stripToken(String line) {
    var out = line.replaceAllMapped(_tokenParam, (m) => m.group(1)!);
    // `a.m3u8?` / `a.m3u8?&x=1` / `a.m3u8?x=1&` leftovers.
    out = out.replaceAll('?&', '?');
    out = out.replaceAll(RegExp(r'[?&](?=")'), '');
    out = out.replaceAll(RegExp(r'[?&]$'), '');
    return out;
  }

  /// Parses the attribute list of an `#EXT-X-…:` tag (quoted values may
  /// contain commas).
  static Map<String, String> parseAttributes(String attrs) {
    final result = <String, String>{};
    var i = 0;
    while (i < attrs.length) {
      final eq = attrs.indexOf('=', i);
      if (eq < 0) break;
      final key = attrs.substring(i, eq).trim();
      i = eq + 1;
      String value;
      if (i < attrs.length && attrs[i] == '"') {
        final close = attrs.indexOf('"', i + 1);
        value = attrs.substring(i + 1, close < 0 ? attrs.length : close);
        i = close < 0 ? attrs.length : close + 1;
        if (i < attrs.length && attrs[i] == ',') i++;
      } else {
        final comma = attrs.indexOf(',', i);
        value = attrs.substring(i, comma < 0 ? attrs.length : comma);
        i = comma < 0 ? attrs.length : comma + 1;
      }
      result[key] = value;
    }
    return result;
  }

  static HlsMaster parseMaster(String text) {
    final media = <HlsMedia>[];
    final variants = <HlsVariant>[];
    final lines = text.split(RegExp(r'\r?\n'));
    String? pendingInf;
    for (final raw in lines) {
      final line = raw.trim();
      if (line.isEmpty) continue;
      if (line.startsWith('#EXT-X-MEDIA:')) {
        final a = parseAttributes(line.substring('#EXT-X-MEDIA:'.length));
        final uri = a['URI'];
        if (uri == null) continue;
        media.add(HlsMedia(
          type: a['TYPE'] ?? '',
          groupId: a['GROUP-ID'] ?? '',
          uri: stripToken(uri),
          language: a['LANGUAGE'],
          name: a['NAME'],
          isDefault: a['DEFAULT'] == 'YES',
          rawLine: stripToken(line),
        ));
      } else if (line.startsWith('#EXT-X-STREAM-INF:')) {
        pendingInf = line;
      } else if (!line.startsWith('#')) {
        if (pendingInf == null) continue;
        final a = parseAttributes(
            pendingInf.substring('#EXT-X-STREAM-INF:'.length));
        final res = a['RESOLUTION'];
        int? height;
        if (res != null && res.contains('x')) {
          height = int.tryParse(res.split('x').last);
        }
        variants.add(HlsVariant(
          uri: stripToken(line),
          rawInf: pendingInf,
          bandwidth: int.tryParse(a['BANDWIDTH'] ?? ''),
          height: height,
          audioGroup: a['AUDIO'],
          subtitlesGroup: a['SUBTITLES'],
        ));
        pendingInf = null;
      }
    }
    return HlsMaster(media: media, variants: variants);
  }

  /// Segment URIs of a media playlist, in order (plus an `#EXT-X-MAP` init
  /// segment first, should the server ever emit one).
  static List<String> parseSegmentUris(String text) {
    final uris = <String>[];
    for (final raw in text.split(RegExp(r'\r?\n'))) {
      final line = raw.trim();
      if (line.isEmpty) continue;
      if (line.startsWith('#EXT-X-MAP:')) {
        final uri = parseAttributes(line.substring('#EXT-X-MAP:'.length))['URI'];
        if (uri != null) uris.add(stripToken(uri));
      } else if (!line.startsWith('#')) {
        uris.add(stripToken(line));
      }
    }
    return uris;
  }

  /// The master as it is stored locally: only the kept renditions/variants,
  /// tokens stripped, and — because subtitles are side-loaded as SRT files on
  /// native — no `SUBTITLES=` group references.
  static String rewriteMaster(
    HlsMaster master, {
    required Set<String> keepVariantUris,
    required Set<String> keepMediaUris,
    bool dropSubtitles = true,
  }) {
    final sb = StringBuffer('#EXTM3U\n#EXT-X-VERSION:6\n\n');
    for (final m in master.media) {
      if (dropSubtitles && m.type == 'SUBTITLES') continue;
      if (!keepMediaUris.contains(m.uri)) continue;
      sb.writeln(m.rawLine);
    }
    sb.writeln();
    for (final v in master.variants) {
      if (!keepVariantUris.contains(v.uri)) continue;
      var inf = v.rawInf;
      if (dropSubtitles) {
        inf = inf.replaceAll(RegExp(r',SUBTITLES="[^"]*"'), '');
      }
      sb.writeln(inf);
      sb.writeln(v.uri);
    }
    return sb.toString();
  }

  /// A media playlist as stored locally: every line token-stripped.
  static String rewriteMediaPlaylist(String text) => text
      .split(RegExp(r'\r?\n'))
      .map(stripToken)
      .join('\n');
}
