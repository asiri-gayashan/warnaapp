import 'package:flutter/material.dart';
import 'package:warna_app/core/constants/app_colors.dart';
import 'package:warna_app/features/auth/logic/auth_service.dart';
import 'package:warna_app/presentation/tutor/controllers/tutor_profile_controller.dart';
import 'package:warna_app/shared/widgets/new/custom_textfield.dart';
import 'package:warna_app/shared/widgets/new/new_select_options.dart';

class TutorProfilePage extends StatefulWidget {
  const TutorProfilePage({Key? key}) : super(key: key);

  @override
  State<TutorProfilePage> createState() => _TutorProfilePageState();
}

class _TutorProfilePageState extends State<TutorProfilePage> {
  late TutorProfileController _controller;

  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _districtId;
  String? _subjectId;
  String? _experienceId;

  bool _initialised = false;

  @override
  void initState() {
    super.initState();
    _controller = TutorProfileController();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await _controller.fetchProfile();
    final profile = _controller.profile;
    if (profile != null && mounted) {
      _fullNameController.text = profile.fullName;
      _phoneController.text = profile.phone;
      _addressLine1Controller.text = profile.addressLine1;
      _addressLine2Controller.text = profile.addressLine2;
      _descriptionController.text = profile.description;
      _districtId = profile.districtId;
      _subjectId = profile.subjectId;
      _experienceId = profile.experienceId;
      setState(() => _initialised = true);
    }
  }

  Future<void> _saveChanges() async {
    final profile = _controller.profile;
    if (profile == null) return;

    final districtName = tutorProfileDistricts.firstWhere(
      (d) => d['id'] == _districtId,
      orElse: () => {'name': profile.districtName},
    )['name']!;

    final subjectName = tutorProfileSubjects.firstWhere(
      (s) => s['id'] == _subjectId,
      orElse: () => {'name': profile.subjectName},
    )['name']!;

    final experienceName = tutorProfileExperienceOptions.firstWhere(
      (e) => e['id'] == _experienceId,
      orElse: () => {'name': profile.experienceName},
    )['name']!;

    final updated = profile.copyWith(
      fullName: _fullNameController.text.trim(),
      phone: _phoneController.text.trim(),
      addressLine1: _addressLine1Controller.text.trim(),
      addressLine2: _addressLine2Controller.text.trim(),
      districtId: _districtId,
      districtName: districtName,
      subjectId: _subjectId,
      subjectName: subjectName,
      experienceId: _experienceId,
      experienceName: experienceName,
      description: _descriptionController.text.trim(),
    );

    final success = await _controller.updateProfile(updated);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: success ? AppColors.success : AppColors.error,
        content: Row(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                success
                    ? 'Profile updated successfully'
                    : 'Failed to update profile',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Log Out',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      AuthService.logoutUser(context: context);
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _descriptionController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final profile = _controller.profile;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textPrimary,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'My Profile',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
          ),
          body: _controller.isLoading || !_initialised || profile == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Avatar header ─────────────────────────
                      Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: AppColors.primary.withOpacity(
                                0.1,
                              ),
                              child: Text(
                                profile.fullName.isNotEmpty
                                    ? profile.fullName[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -4,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          profile.fullName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          profile.email,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Personal Information ──────────────────
                      const Text(
                        'Personal Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),

                      CustomTextField(
                        label: 'Full Name',
                        hintText: 'Enter your full name',
                        controller: _fullNameController,
                        isRequired: true,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: 'Email',
                        hintText: profile.email,
                        controller: TextEditingController(text: profile.email),
                        readOnly: true,
                        fillColor: const Color(0xffF5F7FB),
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: 'Phone',
                        hintText: 'Enter your phone number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        isRequired: true,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: 'Address Line 1',
                        hintText: 'Enter address line 1',
                        controller: _addressLine1Controller,
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: 'Address Line 2',
                        hintText: 'Enter address line 2',
                        controller: _addressLine2Controller,
                      ),
                      const SizedBox(height: 16),

                      NewSelectOptions(
                        label: 'District',
                        value: _districtId,
                        items: tutorProfileDistricts,
                        onChanged: (id) => setState(() => _districtId = id),
                      ),

                      const SizedBox(height: 28),

                      // ── Teaching Information ──────────────────
                      const Text(
                        'Teaching Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 14),

                      NewSelectOptions(
                        label: 'Main Subject',
                        value: _subjectId,
                        items: tutorProfileSubjects,
                        onChanged: (id) => setState(() => _subjectId = id),
                      ),
                      const SizedBox(height: 16),

                      NewSelectOptions(
                        label: 'Years of Experience',
                        value: _experienceId,
                        items: tutorProfileExperienceOptions,
                        onChanged: (id) => setState(() => _experienceId = id),
                      ),
                      const SizedBox(height: 16),

                      CustomTextField(
                        label: 'Bio / Description',
                        hintText: 'Tell students a little about yourself...',
                        controller: _descriptionController,
                        maxLines: 4,
                      ),

                      const SizedBox(height: 28),

                      // ── Save changes ───────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _controller.isSaving ? null : _saveChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _controller.isSaving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // ── Logout ──────────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: _confirmLogout,
                          icon: const Icon(Icons.logout, color: AppColors.error),
                          label: const Text(
                            'Log Out',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.error,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.error),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
