import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/routes/AppRouter.gr.dart';
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
                                  return Card(
                                      child: ListTile(
                                          leading: Icon(Icons.computer),
                                          trailing: IconButton(
                                            onPressed: () => _deleteServer(
                                                snapshot.data![index]),
                                            icon: Icon(Icons.delete),
                                          ),
                                          title: Text(snapshot.data![index]),
                                          onTap: () => AutoRouter.of(context)
                                              .push(ServerHomeRoute(
                                                  serverName:
                                                      snapshot.data![index]))));
                                }
                              });
                        }
                    }
                  }),
            ]))));
  }
}
