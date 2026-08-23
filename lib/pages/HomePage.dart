import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/components/ServerList.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/routes/AppRouter.gr.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _serverListKey = GlobalKey<ServerListState>();
  final _hasServers = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _hasServers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.servers),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: loc.retry,
            onPressed: () => _serverListKey.currentState?.refresh(),
          ),
        ],
      ),
      body: ServerList(key: _serverListKey, hasServers: _hasServers),
      // The welcome state carries its own (bigger) add button; the FAB is
      // for the list.
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: _hasServers,
        builder: (context, hasServers, _) {
          if (!hasServers) return const SizedBox.shrink();
          return FloatingActionButton.extended(
            onPressed: () => context.router.push(AddServerRoute()),
            icon: const Icon(Icons.add),
            label: Text(loc.addServerTitle),
          );
        },
      ),
    );
  }
}
