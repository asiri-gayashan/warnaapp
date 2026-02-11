import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class CreativeSelect extends StatefulWidget {
  final String label;
  final List<String> items;
  final Function(String) onChanged;

  const CreativeSelect({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
  });

  @override
  State<CreativeSelect> createState() => _CreativeSelectState();
}

class _CreativeSelectState extends State<CreativeSelect> {
  String? selectedItem;

  void _openSelectSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.items.map((item) {
              return ListTile(
                title: Text(item),
                trailing: selectedItem == item
                    ? Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  setState(() => selectedItem = item);
                  widget.onChanged(item);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _openSelectSheet,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.secondary.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(selectedItem ?? "Select ${widget.label}"),
                Icon(Icons.keyboard_arrow_down,
                    color: AppColors.secondary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
