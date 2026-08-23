import 'package:player/graphql/seasonById.graphql.dart';

/// Which episodes "download the next N unwatched" picks: it continues from
/// the last episode that was watched or started — a started one counts as
/// the first of the N — and never revisits earlier unwatched ones.
class NextUnwatched {
  NextUnwatched._();

  static List<Query$seasonById$seasonById$episodes> select(
      List<Query$seasonById$seasonById$episodes> episodes, int n) {
    bool watched(Query$seasonById$seasonById$episodes e) =>
        e.watchStatus?.any((w) => w.watched) ?? false;
    int progress(Query$seasonById$seasonById$episodes e) =>
        e.watchStatus?.firstOrNull?.progressInMilliseconds ?? 0;
    var last = -1;
    for (var i = 0; i < episodes.length; i++) {
      if (watched(episodes[i]) || progress(episodes[i]) > 0) last = i;
    }
    final start = last >= 0 && !watched(episodes[last]) ? last : last + 1;
    return episodes
        .skip(start)
        .where((e) => !watched(e) && (e.mediaFile?.isNotEmpty ?? false))
        .take(n)
        .toList();
  }
}
