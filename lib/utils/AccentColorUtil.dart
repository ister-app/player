import 'dart:typed_data';

import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:player/utils/ImageCacheConfig.dart';
import 'package:player/utils/ImageUtil.dart';

/// Extracts a UI accent colour from artwork, shared by the music player and the
/// album page so both derive the same tint from the same cover.
class AccentColorUtil {
  AccentColorUtil._();

  /// Extracts an accent from the artwork at [url]; null on failure or no url.
  static Future<Color?> fromImageUrl(String? url) async {
    if (url == null || url.isEmpty) return null;
    try {
      // Deliberately *not* a CachedNetworkImageProvider: that resolves to the
      // very image stream the artwork widgets are listening to, and attaching
      // and detaching a second listener on it races the multi-codec decode in
      // cached_network_image (two concurrent `getNextFrame`s emit the same
      // frame twice, the second `setImage` disposes the first — the artwork
      // widgets are then left painting a disposed image and the screen goes
      // blank). Going through the app's own cache manager with the artwork's
      // own cache key means the bytes are the ones the cover widget already
      // downloaded, so this costs no extra request; the private MemoryImage is
      // evicted right after so it does not linger in the image cache at full
      // size.
      final key = ImageUtil.cacheKeyFor(url)!;
      final info = await ImageCacheConfig.manager.getFileFromCache(key) ??
          await ImageCacheConfig.manager
              .getFileStream(url, key: key)
              .firstWhere((r) => r is FileInfo) as FileInfo;
      final Uint8List bytes = await info.file.readAsBytes();
      final provider = MemoryImage(bytes);
      try {
        // `content` keeps the source artwork's hue and chroma instead of pulling
        // it towards a muted tonal palette, which is what we want for an accent.
        final scheme = await ColorScheme.fromImageProvider(
          provider: provider,
          brightness: Brightness.dark,
          dynamicSchemeVariant: DynamicSchemeVariant.content,
        );
        return pickAccent(scheme);
      } finally {
        PaintingBinding.instance.imageCache.evict(provider);
      }
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
