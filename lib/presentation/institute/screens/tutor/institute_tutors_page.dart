import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/core/constants/select_options.dart';
import 'package:warna_app/data/repositories/metadata_repository.dart';
import 'package:warna_app/presentation/institute/controllers/tutor_page_controller.dart';
import 'package:warna_app/presentation/institute/screens/tutor/tutor_detail_page.dart';
import 'package:warna_app/shared/widgets/new/custom_textfield.dart';
import 'package:warna_app/shared/widgets/new/empty_list_state.dart';
import 'package:warna_app/shared/widgets/new/info_badge.dart';
import 'package:warna_app/shared/widgets/new/new_select_options.dart';
import 'package:warna_app/shared/widgets/new/user_list_card.dart';

const List<String> tutorStatusOptions = [
  'ACTIVE',
  'INACTIVE',
  'PENDING',
  'APPROVED',
  'REJECTED',
];

// ============================================================
// FILTER RESULT — passed back from the sheet
// ============================================================

class _FilterResult {
  final String? subject;
  final String? district;
  final String? grade;
  final String? status;
  final int? minStudentCount;
  final int? maxStudentCount;
  final int? minClassCount;
  final int? maxClassCount;

  const _FilterResult({
    this.subject,
    this.district,
    this.grade,
    this.status,
    this.minStudentCount,
    this.maxStudentCount,
    this.minClassCount,
    this.maxClassCount,
  });
}

// ============================================================
// FILTER SHEET WIDGET — completely self-contained StatefulWidget
// This is the KEY fix: isolating GlobalKey-heavy children into
// their own widget tree so keys never clash with the page tree.
// ============================================================

class _TutorFilterSheet extends StatefulWidget {
  final List<Map<String, String>> subjectsList;
  final List<Map<String, String>> districtsList;
  final String? initialSubject;
  final String? initialDistrict;
  final String? initialGrade;
  final String? initialStatus;
  final int? initialMinStudent;
  final int? initialMaxStudent;
  final int? initialMinClass;
  final int? initialMaxClass;

  const _TutorFilterSheet({
    required this.subjectsList,
    required this.districtsList,
    this.initialSubject,
    this.initialDistrict,
    this.initialGrade,
    this.initialStatus,
    this.initialMinStudent,
    this.initialMaxStudent,
    this.initialMinClass,
    this.initialMaxClass,
  });

  @override
  State<_TutorFilterSheet> createState() => _TutorFilterSheetState();
}

class _TutorFilterSheetState extends State<_TutorFilterSheet> {
  String? _subject;
  String? _district;
  String? _grade;
  String? _status;

  late final TextEditingController _minStudentCtrl;
  late final TextEditingController _maxStudentCtrl;
  late final TextEditingController _minClassCtrl;
  late final TextEditingController _maxClassCtrl;

  @override
  void initState() {
    super.initState();
    _subject = widget.initialSubject;
    _district = widget.initialDistrict;
    _grade = widget.initialGrade;
    _status = widget.initialStatus;
    _minStudentCtrl =
        TextEditingController(text: widget.initialMinStudent?.toString() ?? '');
    _maxStudentCtrl =
        TextEditingController(text: widget.initialMaxStudent?.toString() ?? '');
    _minClassCtrl =
        TextEditingController(text: widget.initialMinClass?.toString() ?? '');
    _maxClassCtrl =
        TextEditingController(text: widget.initialMaxClass?.toString() ?? '');
  }

  @override
  void dispose() {
    _minStudentCtrl.dispose();
    _maxStudentCtrl.dispose();
    _minClassCtrl.dispose();
    _maxClassCtrl.dispose();
    super.dispose();
  }

  void _clearAll() {
    setState(() {
      _subject = null;
      _district = null;
      _grade = null;
      _status = null;
      _minStudentCtrl.clear();
      _maxStudentCtrl.clear();
      _minClassCtrl.clear();
      _maxClassCtrl.clear();
    });
  }

  void _apply() {
    // Dismiss keyboard first so IME callbacks fire while controllers still live
    FocusScope.of(context).unfocus();

    final result = _FilterResult(
      subject: _subject,
      district: _district,
      grade: _grade,
      status: _status,
      minStudentCount: _minStudentCtrl.text.isNotEmpty
          ? int.tryParse(_minStudentCtrl.text)
          : null,
      maxStudentCount: _maxStudentCtrl.text.isNotEmpty
          ? int.tryParse(_maxStudentCtrl.text)
          : null,
      minClassCount: _minClassCtrl.text.isNotEmpty
          ? int.tryParse(_minClassCtrl.text)
          : null,
      maxClassCount: _maxClassCtrl.text.isNotEmpty
          ? int.tryParse(_maxClassCtrl.text)
          : null,
    );

    Navigator.of(context).pop(result);
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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter Tutors',
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
              // Scrollable filter fields
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Subject
                    NewSelectOptions(
                      label: "Subject",
                      value: _subject,
                      items: widget.subjectsList,
                      onChanged: (id) => setState(() => _subject = id),
                    ),
                    const SizedBox(height: 20),

                    // District
                    NewSelectOptions(
                      label: "District",
                      value: _district,
                      items: widget.districtsList,
                      onChanged: (id) => setState(() => _district = id),
                    ),
                    const SizedBox(height: 20),

                    // Grade
                    NewSelectOptions(
                      label: "Grade",
                      value: _grade,
                      items: SelectOptions.newgradesList,
                      onChanged: (id) => setState(() => _grade = id),
                    ),
                    const SizedBox(height: 20),

                    // Status chips
                    const _FilterSectionLabel('Status'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tutorStatusOptions.map((status) {
                        final isSelected = _status == status;
                        return GestureDetector(
                          onTap: () => setState(
                            () => _status = isSelected ? null : status,
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : const Color(0xffF5F7FB),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : const Color(0xffDDDDDD),
                              ),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xff555555),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Student count range
                    const _FilterSectionLabel('Student Count'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _rangeField(
                            label: 'Min',
                            ctrl: _minStudentCtrl,
                            hint: '0',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _rangeField(
                            label: 'Max',
                            ctrl: _maxStudentCtrl,
                            hint: '100',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Class count range
                    const _FilterSectionLabel('Class Count'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _rangeField(
                            label: 'Min',
                            ctrl: _minClassCtrl,
                            hint: '0',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _rangeField(
                            label: 'Max',
                            ctrl: _maxClassCtrl,
                            hint: '50',
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
                  border:
                      Border(top: BorderSide(color: Color(0xffEEEEEE))),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _apply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
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

class InstituteTutorsPage extends StatefulWidget {
  const InstituteTutorsPage({Key? key}) : super(key: key);

  @override
  State<InstituteTutorsPage> createState() => _InstituteTutorsPageState();
}

class _InstituteTutorsPageState extends State<InstituteTutorsPage> {
  late TutorPageController controller;
  List<Map<String, String>> subjectsList = [];
  List<Map<String, String>> districtsList = [];
  bool isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = TutorPageController();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    await Future.wait([loadTutorData(), loadMetaData()]);
  }

  Future<void> loadTutorData() async {
    final success = await controller.fetchTutors();
    if (!success) debugPrint("Failed to load tutors data");
    if (mounted) setState(() => isLoading = false);
  }

  Future<void> loadMetaData() async {
    await Future.wait([fetchSubjects(), fetchDistricts()]);
  }

  Future<void> fetchSubjects() async {
    final rawSubjects = await MetadataRepository().getSubjects();
    if (!mounted) return;
    if (rawSubjects != null) {
      setState(() {
        subjectsList = rawSubjects
            .map((s) =>
                {"id": s["id"].toString(), "name": s["name"].toString()})
            .toList();
      });
    }
  }

  Future<void> fetchDistricts() async {
    final rawDistricts = await MetadataRepository().getDistricts();
    if (!mounted) return;
    if (rawDistricts != null) {
      setState(() {
        districtsList = rawDistricts
            .map((d) =>
                {"id": d["id"].toString(), "name": d["name"].toString()})
            .toList();
      });
    }
  }

  // ── Open filter sheet ─────────────────────────────────────────
  // The sheet is now a proper StatefulWidget — no GlobalKey conflicts,
  // no controller lifetime issues.
  Future<void> _openFilterSheet() async {
    final result = await showModalBottomSheet<_FilterResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // useSafeArea keeps the sheet from going under system bars
      useSafeArea: true,
      builder: (_) => _TutorFilterSheet(
        subjectsList: subjectsList,
        districtsList: districtsList,
        initialSubject: controller.selectedSubject,
        initialDistrict: controller.selectedDistrict,
        initialGrade: controller.selectedGrade,
        initialStatus: controller.selectedStatus,
        initialMinStudent: controller.minStudentCount,
        initialMaxStudent: controller.maxStudentCount,
        initialMinClass: controller.minClassCount,
        initialMaxClass: controller.maxClassCount,
      ),
    );

    if (result != null && mounted) {
      controller.applyFilters(
        subject: result.subject,
        district: result.district,
        grade: result.grade,
        status: result.status,
        minStudentCount: result.minStudentCount,
        maxStudentCount: result.maxStudentCount,
        minClassCount: result.minClassCount,
        maxClassCount: result.maxClassCount,
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final pageItems = controller.currentPageItems;
        final filteredCount = controller.filteredTutors.length;
        final activeFilterCount = controller.activeFilterCount;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text(
              'My Tutors',
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
                                hintText: 'Search tutors...',
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
                                            ? AppColors.primary
                                                .withOpacity(0.1)
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
                                    fontSize: 12,
                                    color: Color(0xff888888)),
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
                      child:
                          Divider(height: 1, color: Color(0xffEEEEEE)),
                    ),

                    // ── Empty state ──────────────────────────────────
                    if (filteredCount == 0)
                      const SliverFillRemaining(
                        child: EmptyListState(
                          icon: Icons.person_search_outlined,
                          title: 'No tutors found',
                          subtitle:
                              'Try adjusting your search or filters',
                        ),
                      )
                    else ...[
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final tutor = pageItems[index];
                              return UserListCard(
                                name: tutor.fullName,
                                title: tutor.subjectName,
                                titleColor: AppColors.primary,
                                subtitle:
                                    '${tutor.phone} • ${tutor.districtName}',
                                trailingIcon: Icons.arrow_forward_ios,
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => TutorDetailPage(
                                          tutor: tutor.toMap()),
                                    ),
                                  );
                                  if (result == true && mounted) {
                                    setState(() => isLoading = true);
                                    await loadTutorData();
                                  }
                                },
                                badges: [
                                  InfoBadge(
                                    icon: Icons.video_call,
                                    text: '${tutor.classCount} Classes',
                                    color: AppColors.info,
                                  ),
                                  InfoBadge(
                                    icon: Icons.people_outline,
                                    text:
                                        '${tutor.studentCount} Students',
                                    color: AppColors.primary,
                                  ),
                                ],
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
            color: enabled
                ? const Color(0xffDDE3F0)
                : const Color(0xffEEEEEE),
          ),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: const Color(0xff185FA5).withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Icon(icon,
            size: 14,
            color: enabled
                ? AppColors.primary
                : const Color(0xffCCCCCC)),
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
            color: isSelected
                ? AppColors.primary
                : const Color(0xffDDE3F0),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  )
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