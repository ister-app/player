import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Extracts a UI accent colour from artwork, shared by the music player and the
/// album page so both derive the same tint from the same cover.
class AccentColorUtil {
  AccentColorUtil._();

  /// Extracts an accent from the artwork at [url]; null on failure or no url.
  static Future<Color?> fromImageUrl(String? url) async {
    if (url == null || url.isEmpty) return null;
    try {
      // `content` keeps the source artwork's hue and chroma instead of pulling
      // it towards a muted tonal palette, which is what we want for an accent.
      final scheme = await ColorScheme.fromImageProvider(
        provider: CachedNetworkImageProvider(url),
        brightness: Brightness.dark,
        dynamicSchemeVariant: DynamicSchemeVariant.content,
      );
      return pickAccent(scheme);
    } catch (_) {
      return null;
    }
  }

  /// Nudges the extracted colour into a range that reads well both as a thin
  /// progress fill on a dark backdrop and as a filled button that carries black
  /// text.
  static Color pickAccent(ColorScheme scheme) {
    var hsl = HSLColor.fromColor(scheme.primary);
    if (hsl.lightness < 0.45) hsl = hsl.withLightness(0.55);
    if (hsl.lightness > 0.78) hsl = hsl.withLightness(0.7);
    if (hsl.saturation < 0.3) hsl = hsl.withSaturation(0.45);
    return hsl.toColor();
  }
}
