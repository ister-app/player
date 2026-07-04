import 'package:flutter/material.dart';
import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'CarouselItemView.dart';

typedef ItemFromJson<T> = T Function(Map<String, dynamic> json);

/// Read-only view over the items loaded so far by a [PagedContentView].
///
/// Items are stored per page so a grid can address any absolute index and a
/// horizontal list can read them back in order. Both layouts share the same
/// backing data and paging logic.
class PagedContentData<T> {
  const PagedContentData(this._pages, this.totalItems, this.pageSize);

  final Map<int, List<T>> _pages;

  /// Total number of items reported by the server, or null until the first
  /// page has resolved.
  final int? totalItems;
  final int pageSize;

  /// Loaded items concatenated from page 0 upward, stopping at the first gap.
  /// Suitable for an append-as-you-scroll horizontal list.
  List<T> get orderedItems {
    final out = <T>[];
    for (var page = 0; _pages.containsKey(page); page++) {
      out.addAll(_pages[page]!);
    }
    return out;
  }

  /// The item at an absolute index, or null if its page isn't loaded yet.
  /// Suitable for a fixed-size grid addressed by index.
  T? itemAt(int absoluteIndex) {
    final page = _pages[absoluteIndex ~/ pageSize];
    if (page == null) return null;
    final i = absoluteIndex % pageSize;
    return i < page.length ? page[i] : null;
  }
}

/// Handles the shared GraphQL paging plumbing for the movie/album carousels and
/// grids: the initial `cacheAndNetwork` query, `fetchMore` with per-page dedup,
/// error handling, and total-count tracking. Presentation (list vs grid, item
/// rendering) is supplied by [builder].
class PagedContentView<T> extends StatefulWidget {
  const PagedContentView({
    super.key,
    required this.document,
    required this.rootField,
    required this.fromJson,
    required this.sorting,
    required this.sortingOrder,
    required this.builder,
    this.libraryId,
    this.pageSize = 15,
    this.onRefetch,
  });

  /// The paged list query document (e.g. movies/albums).
  final DocumentNode document;

  /// The query's root field name, used to read `content`/`totalElements` from
  /// the raw result and from `fetchMore` results (e.g. `'movies'`).
  final String rootField;
  final ItemFromJson<T> fromJson;
  final Enum$SortingEnum sorting;
  final Enum$SortingOrder sortingOrder;
  final String? libraryId;
  final int pageSize;
  final void Function(Refetch?)? onRefetch;

  /// Builds the scrollable. `requestPage` lazily loads the given (0-based) page.
  final Widget Function(
    BuildContext context,
    PagedContentData<T> data,
    void Function(int page) requestPage,
  ) builder;

  @override
  State<PagedContentView<T>> createState() => _PagedContentViewState<T>();
}

class _PagedContentViewState<T> extends State<PagedContentView<T>> {
  final Map<int, List<T>> _pageData = {};
  int? _totalItems;
  DateTime? _lastResultTimestamp;
  final Set<int> _requestedPages = {0};
  FetchMore? _fetchMore;

  List<T> _parseContent(List<dynamic>? content) =>
      content?.map((e) => widget.fromJson(e as Map<String, dynamic>)).toList() ??
      <T>[];

  void _requestPage(int page) {
    final fetchMore = _fetchMore;
    if (fetchMore == null) return;
    if (_requestedPages.contains(page)) return;
    _requestedPages.add(page);

    fetchMore(
      FetchMoreOptions(
        variables: {'page': page, 'size': widget.pageSize},
        updateQuery: (previous, fetchMoreResult) {
          final content = fetchMoreResult?[widget.rootField]?['content'];
          if (content == null) {
            _requestedPages.remove(page);
            return previous!;
          }
          final fresh = _parseContent(content as List<dynamic>);
          if (mounted) {
            setState(() => _pageData[page] = fresh);
          }
          return previous!;
        },
      ),
    ).then<void>((_) {}, onError: (_) => _requestedPages.remove(page));
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: widget.document,
        variables: {
          'page': 0,
          'size': widget.pageSize,
          'sorting': widget.sorting,
          'sortingOrder': widget.sortingOrder,
          if (widget.libraryId != null) 'libraryId': widget.libraryId,
        },
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
      builder: (result, {Refetch? refetch, FetchMore? fetchMore}) {
        widget.onRefetch?.call(refetch);
        _fetchMore = fetchMore;

        // Parse every new emission (cache, network, refetch) exactly once —
        // an "initialized" latch would pin the UI to the first (cached)
        // result and make pull-to-refresh a no-op.
        if (result.data != null && result.timestamp != _lastResultTimestamp) {
          _lastResultTimestamp = result.timestamp;
          final root = result.data![widget.rootField];
          final content = root?['content'] as List<dynamic>?;
          final total = root?['totalElements'] as int?;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            setState(() {
              _pageData[0] = _parseContent(content);
              _totalItems = total;
            });
          });
        }

        if (result.hasException && _pageData.isEmpty) {
          return Center(child: Text(result.exception.toString()));
        }

        return widget.builder(
          context,
          PagedContentData<T>(_pageData, _totalItems, widget.pageSize),
          _requestPage,
        );
      },
    );
  }
}

/// The skeleton placeholder shared by every paged carousel/grid slot. Requests
/// [onVisible]'s page once it scrolls into view.
Widget pagedSkeletonSlot({required Key key, required VoidCallback onVisible}) {
  return VisibilityDetector(
    key: key,
    onVisibilityChanged: (info) {
      if (info.visibleFraction > 0) onVisible();
    },
    child: Skeletonizer(
      enabled: true,
      child: CarouselItemView(
        serverName: '',
        title: BoneMock.name,
        subTitle: BoneMock.words(10),
      ),
    ),
  );
}
