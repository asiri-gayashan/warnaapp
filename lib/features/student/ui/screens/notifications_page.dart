import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/constants/app_colors.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildSectionTitle("Today"),
                  _buildNotificationItem(
                    icon: CupertinoIcons.book_fill,
                    title: "New course available!",
                    subtitle:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                    isNew: true,
                  ),
                  _buildNotificationItem(
                    icon: CupertinoIcons.rosette,
                    title: "Congrats on finishing!",
                    subtitle:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
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
                    title: "Limited-time offer!",
                    subtitle:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                  ),

                  const SizedBox(height: 25),
                  _buildSectionTitle("Yesterday"),
                  _buildNotificationItem(
                    icon: CupertinoIcons.creditcard_fill,
                    title: "Payment successful!",
                    subtitle:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                  ),
                  _buildNotificationItem(
                    icon: CupertinoIcons.link_circle_fill,
                    title: "Credit card connected!",
                    subtitle:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 HEADER
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Icon(CupertinoIcons.back),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              "Notification",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 24), // balance the back icon
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
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ICON CIRCLE
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFEAF3FF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 0),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
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
