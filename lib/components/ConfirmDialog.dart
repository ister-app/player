import 'package:flutter/material.dart';

/// The app's confirmation dialog: cancel as a plain text button, the
/// destructive action as a filled button. Returns true only on an explicit
/// confirm; dismissing the dialog counts as cancel. Stock [AlertDialog], so
/// D-pad/TV focus traversal works out of the box.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed == true;
}
