import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import '../../../../core/constants/app_colors.dart'; // adjust path if needed

class PaymentRecordsPage extends StatelessWidget {
  const PaymentRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text("Payment Records"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          // 🔵 SUMMARY CARD
          _summaryCard(),

          const SizedBox(height: 25),

          const Text("Recent Transactions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          const SizedBox(height: 12),

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
        ],
      ),
    );
  }

  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Total Paid",
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          SizedBox(height: 6),
          Text("LKR 37,500",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text("Keep up the good learning! 🎓",
              style: TextStyle(color: Colors.white70)),
        ],
      ),
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

  @override
  Widget build(BuildContext context) {
    final bool isPaid = status == "Paid";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [

          // ICON
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.creditcard_fill,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 14),

          // DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(course,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(date,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),

          // AMOUNT + STATUS
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isPaid ? Colors.green : Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
