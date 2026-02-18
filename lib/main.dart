import 'package:fitness_workout_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fitness_workout_app/features/auth/presentation/pages/login_page.dart';
import 'package:fitness_workout_app/features/exercises_tab/data/repository/exercise_repository_impl.dart';
import 'package:fitness_workout_app/features/exercises_tab/presentation/bloc/exercise_bloc.dart';
import 'package:fitness_workout_app/features/user_details/data/repository/user_details_repository_impl.dart';
import 'package:fitness_workout_app/features/user_details/presentations/bloc/user_details_bloc.dart';
import 'package:fitness_workout_app/features/workout_tab/data/repository/workout_home_repository_impl.dart';
import 'package:fitness_workout_app/features/workout_tab/presentation/bloc/dashboard_bloc.dart';
import 'package:fitness_workout_app/presentation/onboarding_screen/onboarding_screen.dart';
import 'package:fitness_workout_app/presentation/splash_screen/splash_screen.dart';
import 'package:fitness_workout_app/theme_provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'features/auth/data/repository/auth_repository_impl.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'injection_dependency.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  // runApp(const MyApp());

  runApp(
    MultiRepositoryProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        RepositoryProvider(create: (context) => DashboardRepositoryImpl(sl())),
        RepositoryProvider(create: (context) => ExerciseRepositoryImpl(sl())),
        RepositoryProvider(create: (context) => RegisterRepositoryImpl(sl())),
        RepositoryProvider(create: (context) => MasterGoalRepositoryImpl(sl())),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => DashboardBloc(sl(), sl(), sl())),
          BlocProvider(create: (context) => ExerciseBloc(sl(), sl())),
          BlocProvider(
            create: (context) => AuthBloc(sl(), sl(), sl(), sl(), sl()),
          ),
          BlocProvider(
            create: (context) => UserDetailsBloc(sl(), sl(), sl(), sl(), sl()),
          ),
        ],
        child: const MyApp(),
      ),
    ),
    // ChangeNotifierProvider(
    //   create: (_) => ThemeProvider(),
    //   child: const MyApp(),
    // ),
  );
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     return MaterialApp(
//       title: 'Fitness App',
//       debugShowCheckedModeBanner: false,
//       themeMode: themeProvider.currentTheme,
//
//       theme: ThemeData(
//         fontFamily: "Poppins",
//         brightness: Brightness.light,
//         scaffoldBackgroundColor: Colors.white,
//         colorScheme: const ColorScheme.light(secondary: Colors.black),
//       ),
//
//       darkTheme: ThemeData(
//         fontFamily: "Poppins",
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: Colors.black,
//         colorScheme: const ColorScheme.dark(
//           //  primary: Color(0xFFFFFF00),
//           secondary: Colors.white,
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.white,
//             foregroundColor: Colors.black,
//             minimumSize: const Size(double.infinity, 50),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(30.0),
//             ),
//             textStyle: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         textButtonTheme: TextButtonThemeData(
//           style: TextButton.styleFrom(
//             backgroundColor: const Color.fromARGB(255, 30, 30, 30),
//             foregroundColor: Colors.white,
//             minimumSize: const Size(120, 80),
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15.0),
//               side: BorderSide.none,
//             ),
//             textStyle: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//         inputDecorationTheme: InputDecorationTheme(
//           filled: true,
//           fillColor: Colors.transparent,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15.0),
//             borderSide: BorderSide.none,
//           ),
//           //hintStyle: TextStyle(color: Colors.grey.shade600),
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 20,
//             vertical: 20,
//           ),
//         ),
//       ),
//       navigatorKey: navigatorKey,
//       home: const OnboardingFlow(),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Fitness App',
      debugShowCheckedModeBanner: false,
      // themeMode: themeProvider.currentTheme,
      //themeMode: ThemeMode.system,
      themeMode: themeProvider.currentTheme,

      theme: ThemeData(
        fontFamily: "Poppins",
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          secondary: Colors.black,
          primary: Colors.black,
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
      ),

      // DARK THEME
      darkTheme: ThemeData(
        fontFamily: "Poppins",
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          secondary: Colors.white,
          primary: Colors.white,
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF000000),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white38,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),

        // elevatedButtonTheme: ElevatedButtonThemeData(
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: Colors.white,
        //     foregroundColor: Colors.black,
        //     minimumSize: const Size(double.infinity, 50),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(30.0),
        //     ),
        //     textStyle: const TextStyle(
        //       fontSize: 18,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),

        // textButtonTheme: TextButtonThemeData(
        //   style: TextButton.styleFrom(
        //     backgroundColor: Color.fromARGB(255, 30, 30, 30),
        //     foregroundColor: Colors.white,
        //     minimumSize: Size(120, 80),
        //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(15.0),
        //       side: BorderSide.none,
        //     ),
        //     textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        //   ),
        // ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
      ),

      navigatorKey: navigatorKey,
      home: const SplashScreen(),
    );
  }
}
