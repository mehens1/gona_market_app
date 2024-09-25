import 'package:flutter/material.dart';

class PrimaryDropdown<T> extends StatelessWidget {
  final String? hintText;
  final T? value;
  final List<T> items;
  final ValueChanged<T?>? onChanged;
  final String Function(T)? itemLabelBuilder;
  final EdgeInsetsGeometry? padding;
  final Color? dropdownColor;
  final double? borderRadius;
  final FormFieldValidator<T>? validator;

  const PrimaryDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hintText,
    this.itemLabelBuilder,
    this.padding,
    this.dropdownColor,
    this.borderRadius = 8.0,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveValue = value != null && items.contains(value) ? value : null;

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<T>(
        value: effectiveValue,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius!),
          ),
          hintText: hintText,
        ),
        dropdownColor: dropdownColor ?? Theme.of(context).colorScheme.surface,
        items: items.map<DropdownMenuItem<T>>((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(itemLabelBuilder?.call(item) ?? item.toString()),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
