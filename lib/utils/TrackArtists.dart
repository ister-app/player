/// The artist line of a track: every person credited on it, in credit order
/// (the primary artist first, then the featured guests).
///
/// A compilation duet is credited to both singers — "A & B" in the file's tag
/// is split into two credits by the server — and showing only the primary one
/// hides half of who is playing. Falls back to [fallback] (the track's primary
/// artist) when a server returns no credits at all.
String trackArtistsLabel(
  Iterable<({int position, String name})> credits,
  String fallback,
) {
  final ordered = credits.toList()
    ..sort((a, b) => a.position.compareTo(b.position));
  final names = <String>[];
  for (final credit in ordered) {
    if (credit.name.isNotEmpty && !names.contains(credit.name)) {
      names.add(credit.name);
    }
  }
  return names.isEmpty ? fallback : names.join(', ');
}
