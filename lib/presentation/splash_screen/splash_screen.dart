import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/user_details/presentations/bloc/user_details_bloc.dart';
import '../../local_database/local_storage.dart';
import '../bottom_navigation_bar/bottom_navigation.dart';
import '../onboarding_screen/onboarding_screen.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../theme/color/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.repeat(reverse: true);

    _checkLoginAndNavigate();
  }

  Future<void> _checkLoginAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));

    final bool loggedIn = await LocalStorage.isLoggedIn();

    if (!mounted) return;

    if (!loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      context.read<UserDetailsBloc>().add(GetUserDetailsEvent());
    }
  }

  void _navigateBasedOnUserDetails(Map<String, dynamic> userDetailsJson) {
    final userDetail = userDetailsJson['data']['user_detail'];

    final hasAllDetails =
        userDetail != null &&
        userDetail['gender'] != null &&
        userDetail['user_name'] != null &&
        userDetail['age'] != null &&
        userDetail['current_weight'] != null &&
        userDetail['current_weight_type'] != null &&
        userDetail['target_weight'] != null &&
        userDetail['target_weight_type'] != null &&
        userDetail['height'] != null &&
        userDetail['height_type'] != null;

    if (hasAllDetails) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const FitnessProgramScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingFlow()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final backgroundColor = isDark ? Colors.black : Colors.white;
    final logoColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: BlocListener<UserDetailsBloc, UserDetailsState>(
        listener: (context, state) {
          if (state is GetUserDetailsSuccessState) {
            _navigateBasedOnUserDetails(state.userDetailResponse.toJson());
          } else if (state is GetUserDetailsErrorState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const OnboardingFlow()),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _animation,
                  child: Icon(
                    Icons.fitness_center,
                    size: 100,
                    color: logoColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "MuscleCraft – Body Workout",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: logoColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Track. Train. Transform.",
                  style: TextStyle(fontSize: 16, color: subtitleColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
