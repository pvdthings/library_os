import 'package:flutter/material.dart';
import 'package:librarian_app/widgets/hint_text.dart';

class ConditionDropdown extends StatelessWidget {
  const ConditionDropdown({
    super.key,
    required this.editable,
    required this.onChanged,
    required this.value,
  });

  final bool editable;
  final String? value;
  final void Function(ConditionDropdownOption?) onChanged;

  static final options = [
    ConditionDropdownOption(
      label: 'None',
      value: null,
    ),
    ConditionDropdownOption(
      label: 'Like New',
      value: 'Like New',
    ),
    ConditionDropdownOption(
      label: 'Lightly Used',
      value: 'Lightly Used',
    ),
    ConditionDropdownOption(
      label: 'Heavily Used',
      value: 'Heavily Used',
    ),
    ConditionDropdownOption(
      label: 'Damaged',
      value: 'Damaged',
      hidden: true,
    ),
    ConditionDropdownOption(
      label: 'In Repair',
      value: 'In Repair',
      hidden: true,
    ),
  ];

  static bool isDamagedCondition(String? value) {
    return value == 'Damaged' || value == 'In Repair';
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ConditionDropdownOption>(
      decoration: const InputDecoration(
        labelText: 'Condition',
      ),
      items: editable
          ? options
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Row(
                      children: [
                        Text(option.label),
                        const SizedBox(width: 16.0),
                        if (option.hidden != null && option.hidden!)
                          const HintText('Hidden'),
                      ],
                    ),
                  ))
              .toList()
          : null,
      onChanged: onChanged,
      value: options.firstWhere((i) => i.value == value),
    );
  }
}

class ConditionDropdownOption {
  final String label;
  final String? value;
  final bool? hidden;

  ConditionDropdownOption({
    required this.label,
    required this.value,
    this.hidden,
  });
}
