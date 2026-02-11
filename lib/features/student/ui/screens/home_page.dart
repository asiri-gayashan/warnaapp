import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/constants/app_colors.dart';

import '../../../../shared/widgets/class_card.dart';
import '../../../../shared/widgets/status_card.dart';
import '../../../../shared/widgets/home_header.dart';
import '../../../../shared/widgets/home_top_section.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(   // 🔥 Column FIRST
            children: [

              // 🔵 FULL WIDTH HEADER
              const HomeHeader(),
              const SizedBox(height: 30),

              // Other content with side padding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [



                    _buildTodayClasses(),
                    const SizedBox(height: 24),

                    _buildQuickStatus(),
                    const SizedBox(height: 24),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Greeting Text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning,',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Sarah Johnson',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),

        // Profile Avatar
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primary.withOpacity(0.2),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: Image.network(
              'https://images.unsplash.com/photo-1494790108755-2616b786d4d4?w=400&h=400&fit=crop&crop=face',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.primaryLight,
                  child: const Icon(
                    CupertinoIcons.person_fill,
                    color: AppColors.primary,
                    size: 28,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }



  Widget _buildTodayClasses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Classes",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Classes List
        Column(
          children: [
            ClassCard(
              subject: 'Mathematics',
              teacher: 'Dr. Rajesh Kumar',
              time: '9:00 AM - 10:00 AM',
              imageUrl: 'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=400&h=300&fit=crop',
              status: 'Ongoing',
            ),
            const SizedBox(height: 12),
            ClassCard(
              subject: 'Physics',
              teacher: 'Prof. Anjali Sharma',
              time: '10:30 AM - 11:30 AM',
              imageUrl: 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=400&h=300&fit=crop',
              status: 'Upcoming',
            ),
            const SizedBox(height: 12),
            ClassCard(
              subject: 'Computer Science',
              teacher: 'Mr. Vikram Singh',
              time: '2:00 PM - 3:30 PM',
              imageUrl: 'https://images.unsplash.com/photo-1517077304055-6e89abbf09b0?w=400&h=300&fit=crop',
              status: 'Later',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickStatus() {
    return StatusCard(
      type: StatusType.warning,
      icon: CupertinoIcons.exclamationmark_triangle_fill,
      title: 'Fee Payment Due',
      message: 'Your quarterly fee payment of ₹5,000 is pending. Please pay before 15th March.',
      actionText: 'Pay Now',
      onAction: () {},
    );
  }
}