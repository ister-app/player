import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/utils/GraphQLCacheStore.dart';

/// The GraphQL cache is persisted per server so a restart repaints the last
/// browsed content instead of empty shelves.
void main() {
  late Directory dir;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('gql_cache_test');
  });

  tearDown(() async {
    await GraphQLCacheStore.resetForTest();
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  Future<void> boot({String version = '1.0.0+1'}) async {
    GraphQLCacheStore.initForTest(path: dir.path, version: version);
    await GraphQLCacheStore.openFor('localhost:8080/api');
  }

  test('cached entities survive a restart', () async {
    await boot();
    GraphQLCacheStore.storeFor('localhost:8080/api')
        .put('Movie:1', {'__typename': 'Movie', 'id': '1', 'title': 'Dune'});

    await GraphQLCacheStore.resetForTest();
    await boot();

    expect(GraphQLCacheStore.storeFor('localhost:8080/api').get('Movie:1'),
        containsPair('title', 'Dune'));
  });

  test('a new app version drops the cache', () async {
    await boot();
    GraphQLCacheStore.storeFor('localhost:8080/api')
        .put('Movie:1', {'__typename': 'Movie', 'id': '1'});

    await GraphQLCacheStore.resetForTest();
    await boot(version: '1.1.0+2');

    expect(
        GraphQLCacheStore.storeFor('localhost:8080/api').get('Movie:1'), isNull);
  });

  test('removing a server deletes its cache', () async {
    await boot();
    GraphQLCacheStore.storeFor('localhost:8080/api')
        .put('Movie:1', {'__typename': 'Movie', 'id': '1'});

    await GraphQLCacheStore.removeFor('localhost:8080/api');
    await GraphQLCacheStore.openFor('localhost:8080/api');

    expect(
        GraphQLCacheStore.storeFor('localhost:8080/api').get('Movie:1'), isNull);
  });

  test('a server without an open box falls back to memory', () async {
    await boot();
    expect(GraphQLCacheStore.storeFor('other:8080'), isA<InMemoryStore>());
  });

  test('box names are file-safe and unique per server', () {
    final a = GraphQLCacheStore.boxNameFor('demo.example.com/api');
    final b = GraphQLCacheStore.boxNameFor('demo.example.com:443/api');
    expect(a, matches(RegExp(r'^[a-z0-9_]+$')));
    expect(a, isNot(b));
    expect(GraphQLCacheStore.boxNameFor('demo.example.com/api'), a);
  });
}
