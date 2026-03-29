import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/WellKnownService.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerList extends StatefulWidget {
  const ServerList({super.key});

  @override
  State<ServerList> createState() => ServerListState();
}

class ServerListState extends State<ServerList> {
  final SharedPreferencesAsync _sharedPreferencesAsync =
      SharedPreferencesAsync();
  late Future<List<String>> _servers;
  int _refreshToken = 0;

  void refresh() => setState(() {
        _refreshToken++;
      });

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
    await WellKnownService.remove(value);
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
      (value) async {
        final servers = value ?? [];
        if (kIsWeb && servers.isEmpty && ClientManager.instance.lastClientUsed == null) {
          final host = Uri.base.host;
          servers.add(host);
          await _sharedPreferencesAsync.setStringList('servers', servers);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) goToServerRoute(host);
          });
        }
        return servers;
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
                        hintText: AppLocalizations.of(context)!.addServer,
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
                          return Text(AppLocalizations.of(context)!.error(snapshot.error!));
                        } else {
                          if (snapshot.data == null ||
                              snapshot.data!.isEmpty) {
                            return Text(AppLocalizations.of(context)!.noServersAdded);
                          }
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              padding: const EdgeInsets.all(8),
                              itemCount: snapshot.data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                final serverUrl = snapshot.data![index];
                                return FutureBuilder<WellKnownInfo?>(
                                    key: ValueKey('$serverUrl-$_refreshToken'),
                                    future: WellKnownService.fetch(serverUrl),
                                    builder: (context, infoSnapshot) {
                                      if (infoSnapshot.connectionState ==
                                          ConnectionState.waiting) {
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

                                      final info = infoSnapshot.data;
                                      return Card(
                                        child: ListTile(
                                          leading: Icon(Icons.dns,
                                              color: info == null
                                                  ? Theme.of(context).disabledColor
                                                  : null),
                                          trailing: IconButton(
                                            onPressed: () =>
                                                _deleteServer(serverUrl),
                                            icon: Icon(Icons.delete,
                                                color: info == null
                                                    ? Theme.of(context).disabledColor
                                                    : null),
                                          ),
                                          title: Text(
                                            info?.name ?? serverUrl,
                                            style: info == null
                                                ? TextStyle(
                                                    color: Theme.of(context)
                                                        .disabledColor)
                                                : null,
                                          ),
                                          subtitle: info != null
                                              ? Text(info.serverUrl)
                                              : Text(
                                                  AppLocalizations.of(context)!
                                                      .serverUnreachable,
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .disabledColor),
                                                ),
                                          onTap: info != null
                                              ? () => goToServerRoute(serverUrl)
                                              : null,
                                        ),
                                      );
                                    },
                                  );
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
