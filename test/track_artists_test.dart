import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/TrackArtists.dart';

void main() {
  test('credits are listed in credit order, primary first', () {
    expect(
      trackArtistsLabel(const [
        (position: 1, name: 'Elizabeth Gillies'),
        (position: 0, name: 'Victoria Justice'),
      ], 'Victoria Justice'),
      'Victoria Justice, Elizabeth Gillies',
    );
  });

  test('a single credit reads as that artist alone', () {
    expect(
      trackArtistsLabel(const [(position: 0, name: 'Matt Bennett')], 'Matt Bennett'),
      'Matt Bennett',
    );
  });

  test('the same person credited twice is named once', () {
    expect(
      trackArtistsLabel(const [
        (position: 0, name: 'Anouk'),
        (position: 1, name: 'Anouk'),
      ], 'Anouk'),
      'Anouk',
    );
  });

  test('without credits the primary artist stands in', () {
    // An older server, or a track whose file has never been analyzed.
    expect(trackArtistsLabel(const [], 'Victorious Cast'), 'Victorious Cast');
    expect(
      trackArtistsLabel(const [(position: 0, name: '')], 'Victorious Cast'),
      'Victorious Cast',
    );
  });
}
