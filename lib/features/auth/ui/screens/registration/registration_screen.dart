import 'package:flutter/material.dart';
import '../../../logic/registration_controller.dart';
import '../../../../../shared/widgets/step_progress_indicator.dart';
import '../../../../../core/constants/registration_strings.dart';
import './step1_basic_info.dart';
import './step2_account_security.dart';
import './step3_role_details.dart';
import './step4_email_verification.dart';
import './step5_success_screen.dart';


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late RegistrationController _controller;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _controller = RegistrationController();
    _pageController = PageController();

    // ADD THIS: Listen to controller changes
    _controller.addListener(() {
      if (mounted) {
        setState(() {}); // ← This forces UI to rebuild
      }
    });
  }

  void _goToNextStep() {
    if (_controller.currentStep < 5) {
      // Call controller method (which now calls notifyListeners)
      _controller.goToNextStep();

      // Navigate to next page
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousStep() {
    if (_controller.currentStep > 1) {
      // Call controller method (which now calls notifyListeners)
      _controller.goToPreviousStep();

      // Navigate to previous page
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: _goToPreviousStep,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Progress Indicator - Will now update automatically
              StepProgressIndicator(
                currentStep: _controller.currentStep, // ← This updates now
                steps: RegistrationStrings.progressSteps,
              ),
              const SizedBox(height: 24),

              // Page View for Steps
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // Step 1: Basic Information
                    RegistrationStep1(
                      controller: _controller,
                      onNext: _goToNextStep,
                    ),

                    // Step 2: Account Security
                    RegistrationStep2(
                      controller: _controller,
                      onNext: _goToNextStep,
                      onBack: _goToPreviousStep,
                    ),

                    // Step 3: Role Specific Details
                    RegistrationStep3(
                      controller: _controller,
                      onNext: _goToNextStep,
                      onBack: _goToPreviousStep,
                    ),

                    // Step 4: Email Verification
                    RegistrationStep4(
                      controller: _controller,
                      onNext: _goToNextStep,
                      onBack: _goToPreviousStep,
                    ),

                    // Step 5: Success Screen
                    RegistrationStep5(
                      controller: _controller,
                      onComplete: _completeRegistration,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _completeRegistration() {
    print('Registration completed successfully!');
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _controller.removeListener(() {}); // Remove listener
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }
}