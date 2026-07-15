import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/booksQuery.graphql.dart';
import 'package:player/graphql/schema.graphql.dart';

import '../graphql/fragmentBook.graphql.dart';
import 'BookCarouselTile.dart';
import 'PagedContentView.dart';

/// Scrollable grid of all books in a book library, loaded page by page.
class BookScroll extends StatelessWidget {
  final String serverName;
  final String? libraryId;
  final Enum$SortingEnum sorting;
  final Enum$SortingOrder sortingOrder;
  final void Function(Refetch?)? onRefetch;

  const BookScroll({
    super.key,
    required this.serverName,
    this.libraryId,
    this.sorting = Enum$SortingEnum.NAME,
    this.sortingOrder = Enum$SortingOrder.ASCENDING,
    this.onRefetch,
  });

  static const int _pageSize = 15;

  @override
  Widget build(BuildContext context) {
    return PagedContentView<Fragment$fragmentBook>(
      document: documentNodeQuerybooks,
      rootField: 'books',
      fromJson: Fragment$fragmentBook.fromJson,
      sorting: sorting,
      sortingOrder: sortingOrder,
      libraryId: libraryId,
      onRefetch: onRefetch,
      pageSize: _pageSize,
      builder: (context, data, requestPage) {
        final itemCount = data.totalItems ?? (_pageSize * 2);

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: BookCarouselTile.coverAspectRatio,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
          ),
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final book = data.itemAt(index);
            if (book != null) {
              return BookCarouselTile(serverName: serverName, book: book);
            }

            return pagedSkeletonSlot(
              key: ValueKey('book-scroll-skeleton-$index'),
              onVisible: () => requestPage(index ~/ _pageSize),
            );
          },
        );
      },
    );
  }
}
