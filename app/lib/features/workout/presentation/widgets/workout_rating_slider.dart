import 'package:flutter/material.dart';

/// Integer rating slider used by the post-workout feedback modal (shown from
/// the active workout screen) for effort, satisfaction, and pain.
class WorkoutRatingSlider extends StatelessWidget {
  const WorkoutRatingSlider({
    super.key,
    this.sliderKey,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.onChanged,
    this.labelColor,
    this.badgeBackground,
    this.badgeForeground,
    this.activeColor,
  });

  final Key? sliderKey;
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final Color? labelColor;
  final Color? badgeBackground;
  final Color? badgeForeground;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rounded = value.round();
    final divisions = (max - min).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: labelColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: badgeBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$rounded / ${max.round()}',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: badgeForeground,
                ),
              ),
            ),
          ],
        ),
        Slider(
          key: sliderKey,
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: '$rounded',
          activeColor: activeColor,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
