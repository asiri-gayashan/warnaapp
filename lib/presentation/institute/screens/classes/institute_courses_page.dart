import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/core/constants/select_options.dart';
import 'package:warna_app/data/repositories/class_repository.dart';
import 'package:warna_app/data/models/class_model.dart';
import 'package:warna_app/presentation/institute/controllers/class_page_controller.dart';
import 'package:warna_app/presentation/institute/screens/classes/class_detail_page.dart';
import 'package:warna_app/router/router_names.dart';
import 'package:warna_app/shared/widgets/new/course_card.dart';
import 'package:warna_app/shared/widgets/new/custom_textfield.dart';
import 'package:warna_app/shared/widgets/new/new_select_options.dart';

// --- Data model ---
class CourseData {
  final String title;
  final String subject;
  final String grade;
  final String location;
  final String day;
  final String time;
  final String duration;
  final int studentCount;
  final Color dayColor;
  final Color dayBg;

  const CourseData({
    required this.title,
    required this.subject,
    required this.grade,
    required this.location,
    required this.day,
    required this.time,
    required this.duration,
    required this.studentCount,
    required this.dayColor,
    required this.dayBg,
  });
}

// --- Sample data ---
List<CourseData> sampleCourses = [
  CourseData(
    title: 'Science 2026',
    subject: 'Science',
    grade: 'Grade 11',
    location: 'Kurunegala',
    day: 'Monday',
    time: '10:30 AM',
    duration: '60 mins',
    studentCount: 8,
    dayColor: Color(0xff185FA5),
    dayBg: Color(0xffE8F2FF),
  ),
  CourseData(
    title: 'Pure Maths 2026',
    subject: 'Mathematics',
    grade: 'Grade 12',
    location: 'Colombo',
    day: 'Wednesday',
    time: '2:00 PM',
    duration: '90 mins',
    studentCount: 12,
    dayColor: Color(0xff0F6E56),
    dayBg: Color(0xffE1F5EE),
  ),
  CourseData(
    title: 'Physics 2026',
    subject: 'Physics',
    grade: 'Grade 11',
    location: 'Kandy',
    day: 'Friday',
    time: '9:00 AM',
    duration: '75 mins',
    studentCount: 6,
    dayColor: Color(0xff993C1D),
    dayBg: Color(0xffFAECE7),
  ),
  CourseData(
    title: 'Combined Maths',
    subject: 'Mathematics',
    grade: 'Grade 12',
    location: 'Gampaha',
    day: 'Tuesday',
    time: '3:30 PM',
    duration: '90 mins',
    studentCount: 15,
    dayColor: Color(0xff185FA5),
    dayBg: Color(0xffE8F2FF),
  ),
  CourseData(
    title: 'Chemistry 2026',
    subject: 'Chemistry',
    grade: 'Grade 11',
    location: 'Kurunegala',
    day: 'Thursday',
    time: '11:00 AM',
    duration: '60 mins',
    studentCount: 10,
    dayColor: Color(0xff0F6E56),
    dayBg: Color(0xffE1F5EE),
  ),
  CourseData(
    title: 'Chemistry 2026',
    subject: 'Chemistry',
    grade: 'Grade 11',
    location: 'Kurunegala',
    day: 'Thursday',
    time: '11:00 AM',
    duration: '60 mins',
    studentCount: 10,
    dayColor: Color(0xff0F6E56),
    dayBg: Color(0xffE1F5EE),
  ),
  CourseData(
    title: 'Chemistry 2026',
    subject: 'Chemistry',
    grade: 'Grade 11',
    location: 'Kurunegala',
    day: 'Thursday',
    time: '11:00 AM',
    duration: '60 mins',
    studentCount: 10,
    dayColor: Color(0xff0F6E56),
    dayBg: Color(0xffE1F5EE),
  ),
  CourseData(
    title: 'Biology 2026',
    subject: 'Biology',
    grade: 'Grade 12',
    location: 'Colombo',
    day: 'Saturday',
    time: '8:00 AM',
    duration: '120 mins',
    studentCount: 18,
    dayColor: Color(0xff993C1D),
    dayBg: Color(0xffFAECE7),
  ),
];

// --- Filter options ---
const List<Map<String, String>> dayItems = [
  {'id': 'monday', 'label': 'Monday'},
  {'id': 'tuesday', 'label': 'Tuesday'},
  {'id': 'wednesday', 'label': 'Wednesday'},
  {'id': 'thursday', 'label': 'Thursday'},
  {'id': 'friday', 'label': 'Friday'},
  {'id': 'saturday', 'label': 'Saturday'},
  {'id': 'sunday', 'label': 'Sunday'},
];

const List<Map<String, String>> subjectItems = [
  {'id': 'science', 'label': 'Science'},
  {'id': 'mathematics', 'label': 'Mathematics'},
  {'id': 'physics', 'label': 'Physics'},
  {'id': 'chemistry', 'label': 'Chemistry'},
  {'id': 'biology', 'label': 'Biology'},
];

const List<Map<String, String>> gradeItems = [
  {'id': 'grade_10', 'label': 'Grade 10'},
  {'id': 'grade_11', 'label': 'Grade 11'},
  {'id': 'grade_12', 'label': 'Grade 12'},
  {'id': 'grade_13', 'label': 'Grade 13'},
];

const List<String> statusOptions = [
  'ACTIVE',
  'INACTIVE',
  'PENDING',
  'APPROVED',
  'REJECTED',
];

// ============================================================
// MAIN PAGE
// ============================================================

class InstituteCoursesPage extends StatefulWidget {
  const InstituteCoursesPage({Key? key}) : super(key: key);

  @override
  State<InstituteCoursesPage> createState() => _InstituteCoursesPageState();
}

class _InstituteCoursesPageState extends State<InstituteCoursesPage> {
  List<ClassModel> ClassesData = [];

  static const int _itemsPerPage = 4;
  int _currentPage = 0;
  bool isLoading = true;

  late ClassPageController controller = ClassPageController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  String? _selectedDay;
  String? _selectedSubject;
  String? _selectedGrade;
  String? _selectedStatus;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    loadClassData();
  }

  Future<void> loadClassData() async {
    final rawClassesData = await ClassRepository().getClasses();

    if (rawClassesData != null) {
      ClassesData = rawClassesData
          .map<ClassModel>((e) => ClassModel.fromJson(e))
          .toList();
      // print(rawClassesData);
      isLoading = false;
      print(ClassesData);
    } else {
      print("Failed to load classes data");
    }
  }

  int get _activeFilterCount {
    int count = 0;
    if (_selectedDay != null) count++;
    if (_selectedSubject != null) count++;
    if (_selectedGrade != null) count++;
    if (_selectedStatus != null) count++;
    if (_startTime != null || _endTime != null) count++;
    return count;
  }

  List<CourseData> get _filteredCourses {
    return sampleCourses.where((course) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          course.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          course.subject.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesDay =
          _selectedDay == null ||
          course.day.toLowerCase() == _selectedDay!.toLowerCase();
      final matchesSubject =
          _selectedSubject == null ||
          course.subject.toLowerCase() == _selectedSubject!.toLowerCase();
      final matchesGrade =
          _selectedGrade == null ||
          course.grade.toLowerCase().replaceAll(' ', '_') ==
              _selectedGrade!.toLowerCase();
      return matchesSearch && matchesDay && matchesSubject && matchesGrade;
    }).toList();
  }

  int get _totalPages =>
      (_filteredCourses.length / _itemsPerPage).ceil().clamp(1, 999);

  List<CourseData> get _currentPageItems {
    if (_filteredCourses.isEmpty) return [];
    final start = _currentPage * _itemsPerPage;
    final end = (start + _itemsPerPage).clamp(0, _filteredCourses.length);
    return _filteredCourses.sublist(start, end);
  }

  void _goToPage(int page) {
    if (page < 0 || page >= _totalPages) return;
    setState(() => _currentPage = page);
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      _currentPage = 0;
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedDay = null;
      _selectedSubject = null;
      _selectedGrade = null;
      _selectedStatus = null;
      _startTime = null;
      _endTime = null;
      _currentPage = 0;
    });
  }

  void _openFilterSheet() {
    String? tempDay = _selectedDay;
    String? tempSubject = _selectedSubject;
    String? tempGrade = _selectedGrade;
    String? tempStatus = _selectedStatus;
    TimeOfDay? tempStart = _startTime;
    TimeOfDay? tempEnd = _endTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Future<void> pickTime(bool isStart) async {
              final picked = await showTimePicker(
                context: context,
                initialTime: isStart
                    ? (tempStart ?? const TimeOfDay(hour: 8, minute: 0))
                    : (tempEnd ?? const TimeOfDay(hour: 10, minute: 0)),
              );
              if (picked != null) {
                setSheetState(() {
                  if (isStart)
                    tempStart = picked;
                  else
                    tempEnd = picked;
                });
              }
            }

            return DraggableScrollableSheet(
              initialChildSize: 0.85,
              minChildSize: 0.5,
              maxChildSize: 0.95,
              builder: (_, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
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
                                tempStart = null;
                                tempEnd = null;
                              }),
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
                            NewSelectOptions(
                              label: 'Day',
                              value: tempDay,
                              items: dayItems,
                              onChanged: (id) =>
                                  setSheetState(() => tempDay = id),
                            ),
                            const SizedBox(height: 20),
                            NewSelectOptions(
                              label: 'Subject',
                              value: tempSubject,
                              items: subjectItems,
                              onChanged: (id) =>
                                  setSheetState(() => tempSubject = id),
                            ),
                            const SizedBox(height: 20),
                            NewSelectOptions(
                              label: 'Grade',
                              value: tempGrade,
                              items: gradeItems,
                              onChanged: (id) =>
                                  setSheetState(() => tempGrade = id),
                            ),
                            const SizedBox(height: 20),
                            _FilterSectionLabel('Status'),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: statusOptions.map((status) {
                                final isSelected = tempStatus == status;
                                return GestureDetector(
                                  onTap: () => setSheetState(
                                    () =>
                                        tempStatus = isSelected ? null : status,
                                  ),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
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
                            _FilterSectionLabel('Time Range'),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTimePicker(
                                    label: 'Start Time',
                                    selectedTime: tempStart,
                                    onTap: () => pickTime(true),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildTimePicker(
                                    label: 'End Time',
                                    selectedTime: tempEnd,
                                    onTap: () => pickTime(false),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Color(0xffEEEEEE)),
                          ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedDay = tempDay;
                                _selectedSubject = tempSubject;
                                _selectedGrade = tempGrade;
                                _selectedStatus = tempStatus;
                                _startTime = tempStart;
                                _endTime = tempEnd;
                                _currentPage = 0;
                              });
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

  Widget _buildTimePicker({
    required String label,
    required TimeOfDay? selectedTime,
    required VoidCallback onTap,
  }) {
    final display = selectedTime != null
        ? selectedTime.format(context)
        : 'Select';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xffF5F7FB),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xffDDDDDD)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              size: 18,
              color: Color(0xff888888),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xff888888),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    display,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: selectedTime != null
                          ? const Color(0xff1A1A2E)
                          : const Color(0xffAAAAAA),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final courses = _currentPageItems;

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

      // ── Everything in one single scrollable ──
      body: CustomScrollView(
        slivers: [
          // Search + filter bar (pinned=false so it scrolls away)
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: CustomTextField(
                        label: '',
                        hintText: 'Search classes...',
                        controller: _searchController,
                        isRequired: true,
                        onChanged: _onSearchChanged,
                      ),
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
                              color: _activeFilterCount > 0
                                  ? AppColors.primary.withOpacity(0.1)
                                  : const Color(0xffF5F7FB),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: _activeFilterCount > 0
                                    ? AppColors.primary
                                    : const Color(0xffE5E5E5),
                              ),
                            ),
                            child: Icon(
                              Icons.tune_rounded,
                              size: 20,
                              color: _activeFilterCount > 0
                                  ? AppColors.primary
                                  : const Color(0xff888888),
                            ),
                          ),
                          if (_activeFilterCount > 0)
                            Positioned(
                              top: -6,
                              right: -6,
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '$_activeFilterCount',
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

          // Active filter indicator
          if (_activeFilterCount > 0)
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
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
                      style: TextStyle(fontSize: 12, color: Color(0xff888888)),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$_activeFilterCount active',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _clearFilters,
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

          SliverToBoxAdapter(
            child: const Divider(height: 1, color: Color(0xffEEEEEE)),
          ),

          // Empty state
          if (_filteredCourses.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 56,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No classes found',
                      style: TextStyle(color: Color(0xffAAAAAA), fontSize: 15),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            // Cards
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final cls = ClassesData[index];
                  return CourseCard(
                    title: cls.name,
                    subject: cls.subjectName,
                    grade:
                        SelectOptions.newgradesList.firstWhere(
                          (e) => e["id"] == cls.grade.toString(),
                        )['name'] ??
                        '',
                    location: cls.location,
                    day:
                        SelectOptions.days.firstWhere(
                          (e) => e['id'] == cls.day.toString(),
                        )['name'] ??
                        '',
                    time: cls.startTime.substring(0, 5),
                    duration: cls.duration,
                    studentCount: cls.studentCount,
                    dayColor: Color(0xff185FA5),
                    dayBg: Color(0xffE8F2FF),
                    onViewDetails: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ClassDetailPage()),
                      );
                    },
                  );
                }, childCount: ClassesData.length),
              ),
            ),

            // Pagination — part of the scroll flow
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50), // room for FAB
                child: _PaginationBar(
                  currentPage: _currentPage,
                  totalPages: _totalPages,
                  onPageChanged: _goToPage,
                ),
              ),
            ),
          ],
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            GoRouter.of(context).pushNamed(InstituteRouteNames.createClass),
        backgroundColor: AppColors.primary,
        elevation: 10,
        child: const Icon(Icons.add),
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
    // Shows: [prev] 1 ... 4 5 6 ... 12 [next]
    // For small total, show all pages
    if (totalPages <= 7) {
      return List.generate(totalPages, (i) => i);
    }

    final items = <dynamic>[];
    items.add(0); // always first

    if (currentPage > 3) items.add('...');

    for (
      int i = (currentPage - 1).clamp(1, totalPages - 2);
      i <= (currentPage + 1).clamp(1, totalPages - 2);
      i++
    ) {
      items.add(i);
    }

    if (currentPage < totalPages - 4) items.add('...');

    items.add(totalPages - 1); // always last
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final pageItems = _buildPageItems();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          // Page info text
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
              // Prev button
              _ModernNavButton(
                icon: Icons.arrow_back_ios_new_rounded,
                enabled: currentPage > 0,
                onTap: () => onPageChanged(currentPage - 1),
              ),

              const SizedBox(width: 6),

              // Page number buttons / ellipsis
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

              // Next button
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

// ── Modern nav arrow button ──────────────────────────────────

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

// ── Modern page number button ────────────────────────────────

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
