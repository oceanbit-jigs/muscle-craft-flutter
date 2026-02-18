// import 'package:flutter/material.dart';
// import 'dart:math' as math;
//
// import '../bottom_navigation_bar/bottom_navigation.dart';
//
// class LoadingScreen extends StatefulWidget {
//   const LoadingScreen({super.key});
//
//   @override
//   State<LoadingScreen> createState() => _LoadingScreenState();
// }
//
// class _LoadingScreenState extends State<LoadingScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _progressAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 6),
//     );
//
//     _progressAnimation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOutCubic,
//     );
//
//     _controller.forward();
//
//     // 🔹 Navigate to FitnessProgramScreen after animation completes
//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         Future.delayed(const Duration(milliseconds: 500), () {
//           if (mounted) {
//             Navigator.of(context).pushReplacement(
//               PageRouteBuilder(
//                 pageBuilder: (_, __, ___) => const FitnessProgramScreen(),
//                 transitionsBuilder: (_, animation, __, child) {
//                   return FadeTransition(opacity: animation, child: child);
//                 },
//                 transitionDuration: const Duration(milliseconds: 800),
//               ),
//             );
//           }
//         });
//       }
//     });
//   }
//
//   String _formatDays(double progress) {
//     int completedDays = (progress * 28).clamp(0, 28).toInt();
//     return "$completedDays/28 days";
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const Color glowColor = Colors.white;
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: AnimatedBuilder(
//           animation: _progressAnimation,
//           builder: (context, _) {
//             double progress = _progressAnimation.value;
//             int percent = (progress * 100).clamp(0, 100).toInt();
//
//             return Stack(
//               children: [
//                 Center(
//                   child: Container(
//                     width: 220,
//                     height: 220,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: RadialGradient(
//                         colors: [
//                           // Animate the brightness of the center dynamically
//                           Color.lerp(
//                             Colors.grey.shade800,
//                             Colors.white,
//                             progress * 0.8,
//                           )!,
//                           Colors.black,
//                         ],
//                         center: Alignment(
//                           math.sin(progress * math.pi * 2) * 0.3,
//                           -math.cos(progress * math.pi * 2) * 0.3,
//                         ), // animate gradient movement
//                         radius: 0.9,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: glowColor.withOpacity(0.3 + progress * 0.4),
//                           blurRadius: 25,
//                           spreadRadius: 5,
//                         ),
//                       ],
//                     ),
//                     child: Center(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           // Percent text
//                           Text(
//                             "$percent%",
//                             style: TextStyle(
//                               fontSize: 38,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               shadows: [
//                                 Shadow(
//                                   color: glowColor.withOpacity(0.5),
//                                   blurRadius: 10,
//                                 ),
//                                 Shadow(
//                                   color: glowColor.withOpacity(0.5),
//                                   blurRadius: 20,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             _formatDays(progress),
//                             style: const TextStyle(
//                               fontSize: 16,
//                               color: Colors.white70,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Padding(
//                     padding: const EdgeInsets.only(bottom: 60.0),
//                     child: Text(
//                       'Please wait, do not lock screen\nor switch to other apps.',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         color: Colors.white54,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../bottom_navigation_bar/bottom_navigation.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _progressAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (_, _, _) => const FitnessProgramScreen(),
                transitionsBuilder: (_, animation, _, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 800),
              ),
            );
          }
        });
      }
    });
  }

  String _formatDays(double progress) {
    int completedDays = (progress * 28).clamp(0, 28).toInt();
    return "$completedDays/28 days";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = theme.scaffoldBackgroundColor;
    final glowColor = isDark ? Colors.white : Colors.black;
    final textColor = theme.colorScheme.onSurface;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, _) {
            double progress = _progressAnimation.value;
            int percent = (progress * 100).clamp(0, 100).toInt();

            return Stack(
              children: [
                Center(
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color.lerp(
                            isDark
                                ? Colors.grey.shade800
                                : Colors.grey.shade300,
                            glowColor,
                            progress * 0.8,
                          )!,
                          bgColor,
                        ],
                        center: Alignment(
                          math.sin(progress * math.pi * 2) * 0.3,
                          -math.cos(progress * math.pi * 2) * 0.3,
                        ),
                        radius: 0.9,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: glowColor.withValues(
                            alpha: 0.3 + progress * 0.4,
                          ),
                          blurRadius: 25,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "$percent%",
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                              shadows: [
                                Shadow(
                                  color: glowColor.withValues(alpha: 0.4),
                                  blurRadius: 10,
                                ),
                                Shadow(
                                  color: glowColor.withValues(alpha: 0.4),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            _formatDays(progress),
                            style: TextStyle(fontSize: 16, color: subTextColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 60.0),
                    child: Text(
                      'Please wait, do not lock screen\nor switch to other apps.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: subTextColor, fontSize: 16),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
