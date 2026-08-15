/// Builds the mpv `video-crop` string ("WxH+X+Y") for a server-detected
/// baked-in black-bar crop, scaled from source pixels to the actually-decoded
/// video dimensions — an HLS transcode variant may be downscaled. Returns
/// null when no crop applies: the rect is missing, degenerate, or equal to
/// the full frame (the server's "detected, no bars" sentinel).
///
/// Pure and static so it can be unit tested without a player.
String? mpvCropString({
  required int? srcW,
  required int? srcH,
  required int? cropX,
  required int? cropY,
  required int? cropW,
  required int? cropH,
  required int actualW,
  required int actualH,
}) {
  if (srcW == null || srcH == null || srcW <= 0 || srcH <= 0) return null;
  if (cropX == null || cropY == null || cropW == null || cropH == null) {
    return null;
  }
  if (cropW <= 0 || cropH <= 0 || actualW <= 0 || actualH <= 0) return null;
  if (cropX == 0 && cropY == 0 && cropW == srcW && cropH == srcH) return null;

  final scaleX = actualW / srcW;
  final scaleY = actualH / srcH;
  int even(num v) {
    final r = v.round();
    return r - (r % 2);
  }

  var x = even(cropX * scaleX);
  var y = even(cropY * scaleY);
  var w = even(cropW * scaleX);
  var h = even(cropH * scaleY);
  if (x < 0) x = 0;
  if (y < 0) y = 0;
  if (w <= 0 || h <= 0) return null;
  if (x + w > actualW) w = actualW - x;
  if (y + h > actualH) h = actualH - y;
  if (w <= 0 || h <= 0) return null;
  if (x == 0 && y == 0 && w == actualW && h == actualH) return null;
  return '${w}x$h+$x+$y';
}
