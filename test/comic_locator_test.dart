import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/comic/ComicLocator.dart';

void main() {
  test('locator round-trips through serialize/tryParse', () {
    const locator = ComicLocator(pageIndex: 12, fraction: 0.4);
    final parsed = ComicLocator.tryParse(locator.serialize());
    expect(parsed, isNotNull);
    expect(parsed!.pageIndex, 12);
    expect(parsed.fraction, closeTo(0.4, 1e-6));
  });

  test('page zero and fraction default survive', () {
    final parsed =
        ComicLocator.tryParse(const ComicLocator(pageIndex: 0).serialize());
    expect(parsed!.pageIndex, 0);
    expect(parsed.fraction, 0);
  });

  test('garbage, epub locators and epubcfi parse to null', () {
    expect(ComicLocator.tryParse(null), isNull);
    expect(ComicLocator.tryParse(''), isNull);
    expect(ComicLocator.tryParse('epubcfi(/6/4!/4/2)'), isNull);
    expect(ComicLocator.tryParse('ister:v1;spine=ch1;block=3'), isNull);
    expect(ComicLocator.tryParse('ister-comic:v1;pct=0.5'), isNull);
    expect(ComicLocator.tryParse('ister-comic:v1;page=-1'), isNull);
    expect(ComicLocator.tryParse('ister-comic:v1;page=x'), isNull);
  });

  test('out-of-range fraction is clamped', () {
    final parsed = ComicLocator.tryParse('ister-comic:v1;page=3;pct=7');
    expect(parsed!.fraction, 1.0);
  });
}
