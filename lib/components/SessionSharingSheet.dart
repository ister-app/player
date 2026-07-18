import 'package:flutter/material.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/utils/SharingSettingsService.dart';

/// Bottom sheet letting the owner override remote-control sharing for one live session only.
/// "Use my default" clears the override; "Specific people" reveals an allowlist just for this
/// session (independent of the account-level allowlist). Now-playing visibility is not touched
/// here — it always follows the account setting.
class SessionSharingSheet extends StatefulWidget {
  const SessionSharingSheet({
    super.key,
    required this.serverName,
    required this.playQueueId,
    required this.currentOverride,
    required this.currentAllowedUserIds,
  });

  final String? serverName;
  final String playQueueId;
  final Enum$RemoteControlScope? currentOverride;
  final List<String> currentAllowedUserIds;

  @override
  State<SessionSharingSheet> createState() => _SessionSharingSheetState();
}

class _SessionSharingSheetState extends State<SessionSharingSheet> {
  late Enum$RemoteControlScope? _scope = widget.currentOverride;
  late final Set<String> _allowed = widget.currentAllowedUserIds.toSet();
  Future<List<ShareableUser>>? _usersFuture;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (_scope == Enum$RemoteControlScope.ALLOWLIST) {
      _usersFuture = SharingSettingsService().shareableUsers(widget.serverName);
    }
  }

  void _selectScope(Enum$RemoteControlScope? scope) {
    setState(() {
      _scope = scope;
      if (scope == Enum$RemoteControlScope.ALLOWLIST) {
        _usersFuture ??= SharingSettingsService().shareableUsers(widget.serverName);
      }
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await SharingSettingsService().setSessionSharing(
        widget.serverName,
        widget.playQueueId,
        controlScope: _scope,
        allowedUserIds:
            _scope == Enum$RemoteControlScope.ALLOWLIST ? _allowed.toList() : null,
      );
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(loc.sharingCouldNotSave)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Text(loc.sessionSharingTitle,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            RadioListTile<Enum$RemoteControlScope?>(
              value: null,
              groupValue: _scope,
              onChanged: _saving ? null : _selectScope,
              title: Text(loc.sessionSharingUseDefault),
            ),
            RadioListTile<Enum$RemoteControlScope?>(
              value: Enum$RemoteControlScope.PRIVATE,
              groupValue: _scope,
              onChanged: _saving ? null : _selectScope,
              title: Text(loc.sharingScopePrivate),
            ),
            RadioListTile<Enum$RemoteControlScope?>(
              value: Enum$RemoteControlScope.EVERYONE,
              groupValue: _scope,
              onChanged: _saving ? null : _selectScope,
              title: Text(loc.sharingScopeEveryone),
            ),
            RadioListTile<Enum$RemoteControlScope?>(
              value: Enum$RemoteControlScope.ALLOWLIST,
              groupValue: _scope,
              onChanged: _saving ? null : _selectScope,
              title: Text(loc.sharingScopeAllowlist),
            ),
            if (_scope == Enum$RemoteControlScope.ALLOWLIST)
              Flexible(child: _allowlist(loc)),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: _saving ? null : _save,
                  child: Text(MaterialLocalizations.of(context).saveButtonLabel),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _allowlist(AppLocalizations loc) {
    return FutureBuilder<List<ShareableUser>>(
      future: _usersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final users = snapshot.data ?? const [];
        if (users.isEmpty) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(loc.sharingNoOtherUsers),
          );
        }
        return ListView(
          shrinkWrap: true,
          children: [
            for (final user in users)
              CheckboxListTile(
                dense: true,
                value: _allowed.contains(user.id),
                title: Text(user.name ?? user.id),
                onChanged: _saving
                    ? null
                    : (checked) {
                        setState(() {
                          if (checked == true) {
                            _allowed.add(user.id);
                          } else {
                            _allowed.remove(user.id);
                          }
                        });
                      },
              ),
          ],
        );
      },
    );
  }
}
