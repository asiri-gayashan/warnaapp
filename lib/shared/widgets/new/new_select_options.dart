import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class NewSelectOptions extends StatefulWidget {
  final String label;
  final List<Map<String, String>> items; // [{id: '...', name: '...'}]
  final String? value; // holds the selected ID
  final Function(String) onChanged; // returns ID

  const NewSelectOptions({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
  });

  @override
  State<NewSelectOptions> createState() => _NewSelectOptionsState();
}

class _NewSelectOptionsState extends State<NewSelectOptions> {

  // Helper: get name from id for display
  String? get _selectedName {
    if (widget.value == null) return null;
    final match = widget.items.firstWhere(
      (item) => item['id'] == widget.value,
      orElse: () => {},
    );
    return match['name'];
  }

  void _openSelectSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return SafeArea(
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.5,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Text(
                      "Select ${widget.label}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          final item = widget.items[index];
                          final id = item['id']!;
                          final name = item['name']!;

                          return ListTile(
                            title: Text(name),
                            trailing: widget.value == id
                                ? Icon(Icons.check, color: AppColors.primary)
                                : null,
                            onTap: () {
                              widget.onChanged(id); // returns ID
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
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
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _openSelectSheet,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.secondary.withOpacity(0.4),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedName ?? "Select",
                  style: TextStyle(
                    color: _selectedName == null
                        ? AppColors.textSecondary
                        : Colors.black,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: AppColors.secondary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}