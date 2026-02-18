import 'dart:io';

import 'package:fitness_workout_app/presentation/tab/profile_tab/profile_screen.dart';
import 'package:fitness_workout_app/presentation/tab/tools_tab/tools_screen.dart';
import 'package:fitness_workout_app/presentation/tab/tracking_tab/tracking_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../features/exercises_tab/presentation/pages/exercise_screen/exercise_screen.dart';
import '../../features/workout_tab/presentation/pages/workout_tab/featured_programs_screen.dart';
import '../../theme_provider/theme_provider.dart';

class FitnessProgramScreen extends StatefulWidget {
  const FitnessProgramScreen({super.key});

  @override
  State<FitnessProgramScreen> createState() => _FitnessProgramScreenState();
}

class _FitnessProgramScreenState extends State<FitnessProgramScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: _buildBottomNavBar(),
      body: SafeArea(
        child: _selectedIndex == 0
            ? ProgramsScreen()
            : _selectedIndex == 1
            ? TrackingScreen()
            : _selectedIndex == 2
            ? ExerciseScreen()
            : _selectedIndex == 3
            ? ToolsScreen()
            : _selectedIndex == 4
            ? ProfileScreen()
            : _buildPlaceholderScreen(),
      ),
    );
  }

  Widget _buildPlaceholderScreen() {
    return const Center(
      child: Text('Coming Soon...', style: TextStyle(color: Colors.white54)),
    );
  }

  // Widget _buildBottomNavBar() {
  //   final themeProvider = Provider.of<ThemeProvider>(context);
  //   bool isDarkMode =
  //       themeProvider.currentTheme == ThemeMode.dark ||
  //       (themeProvider.currentTheme == ThemeMode.system &&
  //           MediaQuery.of(context).platformBrightness == Brightness.dark);
  //   return Container(
  //     //padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
  //     padding: EdgeInsets.fromLTRB(30, 8, 30, Platform.isIOS ? 20 : 8),
  //     // decoration: const BoxDecoration(
  //     //   gradient: LinearGradient(
  //     //     colors: [Color(0xff272727), Color(0xFF000000), Color(0xFF272727)],
  //     //     begin: Alignment.topRight,
  //     //     end: Alignment.bottomLeft,
  //     //   ),
  //     //   border: Border(top: BorderSide(color: Colors.white12)),
  //     // ),
  //     decoration: BoxDecoration(
  //       gradient: isDarkMode
  //           ? const LinearGradient(
  //               colors: [
  //                 Color(0xff272727),
  //                 Color(0xFF000000),
  //                 Color(0xFF272727),
  //               ],
  //             )
  //           : null,
  //       color: isDarkMode
  //           ? Theme.of(context).bottomNavigationBarTheme.backgroundColor
  //           : null,
  //     ),
  //
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         _BottomNavItem(
  //           svgIcon: 'assets/icons/program.svg',
  //           label: "Workout",
  //           isActive: _selectedIndex == 0,
  //           onTap: () => setState(() => _selectedIndex = 0),
  //         ),
  //         _BottomNavItem(
  //           svgIcon: 'assets/icons/tracking.svg',
  //           label: "Tracking",
  //           isActive: _selectedIndex == 1,
  //           onTap: () => setState(() => _selectedIndex = 1),
  //         ),
  //
  //         _BottomNavItem(
  //           svgIcon: 'assets/icons/program.svg',
  //           label: "Exercises",
  //           isActive: _selectedIndex == 2,
  //           onTap: () => setState(() => _selectedIndex = 2),
  //         ),
  //
  //         _BottomNavItem(
  //           svgIcon: 'assets/icons/toolbox.svg',
  //           label: "Tools",
  //           isActive: _selectedIndex == 3,
  //           onTap: () => setState(() => _selectedIndex = 3),
  //         ),
  //         _BottomNavItem(
  //           svgIcon: 'assets/icons/profile.svg',
  //           label: "Profile",
  //           isActive: _selectedIndex == 4,
  //           onTap: () => setState(() => _selectedIndex = 4),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildBottomNavBar() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode =
        themeProvider.currentTheme == ThemeMode.dark ||
        (themeProvider.currentTheme == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    Color? selectedColor = isDarkMode
        ? Colors.white
        : Colors.black; // selected item
    Color? unselectedColor = isDarkMode
        ? Colors.white38
        : Colors.grey; // unselected item
    Color? backgroundColor = isDarkMode
        ? Colors.transparent
        : Colors.white; // container bg

    return Container(
      padding: EdgeInsets.fromLTRB(30, 8, 30, Platform.isIOS ? 20 : 8),
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? const LinearGradient(
                colors: [
                  Color(0xff272727),
                  Color(0xFF000000),
                  Color(0xFF272727),
                ],
              )
            : null,
        color: !isDarkMode ? backgroundColor : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _BottomNavItem(
            svgIcon: 'assets/icons/program.svg',
            label: "Workout",
            isActive: _selectedIndex == 0,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            onTap: () => setState(() => _selectedIndex = 0),
          ),
          _BottomNavItem(
            svgIcon: 'assets/icons/tracking.svg',
            label: "Tracking",
            isActive: _selectedIndex == 1,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            onTap: () => setState(() => _selectedIndex = 1),
          ),
          _BottomNavItem(
            svgIcon: 'assets/icons/program.svg',
            label: "Exercises",
            isActive: _selectedIndex == 2,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            onTap: () => setState(() => _selectedIndex = 2),
          ),
          _BottomNavItem(
            svgIcon: 'assets/icons/toolbox.svg',
            label: "Tools",
            isActive: _selectedIndex == 3,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            onTap: () => setState(() => _selectedIndex = 3),
          ),
          _BottomNavItem(
            svgIcon: 'assets/icons/profile.svg',
            label: "Profile",
            isActive: _selectedIndex == 4,
            selectedColor: selectedColor,
            unselectedColor: unselectedColor,
            onTap: () => setState(() => _selectedIndex = 4),
          ),
        ],
      ),
    );
  }
}

// class _BottomNavItem extends StatelessWidget {
//   final String? svgIcon;
//   final String label;
//   final bool isActive;
//   final VoidCallback onTap;
//
//   const _BottomNavItem({
//     required this.svgIcon,
//     required this.label,
//     required this.onTap,
//     this.isActive = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SvgPicture.asset(
//             svgIcon!,
//             width: 24,
//             height: 24,
//             // colorFilter: ColorFilter.mode(
//             //   isActive ? Colors.white : Colors.grey,
//             //   BlendMode.srcIn,
//             // ),
//             colorFilter: ColorFilter.mode(
//               isActive
//                   ? Theme.of(
//                       context,
//                     ).bottomNavigationBarTheme.selectedItemColor!
//                   : Theme.of(
//                       context,
//                     ).bottomNavigationBarTheme.unselectedItemColor!,
//               BlendMode.srcIn,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               //  color: isActive ? Colors.white : Colors.white38,
//               color: isActive
//                   ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
//                   : Theme.of(
//                       context,
//                     ).bottomNavigationBarTheme.unselectedItemColor,
//
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _BottomNavItem extends StatelessWidget {
  final String? svgIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color? selectedColor;
  final Color? unselectedColor;

  const _BottomNavItem({
    required this.svgIcon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            svgIcon!,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              isActive ? selectedColor! : unselectedColor!,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? selectedColor : unselectedColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
