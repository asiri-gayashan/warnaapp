import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/presentation/institute/controllers/mark_payment_controller.dart';

class MarkPaymentPage extends StatefulWidget {
  final String classId;
  final String className;
  final double classAmount;

  const MarkPaymentPage({
    Key? key,
    required this.classId,
    required this.className,
    required this.classAmount,
  }) : super(key: key);

  @override
  State<MarkPaymentPage> createState() => _MarkPaymentPageState();
}

class _MarkPaymentPageState extends State<MarkPaymentPage> {
  final MarkPaymentController _controller = MarkPaymentController();
  final TextEditingController _searchController = TextEditingController();

  // All enrolled students
  List<Map<String, dynamic>> _enrolledStudents = [];

  // Existing payment records for selected month
  // key: student_id, value: {id, status}
  Map<String, Map<String, dynamic>> _existingPayments = {};

  // Current payment state in UI
  // key: student_id, value: true = PAID, false = NOTPAID
  Map<String, bool> _paymentMap = {};

  String _selectedFilter = 'All'; // All, Paid, Unpaid
  DateTime _selectedMonth = DateTime.now();
  bool _isLoading = true;
  bool _isSaving = false;

  String get _formattedMonth =>
      "${_selectedMonth.year} - ${_selectedMonth.month.toString().padLeft(2, '0')}";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    // Fetch enrolled students
    final students =
        await _controller.getEnrollStudentsByClassId(widget.classId);

    // Fetch existing payments for selected month
    final payments = await _controller.getPaymentsByClassAndMonth(
      widget.classId,
      _selectedMonth.month,
      _selectedMonth.year,
    );

    final existingMap = <String, Map<String, dynamic>>{};
    final paymentMap = <String, bool>{};

    if (payments != null) {
      for (final record in payments) {
        final studentId = record['student_id']?.toString() ?? '';
        existingMap[studentId] = {
          'id': record['id'],
          'status': record['status'],
        };
        paymentMap[studentId] = record['status'] == 'PAID';
      }
    }

    // Students with no existing payment default to NOTPAID
    if (students != null) {
      for (final student in students) {
        final studentId = student['student_id']?.toString() ?? '';
        if (!paymentMap.containsKey(studentId)) {
          paymentMap[studentId] = false;
        }
      }
    }

    setState(() {
      _enrolledStudents = students ?? [];
      _existingPayments = existingMap;
      _paymentMap = paymentMap;
      _isLoading = false;
    });
  }

  Future<void> _onMonthChanged(DateTime newMonth) async {
    setState(() {
      _selectedMonth = newMonth;
      _isLoading = true;
    });

    final payments = await _controller.getPaymentsByClassAndMonth(
      widget.classId,
      newMonth.month,
      newMonth.year,
    );

    final existingMap = <String, Map<String, dynamic>>{};
    final paymentMap = <String, bool>{};

    if (payments != null) {
      for (final record in payments) {
        final studentId = record['student_id']?.toString() ?? '';
        existingMap[studentId] = {
          'id': record['id'],
          'status': record['status'],
        };
        paymentMap[studentId] = record['status'] == 'PAID';
      }
    }

    for (final student in _enrolledStudents) {
      final studentId = student['student_id']?.toString() ?? '';
      if (!paymentMap.containsKey(studentId)) {
        paymentMap[studentId] = false;
      }
    }

    setState(() {
      _existingPayments = existingMap;
      _paymentMap = paymentMap;
      _isLoading = false;
    });
  }

  void _togglePayment(String studentId) {
    // If student already has a PAID record in DB, cannot unmark
    // They can only be toggled if no existing record yet
    final existing = _existingPayments[studentId];
    if (existing != null && existing['status'] == 'PAID') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.orange,
          content: Row(
            children: [
              const Icon(Icons.warning, color: Colors.white),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Payment already recorded. Cannot unmark a paid payment.',
                ),
              ),
            ],
          ),
        ),
      );
      return;
    }

    setState(() {
      _paymentMap[studentId] = !(_paymentMap[studentId] ?? false);
    });
  }

  Future<void> _savePayments() async {
    setState(() => _isSaving = true);

    final markedUserId = await _controller.getMarkedUserId();

    if (markedUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.error,
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 10),
              const Expanded(child: Text('Could not get logged in user')),
            ],
          ),
        ),
      );
      setState(() => _isSaving = false);
      return;
    }

    // Only insert new PAID records — students toggled to PAID with no existing record
    final toInsert = <Map<String, dynamic>>[];

    for (final student in _enrolledStudents) {
      final studentId = student['student_id']?.toString() ?? '';
      final isPaid = _paymentMap[studentId] ?? false;
      final existing = _existingPayments[studentId];

      // Only insert if marked PAID and no existing record
      if (isPaid && existing == null) {
        toInsert.add({
          'student_id': studentId,
          'class_id': widget.classId,
          'paid_date': DateTime(_selectedMonth.year, _selectedMonth.month, 1)
              .toIso8601String(),
          'payment_method': 'Cash',
          'marked_user_id': markedUserId,
        });
      }
    }

    if (toInsert.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.orange,
          content: Row(
            children: [
              const Icon(Icons.info, color: Colors.white),
              const SizedBox(width: 10),
              const Expanded(child: Text('No new payments to save')),
            ],
          ),
        ),
      );
      setState(() => _isSaving = false);
      return;
    }

    final success = await _controller.insertPayments(toInsert);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.success,
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              const Expanded(child: Text('Payments saved successfully')),
            ],
          ),
        ),
      );
      await _loadData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: AppColors.error,
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 10),
              const Expanded(child: Text('Failed to save payments')),
            ],
          ),
        ),
      );
    }

    setState(() => _isSaving = false);
  }

  // Month year picker dialog
  Future<void> _pickMonth() async {
    DateTime tempMonth = _selectedMonth;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text(
                'Select Month & Year',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              content: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Year selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () {
                            setDialogState(() {
                              tempMonth =
                                  DateTime(tempMonth.year - 1, tempMonth.month);
                            });
                          },
                        ),
                        Text(
                          '${tempMonth.year}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {
                            setDialogState(() {
                              tempMonth =
                                  DateTime(tempMonth.year + 1, tempMonth.month);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Month grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        final month = index + 1;
                        final isSelected = tempMonth.month == month;
                        final monthNames = [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun',
                          'Jul',
                          'Aug',
                          'Sep',
                          'Oct',
                          'Nov',
                          'Dec'
                        ];
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              tempMonth = DateTime(tempMonth.year, month);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                monthNames[index],
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _onMonthChanged(tempMonth);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<Map<String, dynamic>> get _filteredStudents {
    return _enrolledStudents.where((student) {
      final studentId = student['student_id']?.toString() ?? '';
      final name = (student['student_full_name'] ?? '').toLowerCase();
      final isPaid = _paymentMap[studentId] ?? false;

      final searchMatch = _searchController.text.isEmpty ||
          name.contains(_searchController.text.toLowerCase());

      bool filterMatch = true;
      if (_selectedFilter == 'Paid') filterMatch = isPaid;
      if (_selectedFilter == 'Unpaid') filterMatch = !isPaid;

      return searchMatch && filterMatch;
    }).toList();
  }

  int get _paidCount => _paymentMap.values.where((v) => v == true).length;

  int get _unpaidCount => _paymentMap.values.where((v) => v == false).length;

  double get _collectedAmount => _paidCount * widget.classAmount;
  double get _pendingAmount => _unpaidCount * widget.classAmount;
  double get _totalAmount => _enrolledStudents.length * widget.classAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Mark Payments',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 20),
                  _buildCountStatsRow(),
                  const SizedBox(height: 20),
        
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildSelectAllRow(),
                  const SizedBox(height: 12),
                  _buildTable(),
                  const SizedBox(height: 24),
                  _buildSaveButton(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
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
          const Text(
            'You are marking payments for:',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          const SizedBox(height: 12),
          _buildHeaderChip(Icons.class_, widget.className),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _pickMonth,
            child: _buildHeaderChip(
              Icons.calendar_month,
              _formattedMonth,
              trailing: const Icon(Icons.edit, color: Colors.white70, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderChip(IconData icon, String label, {Widget? trailing}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildCountStatsRow() {
    return Row(
      children: [
        _buildStatCard(
          'Total Students',
          '${_enrolledStudents.length}',
          'Rs ${_totalAmount.toStringAsFixed(0)}',
          Icons.people_alt,
          AppColors.primary,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          'Paid',
          '$_paidCount',
          'Rs ${_collectedAmount.toStringAsFixed(0)}',
          Icons.check_circle,
          Colors.green,
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          'Not Paid',
          '$_unpaidCount',
          'Rs ${_pendingAmount.toStringAsFixed(0)}',
          Icons.cancel,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, String desicription, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              desicription,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by name...',
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () => setState(() {
                    _searchController.clear();
                  }),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  Widget _buildSelectAllRow() {
    final allPaid = _filteredStudents.isNotEmpty &&
        _filteredStudents.every(
          (s) => _paymentMap[s['student_id']?.toString()] == true,
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text(
              'Filter:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 12),
            ...['All', 'Paid', 'Unpaid'].map((filter) {
              final isSelected = _selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedFilter = filter),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
        Row(
          children: [
            const Text(
              'Mark All Paid',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                setState(() {
                  for (final student in _filteredStudents) {
                    final studentId = student['student_id']?.toString() ?? '';
                    final existing = _existingPayments[studentId];
                    // Only allow toggling if not already paid in DB
                    if (existing == null || existing['status'] != 'PAID') {
                      _paymentMap[studentId] = !allPaid;
                    }
                  }
                });
              },
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: allPaid ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: allPaid ? AppColors.primary : AppColors.textSecondary,
                    width: 1.5,
                  ),
                ),
                child: allPaid
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTable() {
    if (_filteredStudents.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            'No students found',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              color: AppColors.primary.withOpacity(0.06),
              child: const Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Status',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                ],
              ),
            ),

            // Rows
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredStudents.length,
              itemBuilder: (context, index) {
                final student = _filteredStudents[index];
                final studentId = student['student_id']?.toString() ?? '';
                final isPaid = _paymentMap[studentId] ?? false;
                final isExisting = _existingPayments.containsKey(studentId);
                final isEven = index % 2 == 0;

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  color: isEven
                      ? Colors.white
                      : AppColors.background.withOpacity(0.4),
                  child: Row(
                    children: [
                      // Name
                      Expanded(
                        flex: 3,
                        child: Text(
                          student['student_full_name'] ?? '',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Amount
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Rs ${widget.classAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // Status badge
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: isPaid ? Colors.green : Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isPaid ? 'Paid' : 'Not Paid',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isPaid ? Colors.green : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Toggle checkbox
                      SizedBox(
                        width: 40,
                        child: GestureDetector(
                          onTap: () => _togglePayment(studentId),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isPaid
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isExisting && isPaid
                                    ? Colors.green.withOpacity(0.4)
                                    : isPaid
                                        ? Colors.green
                                        : AppColors.textSecondary,
                                width: 1.5,
                              ),
                            ),
                            child: isPaid
                                ? Icon(
                                    isExisting ? Icons.lock : Icons.check,
                                    color: Colors.green,
                                    size: 16,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: !_isSaving ? _savePayments : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: _isSaving
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Save Payments',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}