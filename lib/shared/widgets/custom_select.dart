import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CustomSelect extends StatefulWidget {
  final String label;
  final String hintText;
  final String? value;
  final List<SelectOption> options;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;
  final bool isRequired;
  final bool isSearchable;
  final String? searchHint;
  final Widget? prefixIcon;
  final bool enabled;

  const CustomSelect({
    Key? key,
    required this.label,
    required this.hintText,
    required this.value,
    required this.options,
    required this.onChanged,
    this.validator,
    this.isRequired = false,
    this.isSearchable = false,
    this.searchHint,
    this.prefixIcon,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<CustomSelect> createState() => _CustomSelectState();
}

class _CustomSelectState extends State<CustomSelect> {
  final TextEditingController _searchController = TextEditingController();
  List<SelectOption> _filteredOptions = [];

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.options;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didUpdateWidget(CustomSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.options != oldWidget.options) {
      _filteredOptions = widget.options;
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredOptions = widget.options.where((option) {
        return option.label.toLowerCase().contains(query) ||
            (option.searchKeywords?.any((keyword) =>
                keyword.toLowerCase().contains(query)) ??
                false);
      }).toList();
    });
  }

  void _showSelectModal(BuildContext context) {
    if (!widget.enabled) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _SelectModal(
          title: widget.label,
          options: _filteredOptions,
          selectedValue: widget.value,
          onChanged: (value) {
            widget.onChanged(value);
            Navigator.pop(context);
          },
          isSearchable: widget.isSearchable,
          searchHint: widget.searchHint,
          searchController: _searchController,
        );
      },
    ).whenComplete(() {
      _searchController.clear();
      _filteredOptions = widget.options;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedOption = widget.options
        .firstWhere((option) => option.value == widget.value,
        orElse: () => SelectOption(value: '', label: ''));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        RichText(
          text: TextSpan(
            text: widget.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            children: [
              if (widget.isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: AppColors.error,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Select Field
        GestureDetector(
          onTap: () => _showSelectModal(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: widget.enabled ? AppColors.surface : AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.border,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                if (widget.prefixIcon != null) ...[
                  widget.prefixIcon!,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    widget.value != null && widget.value!.isNotEmpty
                        ? selectedOption.label
                        : widget.hintText,
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.value != null && widget.value!.isNotEmpty
                          ? AppColors.textPrimary
                          : AppColors.textDisabled,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: widget.enabled
                      ? AppColors.textPrimary
                      : AppColors.textDisabled,
                ),
              ],
            ),
          ),
        ),

        // Error Message (if any)
        if (widget.validator != null && widget.value != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              widget.validator!(widget.value) ?? '',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.error,
              ),
            ),
          ),
      ],
    );
  }
}

// Modal for selecting options
class _SelectModal extends StatefulWidget {
  final String title;
  final List<SelectOption> options;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final bool isSearchable;
  final String? searchHint;
  final TextEditingController searchController;

  const _SelectModal({
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    required this.isSearchable,
    this.searchHint,
    required this.searchController,
  });

  @override
  __SelectModalState createState() => __SelectModalState();
}

class __SelectModalState extends State<_SelectModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),

          // Search Field (if searchable)
          if (widget.isSearchable) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: widget.searchController,
                decoration: InputDecoration(
                  hintText: widget.searchHint ?? 'Search...',
                  border: InputBorder.none,
                  icon: const Icon(Icons.search, size: 20),
                ),
              ),
            ),
          ],

          // Options List
          const SizedBox(height: 20),
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: widget.options.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No options found',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              itemCount: widget.options.length,
              itemBuilder: (context, index) {
                final option = widget.options[index];
                final isSelected = option.value == widget.selectedValue;

                return ListTile(
                  onTap: () => widget.onChanged(option.value),
                  leading: option.icon != null
                      ? Icon(
                    option.icon,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  )
                      : null,
                  title: Text(
                    option.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                  )
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Select Option Model
class SelectOption {
  final String value;
  final String label;
  final IconData? icon;
  final List<String>? searchKeywords;

  const SelectOption({
    required this.value,
    required this.label,
    this.icon,
    this.searchKeywords,
  });

  @override
  String toString() => label;
}

// Multi-Select Variant
class CustomMultiSelect extends StatefulWidget {
  final String label;
  final String hintText;
  final List<String> selectedValues;
  final List<SelectOption> options;
  final ValueChanged<List<String>> onChanged;
  final bool isRequired;
  final bool isSearchable;
  final String? searchHint;

  const CustomMultiSelect({
    Key? key,
    required this.label,
    required this.hintText,
    required this.selectedValues,
    required this.options,
    required this.onChanged,
    this.isRequired = false,
    this.isSearchable = false,
    this.searchHint,
  }) : super(key: key);

  @override
  State<CustomMultiSelect> createState() => _CustomMultiSelectState();
}

class _CustomMultiSelectState extends State<CustomMultiSelect> {
  final TextEditingController _searchController = TextEditingController();
  List<SelectOption> _filteredOptions = [];

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.options;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredOptions = widget.options.where((option) {
        return option.label.toLowerCase().contains(query) ||
            (option.searchKeywords?.any((keyword) =>
                keyword.toLowerCase().contains(query)) ??
                false);
      }).toList();
    });
  }

  void _toggleSelection(String value) {
    final newValues = List<String>.from(widget.selectedValues);
    if (newValues.contains(value)) {
      newValues.remove(value);
    } else {
      newValues.add(value);
    }
    widget.onChanged(newValues);
  }

  void _showSelectModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _MultiSelectModal(
          title: widget.label,
          options: _filteredOptions,
          selectedValues: widget.selectedValues,
          onToggle: _toggleSelection,
          isSearchable: widget.isSearchable,
          searchHint: widget.searchHint,
          searchController: _searchController,
        );
      },
    ).whenComplete(() {
      _searchController.clear();
      _filteredOptions = widget.options;
    });
  }

  String _getDisplayText() {
    if (widget.selectedValues.isEmpty) {
      return widget.hintText;
    }

    final selectedLabels = widget.options
        .where((option) => widget.selectedValues.contains(option.value))
        .map((option) => option.label)
        .toList();

    if (selectedLabels.length <= 2) {
      return selectedLabels.join(', ');
    } else {
      return '${selectedLabels.take(2).join(', ')} +${selectedLabels.length - 2} more';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        RichText(
          text: TextSpan(
            text: widget.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            children: [
              if (widget.isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: AppColors.error,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Select Field
        GestureDetector(
          onTap: () => _showSelectModal(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.border,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _getDisplayText(),
                    style: TextStyle(
                      fontSize: 16,
                      color: widget.selectedValues.isNotEmpty
                          ? AppColors.textPrimary
                          : AppColors.textDisabled,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textPrimary,
                ),
              ],
            ),
          ),
        ),

        // Selected Tags (if any)
        if (widget.selectedValues.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.selectedValues.map((value) {
              final option = widget.options
                  .firstWhere((opt) => opt.value == value);
              return Chip(
                label: Text(option.label),
                onDeleted: () => _toggleSelection(value),
                deleteIcon: const Icon(Icons.close, size: 16),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

// Multi-Select Modal
class _MultiSelectModal extends StatefulWidget {
  final String title;
  final List<SelectOption> options;
  final List<String> selectedValues;
  final ValueChanged<String> onToggle;
  final bool isSearchable;
  final String? searchHint;
  final TextEditingController searchController;

  const _MultiSelectModal({
    required this.title,
    required this.options,
    required this.selectedValues,
    required this.onToggle,
    required this.isSearchable,
    this.searchHint,
    required this.searchController,
  });

  @override
  __MultiSelectModalState createState() => __MultiSelectModalState();
}

class __MultiSelectModalState extends State<_MultiSelectModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),

          // Search Field (if searchable)
          if (widget.isSearchable) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: widget.searchController,
                decoration: InputDecoration(
                  hintText: widget.searchHint ?? 'Search...',
                  border: InputBorder.none,
                  icon: const Icon(Icons.search, size: 20),
                ),
              ),
            ),
          ],

          // Options List
          const SizedBox(height: 20),
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: widget.options.isEmpty
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No options found',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              itemCount: widget.options.length,
              itemBuilder: (context, index) {
                final option = widget.options[index];
                final isSelected =
                widget.selectedValues.contains(option.value);

                return CheckboxListTile(
                  value: isSelected,
                  onChanged: (_) => widget.onToggle(option.value),
                  title: Text(
                    option.label,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  secondary: option.icon != null
                      ? Icon(
                    option.icon,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  )
                      : null,
                  controlAffinity: ListTileControlAffinity.leading,
                );
              },
            ),
          ),

          // Done Button
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}