// import 'dart:async';
// import 'package:fitness_workout_app/features/workout_tab/presentation/pages/workout_tab/video_widget_page/video_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../../../../../core/utils/api.dart';
// import '../../../../../../../theme/color/colors.dart';
// import '../../../../exercises_tab/domain/model/exercise_model.dart';
// import '../../../../exercises_tab/presentation/bloc/exercise_bloc.dart';
// import 'exercise_complete_screen.dart';
//
// class _UiExercise {
//   final int id;
//   final String displayName;
//   final String imageUrl;
//
//   _UiExercise({
//     required this.id,
//     required this.displayName,
//     required this.imageUrl,
//   });
//
//   factory _UiExercise.fromExerciseModel(ExerciseModel e) {
//     return _UiExercise(
//       id: e.id,
//       displayName: e.displayName,
//       imageUrl: e.imageUrl,
//     );
//   }
// }
//
// class CompletedExercise1 {
//   final String workoutName;
//   final String name;
//   final String imageUrl;
//   final int sets;
//   final int done;
//   final List<int> weights;
//   final List<int> reps;
//
//   CompletedExercise1({
//     required this.workoutName,
//     required this.name,
//     required this.sets,
//     required this.imageUrl,
//     required this.done,
//     required this.weights,
//     required this.reps,
//   });
// }
//
// class ExerciseCounterScreen extends StatefulWidget {
//   final int focusAreaId;
//   final String focusAreaName;
//
//   const ExerciseCounterScreen({
//     super.key,
//     required this.focusAreaId,
//     required this.focusAreaName,
//   });
//
//   @override
//   State<ExerciseCounterScreen> createState() => ExerciseCounterScreenState();
// }
//
// class ExerciseCounterScreenState extends State<ExerciseCounterScreen> {
//   final Map<int, bool> _expanded = {};
//   final Map<int, int> _setsCount = {};
//   final Map<int, int> _doneCount = {};
//   final Map<int, Set<int>> _completedSets = {};
//
//   List<ExerciseModel> addedExercises = [];
//
//   final ScrollController _scrollController = ScrollController();
//
//   Timer? _timer;
//   int _seconds = 0;
//
//   final TextEditingController _searchController = TextEditingController();
//
//   final String timerKey = "workout_timer_value";
//
//   Map<int, Map<int, TextEditingController>> weightControllers = {};
//   Map<int, Map<int, TextEditingController>> repsControllers = {};
//
//   TextEditingController _getWeightController(int exerciseIndex, int setNo) {
//     weightControllers[exerciseIndex] ??= {};
//     weightControllers[exerciseIndex]![setNo] ??= TextEditingController(
//       text: "4",
//     );
//     return weightControllers[exerciseIndex]![setNo]!;
//   }
//
//   TextEditingController _getRepsController(int exerciseIndex, int setNo) {
//     repsControllers[exerciseIndex] ??= {};
//     repsControllers[exerciseIndex]![setNo] ??= TextEditingController(text: "4");
//     return repsControllers[exerciseIndex]![setNo]!;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSavedTimer();
//     context.read<ExerciseBloc>().add(
//       GetExercisesEvent(focusAreaId: widget.focusAreaId),
//     );
//   }
//
//   void _loadSavedTimer() async {
//     final prefs = await SharedPreferences.getInstance();
//     _seconds = prefs.getInt(timerKey) ?? 0;
//     _startTimer();
//     setState(() {});
//   }
//
//   void _saveTimer() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setInt(timerKey, _seconds);
//   }
//
//   void _startTimer() {
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
//       _seconds++;
//       setState(() {});
//     });
//   }
//
//   void _stopTimer() {
//     _timer?.cancel();
//     _saveTimer();
//   }
//
//   @override
//   void dispose() {
//     _stopTimer();
//     _searchController;
//     for (var exerciseControllers in weightControllers.values) {
//       for (var controller in exerciseControllers.values) {
//         controller.dispose();
//       }
//     }
//     for (var exerciseControllers in repsControllers.values) {
//       for (var controller in exerciseControllers.values) {
//         controller.dispose();
//       }
//     }
//     super.dispose();
//   }
//
//   String _formatTime(int sec) {
//     int m = sec ~/ 60;
//     int s = sec % 60;
//     return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
//   }
//
//   void _markCurrentExerciseAllDone() {
//     for (int i = 0; i < _setsCount.length; i++) {
//       int total = _setsCount[i] ?? 4;
//       int done = _doneCount[i] ?? 0;
//
//       if (done < total) {
//         setState(() {
//           _doneCount[i] = total;
//           _completedSets[i] = Set.from(
//             List.generate(total, (index) => index + 1),
//           );
//           _expanded[i] = false;
//         });
//         break;
//       }
//     }
//   }
//
//   void _logNextSet() {
//     for (int i = 0; i < _setsCount.length; i++) {
//       int total = _setsCount[i] ?? 4;
//       int done = _doneCount[i] ?? 0;
//
//       if (done >= total) continue;
//
//       int nextSet = done + 1;
//
//       setState(() {
//         _doneCount[i] = nextSet;
//
//         _completedSets.putIfAbsent(i, () => <int>{});
//         _completedSets[i]!.add(nextSet);
//
//         _expanded[i] = true;
//       });
//
//       if (_doneCount[i] == total) {
//         Future.delayed(const Duration(milliseconds: 600), () {
//           setState(() {
//             _expanded[i] = false;
//           });
//         });
//       }
//
//       return;
//     }
//
//     bool allDone = _setsCount.keys.every((i) {
//       int total = _setsCount[i] ?? 4;
//       int done = _doneCount[i] ?? 0;
//       return done >= total;
//     });
//
//     if (allDone) {
//       _stopTimer();
//
//       // Navigator.push(
//       //   context,
//       //   MaterialPageRoute(
//       //     builder: (_) => WorkoutCompletedScreen(
//       //       durationSeconds: _seconds,
//       //       exercises: _buildCompletionData(),
//       //     ),
//       //   ),
//       // );
//       return;
//     }
//   }
//
//   void _finishWorkout() {
//     _stopTimer();
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ExerciseCompletedScreen(
//           durationSeconds: _seconds,
//           exercises: _buildCompletionData(),
//         ),
//       ),
//     );
//   }
//
//   bool get isWorkoutFullyCompleted {
//     if (_setsCount.isEmpty) return false;
//
//     return _setsCount.keys.every((index) {
//       int totalSets = _setsCount[index] ?? 0;
//       int doneSets = _doneCount[index] ?? 0;
//       return totalSets > 0 && doneSets >= totalSets;
//     });
//   }
//
//   List<CompletedExercise1> _buildCompletionData() {
//     final List<CompletedExercise1> result = [];
//
//     final allExercises = [
//       ...(context.read<ExerciseBloc>().state as ExerciseLoaded).exercises.map(
//         (we) => _UiExercise.fromExerciseModel(we),
//       ),
//       ...addedExercises.map((e) => _UiExercise.fromExerciseModel(e)),
//     ];
//
//     for (int i = 0; i < _setsCount.length; i++) {
//       final exercise = i < allExercises.length
//           ? allExercises[i]
//           : _UiExercise(id: -1, displayName: "Exercise ${i + 1}", imageUrl: "");
//
//       final int totalSets = _setsCount[i] ?? 0;
//
//       final List<int> weights = List.generate(totalSets, (setIndex) {
//         final controller = weightControllers[i]?[setIndex + 1];
//         return int.tryParse(controller?.text ?? '0') ?? 0;
//       });
//
//       final List<int> reps = List.generate(totalSets, (setIndex) {
//         final controller = repsControllers[i]?[setIndex + 1];
//         return int.tryParse(controller?.text ?? '0') ?? 0;
//       });
//
//       result.add(
//         CompletedExercise1(
//           workoutName: widget.focusAreaName,
//           name: exercise.displayName,
//           imageUrl: exercise.imageUrl,
//           sets: totalSets,
//           done: _doneCount[i] ?? 0,
//           weights: weights,
//           reps: reps,
//         ),
//       );
//     }
//
//     return result;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (didPop, result) {
//         if (!didPop) {
//           _stopTimer();
//           Navigator.pop(context, true);
//         }
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.background(context),
//         appBar: _appBar(context),
//         body: _body(context),
//         bottomNavigationBar: _bottomButton(context),
//       ),
//     );
//   }
//
//   AppBar _appBar(BuildContext context) {
//     return AppBar(
//       backgroundColor: AppColors.card(context),
//       elevation: 0,
//       leading: Padding(
//         padding: const EdgeInsets.only(left: 12),
//         child: Builder(
//           builder: (context) {
//             bool isDark = Theme.of(context).brightness == Brightness.dark;
//             return Container(
//               height: 25,
//               width: 25,
//               decoration: BoxDecoration(
//                 color: isDark ? Colors.white : Colors.black,
//                 shape: BoxShape.circle,
//               ),
//               child: IconButton(
//                 icon: Icon(
//                   Icons.arrow_back,
//                   color: isDark ? Colors.black : Colors.white,
//                   size: 21,
//                 ),
//                 onPressed: () {
//                   _stopTimer();
//                   Navigator.pop(context, true);
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//       title: Text(
//         widget.focusAreaName,
//         style: TextStyle(
//           color: AppColors.text(context),
//           fontWeight: FontWeight.w700,
//           fontSize: 18,
//         ),
//       ),
//       centerTitle: true,
//     );
//   }
//
//   Widget _body(BuildContext context) {
//     return SingleChildScrollView(
//       controller: _scrollController,
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         children: [
//           _timerBox(context),
//           const SizedBox(height: 16),
//           BlocBuilder<ExerciseBloc, ExerciseState>(
//             builder: (context, state) {
//               if (state is ExerciseLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (state is ExerciseError) {
//                 return Center(child: Text(state.message));
//               } else if (state is ExerciseLoaded) {
//                 final exercise = state.exercises;
//
//                 final List<_UiExercise> uiExercises = [
//                   ...exercise.map((we) => _UiExercise.fromExerciseModel(we)),
//                   ...addedExercises.map(
//                     (e) => _UiExercise.fromExerciseModel(e),
//                   ),
//                 ];
//
//                 if (_setsCount.isEmpty) {
//                   for (int i = 0; i < uiExercises.length; i++) {
//                     _setsCount[i] = 4;
//                     _doneCount[i] = 0;
//                   }
//                 } else if (_setsCount.length < uiExercises.length) {
//                   for (int i = _setsCount.length; i < uiExercises.length; i++) {
//                     _setsCount[i] = 4;
//                     _doneCount[i] = 0;
//                   }
//                 }
//
//                 if (uiExercises.isEmpty) {
//                   return Center(child: Text("No exercises found"));
//                 }
//
//                 if (uiExercises.isEmpty) {
//                   return Center(child: Text("No exercises found"));
//                 }
//
//                 return Column(
//                   children: [
//                     ...List.generate(
//                       uiExercises.length,
//                       (index) => Column(
//                         children: [
//                           //_exerciseCard(context, exercises[index], index),
//                           _exerciseCard(context, uiExercises[index], index),
//                           const SizedBox(height: 16),
//                         ],
//                       ),
//                     ),
//                     // SizedBox(height: 10),
//                     // GestureDetector(
//                     //   onTap: () async {
//                     //     final selectedIds = await _openAddExerciseSheet();
//                     //
//                     //     if (selectedIds != null && selectedIds.isNotEmpty) {
//                     //       _addSelectedExercises(selectedIds);
//                     //     }
//                     //   },
//                     //
//                     //   child: Container(
//                     //     height: 50,
//                     //     alignment: Alignment.center,
//                     //     decoration: BoxDecoration(
//                     //       color: AppColors.primary(context),
//                     //       borderRadius: BorderRadius.circular(16),
//                     //     ),
//                     //     child: Text(
//                     //       "+ Add Exercise",
//                     //       style: TextStyle(
//                     //         color: AppColors.buttonText(context),
//                     //         fontSize: 17,
//                     //         fontWeight: FontWeight.w600,
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//                   ],
//                 );
//               }
//               return const SizedBox();
//             },
//           ),
//           // const SizedBox(height: 100),
//         ],
//       ),
//     );
//   }
//
//   Widget _timerBox(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
//       decoration: BoxDecoration(
//         color: AppColors.card(context),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.timer_outlined, color: AppColors.text(context), size: 32),
//           const SizedBox(width: 12),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.green.withValues(alpha: 0.15),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Text(
//               _formatTime(_seconds),
//               style: const TextStyle(
//                 color: Colors.green,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _exerciseCard(BuildContext context, _UiExercise exercise, int index) {
//     final isOpen = _expanded[index] ?? false;
//     final totalSets = _setsCount[index] ?? 4;
//     final doneSets = _doneCount[index] ?? 0;
//
//     final image = (exercise.imageUrl.isNotEmpty)
//         ? NetworkImage(Api.base + exercise.imageUrl)
//         : const AssetImage("assets/program/shoulders.png") as ImageProvider;
//
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 250),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: AppColors.card(context),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: AppColors.border(context)),
//       ),
//       child: Column(
//         children: [
//           InkWell(
//             onTap: () => setState(() => _expanded[index] = !isOpen),
//             child: Row(
//               children: [
//                 Container(
//                   height: 55,
//                   width: 55,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     image: DecorationImage(image: image, fit: BoxFit.cover),
//                     border: Border.all(color: AppColors.border(context)),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         exercise.displayName,
//                         style: TextStyle(
//                           color: AppColors.text(context),
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         "$doneSets/$totalSets Done",
//                         style: TextStyle(color: AppColors.subText(context)),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Column(
//                   children: [
//                     IconButton(
//                       icon: Icon(
//                         Icons.more_vert,
//                         color: AppColors.text(context),
//                       ),
//                       onPressed: () {},
//                       padding: EdgeInsets.zero,
//                     ),
//                     Icon(
//                       isOpen
//                           ? Icons.keyboard_arrow_up
//                           : Icons.keyboard_arrow_down,
//                       color: AppColors.text(context),
//                       size: 26,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           AnimatedCrossFade(
//             firstChild: const SizedBox.shrink(),
//             secondChild: Column(
//               children: [
//                 const SizedBox(height: 14),
//                 for (int i = 1; i <= totalSets; i++) ...[
//                   _setRow(context, i, index),
//                   const SizedBox(height: 10),
//                 ],
//                 _exerciseBottomButtons(context, index, exercise.id),
//               ],
//             ),
//             crossFadeState: isOpen
//                 ? CrossFadeState.showSecond
//                 : CrossFadeState.showFirst,
//             duration: const Duration(milliseconds: 250),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _setRow(BuildContext context, int setNo, int exerciseIndex) {
//     bool isCompleted = _completedSets[exerciseIndex]?.contains(setNo) ?? false;
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       decoration: BoxDecoration(
//         color: isCompleted
//             ? Colors.green.withValues(alpha: 0.2)
//             : AppColors.rowAlternate(context),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: isCompleted ? Colors.greenAccent : AppColors.border(context),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Icon(
//             isCompleted ? Icons.check_circle : Icons.circle_outlined,
//             size: 22,
//             color: isCompleted ? Colors.green : AppColors.text(context),
//           ),
//
//           Text(
//             "$setNo",
//             style: TextStyle(
//               color: isCompleted ? Colors.green : AppColors.text(context),
//             ),
//           ),
//
//           _numberTextField(
//             context,
//             _getWeightController(exerciseIndex, setNo),
//             isCompleted,
//           ),
//           Text("kg", style: TextStyle(color: AppColors.subText(context))),
//
//           _numberTextField(
//             context,
//             _getRepsController(exerciseIndex, setNo),
//             isCompleted,
//           ),
//           Text("Reps", style: TextStyle(color: AppColors.subText(context))),
//         ],
//       ),
//     );
//   }
//
//   Widget _numberTextField(
//     BuildContext context,
//     TextEditingController controller,
//     bool isCompleted,
//   ) {
//     return Container(
//       width: 55,
//       height: 36,
//       decoration: BoxDecoration(
//         color: AppColors.cardDark(context),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: AppColors.border(context)),
//       ),
//       child: TextField(
//         controller: controller,
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         maxLength: 3,
//         inputFormatters: [
//           FilteringTextInputFormatter.digitsOnly,
//           LengthLimitingTextInputFormatter(3),
//         ],
//         style: TextStyle(
//           color: isCompleted ? Colors.green : AppColors.text(context),
//           fontWeight: FontWeight.w600,
//           fontSize: 14,
//         ),
//         decoration: const InputDecoration(
//           border: InputBorder.none,
//           counterText: "",
//           isDense: true,
//           contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//         ),
//         onTapOutside: (_) => FocusScope.of(context).unfocus(),
//       ),
//     );
//   }
//
//   Widget _exerciseBottomButtons(
//     BuildContext context,
//     int index,
//     int exerciseId,
//   ) {
//     return Row(
//       children: [
//         Expanded(
//           child: SizedBox(
//             height: 48,
//             child: OutlinedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => VideoPage(exerciseId: exerciseId),
//                   ),
//                 );
//               },
//               style: OutlinedButton.styleFrom(
//                 side: BorderSide(color: AppColors.text(context)),
//               ),
//               child: Text(
//                 "Detail",
//                 style: TextStyle(color: AppColors.text(context)),
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           flex: 2,
//           child: SizedBox(
//             height: 48,
//             child: ElevatedButton.icon(
//               onPressed: () => setState(() {
//                 _setsCount[index] = (_setsCount[index] ?? 4) + 1;
//               }),
//               icon: Icon(Icons.add, color: AppColors.buttonText(context)),
//               label: Text(
//                 "Add a set",
//                 style: TextStyle(color: AppColors.buttonText(context)),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary(context),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _bottomButton(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 _markCurrentExerciseAllDone();
//               },
//               child: Container(
//                 width: 70,
//                 height: 55,
//                 decoration: BoxDecoration(
//                   color: AppColors.primary(context),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.check_circle_outline,
//                       color: AppColors.buttonText(context),
//                     ),
//                     Text(
//                       "All",
//                       style: TextStyle(color: AppColors.buttonText(context)),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: GestureDetector(
//                 onTap: isWorkoutFullyCompleted ? _finishWorkout : _logNextSet,
//                 child: Container(
//                   height: 55,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: AppColors.primary(context),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Text(
//                     isWorkoutFullyCompleted ? "DONE" : "LOG NEXT SET",
//                     style: TextStyle(
//                       color: AppColors.buttonText(context),
//                       fontSize: 17,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:fitness_workout_app/features/workout_tab/presentation/pages/workout_tab/video_widget_page/video_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../../../../core/utils/api.dart';
import '../../../../../../../theme/color/colors.dart';
import '../../../../../local_database/database_model/workout_session_model.dart';
import '../../../../../local_database/onboarding_storage.dart';
import '../../../../../local_database/repo/workout_session_repository.dart';
import '../../../../exercises_tab/domain/model/exercise_model.dart';
import '../../../../exercises_tab/presentation/bloc/exercise_bloc.dart';
import 'excersice_history_screen.dart';
import 'exercise_complete_screen.dart';

class _UiExercise {
  final int id;
  final String displayName;
  final String imageUrl;

  _UiExercise({
    required this.id,
    required this.displayName,
    required this.imageUrl,
  });

  factory _UiExercise.fromExerciseModel(ExerciseModel e) {
    return _UiExercise(
      id: e.id,
      displayName: e.displayName,
      imageUrl: e.imageUrl,
    );
  }
}

class CompletedExercise1 {
  final String workoutName;
  final String name;
  final String imageUrl;
  final int sets;
  final int done;
  final List<int> weights;
  final List<int> reps;

  CompletedExercise1({
    required this.workoutName,
    required this.name,
    required this.sets,
    required this.imageUrl,
    required this.done,
    required this.weights,
    required this.reps,
  });
}

class ExerciseCounterScreen extends StatefulWidget {
  final int focusAreaId;
  final String focusAreaName;

  const ExerciseCounterScreen({
    super.key,
    required this.focusAreaId,
    required this.focusAreaName,
  });

  @override
  State<ExerciseCounterScreen> createState() => ExerciseCounterScreenState();
}

class ExerciseCounterScreenState extends State<ExerciseCounterScreen>
    with WidgetsBindingObserver {
  final Map<int, bool> _expanded = {};
  final Map<int, int> _setsCount = {};
  final Map<int, int> _doneCount = {};
  final Map<int, Set<int>> _completedSets = {};

  List<ExerciseModel> addedExercises = [];

  final ScrollController _scrollController = ScrollController();

  Timer? _timer;
  Timer? _midnightTimer;
  int _seconds = 0;

  final TextEditingController _searchController = TextEditingController();

  // Database
  final WorkoutSessionRepository _repository = WorkoutSessionRepository();
  WorkoutSessionModel? _currentSession;
  bool _isInitialized = false;
  bool _exercisesLoadedFromDb = false;
  bool _isSaving = false;
  String _gender = "male";

  final Map<int, Uint8List> _videoThumbnails = {};

  // Keys for SharedPreferences
  static const String _lastSavedDateKey = "workout_last_saved_date";
  static const String _timerValueKey = "workout_timer_value";

  Map<int, Map<int, TextEditingController>> weightControllers = {};
  Map<int, Map<int, TextEditingController>> repsControllers = {};
  bool _thumbnailsGenerated = false;

  TextEditingController _getWeightController(int exerciseIndex, int setNo) {
    weightControllers[exerciseIndex] ??= {};
    weightControllers[exerciseIndex]![setNo] ??= TextEditingController(
      text: "3",
    );
    return weightControllers[exerciseIndex]![setNo]!;
  }

  TextEditingController _getRepsController(int exerciseIndex, int setNo) {
    repsControllers[exerciseIndex] ??= {};
    repsControllers[exerciseIndex]![setNo] ??= TextEditingController(
      text: "10",
    );
    return repsControllers[exerciseIndex]![setNo]!;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeSession();
    _setupMidnightReset();
    context.read<ExerciseBloc>().add(
      GetExercisesEvent(focusAreaId: widget.focusAreaId),
    );
    _loadGender();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _stopTimer();
      _saveCurrentProgress();
    } else if (state == AppLifecycleState.resumed) {
      _checkMidnightReset().then((_) {
        _startTimer();
      });
    }
  }

  String getVideoPath(dynamic workout) {
    if (_gender == "female" &&
        workout.femaleVideoPath != null &&
        workout.femaleVideoPath.isNotEmpty) {
      return workout.femaleVideoPath;
    }
    return workout.maleVideoPath;
  }

  Future<void> _loadGender() async {
    final gender = await OnboardingStorage.getString("gender");
    if (gender != null) {
      _gender = gender.toLowerCase();
    }
  }

  Future<void> _generateThumbnail(int exerciseId, ExerciseModel workout) async {
    if (_videoThumbnails.containsKey(exerciseId)) return;

    final videoPath = getVideoPath(workout);

    if (videoPath.isEmpty) return;

    try {
      final bytes = await VideoThumbnail.thumbnailData(
        video: Api.base + videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200,
        quality: 75,
      );

      if (bytes != null && mounted) {
        setState(() {
          _videoThumbnails[exerciseId] = bytes;
        });
      }
    } catch (e) {
      debugPrint("Thumbnail error for $exerciseId: $e");
    }
  }

  Future<void> _initializeSession() async {
    await _checkMidnightReset();

    _currentSession = await _repository.getOrCreateTodaySession(
      focusAreaId: widget.focusAreaId,
      focusAreaName: widget.focusAreaName,
    );

    _seconds = _currentSession?.totalTimeSeconds ?? 0;

    _isInitialized = true;
    _startTimer();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _onExercisesLoaded(List<ExerciseModel> exercises) async {
    if (_exercisesLoadedFromDb || _currentSession == null) return;

    _exercisesLoadedFromDb = true;

    final savedExercises = await _repository.getExercisesForSession(
      _currentSession!.id!,
    );

    if (savedExercises.isEmpty) {
      debugPrint("No saved exercises found in database");
      return;
    }

    debugPrint(
      "Loading ${savedExercises.length} saved exercises from database",
    );

    for (var savedExercise in savedExercises) {
      // Find the index in the loaded exercises list
      int index = -1;
      for (int i = 0; i < exercises.length; i++) {
        if (exercises[i].id == savedExercise.exerciseId) {
          index = i;
          break;
        }
      }

      if (index != -1) {
        debugPrint(
          "Restoring exercise at index $index: ${savedExercise.exerciseName}",
        );
        debugPrint("  - Total sets: ${savedExercise.totalSets}");
        debugPrint("  - Completed sets: ${savedExercise.completedSets}");

        _setsCount[index] = savedExercise.totalSets;
        _doneCount[index] = savedExercise.completedSets;

        // Load completed sets
        _completedSets[index] = Set.from(
          List.generate(savedExercise.completedSets, (i) => i + 1),
        );

        // Load weights and reps
        try {
          final weights = List<int>.from(jsonDecode(savedExercise.weightsJson));
          final reps = List<int>.from(jsonDecode(savedExercise.repsJson));

          for (int i = 0; i < weights.length; i++) {
            _getWeightController(index, i + 1).text = weights[i].toString();
          }
          for (int i = 0; i < reps.length; i++) {
            _getRepsController(index, i + 1).text = reps[i].toString();
          }
        } catch (e) {
          debugPrint("Error parsing weights/reps JSON: $e");
        }
      } else {
        debugPrint(
          "Could not find exercise with id ${savedExercise.exerciseId} in loaded exercises",
        );
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _checkMidnightReset() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSavedDate = prefs.getString(_lastSavedDateKey);
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (lastSavedDate != today) {
      _seconds = 0;
      _setsCount.clear();
      _doneCount.clear();
      _completedSets.clear();
      _expanded.clear();
      _exercisesLoadedFromDb = false;

      for (var exerciseControllers in weightControllers.values) {
        for (var controller in exerciseControllers.values) {
          controller.text = "4";
        }
      }
      for (var exerciseControllers in repsControllers.values) {
        for (var controller in exerciseControllers.values) {
          controller.text = "4";
        }
      }

      await prefs.setString(_lastSavedDateKey, today);

      _currentSession = await _repository.getOrCreateTodaySession(
        focusAreaId: widget.focusAreaId,
        focusAreaName: widget.focusAreaName,
      );
    }
  }

  void _setupMidnightReset() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = midnight.difference(now);

    _midnightTimer = Timer(durationUntilMidnight, () {
      _handleMidnightReset();

      _midnightTimer = Timer.periodic(const Duration(days: 1), (_) {
        _handleMidnightReset();
      });
    });
  }

  void _handleMidnightReset() async {
    await _saveCurrentProgress();

    setState(() {
      _seconds = 0;
      _setsCount.clear();
      _doneCount.clear();
      _completedSets.clear();
      _expanded.clear();
      _exercisesLoadedFromDb = false;
    });

    _currentSession = await _repository.getOrCreateTodaySession(
      focusAreaId: widget.focusAreaId,
      focusAreaName: widget.focusAreaName,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _lastSavedDateKey,
      DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      _seconds++;
      if (mounted) {
        setState(() {});
      }

      if (_seconds % 30 == 0) {
        _saveTimerToDatabase();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _saveTimerToDatabase();
  }

  Future<void> _saveTimerToDatabase() async {
    if (_currentSession != null) {
      await _repository.updateSessionTimer(_currentSession!.id!, _seconds);
    }
  }

  // NEW: Get exercises list safely
  List<_UiExercise> _getAllExercises() {
    final state = context.read<ExerciseBloc>().state;
    if (state is ExerciseLoaded) {
      return [
        ...state.exercises.map((e) => _UiExercise.fromExerciseModel(e)),
        ...addedExercises.map((e) => _UiExercise.fromExerciseModel(e)),
      ];
    }
    return [];
  }

  Future<void> _saveCurrentProgress() async {
    // Prevent multiple simultaneous saves
    if (_isSaving) {
      debugPrint("Already saving, skipping...");
      return;
    }

    if (_currentSession == null || !_isInitialized) {
      debugPrint(
        "Cannot save: session=${_currentSession?.id}, initialized=$_isInitialized",
      );
      return;
    }

    _isSaving = true;

    try {
      // Save timer first
      await _saveTimerToDatabase();
      debugPrint("Timer saved: $_seconds seconds");

      final allExercises = _getAllExercises();

      if (allExercises.isEmpty) {
        debugPrint("No exercises to save");
        _isSaving = false;
        return;
      }

      debugPrint("Saving ${allExercises.length} exercises...");

      for (int i = 0; i < allExercises.length; i++) {
        final exercise = allExercises[i];
        final totalSets = _setsCount[i] ?? 4;
        final completedSets = _doneCount[i] ?? 0;

        final weights = List<int>.generate(totalSets, (setIndex) {
          final controller = weightControllers[i]?[setIndex + 1];
          return int.tryParse(controller?.text ?? '4') ?? 4;
        });

        final reps = List<int>.generate(totalSets, (setIndex) {
          final controller = repsControllers[i]?[setIndex + 1];
          return int.tryParse(controller?.text ?? '4') ?? 4;
        });

        debugPrint("Saving exercise $i: ${exercise.displayName}");
        debugPrint("  - Total sets: $totalSets, Completed: $completedSets");
        debugPrint("  - Weights: $weights");
        debugPrint("  - Reps: $reps");

        await _repository.saveExerciseProgress(
          workoutSessionId: _currentSession!.id!,
          exerciseId: exercise.id,
          exerciseName: exercise.displayName,
          imageUrl: exercise.imageUrl,
          totalSets: totalSets,
          completedSets: completedSets,
          weights: weights,
          reps: reps,
          isCompleted: completedSets >= totalSets,
        );
      }

      debugPrint("All exercises saved successfully!");
    } catch (e) {
      debugPrint("Error saving progress: $e");
    } finally {
      _isSaving = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _midnightTimer?.cancel();
    // Note: Don't call async _saveCurrentProgress() here
    // It's already called in onPopInvokedWithResult and back button
    _searchController.dispose();
    _scrollController.dispose();

    for (var exerciseControllers in weightControllers.values) {
      for (var controller in exerciseControllers.values) {
        controller.dispose();
      }
    }
    for (var exerciseControllers in repsControllers.values) {
      for (var controller in exerciseControllers.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  String _formatTime(int sec) {
    int m = sec ~/ 60;
    int s = sec % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  void _markCurrentExerciseAllDone() {
    for (int i = 0; i < _setsCount.length; i++) {
      int total = _setsCount[i] ?? 4;
      int done = _doneCount[i] ?? 0;

      if (done < total) {
        setState(() {
          _doneCount[i] = total;
          _completedSets[i] = Set.from(
            List.generate(total, (index) => index + 1),
          );
          _expanded[i] = false;
        });

        _saveCurrentProgress();
        break;
      }
    }
  }

  void _logNextSet() {
    for (int i = 0; i < _setsCount.length; i++) {
      int total = _setsCount[i] ?? 4;
      int done = _doneCount[i] ?? 0;

      if (done >= total) continue;

      int nextSet = done + 1;

      setState(() {
        _doneCount[i] = nextSet;

        _completedSets.putIfAbsent(i, () => <int>{});
        _completedSets[i]!.add(nextSet);

        _expanded[i] = true;
      });

      _saveCurrentProgress();

      if (_doneCount[i] == total) {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) {
            setState(() {
              _expanded[i] = false;
            });
          }
        });
      }

      return;
    }

    bool allDone = _setsCount.keys.every((i) {
      int total = _setsCount[i] ?? 4;
      int done = _doneCount[i] ?? 0;
      return done >= total;
    });

    if (allDone) {
      _finishWorkout();
    }
  }

  Future<void> _finishWorkout() async {
    _stopTimer();

    await _saveCurrentProgress();

    if (_currentSession != null) {
      await _repository.completeWorkoutSession(_currentSession!.id!, _seconds);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_timerValueKey);

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ExerciseCompletedScreen(
            durationSeconds: _seconds,
            exercises: _buildCompletionData(),
          ),
        ),
      );
    }
  }

  bool get isWorkoutFullyCompleted {
    if (_setsCount.isEmpty) return false;

    return _setsCount.keys.every((index) {
      int totalSets = _setsCount[index] ?? 0;
      int doneSets = _doneCount[index] ?? 0;
      return totalSets > 0 && doneSets >= totalSets;
    });
  }

  List<CompletedExercise1> _buildCompletionData() {
    final List<CompletedExercise1> result = [];

    final allExercises = _getAllExercises();

    for (int i = 0; i < _setsCount.length; i++) {
      final exercise = i < allExercises.length
          ? allExercises[i]
          : _UiExercise(id: -1, displayName: "Exercise ${i + 1}", imageUrl: "");

      final int totalSets = _setsCount[i] ?? 0;

      final List<int> weights = List.generate(totalSets, (setIndex) {
        final controller = weightControllers[i]?[setIndex + 1];
        return int.tryParse(controller?.text ?? '0') ?? 0;
      });

      final List<int> reps = List.generate(totalSets, (setIndex) {
        final controller = repsControllers[i]?[setIndex + 1];
        return int.tryParse(controller?.text ?? '0') ?? 0;
      });

      result.add(
        CompletedExercise1(
          workoutName: widget.focusAreaName,
          name: exercise.displayName,
          imageUrl: exercise.imageUrl,
          sets: totalSets,
          done: _doneCount[i] ?? 0,
          weights: weights,
          reps: reps,
        ),
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          _stopTimer();
          await _saveCurrentProgress(); // This is awaited properly
          if (mounted) {
            Navigator.pop(context, true);
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background(context),
        appBar: _appBar(context),
        body: _body(context),
        bottomNavigationBar: _bottomButton(context),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.card(context),
      elevation: 0,
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
                onPressed: () async {
                  _stopTimer();
                  await _saveCurrentProgress(); // Await before popping
                  if (mounted) {
                    Navigator.pop(context, true);
                  }
                },
              ),
            );
          },
        ),
      ),
      title: Text(
        widget.focusAreaName,
        style: TextStyle(
          color: AppColors.text(context),
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _body(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _timerBox(context),
          const SizedBox(height: 16),
          BlocConsumer<ExerciseBloc, ExerciseState>(
            listener: (context, state) {
              // if (state is ExerciseLoaded && !_exercisesLoadedFromDb) {
              //   _onExercisesLoaded(state.exercises);
              // }
              //
              // if (!_thumbnailsGenerated) {
              //   for (final ex in state.exercises) {
              //     _generateThumbnail(ex.id, ex);
              //   }
              //   _thumbnailsGenerated = true;
              // }

              if (state is ExerciseLoaded) {
                // Load saved progress once
                if (!_exercisesLoadedFromDb) {
                  _onExercisesLoaded(state.exercises);
                }

                // Generate thumbnails only once
                if (!_thumbnailsGenerated) {
                  for (final ex in state.exercises) {
                    _generateThumbnail(ex.id, ex);
                  }
                  _thumbnailsGenerated = true;
                }
              }
            },
            builder: (context, state) {
              if (state is ExerciseLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ExerciseError) {
                return Center(child: Text(state.message));
              } else if (state is ExerciseLoaded) {
                // for (final ex in state.exercises) {
                //   _generateThumbnail(ex.id, ex);
                // }
                final exercise = state.exercises;

                final List<_UiExercise> uiExercises = [
                  ...exercise.map((we) => _UiExercise.fromExerciseModel(we)),
                  ...addedExercises.map(
                    (e) => _UiExercise.fromExerciseModel(e),
                  ),
                ];

                // Only initialize if not already loaded from DB
                if (_setsCount.isEmpty && !_exercisesLoadedFromDb) {
                  for (int i = 0; i < uiExercises.length; i++) {
                    _setsCount[i] = 4;
                    _doneCount[i] = 0;
                  }
                } else if (_setsCount.length < uiExercises.length) {
                  for (int i = _setsCount.length; i < uiExercises.length; i++) {
                    _setsCount[i] = 4;
                    _doneCount[i] = 0;
                  }
                }

                if (uiExercises.isEmpty) {
                  return const Center(child: Text("No exercises found"));
                }

                return Column(
                  children: [
                    ...List.generate(
                      uiExercises.length,
                      (index) => Column(
                        children: [
                          _exerciseCard(context, uiExercises[index], index),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Widget _timerBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.timer_outlined, color: AppColors.text(context), size: 32),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _formatTime(_seconds),
              style: const TextStyle(
                color: Colors.green,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          if (_currentSession != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Session Active",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _exerciseCard(BuildContext context, _UiExercise exercise, int index) {
    final isOpen = _expanded[index] ?? false;
    final totalSets = _setsCount[index] ?? 4;
    final doneSets = _doneCount[index] ?? 0;

    // final image = (exercise.imageUrl.isNotEmpty)
    //     ? NetworkImage(Api.base + exercise.imageUrl)
    //     : const AssetImage("assets/program/shoulders.png") as ImageProvider;

    final thumb = _videoThumbnails[exercise.id];

    final ImageProvider image = thumb != null
        ? MemoryImage(thumb)
        : const AssetImage("assets/program/shoulders.png");

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded[index] = !isOpen),
            child: Row(
              children: [
                Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(image: image, fit: BoxFit.cover),
                    border: Border.all(color: AppColors.border(context)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.displayName,
                        style: TextStyle(
                          color: AppColors.text(context),
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$doneSets/$totalSets Done",
                        style: TextStyle(color: AppColors.subText(context)),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    // IconButton(
                    //   icon: Icon(
                    //     Icons.more_vert,
                    //     color: AppColors.text(context),
                    //   ),
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => WorkoutHistoryScreen(),
                    //       ),
                    //     );
                    //   },
                    //   padding: EdgeInsets.zero,
                    // ),
                    Icon(
                      isOpen
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: AppColors.text(context),
                      size: 26,
                    ),
                  ],
                ),
              ],
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                const SizedBox(height: 14),
                for (int i = 1; i <= totalSets; i++) ...[
                  _setRow(context, i, index),
                  const SizedBox(height: 10),
                ],
                _exerciseBottomButtons(context, index, exercise.id),
              ],
            ),
            crossFadeState: isOpen
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }

  Widget _setRow(BuildContext context, int setNo, int exerciseIndex) {
    bool isCompleted = _completedSets[exerciseIndex]?.contains(setNo) ?? false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.green.withOpacity(0.2)
            : AppColors.rowAlternate(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted ? Colors.greenAccent : AppColors.border(context),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.circle_outlined,
            size: 22,
            color: isCompleted ? Colors.green : AppColors.text(context),
          ),
          Text(
            "$setNo",
            style: TextStyle(
              color: isCompleted ? Colors.green : AppColors.text(context),
            ),
          ),
          _numberTextField(
            context,
            _getWeightController(exerciseIndex, setNo),
            isCompleted,
          ),
          Text("kg", style: TextStyle(color: AppColors.subText(context))),
          _numberTextField(
            context,
            _getRepsController(exerciseIndex, setNo),
            isCompleted,
          ),
          Text("Reps", style: TextStyle(color: AppColors.subText(context))),
        ],
      ),
    );
  }

  Widget _numberTextField(
    BuildContext context,
    TextEditingController controller,
    bool isCompleted,
  ) {
    return Container(
      width: 55,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.cardDark(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 3,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
        ],
        style: TextStyle(
          color: isCompleted ? Colors.green : AppColors.text(context),
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: "",
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        ),
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
      ),
    );
  }

  Widget _exerciseBottomButtons(
    BuildContext context,
    int index,
    int exerciseId,
  ) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPage(exerciseId: exerciseId),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.text(context)),
              ),
              child: Text(
                "Detail",
                style: TextStyle(color: AppColors.text(context)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => setState(() {
                _setsCount[index] = (_setsCount[index] ?? 4) + 1;
              }),
              icon: Icon(Icons.add, color: AppColors.buttonText(context)),
              label: Text(
                "Add a set",
                style: TextStyle(color: AppColors.buttonText(context)),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bottomButton(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                _markCurrentExerciseAllDone();
              },
              child: Container(
                width: 70,
                height: 55,
                decoration: BoxDecoration(
                  color: AppColors.primary(context),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: AppColors.buttonText(context),
                    ),
                    Text(
                      "All",
                      style: TextStyle(color: AppColors.buttonText(context)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: isWorkoutFullyCompleted ? _finishWorkout : _logNextSet,
                child: Container(
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary(context),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    isWorkoutFullyCompleted ? "DONE" : "LOG NEXT SET",
                    style: TextStyle(
                      color: AppColors.buttonText(context),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _exerciseThumbnail(_UiExercise uiExercise) {
    final thumb = _videoThumbnails[uiExercise.id];

    if (thumb != null) {
      return Image.memory(thumb, fit: BoxFit.cover, gaplessPlayback: true);
    }

    return Image.asset("assets/program/shoulders.png", fit: BoxFit.cover);
  }
}
