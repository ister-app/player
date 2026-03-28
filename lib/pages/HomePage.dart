import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/components/ServerList.dart';
import 'package:player/l10n/app_localizations.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _serverListKey = GlobalKey<ServerListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.servers),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _serverListKey.currentState?.refresh(),
          ),
        ],
      ),
      body: ListView(
        children: [
          ServerList(key: _serverListKey),
        ],
      ),
    );
  }
}
