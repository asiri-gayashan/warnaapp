import 'package:flutter/material.dart';
import '../../../logic/registration_controller.dart';
import '../registration/step1_basic_info.dart';
// import './registration/step2_institute_details.dart';
// import './registration/step3_verification.dart';
// import './registration/step4_complete_profile.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late RegistrationController _controller;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _controller = RegistrationController();
    _controller.addListener(_updateUI);
  }

  void _updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  void _goToNextStep() {
    if (_controller.currentStep < 4) {
      _controller.goToNextStep();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousStep() {
    if (_controller.currentStep > 1) {
      _controller.goToPreviousStep();
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
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF374151),
            size: 24,
          ),
          onPressed: _goToPreviousStep,
        ),
        title: Text(
          'Step ${_controller.currentStep} of 4',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
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

                    // Step 2: Institute Details (Placeholder)
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Step 2: Institute Details',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),

                    // Step 3: Verification (Placeholder)
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Step 3: Verification',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),

                    // Step 4: Complete Profile (Placeholder)
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Step 4: Complete Profile',
                        style: TextStyle(fontSize: 24),
                      ),
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

  @override
  void dispose() {
    _controller.removeListener(_updateUI);
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }
}