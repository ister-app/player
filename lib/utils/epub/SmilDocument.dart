import 'package:player/utils/epub/EpubPackage.dart';
import 'package:xml/xml.dart';

/// One `<par>` of an EPUB 3 media-overlay SMIL document: a text fragment and
/// the audio clip that reads it aloud.
class SmilPar {
  const SmilPar({
    required this.fragment,
    required this.audioHref,
    required this.clipBegin,
    required this.clipEnd,
  });

  /// Element id inside the chapter document.
  final String fragment;

  /// Resolved zip entry path of the audio file.
  final String audioHref;
  final Duration clipBegin;
  final Duration clipEnd;
}

class SmilDocument {
  const SmilDocument(this.pars);

  final List<SmilPar> pars;

  Duration get end => pars.isEmpty ? Duration.zero : pars.last.clipEnd;

  /// Parses a SMIL document; [smilDir] is the SMIL entry's directory prefix,
  /// which audio/text srcs are relative to. Pars without a text fragment or
  /// audio clip are skipped, like in the old web reader.
  static SmilDocument parse(String content, String smilDir) {
    final document = XmlDocument.parse(content);
    final pars = <SmilPar>[];
    for (final par in document.rootElement.descendantElements
        .where((element) => element.name.local == 'par')) {
      XmlElement? text;
      XmlElement? audio;
      for (final child in par.descendantElements) {
        if (child.name.local == 'text') text ??= child;
        if (child.name.local == 'audio') audio ??= child;
      }
      final src = text?.getAttribute('src') ?? '';
      final audioSrc = audio?.getAttribute('src');
      final hashIndex = src.indexOf('#');
      if (audio == null || audioSrc == null || hashIndex < 0) continue;
      final fragment = src.substring(hashIndex + 1);
      if (fragment.isEmpty) continue;
      pars.add(SmilPar(
        fragment: fragment,
        audioHref: EpubPackage.resolveHref(smilDir, audioSrc),
        clipBegin: parseClockValue(audio.getAttribute('clipBegin')),
        clipEnd: parseClockValue(audio.getAttribute('clipEnd')),
      ));
    }
    return SmilDocument(pars);
  }

  /// SMIL clock values: `1234ms`, `12.5s`, `mm:ss.f` or `hh:mm:ss.f`.
  static Duration parseClockValue(String? value) {
    if (value == null || value.trim().isEmpty) return Duration.zero;
    final trimmed = value.trim();
    double seconds;
    if (trimmed.endsWith('ms')) {
      seconds = (double.tryParse(trimmed.substring(0, trimmed.length - 2)) ?? 0) /
          1000;
    } else if (trimmed.endsWith('s')) {
      seconds =
          double.tryParse(trimmed.substring(0, trimmed.length - 1)) ?? 0;
    } else {
      seconds = trimmed
          .split(':')
          .fold(0, (total, part) => total * 60 + (double.tryParse(part) ?? 0));
    }
    return Duration(microseconds: (seconds * 1000000).round());
  }
}
