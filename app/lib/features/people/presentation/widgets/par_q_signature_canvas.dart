import 'package:flutter/material.dart';

import '../people_strings.dart';

/// Touch & mouse signature canvas for member and trainer sign-offs.
class ParQSignatureCanvas extends StatefulWidget {
  const ParQSignatureCanvas({
    super.key,
    this.height = 150,
    this.onChanged,
    this.initialHasSignature = false,
  });

  final double height;
  final ValueChanged<bool>? onChanged;
  final bool initialHasSignature;

  @override
  State<ParQSignatureCanvas> createState() => ParQSignatureCanvasState();
}

class ParQSignatureCanvasState extends State<ParQSignatureCanvas> {
  final List<List<Offset>> _strokes = [];
  bool _hasSignature = false;

  bool get hasSignature => _hasSignature;
  List<List<Offset>> get strokes => List.unmodifiable(_strokes);

  @override
  void initState() {
    super.initState();
    _hasSignature = widget.initialHasSignature;
  }

  void clear() {
    setState(() {
      _strokes.clear();
      _hasSignature = false;
    });
    widget.onChanged?.call(false);
  }

  void setStrokes(List<List<Offset>> strokes) {
    setState(() {
      _strokes.clear();
      _strokes.addAll(strokes.map((s) => List<Offset>.from(s)));
      _hasSignature = _strokes.any((s) => s.isNotEmpty);
    });
    widget.onChanged?.call(_hasSignature);
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _strokes.add([details.localPosition]);
      if (!_hasSignature) {
        _hasSignature = true;
        widget.onChanged?.call(true);
      }
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      if (_strokes.isNotEmpty) {
        _strokes.last.add(details.localPosition);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.outlineVariant;
    final strokeColor = theme.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: widget.height,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.35,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Stack(
              children: [
                if (!_hasSignature)
                  Center(
                    child: Text(
                      PeopleStrings.parQSignaturePrompt,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.outline,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: _SignatureBaselinePainter(
                      lineColor: theme.colorScheme.outline.withValues(
                        alpha: 0.25,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: GestureDetector(
                    key: const Key('par_q_signature_gesture_detector'),
                    behavior: HitTestBehavior.opaque,
                    onPanStart: _onPanStart,
                    onPanUpdate: _onPanUpdate,
                    child: CustomPaint(
                      painter: _SignaturePainter(
                        strokes: _strokes,
                        strokeColor: strokeColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            key: const Key('par_q_signature_clear_button'),
            onPressed: _hasSignature ? clear : null,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text(PeopleStrings.parQSignatureClear),
          ),
        ),
      ],
    );
  }
}

class _SignaturePainter extends CustomPainter {
  const _SignaturePainter({required this.strokes, required this.strokeColor});

  final List<List<Offset>> strokes;
  final Color strokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = strokeColor
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke;

    for (final stroke in strokes) {
      if (stroke.isEmpty) continue;
      if (stroke.length == 1) {
        canvas.drawCircle(stroke.first, 1.5, paint..style = PaintingStyle.fill);
        paint.style = PaintingStyle.stroke;
        continue;
      }
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length; i++) {
        path.lineTo(stroke[i].dx, stroke[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SignaturePainter oldDelegate) => true;
}

class _SignatureBaselinePainter extends CustomPainter {
  const _SignatureBaselinePainter({required this.lineColor});

  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height * 0.75;
    final paint =
        Paint()
          ..color = lineColor
          ..strokeWidth = 1.0;

    // Draw baseline
    canvas.drawLine(Offset(16, y), Offset(size.width - 16, y), paint);

    // Draw 'X' indicator
    final textPainter = TextPainter(
      text: TextSpan(
        text: '✕',
        style: TextStyle(
          color: lineColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(20, y - 20));
  }

  @override
  bool shouldRepaint(covariant _SignatureBaselinePainter oldDelegate) => false;
}

/// Dialog for signing a PAR-Q+ questionnaire with a larger touch canvas.
/// Returns the recorded signature strokes on confirmation, or null on cancel.
Future<List<List<Offset>>?> showParQSignatureDialog({
  required BuildContext context,
  bool initialHasSignature = false,
}) {
  return showDialog<List<List<Offset>>>(
    context: context,
    builder: (dialogContext) {
      final key = GlobalKey<ParQSignatureCanvasState>();
      bool hasSig = initialHasSignature;

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text(PeopleStrings.parQSignatureDialogTitle),
            content: SizedBox(
              width: 480,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    PeopleStrings.parQSignaturePrompt,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  ParQSignatureCanvas(
                    key: key,
                    height: 200,
                    initialHasSignature: initialHasSignature,
                    onChanged: (val) => setState(() => hasSig = val),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(null),
                child: const Text(PeopleStrings.cancel),
              ),
              FilledButton(
                onPressed:
                    hasSig
                        ? () => Navigator.of(
                          dialogContext,
                        ).pop(key.currentState?.strokes ?? const [])
                        : null,
                child: const Text(PeopleStrings.parQSignatureDone),
              ),
            ],
          );
        },
      );
    },
  );
}
