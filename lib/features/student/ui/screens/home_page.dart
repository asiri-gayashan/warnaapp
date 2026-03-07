import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/class_card.dart';
import '../../../../shared/widgets/status_card.dart';
import '../../../../shared/widgets/home_header.dart';
import '../../../../shared/widgets/home_top_section.dart';
import '../../../../services/token_service.dart';
import '../../../auth/ui/screens/login/login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _logout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await TokenService.clearToken();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Pass the logout function to HomeHeader
              HomeHeader(onLogout: _logout),
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

  // Keep your existing _buildTodayClasses and _buildQuickStatus methods
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

// You can remove _buildHeader since it's now in HomeHeader
}