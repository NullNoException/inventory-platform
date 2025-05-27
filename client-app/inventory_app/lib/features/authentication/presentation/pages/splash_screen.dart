import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_app/core/theme/app_theme.dart';
import 'package:inventory_app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:inventory_app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:inventory_app/features/authentication/presentation/bloc/auth_state.dart';
import 'package:inventory_app/features/authentication/presentation/pages/login_page.dart';
import 'package:inventory_app/features/inventory/presentation/pages/dashboard_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Check authentication status
        context.read<AuthBloc>().add(const AppStarted());
      }
    });

    // Auto-start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              // Navigate to dashboard if authenticated
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const DashboardPage()),
              );
            } else if (state is Unauthenticated) {
              // Navigate to login if not authenticated
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and animation
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Hero(
                      tag: 'app_logo',
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        child: Icon(
                          Icons.inventory_2_rounded,
                          size: 100,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),

                // Text and loading indicator
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        'Inventory Management',
                        style: AppTheme.headingMedium.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Track your inventory across\nmultiple locations with ease',
                        textAlign: TextAlign.center,
                        style: AppTheme.bodyLarge.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 48),
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
