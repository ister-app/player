import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:player/graphql/getServerInfo.graphql.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerList extends StatefulWidget {
  const ServerList({super.key});

  @override
  State<ServerList> createState() => _ServerListState();
}

class _ServerListState extends State<ServerList> {
  final SharedPreferencesAsync _sharedPreferencesAsync =
      SharedPreferencesAsync();
  late Future<List<String>> _servers;

  Future<void> _addServer(String value) async {
    final List<String> servers =
        await _sharedPreferencesAsync.getStringList('servers') ?? [];
    servers.add(value);
    setState(() {
      _servers =
          _sharedPreferencesAsync.setStringList('servers', servers).then((_) {
        return servers;
      });
    });
  }

  Future<void> _deleteServer(String value) async {
    final List<String> servers =
        await _sharedPreferencesAsync.getStringList('servers') ?? [];
    servers.remove(value);
    setState(() {
      _servers =
          _sharedPreferencesAsync.setStringList('servers', servers).then((_) {
        return servers;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (ClientManager.instance.lastClientUsed != null) {
      goToServerRoute(ClientManager.instance.lastClientUsed!);
    }

    _servers = _sharedPreferencesAsync.getStringList('servers').then(
      (value) {
        return value ?? [];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            constraints: BoxConstraints(maxWidth: 500),
            child: (Column(children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Add a server',
                      ),
                      onSubmitted: (value) => _addServer(value))),
              FutureBuilder<List<String>>(
                  future: _servers,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<String>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const CircularProgressIndicator();
                      case ConnectionState.active:
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          if (snapshot.data == null ||
                              snapshot.data?.isEmpty == null ||
                              snapshot.data!.isEmpty) {
                            return Text("No servers added yet");
                          }
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              padding: const EdgeInsets.all(8),
                              itemCount: snapshot.data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                if (snapshot.data?[index] != null) {
                                  final serverUrl = snapshot.data![index];
                                  return GraphQLProvider(
                                    client: ClientManager.getClientForUrl(serverUrl),
                                    child: Query(
                                      options: QueryOptions(
                                        document: documentNodeQuerygetServerInfoQuery,
                                        fetchPolicy: FetchPolicy.cacheAndNetwork,
                                      ),
                                      builder: (QueryResult result,
                                          {VoidCallback? refetch, FetchMore? fetchMore}) {
                                        final isLoading = result.data == null && result.isLoading;
                                        final hasError = result.hasException;

                                        if (isLoading) {
                                          return Skeletonizer(
                                            enabled: true,
                                            child: Card(
                                              child: ListTile(
                                                leading: const Icon(Icons.dns),
                                                title: Text(BoneMock.name),
                                                subtitle: Text(BoneMock.words(3)),
                                              ),
                                            ),
                                          );
                                        }

                                        if (hasError) {
                                          return Card(
                                            child: ListTile(
                                              leading: Icon(Icons.dns,
                                                  color: Theme.of(context).disabledColor),
                                              title: Text(serverUrl,
                                                  style: TextStyle(
                                                      color: Theme.of(context).disabledColor)),
                                              subtitle: Text(
                                                result.exception.toString(),
                                                style: TextStyle(
                                                    color: Theme.of(context).disabledColor),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              trailing: IconButton(
                                                onPressed: () => _deleteServer(serverUrl),
                                                icon: Icon(Icons.delete,
                                                    color: Theme.of(context).disabledColor),
                                              ),
                                            ),
                                          );
                                        }

                                        final info = Query$getServerInfoQuery
                                            .fromJson(result.data!)
                                            .getServerInfo;
                                        return Card(
                                          child: ListTile(
                                            leading: const Icon(Icons.dns),
                                            trailing: IconButton(
                                              onPressed: () => _deleteServer(serverUrl),
                                              icon: const Icon(Icons.delete),
                                            ),
                                            title: Text(info?.name ?? serverUrl),
                                            subtitle: info != null ? Text(info.url) : null,
                                            onTap: () => goToServerRoute(serverUrl),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                              });
                        }
                    }
                  }),
            ]))));
  }

  Future<void> goToServerRoute(String serverName) async {
    if (!mounted) return;
    await _sharedPreferencesAsync.setString("currentServer", serverName);
    AutoRouter.of(context).replace(ServerHomeRoute(serverName: serverName));
  }
}
