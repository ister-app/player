import 'package:flutter/material.dart';
import 'package:player/utils/PermissionsService.dart';

/// Shows [child] only when the current user is an admin on [serverName].
///
/// [showWhenUnknown] controls the legacy case (an older server without the `me` query, or the
/// status not loaded yet): pre-permissions admin UI (scan, analyze, metadata refresh) passes
/// true so it keeps working against old servers, the new permissions-management UI passes
/// false because it cannot work there anyway.
class AdminGate extends StatefulWidget {
  final String serverName;
  final bool showWhenUnknown;
  final Widget child;

  const AdminGate({
    super.key,
    required this.serverName,
    required this.child,
    this.showWhenUnknown = false,
  });

  @override
  State<AdminGate> createState() => _AdminGateState();
}

class _AdminGateState extends State<AdminGate> {
  late AdminStatus _status;

  @override
  void initState() {
    super.initState();
    _status = PermissionsService().cachedStatusFor(widget.serverName);
    if (_status == AdminStatus.unknown) {
      PermissionsService().adminStatusFor(widget.serverName).then((status) {
        if (mounted && status != _status) setState(() => _status = status);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = _status == AdminStatus.admin ||
        (_status == AdminStatus.unknown && widget.showWhenUnknown);
    return visible ? widget.child : const SizedBox.shrink();
  }
}
