import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/core/constants/select_options.dart';
import 'package:warna_app/data/repositories/metadata_repository.dart';
import 'package:warna_app/presentation/student/controllers/student_class_page_controller.dart';
import 'package:warna_app/presentation/student/screens/classes/student_class_detail_page.dart';
import 'package:warna_app/shared/widgets/field_error_text.dart';
import 'package:warna_app/shared/widgets/new/course_card.dart';
import 'package:warna_app/shared/widgets/new/custom_textfield.dart';
import 'package:warna_app/shared/widgets/new/new_select_options.dart';

// ============================================================
// MAIN PAGE
// ============================================================

class StudentClassesPage extends StatefulWidget {
  const StudentClassesPage({Key? key}) : super(key: key);

  @override
  State<StudentClassesPage> createState() => _StudentClassesPageState();
}

class _StudentClassesPageState extends State<StudentClassesPage> {
  late StudentClassPageController controller;
  List<Map<String, String>> _subjectsList = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = StudentClassPageController();
    controller.fetchClasses();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    final raw = await MetadataRepository().getSubjects();
    if (raw != null && mounted) {
      setState(() {
        _subjectsList = raw
            .map((s) => {
                  'id': s['id'].toString(),
                  'name': s['name'].toString(),
                })
            .toList();
      });
    }
  }

  // ── Filter sheet ─────────────────────────────────────────────

  void _openFilterSheet() {
    String? tempDay = controller.selectedDay;
    String? tempSubject = controller.selectedSubject;
    String? tempGrade = controller.selectedGrade;
    String? tempStatus = controller.selectedStatus;
    String? tempType = controller.selectedType;
    TimeOfDay? tempStart = controller.startTime;
    TimeOfDay? tempEnd = controller.endTime;

    // Fee range — default to full range (0–20000)
    const double feeMin = 0;
    const double feeMax = 20000;
    double tempMinFee = controller.minFee ?? feeMin;
    double tempMaxFee = controller.maxFee ?? feeMax;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.9,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (_, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
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
                            horizontal: 20, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Filter Classes',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff1A1A2E),
                              ),
                            ),
                            TextButton(
                              onPressed: () => setSheetState(() {
                                tempDay = null;
                                tempSubject = null;
                                tempGrade = null;
                                tempStatus = null;
                                tempType = null;
                                tempStart = null;
                                tempEnd = null;
                                tempMinFee = feeMin;
                                tempMaxFee = feeMax;
                              }),
                              child: const Text(
                                'Clear All',
                                style: TextStyle(color: Color(0xff185FA5)),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Filter fields
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.all(20),
                          children: [
                            // ── Day ───────────────────────────────────
                            NewSelectOptions(
                              label: "Day",
                              value: tempDay,
                              items: SelectOptions.days,
                              onChanged: (id) =>
                                  setSheetState(() => tempDay = id),
                            ),
                            const SizedBox(height: 20),

                            // ── Subject ───────────────────────────────
                            NewSelectOptions(
                              label: "Subject",
                              value: tempSubject,
                              items: _subjectsList,
                              onChanged: (id) =>
                                  setSheetState(() => tempSubject = id),
                            ),
                            const SizedBox(height: 20),

                            // ── Grade ─────────────────────────────────
                            NewSelectOptions(
                              label: "Grade",
                              value: tempGrade,
                              items: SelectOptions.newgradesList,
                              onChanged: (id) =>
                                  setSheetState(() => tempGrade = id),
                            ),
                            const SizedBox(height: 20),

                            // ── Status ────────────────────────────────
                            const _FilterSectionLabel('Status'),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: studentClassStatusOptions.map((s) {
                                final isSelected = tempStatus == s;
                                return _FilterChip(
                                  label: s,
                                  isSelected: isSelected,
                                  onTap: () => setSheetState(
                                      () => tempStatus = isSelected ? null : s),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),

                            // ── Class Type ────────────────────────────
                            const _FilterSectionLabel('Class Type'),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: studentClassTypeOptions.map((opt) {
                                final isSelected = tempType == opt['id'];
                                return _FilterChip(
                                  label: opt['label']!,
                                  isSelected: isSelected,
                                  onTap: () => setSheetState(() =>
                                      tempType =
                                          isSelected ? null : opt['id']),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 20),

                            // ── Fee Range ─────────────────────────────
                            const _FilterSectionLabel('Fee Range (Rs.)'),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Rs. ${tempMinFee.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Rs. ${tempMaxFee.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: AppColors.primary,
                                inactiveTrackColor:
                                    AppColors.primary.withOpacity(0.15),
                                thumbColor: AppColors.primary,
                                overlayColor:
                                    AppColors.primary.withOpacity(0.12),
                                rangeThumbShape:
                                    const RoundRangeSliderThumbShape(
                                        enabledThumbRadius: 10),
                              ),
                              child: RangeSlider(
                                min: feeMin,
                                max: feeMax,
                                divisions: 200,
                                values: RangeValues(tempMinFee, tempMaxFee),
                                onChanged: (v) => setSheetState(() {
                                  tempMinFee = v.start;
                                  tempMaxFee = v.end;
                                }),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // ── Time Range ────────────────────────────
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTimePicker(
                                    label: 'Start Time',
                                    selectedTime: tempStart,
                                    onTap: () async {
                                      final picked = await showTimePicker(
                                        context: context,
                                        initialTime: tempStart ??
                                            const TimeOfDay(hour: 8, minute: 0),
                                      );
                                      if (picked != null) {
                                        setSheetState(() => tempStart = picked);
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTimePicker(
                                    label: 'End Time',
                                    selectedTime: tempEnd,
                                    onTap: () async {
                                      final picked = await showTimePicker(
                                        context: context,
                                        initialTime: tempEnd ??
                                            const TimeOfDay(
                                                hour: 10, minute: 0),
                                      );
                                      if (picked != null) {
                                        setSheetState(() => tempEnd = picked);
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (tempStart != null && tempEnd != null)
                              Builder(builder: (_) {
                                final s =
                                    tempStart!.hour * 60 + tempStart!.minute;
                                final e = tempEnd!.hour * 60 + tempEnd!.minute;
                                if (e <= s) {
                                  return const Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: FieldErrorText(
                                      message:
                                          'End time must be after start time',
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              }),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),

                      // Apply button
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              top: BorderSide(color: Color(0xffEEEEEE))),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (tempStart != null && tempEnd != null) {
                                final s =
                                    tempStart!.hour * 60 + tempStart!.minute;
                                final e = tempEnd!.hour * 60 + tempEnd!.minute;
                                if (e <= s) return;
                              }
                              controller.applyFilters(
                                day: tempDay,
                                subject: tempSubject,
                                grade: tempGrade,
                                status: tempStatus,
                                type: tempType,
                                startTime: tempStart,
                                endTime: tempEnd,
                                minFee: tempMinFee > feeMin ? tempMinFee : null,
                                maxFee: tempMaxFee < feeMax ? tempMaxFee : null,
                              );
                              setState(() {});
                              Navigator.pop(context);
                            },
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
          },
        );
      },
    );
  }

  // ── Time picker widget ───────────────────────────────────────

  Widget _buildTimePicker({
    required String label,
    required TimeOfDay? selectedTime,
    required VoidCallback onTap,
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
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedTime != null
                      ? selectedTime.format(context)
                      : 'Select Time',
                  style: TextStyle(
                    color: selectedTime != null
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const Icon(Icons.access_time,
                    color: AppColors.textSecondary, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Lifecycle ─────────────────────────────────────────────────

  @override
  void dispose() {
    _searchController.dispose();
    controller.dispose();
    super.dispose();
  }

  // ── Build ─────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final pageItems = controller.currentPageItems;
        final filteredCount = controller.filteredClasses.length;
        final activeFilterCount = controller.activeFilterCount;

        return Scaffold(
          backgroundColor: const Color(0xffF5F7FB),
          appBar: AppBar(
            title: const Text(
              'My Classes',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                  slivers: [
                    // ── Search + filter bar ──────────────────────────
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                label: '',
                                hintText: 'Search classes...',
                                controller: _searchController,
                                isRequired: true,
                                onChanged: (value) {
                                  controller.onSearchChanged(value);
                                  setState(() {});
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
                                        borderRadius:
                                            BorderRadius.circular(10),
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
                              left: 16, right: 16, bottom: 10),
                          child: Row(
                            children: [
                              const Icon(Icons.filter_alt_outlined,
                                  size: 14, color: Color(0xff888888)),
                              const SizedBox(width: 6),
                              const Text(
                                'Filters applied:',
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xff888888)),
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
                                  setState(() {});
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
                      SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off_rounded,
                                  size: 56, color: Colors.grey.shade300),
                              const SizedBox(height: 12),
                              const Text(
                                'No classes found',
                                style: TextStyle(
                                    color: Color(0xffAAAAAA), fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      )
                    else ...[
                      // ── Cards ──────────────────────────────────────
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final cls = pageItems[index];
                              return CourseCard(
                                title: cls.name,
                                subject: cls.subjectName,
                                grade: studentGradeName(cls.grade),
                                tutorName: cls.tutorName,
                                location: cls.location ?? '—',
                                day: studentDayName(cls.day),
                                time: cls.startTime,
                                duration: cls.duration,
                                studentCount: cls.studentCount,
                                dayColor: studentDayColor(cls.day),
                                dayBg: studentDayBg(cls.day),
                                onViewDetails: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => StudentClassDetailPage(
                                          classItemDetails: cls),
                                    ),
                                  ).then((_) => controller.fetchClasses());
                                },
                              );
                            },
                            childCount: pageItems.length,
                          ),
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
                              setState(() {});
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
// REUSABLE FILTER CHIP
// ============================================================

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : const Color(0xffF5F7FB),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xffDDDDDD),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xff555555),
            letterSpacing: 0.5,
          ),
        ),
      ),
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
    for (int i = (currentPage - 1).clamp(1, totalPages - 2);
        i <= (currentPage + 1).clamp(1, totalPages - 2);
        i++) {
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
                fontWeight: FontWeight.w400),
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
                    child: Text('···',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xffAAAAAA),
                            letterSpacing: 1)),
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
            color:
                enabled ? const Color(0xffDDE3F0) : const Color(0xffEEEEEE),
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
