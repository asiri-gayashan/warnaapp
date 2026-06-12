import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_institute_page_controller.dart';
import 'package:warna_app/presentation/tutor/screens/institute/tutor_institute_detail_page.dart';
import 'package:warna_app/shared/widgets/new/custom_textfield.dart';
import 'package:warna_app/shared/widgets/new/empty_list_state.dart';
import 'package:warna_app/shared/widgets/new/info_badge.dart';
import 'package:warna_app/shared/widgets/new/new_select_options.dart';
import 'package:warna_app/shared/widgets/new/user_list_card.dart';

const List<String> tutorInstituteStatusOptions = [
  'ACTIVE',
  'INACTIVE',
  'PENDING',
];

// ============================================================
// FILTER RESULT
// ============================================================

class _FilterResult {
  final String? district;
  final String? status;
  final int? minClasses;
  final int? maxClasses;

  const _FilterResult({
    this.district,
    this.status,
    this.minClasses,
    this.maxClasses,
  });
}

// ============================================================
// FILTER SHEET — self-contained StatefulWidget
// ============================================================

class _InstituteFilterSheet extends StatefulWidget {
  final String? initialDistrict;
  final String? initialStatus;
  final int? initialMinClasses;
  final int? initialMaxClasses;

  const _InstituteFilterSheet({
    this.initialDistrict,
    this.initialStatus,
    this.initialMinClasses,
    this.initialMaxClasses,
  });

  @override
  State<_InstituteFilterSheet> createState() => _InstituteFilterSheetState();
}

class _InstituteFilterSheetState extends State<_InstituteFilterSheet> {
  String? _district;
  String? _status;

  late final TextEditingController _minClassesCtrl;
  late final TextEditingController _maxClassesCtrl;

  @override
  void initState() {
    super.initState();
    _district = widget.initialDistrict;
    _status = widget.initialStatus;
    _minClassesCtrl = TextEditingController(
      text: widget.initialMinClasses?.toString() ?? '',
    );
    _maxClassesCtrl = TextEditingController(
      text: widget.initialMaxClasses?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _minClassesCtrl.dispose();
    _maxClassesCtrl.dispose();
    super.dispose();
  }

  void _clearAll() {
    setState(() {
      _district = null;
      _status = null;
      _minClassesCtrl.clear();
      _maxClassesCtrl.clear();
    });
  }

  void _apply() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop(
      _FilterResult(
        district: _district,
        status: _status,
        minClasses: _minClassesCtrl.text.isNotEmpty
            ? int.tryParse(_minClassesCtrl.text)
            : null,
        maxClasses: _maxClassesCtrl.text.isNotEmpty
            ? int.tryParse(_maxClassesCtrl.text)
            : null,
      ),
    );
  }

  Widget _rangeField({
    required String label,
    required TextEditingController ctrl,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 4),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xffDDDDDD),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter Institutes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff1A1A2E),
                      ),
                    ),
                    TextButton(
                      onPressed: _clearAll,
                      child: const Text(
                        'Clear All',
                        style: TextStyle(color: Color(0xff185FA5)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // District
                    NewSelectOptions(
                      label: "District",
                      value: _district,
                      items: tutorInstituteDistrictsList,
                      onChanged: (id) => setState(() => _district = id),
                    ),
                    const SizedBox(height: 20),

                    // Status
                    const _FilterSectionLabel('Status'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tutorInstituteStatusOptions.map((status) {
                        final isSelected = _status == status;
                        return ChoiceChip(
                          label: Text(status),
                          selected: isSelected,
                          onSelected: (selected) =>
                              setState(() => _status = selected ? status : null),
                          selectedColor: AppColors.primary.withOpacity(0.15),
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // My classes range
                    const _FilterSectionLabel('My Classes (Count)'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _rangeField(
                            label: 'Min',
                            ctrl: _minClassesCtrl,
                            hint: '0',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _rangeField(
                            label: 'Max',
                            ctrl: _maxClassesCtrl,
                            hint: '10',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              // Apply button
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Color(0xffEEEEEE))),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _apply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================
// MAIN PAGE
// ============================================================

class TutorInstitutesPage extends StatefulWidget {
  const TutorInstitutesPage({Key? key}) : super(key: key);

  @override
  State<TutorInstitutesPage> createState() => _TutorInstitutesPageState();
}

class _TutorInstitutesPageState extends State<TutorInstitutesPage> {
  late TutorInstitutePageController controller;
  bool isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = TutorInstitutePageController();
    _loadData();
  }

  Future<void> _loadData() async {
    final success = await controller.fetchInstitutes();
    if (!success) debugPrint("Failed to load institutes data");
    if (mounted) setState(() => isLoading = false);
  }

  Future<void> _openFilterSheet() async {
    final result = await showModalBottomSheet<_FilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => _InstituteFilterSheet(
        initialDistrict: controller.selectedDistrict,
        initialStatus: controller.selectedStatus,
        initialMinClasses: controller.minClasses,
        initialMaxClasses: controller.maxClasses,
      ),
    );

    if (result != null && mounted) {
      controller.applyFilters(
        district: result.district,
        status: result.status,
        minClasses: result.minClasses,
        maxClasses: result.maxClasses,
      );
      setState(() {});
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    controller.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return AppColors.success;
      case 'PENDING':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final pageItems = controller.currentPageItems;
        final filteredCount = controller.filteredInstitutes.length;
        final activeFilterCount = controller.activeFilterCount;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text(
              'My Institutes',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                  slivers: [
                    // ── Search + filter bar ──────────────────────────
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: '',
                                hintText: 'Search institutes...',
                                controller: _searchController,
                                isRequired: false,
                                onChanged: (value) {
                                  controller.onSearchChanged(value);
                                  if (mounted) setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.only(top: 28),
                              child: GestureDetector(
                                onTap: _openFilterSheet,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: activeFilterCount > 0
                                            ? AppColors.primary.withOpacity(0.1)
                                            : const Color(0xffF5F7FB),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: activeFilterCount > 0
                                              ? AppColors.primary
                                              : const Color(0xffE5E5E5),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.tune_rounded,
                                        size: 20,
                                        color: activeFilterCount > 0
                                            ? AppColors.primary
                                            : const Color(0xff888888),
                                      ),
                                    ),
                                    if (activeFilterCount > 0)
                                      Positioned(
                                        top: -6,
                                        right: -6,
                                        child: Container(
                                          width: 18,
                                          height: 18,
                                          decoration: const BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            '$activeFilterCount',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Active filter indicator ──────────────────────
                    if (activeFilterCount > 0)
                      SliverToBoxAdapter(
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.filter_alt_outlined,
                                size: 14,
                                color: Color(0xff888888),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'Filters applied:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff888888),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$activeFilterCount active',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  controller.clearFilters();
                                  if (mounted) setState(() {});
                                },
                                child: const Text(
                                  'Clear all',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xffE53935),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SliverToBoxAdapter(
                      child: Divider(height: 1, color: Color(0xffEEEEEE)),
                    ),

                    // ── Empty state ──────────────────────────────────
                    if (filteredCount == 0)
                      const SliverFillRemaining(
                        child: EmptyListState(
                          icon: Icons.apartment_outlined,
                          title: 'No institutes found',
                          subtitle: 'Try adjusting your search or filters',
                        ),
                      )
                    else ...[
                      // ── Cards ──────────────────────────────────────
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final institute = pageItems[index];
                            return UserListCard(
                              name: institute.fullName,
                              title: institute.districtName,
                              titleColor: AppColors.primary,
                              subtitle: institute.phone,
                              trailingIcon: Icons.arrow_forward_ios,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TutorInstituteDetailPage(
                                      institute: institute,
                                    ),
                                  ),
                                );
                              },
                              badges: [
                                InfoBadge(
                                  icon: Icons.groups_outlined,
                                  text: '${institute.totalTutors} Tutors',
                                  color: AppColors.info,
                                ),
                                InfoBadge(
                                  icon: Icons.people_outline,
                                  text: '${institute.totalStudents} Students',
                                  color: AppColors.secondary,
                                ),
                               
                              ],
                            );
                          }, childCount: pageItems.length),
                        ),
                      ),

                      // ── Pagination ─────────────────────────────────
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: _PaginationBar(
                            currentPage: controller.currentPage,
                            totalPages: controller.totalPages,
                            onPageChanged: (page) {
                              controller.goToPage(page);
                              if (mounted) setState(() {});
                            },
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
        );
      },
    );
  }
}

// ============================================================
// HELPERS
// ============================================================

class _FilterSectionLabel extends StatelessWidget {
  final String text;
  const _FilterSectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xff444444),
        letterSpacing: 0.3,
      ),
    );
  }
}

// ============================================================
// PAGINATION BAR
// ============================================================

class _PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const _PaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  List<dynamic> _buildPageItems() {
    if (totalPages <= 7) return List.generate(totalPages, (i) => i);
    final items = <dynamic>[];
    items.add(0);
    if (currentPage > 3) items.add('...');
    for (
      int i = (currentPage - 1).clamp(1, totalPages - 2);
      i <= (currentPage + 1).clamp(1, totalPages - 2);
      i++
    ) {
      items.add(i);
    }
    if (currentPage < totalPages - 4) items.add('...');
    items.add(totalPages - 1);
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final pageItems = _buildPageItems();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          Text(
            'Page ${currentPage + 1} of $totalPages',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xff999999),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ModernNavButton(
                icon: Icons.arrow_back_ios_new_rounded,
                enabled: currentPage > 0,
                onTap: () => onPageChanged(currentPage - 1),
              ),
              const SizedBox(width: 6),
              ...pageItems.map((item) {
                if (item == '...') {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '···',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xffAAAAAA),
                        letterSpacing: 1,
                      ),
                    ),
                  );
                }
                final page = item as int;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: _ModernPageButton(
                    page: page,
                    isSelected: page == currentPage,
                    onTap: () => onPageChanged(page),
                  ),
                );
              }),
              const SizedBox(width: 6),
              _ModernNavButton(
                icon: Icons.arrow_forward_ios_rounded,
                enabled: currentPage < totalPages - 1,
                onTap: () => onPageChanged(currentPage + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModernNavButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _ModernNavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: enabled ? Colors.white : const Color(0xffF5F5F5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled ? const Color(0xffDDE3F0) : const Color(0xffEEEEEE),
          ),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: const Color(0xff185FA5).withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Icon(
          icon,
          size: 14,
          color: enabled ? AppColors.primary : const Color(0xffCCCCCC),
        ),
      ),
    );
  }
}

class _ModernPageButton extends StatelessWidget {
  final int page;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModernPageButton({
    required this.page,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xffDDE3F0),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        alignment: Alignment.center,
        child: Text(
          '${page + 1}',
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xff555555),
          ),
        ),
      ),
    );
  }
}
