import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/core/constants/select_options.dart';
import 'package:warna_app/data/repositories/metadata_repository.dart';
import 'package:warna_app/features/auth/logic/auth_service.dart';
import 'package:warna_app/presentation/institute/controllers/institute_dashboard_controller.dart';
import 'package:warna_app/shared/widgets/new/category_grid_card.dart';
import 'package:warna_app/shared/widgets/new/metric_overview_card.dart';
import 'package:warna_app/shared/widgets/new/performance_row_item.dart';
import 'package:warna_app/shared/widgets/new/quick_stat_row_item.dart';
import 'package:warna_app/shared/widgets/new/upcoming_class_list_tile.dart';

// ============================================================
// REPORT FILTER SHEETS
// ============================================================

class _ClassReportFilterSheet extends StatefulWidget {
  final List<Map<String, String>> subjectsList;
  const _ClassReportFilterSheet({required this.subjectsList});

  @override
  State<_ClassReportFilterSheet> createState() =>
      _ClassReportFilterSheetState();
}

class _ClassReportFilterSheetState
    extends State<_ClassReportFilterSheet> {
  String? _grade;
  String? _status;
  String? _subjectId;
  DateTime? _from;
  DateTime? _to;

  final List<String> _statusOptions = [
    'ACTIVE', 'INACTIVE', 'PENDING'
  ];

  Future<void> _pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => isFrom ? _from = picked : _to = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ReportSheetScaffold(
      title: 'Class Report Filters',
      onClear: () => setState(() {
        _grade = _status = _subjectId = null;
        _from = _to = null;
      }),
      onExport: () => Navigator.of(context).pop(
        ReportFilter(
          grade: _grade,
          status: _status,
          subjectId: _subjectId,
          fromDate: _from,
          toDate: _to,
        ),
      ),
      children: [
        _SheetDropdown(
          label: 'Grade',
          value: _grade,
          items: SelectOptions.newgradesList,
          onChanged: (v) => setState(() => _grade = v),
        ),
        const SizedBox(height: 16),
        _SheetDropdown(
          label: 'Subject',
          value: _subjectId,
          items: widget.subjectsList,
          onChanged: (v) => setState(() => _subjectId = v),
        ),
        const SizedBox(height: 16),
        _StatusChips(
          options: _statusOptions,
          selected: _status,
          onSelected: (v) => setState(() => _status = v),
        ),
        const SizedBox(height: 16),
        _DateRangeRow(
          from: _from,
          to: _to,
          onPickFrom: () => _pickDate(true),
          onPickTo: () => _pickDate(false),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────

class _StudentReportFilterSheet extends StatefulWidget {
  const _StudentReportFilterSheet();

  @override
  State<_StudentReportFilterSheet> createState() =>
      _StudentReportFilterSheetState();
}

class _StudentReportFilterSheetState
    extends State<_StudentReportFilterSheet> {
  String? _grade;
  String? _status;
  DateTime? _from;
  DateTime? _to;

  final List<String> _statusOptions = ['ACTIVE', 'INACTIVE', 'PENDING'];

  Future<void> _pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => isFrom ? _from = picked : _to = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ReportSheetScaffold(
      title: 'Student Report Filters',
      onClear: () => setState(() {
        _grade = _status = null;
        _from = _to = null;
      }),
      onExport: () => Navigator.of(context).pop(
        ReportFilter(grade: _grade, status: _status, fromDate: _from, toDate: _to),
      ),
      children: [
        _SheetDropdown(
          label: 'Grade',
          value: _grade,
          items: SelectOptions.newgradesList,
          onChanged: (v) => setState(() => _grade = v),
        ),
        const SizedBox(height: 16),
        _StatusChips(
          options: _statusOptions,
          selected: _status,
          onSelected: (v) => setState(() => _status = v),
        ),
        const SizedBox(height: 16),
        _DateRangeRow(
          from: _from,
          to: _to,
          onPickFrom: () => _pickDate(true),
          onPickTo: () => _pickDate(false),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────

class _TutorReportFilterSheet extends StatefulWidget {
  final List<Map<String, String>> subjectsList;
  final List<Map<String, String>> districtsList;
  const _TutorReportFilterSheet({
    required this.subjectsList,
    required this.districtsList,
  });

  @override
  State<_TutorReportFilterSheet> createState() =>
      _TutorReportFilterSheetState();
}

class _TutorReportFilterSheetState
    extends State<_TutorReportFilterSheet> {
  String? _status;
  String? _subjectId;
  String? _districtId;

  final List<String> _statusOptions = [
    'ACTIVE', 'INACTIVE', 'PENDING', 'APPROVED', 'REJECTED'
  ];

  @override
  Widget build(BuildContext context) {
    return _ReportSheetScaffold(
      title: 'Tutor Report Filters',
      onClear: () => setState(() {
        _status = _subjectId = _districtId = null;
      }),
      onExport: () => Navigator.of(context).pop(
        ReportFilter(
          status: _status,
          subjectId: _subjectId,
          districtId: _districtId,
        ),
      ),
      children: [
        _SheetDropdown(
          label: 'Subject',
          value: _subjectId,
          items: widget.subjectsList,
          onChanged: (v) => setState(() => _subjectId = v),
        ),
        const SizedBox(height: 16),
        _SheetDropdown(
          label: 'District',
          value: _districtId,
          items: widget.districtsList,
          onChanged: (v) => setState(() => _districtId = v),
        ),
        const SizedBox(height: 16),
        _StatusChips(
          options: _statusOptions,
          selected: _status,
          onSelected: (v) => setState(() => _status = v),
        ),
      ],
    );
  }
}

// ============================================================
// SHARED SHEET SCAFFOLD
// ============================================================

class _ReportSheetScaffold extends StatelessWidget {
  final String title;
  final VoidCallback onClear;
  final VoidCallback onExport;
  final List<Widget> children;

  const _ReportSheetScaffold({
    required this.title,
    required this.onClear,
    required this.onExport,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, sc) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(20)),
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
                    horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff1A1A2E))),
                    TextButton(
                      onPressed: onClear,
                      child: const Text('Clear All',
                          style:
                              TextStyle(color: Color(0xff185FA5))),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: sc,
                  padding: const EdgeInsets.all(20),
                  children: children,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.fromLTRB(20, 12, 20, 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      top: BorderSide(color: Color(0xffEEEEEE))),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: onExport,
                    icon: const Icon(Icons.download_rounded,
                        color: Colors.white),
                    label: const Text('Export Report',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
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
// SHARED SHEET WIDGETS
// ============================================================

class _SheetDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<Map<String, String>> items;
  final ValueChanged<String?> onChanged;

  const _SheetDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xff444444))),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            filled: true,
            fillColor: const Color(0xffF5F7FB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          hint: Text('Select $label',
              style: const TextStyle(
                  color: Color(0xff999999), fontSize: 14)),
          items: [
            DropdownMenuItem(
                value: null,
                child: Text('All $label',
                    style:
                        const TextStyle(color: Color(0xff999999)))),
            ...items.map((item) => DropdownMenuItem(
                  value: item['id'],
                  child: Text(item['name'] ?? ''),
                )),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _StatusChips extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final ValueChanged<String?> onSelected;

  const _StatusChips({
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Status',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xff444444))),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((s) {
            final isSel = selected == s;
            return GestureDetector(
              onTap: () => onSelected(isSel ? null : s),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSel
                      ? AppColors.primary
                      : const Color(0xffF5F7FB),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: isSel
                          ? AppColors.primary
                          : const Color(0xffDDDDDD)),
                ),
                child: Text(s,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSel
                            ? Colors.white
                            : const Color(0xff555555))),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _DateRangeRow extends StatelessWidget {
  final DateTime? from;
  final DateTime? to;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;

  const _DateRangeRow({
    required this.from,
    required this.to,
    required this.onPickFrom,
    required this.onPickTo,
  });

  String _fmt(DateTime? d) =>
      d != null ? d.toIso8601String().substring(0, 10) : 'Select';

  Widget _dateTile(String label, DateTime? date, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff444444))),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xffF5F7FB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xffDDDDDD)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 16, color: Color(0xff888888)),
                  const SizedBox(width: 8),
                  Text(_fmt(date),
                      style: TextStyle(
                          fontSize: 13,
                          color: date != null
                              ? const Color(0xff1A1A2E)
                              : const Color(0xff999999))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _dateTile('From', from, onPickFrom),
        const SizedBox(width: 16),
        _dateTile('To', to, onPickTo),
      ],
    );
  }
}

// ============================================================
// MAIN DASHBOARD PAGE
// ============================================================

class InstituteDashboardPage extends StatefulWidget {
  const InstituteDashboardPage({Key? key}) : super(key: key);

  @override
  State<InstituteDashboardPage> createState() =>
      _InstituteDashboardPageState();
}

class _InstituteDashboardPageState
    extends State<InstituteDashboardPage> {
  late InstituteDashboardController _controller;
  List<Map<String, String>> subjectsList  = [];
  List<Map<String, String>> districtsList = [];

  @override
  void initState() {
    super.initState();
    _controller = InstituteDashboardController();
    _controller.fetchAll();
    _loadMeta();
  }

  Future<void> _loadMeta() async {
    final rawS = await MetadataRepository().getSubjects();
    final rawD = await MetadataRepository().getDistricts();
    if (!mounted) return;
    setState(() {
      if (rawS != null) {
        subjectsList = rawS
            .map((s) => {
                  "id": s["id"].toString(),
                  "name": s["name"].toString()
                })
            .toList();
      }
      if (rawD != null) {
        districtsList = rawD
            .map((d) => {
                  "id": d["id"].toString(),
                  "name": d["name"].toString()
                })
            .toList();
      }
    });
  }

  // ── Open filter sheet and trigger export ──────────────────
  Future<void> _openReport(ReportType type) async {
    Widget sheet = switch (type) {
      ReportType.classes =>
        _ClassReportFilterSheet(subjectsList: subjectsList),
      ReportType.students =>
        const _StudentReportFilterSheet(),
      ReportType.tutors =>
        _TutorReportFilterSheet(
          subjectsList: subjectsList,
          districtsList: districtsList,
        ),
    };

    final filter = await showModalBottomSheet<ReportFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => sheet,
    );

    if (filter == null || !mounted) return;

    try {
      final filePath = await _controller.exportReport(
        type: type,
        filter: filter,
      );

      if (!mounted) return;

      if (filePath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No data found for the selected filters."),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Report saved: $filePath"),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: "Open",
            textColor: Colors.white,
            onPressed: () => OpenFilex.open(filePath),
          ),
          duration: const Duration(seconds: 6),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Export failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        // Full-screen loading overlay while exporting
        return Stack(
          children: [
            _buildScaffold(context),
            if (_controller.isExporting)
              Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text("Generating report...",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final s = _controller.stats;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        actions: [
          IconButton(
            icon:
                const Icon(Icons.logout, color: AppColors.textPrimary),
            onPressed: () => AuthService.logoutUser(context: context),
          ),
        ],
        title: const Text(
          'Institute Dashboard',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: _controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Overview ────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Institute Overview',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: MetricOverviewCard(
                                label: 'Total Students',
                                value: '${s.totalStudents}',
                                icon: Icons.people_outline,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: MetricOverviewCard(
                                label: 'Total Teachers',
                                value: '${s.totalTutors}',
                                icon: Icons.person_outline,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: MetricOverviewCard(
                                label: 'Total Classes',
                                value: '${s.totalClasses}',
                                icon: Icons.class_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: MetricOverviewCard(
                                label: 'Monthly Revenue',
                                value:
                                    'Rs ${s.monthlyRevenue.toStringAsFixed(0)}',
                                icon: Icons.trending_up,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: MetricOverviewCard(
                                label: 'Total Commission',
                                value:
                                    'Rs ${s.totalCommission.toStringAsFixed(0)}',
                                icon: Icons.percent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Generate Reports ────────────────────────
                  const Text('Generate Reports',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: [
                      CategoryGridCard(
                        title: 'Class Reports',
                        icon: Icons.class_,
                        color: Colors.orange,
                        onTap: () => _openReport(ReportType.classes),
                      ),
                      CategoryGridCard(
                        title: 'Student Reports',
                        icon: Icons.people,
                        color: AppColors.info,
                        onTap: () => _openReport(ReportType.students),
                      ),
                      CategoryGridCard(
                        title: 'Teacher Reports',
                        icon: Icons.person,
                        color: Colors.purple,
                        onTap: () => _openReport(ReportType.tutors),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Top Performing ──────────────────────────
                  _PerformanceCard(
                    title: 'Top Performing Classes',
                    icon: Icons.star,
                    iconColor: AppColors.success,
                    items: _controller.topClasses,
                    metricColor: AppColors.success,
                  ),

                  const SizedBox(height: 12),

                  // ── Needs Improvement ───────────────────────
                  _PerformanceCard(
                    title: 'Needs Improvement',
                    icon: Icons.trending_down,
                    iconColor: Colors.orange,
                    items: _controller.leastClasses,
                    metricColor: Colors.orange,
                  ),

                  const SizedBox(height: 16),

                  // ── Upcoming Classes ────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary
                                      .withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                    Icons.calendar_month,
                                    color: AppColors.primary,
                                    size: 18),
                              ),
                              const SizedBox(width: 12),
                              const Text('Upcoming Classes',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16)),
                            ]),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (_controller.upcomingClasses.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('No upcoming classes',
                                  style: TextStyle(
                                      color: AppColors
                                          .textSecondary)),
                            ),
                          )
                        else
                          ..._controller.upcomingClasses
                              .map((cls) => UpcomingClassListTile(
                                    className: cls.name,
                                    grade: 'Grade ${cls.grade}',
                                    time:
                                        '${cls.startTime} - ${cls.endTime}',
                                    teacher: cls.tutorName,
                                    day: cls.dayName,
                                  )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Quick Statistics ────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Quick Statistics',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16)),
                        const SizedBox(height: 16),
                        QuickStatRowItem(
                          label: 'Total Students Enrolled',
                          value: '${s.totalStudents}',
                          change: '',
                        ),
                        QuickStatRowItem(
                          label: 'Teachers',
                          value: '${s.totalTutors}',
                          change: '',
                        ),
                        QuickStatRowItem(
                          label: 'Total Classes',
                          value: '${s.totalClasses}',
                          change: '${s.activeClasses} active',
                        ),
                        QuickStatRowItem(
                          label: 'Monthly Revenue',
                          value:
                              'Rs ${s.monthlyRevenue.toStringAsFixed(0)}',
                          change: '',
                        ),
                        QuickStatRowItem(
                          label: 'Commission Received',
                          value:
                              'Rs ${s.totalCommission.toStringAsFixed(0)}',
                          change: '',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}

// ============================================================
// PERFORMANCE CARD WIDGET
// ============================================================

class _PerformanceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<ClassPerformanceModel> items;
  final Color metricColor;

  const _PerformanceCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.items,
    required this.metricColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 16)),
          ]),
          const SizedBox(height: 16),
          if (items.isEmpty)
            const Text('No data available',
                style:
                    TextStyle(color: AppColors.textSecondary))
          else
            ...items.map(
              (c) => PerformanceRowItem(
                className: '${c.name} - Grade ${c.grade}',
                value: '${c.studentCount}',
                metric: 'Students',
                color: metricColor,
              ),
            ),
        ],
      ),
    );
  }
}