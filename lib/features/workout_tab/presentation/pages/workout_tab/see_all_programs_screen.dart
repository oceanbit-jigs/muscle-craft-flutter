// import 'package:fitness_workout_app/features/workout_tab/presentation/pages/workout_tab/workout_tab.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../../core/utils/api.dart';
// import '../../../domain/model/workout_home_model.dart';
//
// class SeeAllProgramsScreen extends StatelessWidget {
//   final String title;
//   //final List<Map<String, String>> programs;
//   //final List<Workout> programs;
//   final int categoryId;
//
//   const SeeAllProgramsScreen({
//     super.key,
//     required this.title,
//     //required this.programs,
//     required this.categoryId,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvoked: (didPop) {
//         if (didPop) return;
//
//         Navigator.pop(context, true);
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           leading: Padding(
//             padding: const EdgeInsets.only(left: 12),
//             child: Builder(
//               builder: (context) {
//                 bool isDark = Theme.of(context).brightness == Brightness.dark;
//                 return Container(
//                   height: 25,
//                   width: 25,
//                   decoration: BoxDecoration(
//                     color: isDark ? Colors.white : Colors.black,
//                     shape: BoxShape.circle,
//                   ),
//                   child: IconButton(
//                     icon: Icon(
//                       Icons.arrow_back,
//                       color: isDark ? Colors.black : Colors.white,
//                       size: 21,
//                     ),
//                     //onPressed: () => Navigator.pop(context),
//                     onPressed: () => Navigator.pop(context, true),
//                   ),
//                 );
//               },
//             ),
//           ),
//           title: Builder(
//             builder: (context) {
//               bool isDark = Theme.of(context).brightness == Brightness.dark;
//               return Text(
//                 title,
//                 style: TextStyle(
//                   color: isDark ? Colors.white : Colors.black,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 18,
//                 ),
//               );
//             },
//           ),
//           centerTitle: true,
//         ),
//
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: ListView.builder(
//               itemCount: programs.length,
//               itemBuilder: (context, index) {
//                 final program = programs[index];
//                 return Padding(
//                   padding: const EdgeInsets.only(bottom: 16.0),
//                   child: _buildProgramCard(program, context),
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProgramCard(Workout program, BuildContext context) {
//     bool isDark = Theme.of(context).brightness == Brightness.dark;
//
//     final imageUrl = program.imageUrl.startsWith('http')
//         ? program.imageUrl
//         : Api.base + program.imageUrl;
//
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => WorkoutProgramDetailScreen(workoutId: program.id),
//           ),
//         );
//       },
//       child: Container(
//         height: 250,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: NetworkImage(imageUrl),
//             fit: BoxFit.cover,
//           ),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isDark ? Colors.grey : Colors.black,
//             width: 1,
//           ),
//         ),
//         child: Container(
//           alignment: Alignment.bottomCenter,
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             gradient: LinearGradient(
//               colors: [Colors.black.withOpacity(0.6), Colors.transparent],
//               begin: Alignment.bottomCenter,
//               end: Alignment.topCenter,
//             ),
//           ),
//           child: Text(
//             program.displayName,
//             textAlign: TextAlign.center,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:fitness_workout_app/features/workout_tab/presentation/pages/workout_tab/workout_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/api.dart';
import '../../../../exercises_tab/domain/model/show_category_model.dart';
import '../../../../exercises_tab/presentation/bloc/exercise_bloc.dart';

class SeeAllProgramsScreen extends StatelessWidget {
  final String title;
  final int categoryId;

  const SeeAllProgramsScreen({
    super.key,
    required this.title,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    context.read<ExerciseBloc>().add(
      GetCategoryDetailsEvent(categoryId: categoryId),
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Builder(
              builder: (context) {
                bool isDark = Theme.of(context).brightness == Brightness.dark;
                return Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white : Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: isDark ? Colors.black : Colors.white,
                      size: 21,
                    ),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                );
              },
            ),
          ),
          title: Builder(
            builder: (context) {
              bool isDark = Theme.of(context).brightness == Brightness.dark;
              return Text(
                title,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              );
            },
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: BlocBuilder<ExerciseBloc, ExerciseState>(
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CategoryError) {
                  return Center(child: Text(state.message));
                } else if (state is CategoryLoaded) {
                  final programs = state.data.data.workouts;

                  if (programs.isEmpty) {
                    return const Center(child: Text("No workouts found"));
                  }

                  return ListView.builder(
                    itemCount: programs.length,
                    itemBuilder: (context, index) {
                      final program = programs[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildProgramCard(program, context),
                      );
                    },
                  );
                }

                // Fallback empty widget
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildProgramCard(Workout program, BuildContext context) {
  //   bool isDark = Theme.of(context).brightness == Brightness.dark;
  //
  //   final imageUrl = program.imageUrl.startsWith('http')
  //       ? program.imageUrl
  //       : Api.base + program.imageUrl;
  //
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) => WorkoutProgramDetailScreen(workoutId: program.id),
  //         ),
  //       );
  //     },
  //     child: Container(
  //       height: 250,
  //       decoration: BoxDecoration(
  //         image: DecorationImage(
  //           image: NetworkImage(imageUrl),
  //           fit: BoxFit.cover,
  //         ),
  //         borderRadius: BorderRadius.circular(16),
  //         border: Border.all(
  //           color: isDark ? Colors.grey : Colors.black,
  //           width: 1,
  //         ),
  //       ),
  //       child: Container(
  //         alignment: Alignment.bottomCenter,
  //         padding: const EdgeInsets.all(12),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(16),
  //           gradient: LinearGradient(
  //             colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
  //             begin: Alignment.bottomCenter,
  //             end: Alignment.topCenter,
  //           ),
  //         ),
  //         child: Align(
  //           alignment: Alignment.bottomLeft,
  //           child: Text(
  //             program.displayName,
  //             textAlign: TextAlign.start,
  //             maxLines: 2,
  //             overflow: TextOverflow.ellipsis,
  //             style: const TextStyle(
  //               color: Colors.white,
  //               fontSize: 18,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildProgramCard(Workout program, BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final imageUrl = program.imageUrl.startsWith('http')
        ? program.imageUrl
        : Api.base + program.imageUrl;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorkoutProgramDetailScreen(workoutId: program.id),
          ),
        );
      },
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.grey : Colors.black,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            /// Bottom gradient + title
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    program.displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            /// Top-right button
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          WorkoutProgramDetailScreen(workoutId: program.id),
                    ),
                  );
                },
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white : Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: isDark ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
