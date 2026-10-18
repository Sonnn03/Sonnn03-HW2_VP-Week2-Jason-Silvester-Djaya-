import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText({
    super.key,
    required this.text,
    this.style,
    this.collapsedLines = 4,
  });

  final String text;
  final TextStyle? style;
  final int collapsedLines;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final style = widget.style ?? DefaultTextStyle.of(context).style;

    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: style),
          maxLines: widget.collapsedLines,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        )..layout(maxWidth: constraints.maxWidth);
        final isLong = painter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: style,
              maxLines: _expanded ? null : widget.collapsedLines,
              overflow:
                  _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (isLong)
              TextButton(
                onPressed: () => setState(() => _expanded = !_expanded),
                child: Text(_expanded ? 'Sembunyikan' : 'Selengkapnya'),
              ),
          ],
        );
      },
    );
  }
}