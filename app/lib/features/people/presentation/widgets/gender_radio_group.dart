import 'package:flutter/material.dart';

import '../people_strings.dart';

class GenderRadioGroup extends StatelessWidget {
  const GenderRadioGroup({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.errorText,
  });

  final String? value;
  final ValueChanged<String?> onChanged;
  final bool enabled;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: hasError
                  ? theme.colorScheme.error
                  : theme.colorScheme.outlineVariant,
              width: hasError ? 1.5 : 1.0,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                PeopleStrings.gender,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: hasError ? theme.colorScheme.error : null,
                  fontWeight: FontWeight.w500,
                ),
              ),
              RadioGroup<String>(
                groupValue: value,
                onChanged: onChanged,
                child: Row(
                  children: [
                    for (final option in const [
                      PeopleStrings.genderMale,
                      PeopleStrings.genderFemale,
                    ])
                      Expanded(
                        child: RadioListTile<String>(
                          value: option,
                          enabled: enabled,
                          contentPadding: EdgeInsets.zero,
                          title: Text(option),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Text(
              errorText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
