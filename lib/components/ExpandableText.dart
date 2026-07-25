import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

/// Body text that clamps to [collapsedMaxLines] lines with a "read more"
/// toggle when it overflows; short text renders as a plain [Text]. The toggle
/// is a [TextButton], so it is reachable with D-pad/keyboard focus on TV.
class ExpandableText extends StatefulWidget {
  const ExpandableText({
    super.key,
    required this.text,
    this.collapsedMaxLines = 4,
  });

  final String text;
  final int collapsedMaxLines;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final style = DefaultTextStyle.of(context).style;
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: style),
          maxLines: widget.collapsedMaxLines,
          textDirection: Directionality.of(context),
        )..layout(maxWidth: constraints.maxWidth);
        if (!painter.didExceedMaxLines) {
          return Text(widget.text);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              maxLines: _expanded ? null : widget.collapsedMaxLines,
              overflow: _expanded ? null : TextOverflow.ellipsis,
            ),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () => setState(() => _expanded = !_expanded),
              child: Text(_expanded ? loc.showLess : loc.readMore),
            ),
          ],
        );
      },
    );
  }
}
