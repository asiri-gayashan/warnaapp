import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:warna_app/core/constants/app_colors.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle("Today"),
          _buildNotificationItem(
            icon: CupertinoIcons.book_fill,
            title: "New class enrollment!",
            subtitle:
                "A new student has enrolled in your Advanced Mathematics class.",
            isNew: true,
          ),
          _buildNotificationItem(
            icon: CupertinoIcons.rosette,
            title: "Attendance marked",
            subtitle:
                "Attendance for Physics Foundations has been recorded successfully.",
          ),
          _buildNotificationItem(
            icon: CupertinoIcons.bookmark_fill,
            title: "New material added!",
            subtitle:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
            isNew: true,
          ),
          _buildNotificationItem(
            icon: CupertinoIcons.time_solid,
            title: "Upcoming class reminder",
            subtitle: "Chemistry Basics starts at 2:00 PM today.",
          ),

          const SizedBox(height: 25),
          _buildSectionTitle("Yesterday"),
          _buildNotificationItem(
            icon: CupertinoIcons.creditcard_fill,
            title: "Payment received!",
            subtitle:
                "Your monthly earnings for May have been credited to your account.",
          ),
          _buildNotificationItem(
            icon: CupertinoIcons.link_circle_fill,
            title: "Institute commission updated!",
            subtitle:
                "Your institute commission rate has been updated for this month.",
          ),
        ],
      ),
    );
  }

  // 🔹 SECTION TITLE (Today / Yesterday)
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "Mark all as read",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 SINGLE NOTIFICATION ITEM
  Widget _buildNotificationItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isNew = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ICON CIRCLE
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),

          const SizedBox(width: 12),

          // TEXTS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (isNew)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
