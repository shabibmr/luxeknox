import 'package:flutter/material.dart';

import '../people_strings.dart';

class GenderRadioGroup extends StatelessWidget {
  const GenderRadioGroup({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final String? value;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            PeopleStrings.gender,
            style: Theme.of(context).textTheme.bodyMedium,
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
    );
  }
}
