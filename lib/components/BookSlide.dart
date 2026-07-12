import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/booksQuery.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

import '../graphql/fragmentBook.graphql.dart';
import 'BookCarouselTile.dart';
import 'PagedContentView.dart';

/// Horizontal carousel that lazily loads book items.
class BookSlide extends StatelessWidget {
  final String serverName;
  final String? libraryId;
  final void Function(Refetch?)? onRefetch;

  const BookSlide({
    super.key,
    required this.serverName,
    this.libraryId,
    this.onRefetch,
  });

  static const int _pageSize = 15;

  @override
  Widget build(BuildContext context) {
    return PagedContentView<Fragment$fragmentBook>(
      document: documentNodeQuerybooks,
      rootField: 'books',
      fromJson: Fragment$fragmentBook.fromJson,
      sorting: Enum$SortingEnum.DATE_CREATED,
      sortingOrder: Enum$SortingOrder.DESCENDING,
      libraryId: libraryId,
      onRefetch: onRefetch,
      pageSize: _pageSize,
      builder: (context, data, requestPage) {
        final items = data.orderedItems;
        final placeholderCount = data.totalItems == null
            ? _pageSize * 2
            : (data.totalItems! - items.length).clamp(0, _pageSize);

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemExtent: 200.0,
          itemCount: items.length + placeholderCount,
          itemBuilder: (context, index) {
            if (index < items.length) {
              return BookCarouselTile(
                  serverName: serverName, book: items[index]);
            }

            return pagedSkeletonSlot(
              key: ValueKey('book-slide-placeholder-$index'),
              onVisible: () => requestPage(index ~/ _pageSize),
            );
          },
        );
      },
    );
  }
}
