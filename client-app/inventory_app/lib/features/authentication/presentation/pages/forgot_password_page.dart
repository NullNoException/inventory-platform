import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_app/core/theme/app_theme.dart';
import 'package:inventory_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:inventory_app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:inventory_app/features/authentication/presentation/bloc/auth_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Dispatch reset password event to the BLoC
    context.read<AuthBloc>().add(
      ResetPasswordRequested(email: _emailController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppTheme.errorColor,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is PasswordResetSent) {
              return _buildSuccessContent(state.email);
            }

            final isLoading = state is AuthLoading;
            return _buildFormContent(isLoading);
          },
        ),
      ),
    );
  }

  Widget _buildFormContent(bool isLoading) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title and description
          Text(
            'Reset Your Password',
            style: AppTheme.headingSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          Text(
            'Enter your email and we\'ll send you a link to reset your password',
            style: AppTheme.bodyMedium.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onBackground.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),

          // Form
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32.h),

                // Submit button
                ElevatedButton(
                  onPressed: isLoading ? null : _resetPassword,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                  ),
                  child:
                      isLoading
                          ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.w,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                          : Text(
                            'Send Reset Link',
                            style: AppTheme.titleSmall.copyWith(
                              color: Colors.white,
                            ),
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent(String email) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Success icon
          Icon(
            Icons.check_circle_outline,
            size: 80.sp,
            color: AppTheme.successColor,
          ),
          SizedBox(height: 24.h),

          // Success message
          Text(
            'Email Sent!',
            style: AppTheme.headingSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          Text(
            'We\'ve sent a password reset link to\n$email\nCheck your inbox and follow the link to reset your password.',
            style: AppTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32.h),

          // Return to login button
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.h),
            ),
            child: Text(
              'Return to Login',
              style: AppTheme.titleSmall.copyWith(color: AppTheme.primaryColor),
            ),
          ),
          SizedBox(height: 16.h),

          // Resend link button
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isLoading = state is AuthLoading;

              return TextButton(
                onPressed: isLoading ? null : _resetPassword,
                child:
                    isLoading
                        ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.w,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryColor,
                            ),
                          ),
                        )
                        : Text(
                          'Didn\'t receive email? Send again',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.primaryColor,
                          ),
                        ),
              );
            },
          ),
        ],
      ),
    );
  }
}
