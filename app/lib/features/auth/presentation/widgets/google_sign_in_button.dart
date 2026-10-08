import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../auth_strings.dart';

/// A button that displays the Google logo and "Sign in with Google",
/// following Google's visual guidelines and adapting to LuxeKnox themes.
class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(
          color: isDark
              ? theme.colorScheme.outlineVariant
              : const Color(0xFF747775),
        ),
        backgroundColor: isDark
            ? theme.colorScheme.surfaceContainerHigh
            : Colors.white,
        foregroundColor: isDark ? Colors.white : const Color(0xFF1F1F1F),
        elevation: 0,
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 20, height: 20, child: GoogleLogo()),
                SizedBox(width: 12),
                Flexible(
                  child: Text(
                    AuthStrings.signInWithGoogle,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.25,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

/// Standalone, vector-drawn Google "G" logo.
/// Renders identically without external assets or network dependencies.
class GoogleLogo extends StatelessWidget {
  const GoogleLogo({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size), painter: _GoogleLogoPainter());
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = radius * 0.42;
    final arcRect = Rect.fromCircle(
      center: center,
      radius: radius - strokeWidth / 2,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Blue arc (top-right to bottom-right)
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(arcRect, -math.pi / 4, math.pi / 2, false, paint);

    // Green arc (bottom-right to bottom-left)
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(arcRect, math.pi / 4, math.pi / 2, false, paint);

    // Yellow arc (bottom-left to top-left)
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(arcRect, 3 * math.pi / 4, math.pi / 2, false, paint);

    // Red arc (top-left to top-right)
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(arcRect, 5 * math.pi / 4, math.pi / 2, false, paint);

    // Horizontal bar for the "G"
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    final barRect = Rect.fromLTWH(
      center.dx - strokeWidth * 0.1,
      center.dy - strokeWidth / 2,
      radius - strokeWidth * 0.1,
      strokeWidth,
    );
    canvas.drawRect(barRect, barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
