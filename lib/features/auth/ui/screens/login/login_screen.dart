import 'package:flutter/material.dart';
import 'package:warna_app/features/student/ui/navigation/student_navigation.dart';
import '../../../../../shared/widgets/custom_button.dart';
import '../../../../../shared/widgets/custom_textfield.dart';
import '../../../../../shared/widgets/field_error_text.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../config/theme/text_styles.dart';
import '../../../logic/login_controller.dart';
import '../registration/registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginController _controller;

  @override
  void initState() {
    super.initState();
    _controller = LoginController();

    // Add listeners for real-time validation
    _controller.emailController.addListener(_onEmailChanged);
    _controller.passwordController.addListener(_onPasswordChanged);
  }

  void _onEmailChanged() {
    _controller.validateEmail(_controller.emailController.text);
  }

  void _onPasswordChanged() {
    _controller.validatePassword(_controller.passwordController.text);
  }

  @override
  void dispose() {
    _controller.emailController.removeListener(_onEmailChanged);
    _controller.passwordController.removeListener(_onPasswordChanged);
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              // Header Section
              _buildHeader(),
              const SizedBox(height: 48),

              // Form Section
              _buildForm(),
              const SizedBox(height: 32),


              // Login Button
              CustomButton(
                text: AppStrings.loginButton,
                onPressed: () async {

                  var result = await _controller.loginUser();

                  if (result != null) {

                    String role = result['role'];
                    String token = result['token'];

                    print(role + "From login screen");
                    print(token);


                    if (role == "STUDENT") {



                      // Navigator.pushReplacementNamed(context, '/student');

                      Navigator.push( context, MaterialPageRoute( builder: (context) => StudentNavigation(token: token)));
                    }
                  }
                },

                isLoading: _controller.isLoading,
                // isDisabled: !_controller.isFormValid() && !_controller.isLoading,
              ),
              const SizedBox(height: 32),



              // Divider
              _buildDivider(),
              const SizedBox(height: 32),

              // Sign Up Link
              _buildSignUpLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.welcomeBack,
          style: TextStyles.heading1,
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.loginSubtitle,
          style: TextStyles.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Column(
          children: [
            // Email Field
            CustomTextField(
              label: AppStrings.emailLabel,
              hintText: AppStrings.emailHint,
              controller: _controller.emailController,
              keyboardType: TextInputType.emailAddress,
              isRequired: true,
              onChanged: (value) {
                _controller.validateEmail(value);
              },
              suffixIcon: _controller.emailController.text.isNotEmpty
                  ? _controller.emailValidated
                  ? const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 20,
              )
                  : const Icon(
                Icons.error,
                color: AppColors.error,
                size: 20,
              )
                  : null,
            ),

            // Email Error
            if (_controller.emailError != null)
              FieldErrorText(
                message: _controller.emailError,
              ),

            const SizedBox(height: 20),

            // Password Field
            CustomTextField(
              label: AppStrings.passwordLabel,
              hintText: AppStrings.passwordHint,
              controller: _controller.passwordController,
              obscureText: _controller.obscurePassword,
              isRequired: true,
              onChanged: (value) {
                _controller.validatePassword(value);
              },
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Validation icon
                  if (_controller.passwordController.text.isNotEmpty)
                    _controller.passwordValidated
                        ? const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 20,
                    )
                        : const Icon(
                      Icons.error,
                      color: AppColors.error,
                      size: 20,
                    ),

                  // Visibility toggle
                  IconButton(
                    icon: Icon(
                      _controller.obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.textDisabled,
                    ),
                    onPressed: _controller.togglePasswordVisibility,
                  ),
                ],
              ),
            ),

            // Password Error
            if (_controller.passwordError != null)
              FieldErrorText(
                message: _controller.passwordError,
              ),

            const SizedBox(height: 16),

            // Remember Me & Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remember Me
                Row(
                  children: [
                    Checkbox(
                      value: _controller.rememberMe,
                      onChanged: _controller.toggleRememberMe,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Text(
                      AppStrings.rememberMe,
                      style: TextStyles.bodyMedium,
                    ),
                  ],
                ),

                // Forgot Password

              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.border,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            AppStrings.orContinueWith,
            style: TextStyles.caption,
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.border,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpLink() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppStrings.dontHaveAccount,
            style: TextStyles.bodyMedium,
          ),
          const SizedBox(width: 4),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RegistrationScreen(),
                ),
              );
            },
            child: Text(
              AppStrings.signUp,
              style: TextStyles.link,
            ),
          ),
        ],
      ),
    );
  }


}