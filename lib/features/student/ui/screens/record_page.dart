import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:warna_app/core/constants/app_colors.dart';

class PaymentRecordsPage extends StatelessWidget {
  const PaymentRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: _buildHeader(context),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 🔵 SUMMARY CARD
          _summaryCard(),

          const SizedBox(height: 24),

          // 🔵 SECTION TITLE
          const Text(
            "Recent Payments",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),

          const SizedBox(height: 16),

          // 🔵 PAYMENT LIST
          PaymentCard(
            course: "UI/UX Design Course",
            date: "12 Feb 2026",
            amount: "LKR 12,000",
            status: "Paid",
          ),
          PaymentCard(
            course: "Mobile App Development",
            date: "05 Feb 2026",
            amount: "LKR 15,500",
            status: "Paid",
          ),
          PaymentCard(
            course: "Graphic Design Mastery",
            date: "01 Feb 2026",
            amount: "LKR 10,000",
            status: "Pending",
          ),
          PaymentCard(
            course: "Data Science Fundamentals",
            date: "28 Jan 2026",
            amount: "LKR 18,000",
            status: "Paid",
          ),
          PaymentCard(
            course: "Digital Marketing",
            date: "20 Jan 2026",
            amount: "LKR 8,500",
            status: "Refunded",
          ),

          const SizedBox(height: 20),

          // 🔵 VIEW ALL BUTTON
          Center(
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                "View All Transactions",
                style: TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ APP BAR HEADER
  PreferredSizeWidget _buildHeader(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            // Back button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  CupertinoIcons.chevron_left,
                  color: Color(0xFF1E293B),
                  size: 20,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Title
            const Expanded(
              child: Text(
                "Payment Records",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
            ),

            // Filter/Search icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                CupertinoIcons.slider_horizontal_3,
                color: Color(0xFF1E293B),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ SUMMARY CARD
  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2563EB), // Primary blue
            Color(0xFF1E40AF), // Darker blue
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Paid",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "This Month",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "LKR 18,500",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green.shade400,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning,
                  color: Colors.white,
                  size: 12,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                "You have classes to pay !",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(
            color: Colors.white24,
            thickness: 1,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryStat("Paid Classes", "6", Colors.white),
              _buildSummaryStat("To Pay", "2", Colors.orange.shade300),
              _buildSummaryStat("Amount", "LKR 5.5k", Colors.green.shade300),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ SUMMARY STAT HELPER
  Widget _buildSummaryStat(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

//////////////////////////////////////////////////////////
// 💳 PAYMENT CARD
//////////////////////////////////////////////////////////

class PaymentCard extends StatelessWidget {
  final String course;
  final String date;
  final String amount;
  final String status;

  const PaymentCard({
    super.key,
    required this.course,
    required this.date,
    required this.amount,
    required this.status,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'paid':
        return const Color(0xFF10B981); // Green
      case 'pending':
        return const Color(0xFFF59E0B); // Orange
      case 'refunded':
        return const Color(0xFF6B7280); // Gray
      case 'failed':
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'paid':
        return CupertinoIcons.check_mark_circled_solid;
      case 'pending':
        return CupertinoIcons.clock_solid;
      case 'refunded':
        return CupertinoIcons.arrow_2_circlepath;
      case 'failed':
        return CupertinoIcons.exclamationmark_triangle_fill;
      default:
        return CupertinoIcons.creditcard_fill;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPaid = status.toLowerCase() == "paid";
    final statusColor = _getStatusColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          // ICON with status-based color
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getStatusIcon(),
              color: statusColor,
              size: 20,
            ),
          ),

          const SizedBox(width: 14),

          // DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.calendar,
                      size: 12,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // AMOUNT + STATUS
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: statusColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getStatusIcon(),
                      size: 10,
                      color: statusColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}