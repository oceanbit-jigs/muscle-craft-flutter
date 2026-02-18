// import 'dart:async';
// import 'package:fitness_workout_app/features/workout_tab/presentation/pages/workout_tab/workouts_counter_screen/workout_complete_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../../../../core/utils/api.dart';
// import '../../../../../../theme/color/colors.dart';
// import '../../../../../exercises_tab/domain/model/exercise_model.dart';
// import '../../../../../exercises_tab/presentation/bloc/exercise_bloc.dart';
// import '../../../../domain/model/workout_details_model.dart';
// import '../../../bloc/dashboard_bloc.dart';
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
//   factory _UiExercise.fromWorkoutExercise(WorkoutExercise w) {
//     return _UiExercise(
//       id: w.id,
//       displayName: w.displayName,
//       imageUrl: w.imageUrl,
//     );
//   }
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
// class CompletedExercise {
//   final String workoutName;
//   final String name;
//   final String imageUrl;
//   final int sets;
//   final int done;
//   final List<int> weights;
//   final List<int> reps;
//
//   CompletedExercise({
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
// class WorkoutCounterScreen extends StatefulWidget {
//   final int workoutId;
//   final String workoutName;
//
//   const WorkoutCounterScreen({
//     super.key,
//     required this.workoutId,
//     required this.workoutName,
//   });
//
//   @override
//   State<WorkoutCounterScreen> createState() => _WorkoutCounterScreenState();
// }
//
// class _WorkoutCounterScreenState extends State<WorkoutCounterScreen> {
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
//   final FocusNode _searchFocusNode = FocusNode();
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
//     context.read<DashboardBloc>().add(
//       FetchWorkoutDetailEvent(widget.workoutId),
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
//     _timer?.cancel(); // always cancel old timer
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
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => WorkoutCompletedScreen(
//             durationSeconds: _seconds,
//             exercises: _buildCompletionData(),
//           ),
//         ),
//       );
//       return;
//     }
//   }
//
//   List<CompletedExercise> _buildCompletionData() {
//     final List<CompletedExercise> result = [];
//
//     final allExercises = [
//       ...(context.read<DashboardBloc>().state as WorkoutDetailLoaded)
//           .workoutDetail
//           .data
//           .exercises
//           .map((we) => _UiExercise.fromWorkoutExercise(we)),
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
//         CompletedExercise(
//           workoutName: widget.workoutName,
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
//   Future<List<int>?> _openAddExerciseSheet({int? focusAreaId}) async {
//     context.read<ExerciseBloc>().add(
//       GetExercisesEvent(focusAreaId: focusAreaId),
//     );
//
//     Set<int> selectedExerciseIds = {};
//
//     return await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         final ScrollController scrollController = ScrollController();
//
//         scrollController.addListener(() {
//           if (scrollController.position.pixels >=
//               scrollController.position.maxScrollExtent - 100) {
//             context.read<ExerciseBloc>().add(LoadMoreExercisesEvent());
//           }
//         });
//
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           child: DraggableScrollableSheet(
//             initialChildSize: 0.85,
//             minChildSize: 0.5,
//             maxChildSize: 0.95,
//             expand: false,
//             builder: (context, _) {
//               return StatefulBuilder(
//                 builder: (context, setState) {
//                   return BlocBuilder<ExerciseBloc, ExerciseState>(
//                     builder: (context, state) {
//                       if (state is ExerciseLoading) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//
//                       if (state is ExerciseError) {
//                         return Center(
//                           child: Text(
//                             state.message,
//                             style: const TextStyle(color: Colors.red),
//                           ),
//                         );
//                       }
//
//                       final exercises = state is ExerciseLoaded
//                           ? state.exercises
//                           : state is ExercisePaginationLoading
//                           ? state.oldData
//                           : <ExerciseModel>[];
//
//                       final groupedExercises = _groupAndSortExercises(
//                         exercises,
//                       );
//
//                       return Stack(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).scaffoldBackgroundColor,
//                               borderRadius: const BorderRadius.only(
//                                 topLeft: Radius.circular(26),
//                                 topRight: Radius.circular(26),
//                               ),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // Header
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "Add Exercises",
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w700,
//                                         color: AppColors.text(context),
//                                       ),
//                                     ),
//                                     Container(
//                                       height: 32,
//                                       width: 32,
//                                       decoration: BoxDecoration(
//                                         color: Colors.black,
//                                         shape: BoxShape.circle,
//                                         border: Border.all(
//                                           color: AppColors.border(context),
//                                         ),
//                                       ),
//                                       child: IconButton(
//                                         padding: EdgeInsets.zero,
//                                         icon: const Icon(
//                                           Icons.close,
//                                           color: Colors.white,
//                                           size: 18,
//                                         ),
//                                         onPressed: () => Navigator.pop(context),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 16),
//
//                                 // Search bar
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       height: 45,
//                                       width: 45,
//                                       decoration: BoxDecoration(
//                                         color: AppColors.card(context),
//                                         borderRadius: BorderRadius.circular(12),
//                                         border: Border.all(
//                                           color: AppColors.border(context),
//                                         ),
//                                       ),
//                                       child: Icon(
//                                         Icons.tune,
//                                         color: AppColors.text(context),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Expanded(
//                                       child: Container(
//                                         height: 45,
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 16,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: AppColors.card(context),
//                                           borderRadius: BorderRadius.circular(
//                                             12,
//                                           ),
//                                           border: Border.all(
//                                             color: AppColors.border(context),
//                                           ),
//                                         ),
//                                         child: Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Expanded(
//                                               child: TextField(
//                                                 controller: _searchController,
//                                                 focusNode: _searchFocusNode,
//                                                 textAlignVertical:
//                                                     TextAlignVertical.center,
//                                                 decoration: InputDecoration(
//                                                   hintText: "Search",
//                                                   isDense: true,
//                                                   contentPadding:
//                                                       const EdgeInsets.symmetric(
//                                                         vertical: 0,
//                                                       ),
//                                                   border: InputBorder.none,
//                                                 ),
//                                                 onChanged: (value) {
//                                                   // Optional: dispatch search event
//                                                 },
//                                               ),
//                                             ),
//                                             Icon(
//                                               Icons.search,
//                                               color: AppColors.subText(context),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 16),
//
//                                 // Exercise list
//                                 Expanded(
//                                   child: ListView.builder(
//                                     controller: scrollController,
//                                     itemCount: groupedExercises.length + 1,
//                                     itemBuilder: (context, index) {
//                                       if (index == groupedExercises.length) {
//                                         if (state
//                                             is ExercisePaginationLoading) {
//                                           return const Center(
//                                             child: Padding(
//                                               padding: EdgeInsets.symmetric(
//                                                 vertical: 8,
//                                               ),
//                                               child:
//                                                   CircularProgressIndicator(),
//                                             ),
//                                           );
//                                         }
//                                         return const SizedBox.shrink();
//                                       }
//
//                                       final letter = groupedExercises.keys
//                                           .elementAt(index);
//                                       final exercises =
//                                           groupedExercises[letter]!;
//
//                                       return Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                               vertical: 8,
//                                             ),
//                                             child: Text(
//                                               letter,
//                                               style: TextStyle(
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: AppColors.text(context),
//                                               ),
//                                             ),
//                                           ),
//                                           ...exercises.map(
//                                             (item) => GestureDetector(
//                                               onTap: () {
//                                                 setState(() {
//                                                   if (selectedExerciseIds
//                                                       .contains(item.id)) {
//                                                     selectedExerciseIds.remove(
//                                                       item.id,
//                                                     );
//                                                   } else {
//                                                     selectedExerciseIds.add(
//                                                       item.id,
//                                                     );
//                                                   }
//                                                 });
//                                               },
//                                               child: Container(
//                                                 margin: const EdgeInsets.only(
//                                                   bottom: 12,
//                                                 ),
//                                                 padding: const EdgeInsets.all(
//                                                   12,
//                                                 ),
//                                                 decoration: BoxDecoration(
//                                                   color: AppColors.card(
//                                                     context,
//                                                   ),
//                                                   borderRadius:
//                                                       BorderRadius.circular(18),
//                                                   border: Border.all(
//                                                     color: AppColors.border(
//                                                       context,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 child: Row(
//                                                   children: [
//                                                     Container(
//                                                       height: 55,
//                                                       width: 55,
//                                                       decoration: BoxDecoration(
//                                                         borderRadius:
//                                                             BorderRadius.circular(
//                                                               12,
//                                                             ),
//                                                         image: DecorationImage(
//                                                           image: NetworkImage(
//                                                             Api.base +
//                                                                 item.imageUrl,
//                                                           ),
//                                                           fit: BoxFit.contain,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     const SizedBox(width: 12),
//                                                     Expanded(
//                                                       child: Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Text(
//                                                             item.displayName,
//                                                             style: TextStyle(
//                                                               fontSize: 16,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w700,
//                                                               color:
//                                                                   AppColors.text(
//                                                                     context,
//                                                                   ),
//                                                             ),
//                                                           ),
//                                                           const SizedBox(
//                                                             height: 4,
//                                                           ),
//                                                           Text(
//                                                             item
//                                                                     .focusAreas
//                                                                     .isNotEmpty
//                                                                 ? item.focusAreas
//                                                                       .map(
//                                                                         (e) => e
//                                                                             .displayName,
//                                                                       )
//                                                                       .join(
//                                                                         ", ",
//                                                                       )
//                                                                 : "",
//                                                             style: TextStyle(
//                                                               fontSize: 13,
//                                                               color:
//                                                                   AppColors.subText(
//                                                                     context,
//                                                                   ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     Icon(
//                                                       selectedExerciseIds
//                                                               .contains(item.id)
//                                                           ? Icons.check_circle
//                                                           : Icons
//                                                                 .circle_outlined,
//                                                       color: AppColors.text(
//                                                         context,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // Add button
//                           if (selectedExerciseIds.isNotEmpty)
//                             Positioned(
//                               left: 16,
//                               right: 16,
//                               bottom: 16,
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 16,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   backgroundColor: AppColors.primary(context),
//                                 ),
//                                 onPressed: () {
//                                   Navigator.pop(
//                                     context,
//                                     selectedExerciseIds.toList(),
//                                   );
//                                 },
//                                 child: Text(
//                                   "Add",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: AppColors.buttonText(context),
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   Map<String, List<ExerciseModel>> _groupAndSortExercises(
//     List<ExerciseModel> exercises,
//   ) {
//     exercises.sort(
//       (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
//     );
//     Map<String, List<ExerciseModel>> grouped = {};
//     for (var ex in exercises) {
//       String firstLetter = ex.name[0].toUpperCase();
//       grouped.putIfAbsent(firstLetter, () => []);
//       grouped[firstLetter]!.add(ex);
//     }
//     return grouped;
//   }
//
//   void _addSelectedExercises(List<int> selectedExerciseIds) {
//     final exerciseState = context.read<ExerciseBloc>().state;
//
//     if (exerciseState is! ExerciseLoaded &&
//         exerciseState is! ExercisePaginationLoading) {
//       return;
//     }
//
//     final allExercises = exerciseState is ExerciseLoaded
//         ? exerciseState.exercises
//         : (exerciseState as ExercisePaginationLoading).oldData;
//
//     final mainExercises =
//         context.read<DashboardBloc>().state is WorkoutDetailLoaded
//         ? (context.read<DashboardBloc>().state as WorkoutDetailLoaded)
//               .workoutDetail
//               .data
//               .exercises
//         : [];
//
//     final existingUiNames = <String>{
//       ...mainExercises.map((e) => e.displayName.toLowerCase()),
//       ...addedExercises.map((e) => e.displayName.toLowerCase()),
//     };
//
//     final existingUiIds = <int>{
//       ...mainExercises.map((e) => e.id),
//       ...addedExercises.map((e) => e.id),
//     };
//
//     List<String> snackMessages = [];
//
//     setState(() {
//       for (var id in selectedExerciseIds) {
//         final idx = allExercises.indexWhere((e) => e.id == id);
//         if (idx == -1) continue;
//
//         final ex = allExercises[idx];
//         final nameLower = ex.displayName.toLowerCase();
//
//         if (existingUiNames.contains(nameLower)) {
//           snackMessages.add("⚠️ '${ex.displayName}' already added");
//           continue;
//         }
//
//         if (existingUiIds.contains(ex.id)) {
//           snackMessages.add("⚠️ '${ex.displayName}' already added");
//           continue;
//         }
//
//         addedExercises.add(ex);
//         existingUiNames.add(nameLower);
//         existingUiIds.add(ex.id);
//
//         snackMessages.add("Added '${ex.displayName}'");
//
//         final newIndex = _setsCount.length;
//         _setsCount[newIndex] = 4;
//         _doneCount[newIndex] = 0;
//       }
//     });
//
//     if (snackMessages.isNotEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: Colors.black87,
//           duration: const Duration(seconds: 3),
//           content: Text(
//             snackMessages.join("\n"),
//             style: const TextStyle(color: Colors.white, fontSize: 14),
//           ),
//         ),
//       );
//     }
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
//         "${widget.workoutName} Workout",
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
//           BlocBuilder<DashboardBloc, DashboardState>(
//             builder: (context, state) {
//               if (state is WorkoutDetailLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (state is WorkoutDetailError) {
//                 return Center(child: Text(state.message));
//               } else if (state is WorkoutDetailLoaded) {
//                 final apiExercises = state.workoutDetail.data.exercises;
//
//                 final List<_UiExercise> uiExercises = [
//                   ...apiExercises.map(
//                     (we) => _UiExercise.fromWorkoutExercise(we),
//                   ),
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
//                     SizedBox(height: 10),
//                     GestureDetector(
//                       onTap: () async {
//                         final selectedIds = await _openAddExerciseSheet();
//
//                         if (selectedIds != null && selectedIds.isNotEmpty) {
//                           _addSelectedExercises(selectedIds);
//                         }
//                       },
//
//                       child: Container(
//                         height: 50,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: AppColors.primary(context),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Text(
//                           "+ Add Exercise",
//                           style: TextStyle(
//                             color: AppColors.buttonText(context),
//                             fontSize: 17,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               }
//               return const SizedBox();
//             },
//           ),
//           const SizedBox(height: 100),
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
//                 _exerciseBottomButtons(context, index),
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
//   Widget _exerciseBottomButtons(BuildContext context, int index) {
//     return Row(
//       children: [
//         Expanded(
//           child: SizedBox(
//             height: 48,
//             child: OutlinedButton(
//               onPressed: () {},
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
//                 onTap: () {
//                   debugPrint("button pressed");
//                   _logNextSet();
//                 },
//                 child: Container(
//                   height: 55,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: AppColors.primary(context),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Text(
//                     "LOG NEXT SET",
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

// class _WorkoutCounterScreenState extends State<WorkoutCounterScreen> {
//   final Map<int, bool> _expanded = {};
//
//   int? _sessionId;
//   List<_UiExercise> _exercises = [];
//   Map<int, List<_UiSet>> _exerciseSets = {};
//
//   final ScrollController _scrollController = ScrollController();
//
//   Timer? _timer;
//   int _seconds = 0;
//   bool _isLoading = true;
//
//   final TextEditingController _searchController = TextEditingController();
//   final FocusNode _searchFocusNode = FocusNode();
//
//   Map<int, Map<int, TextEditingController>> weightControllers = {};
//   Map<int, Map<int, TextEditingController>> repsControllers = {};
//
//   TextEditingController _getWeightController(
//     int exerciseIndex,
//     int setNo,
//     double initialValue,
//   ) {
//     weightControllers[exerciseIndex] ??= {};
//     if (weightControllers[exerciseIndex]![setNo] == null) {
//       weightControllers[exerciseIndex]![setNo] = TextEditingController(
//         text: initialValue > 0 ? initialValue.toStringAsFixed(0) : "4",
//       );
//     }
//     return weightControllers[exerciseIndex]![setNo]!;
//   }
//
//   TextEditingController _getRepsController(
//     int exerciseIndex,
//     int setNo,
//     int initialValue,
//   ) {
//     repsControllers[exerciseIndex] ??= {};
//     if (repsControllers[exerciseIndex]![setNo] == null) {
//       repsControllers[exerciseIndex]![setNo] = TextEditingController(
//         text: initialValue > 0 ? initialValue.toString() : "4",
//       );
//     }
//     return repsControllers[exerciseIndex]![setNo]!;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeSession();
//     context.read<DashboardBloc>().add(
//       FetchWorkoutDetailEvent(widget.workoutId),
//     );
//   }
//
//   Future<void> _initializeSession() async {
//     try {
//       // Only get/create session for timer persistence
//       final session = await WeightDB.instance.getOrCreateTodaySession(
//         workoutId: widget.workoutId,
//         workoutName: widget.workoutName,
//       );
//
//       _sessionId = session['id'] as int;
//       _seconds = session['timer_seconds'] as int;
//
//       _startTimer();
//
//       setState(() {
//         _isLoading = false;
//       });
//     } catch (e) {
//       debugPrint("Error initializing session: $e");
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   void _populateExercisesFromApi(List<WorkoutExercise> apiExercises) {
//     if (_exercises.isNotEmpty) return; // Already populated
//
//     _exercises = apiExercises
//         .map((e) => _UiExercise.fromWorkoutExercise(e))
//         .toList();
//
//     // Initialize sets for each exercise (4 sets by default)
//     for (int i = 0; i < _exercises.length; i++) {
//       _exerciseSets[i] = List.generate(
//         4,
//         (setIndex) => _UiSet(setNumber: setIndex + 1),
//       );
//     }
//
//     setState(() {});
//   }
//
//   void _startTimer() {
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
//       _seconds++;
//       _saveTimer();
//       setState(() {});
//     });
//   }
//
//   void _saveTimer() async {
//     if (_sessionId != null) {
//       await WeightDB.instance.updateSessionTimer(_sessionId!, _seconds);
//     }
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
//     _searchController.dispose();
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
//   Future<void> _markCurrentExerciseAllDone() async {
//     for (int i = 0; i < _exercises.length; i++) {
//       final sets = _exerciseSets[i] ?? [];
//       final uncompletedSets = sets.where((s) => !s.isCompleted).toList();
//
//       if (uncompletedSets.isNotEmpty) {
//         for (var set in uncompletedSets) {
//           final weightController = weightControllers[i]?[set.setNumber];
//           final repsController = repsControllers[i]?[set.setNumber];
//
//           final weight = double.tryParse(weightController?.text ?? '0') ?? 0;
//           final reps = int.tryParse(repsController?.text ?? '0') ?? 0;
//
//           set.weight = weight;
//           set.reps = reps;
//           set.isCompleted = true;
//         }
//
//         setState(() {
//           _expanded[i] = false;
//         });
//         break;
//       }
//     }
//   }
//
//   Future<void> _logNextSet() async {
//     for (int i = 0; i < _exercises.length; i++) {
//       final sets = _exerciseSets[i] ?? [];
//       final nextSet = sets.firstWhere(
//         (s) => !s.isCompleted,
//         orElse: () => _UiSet(setNumber: -1),
//       );
//
//       if (nextSet.setNumber == -1) continue;
//
//       final weightController = weightControllers[i]?[nextSet.setNumber];
//       final repsController = repsControllers[i]?[nextSet.setNumber];
//
//       final weight = double.tryParse(weightController?.text ?? '0') ?? 0;
//       final reps = int.tryParse(repsController?.text ?? '0') ?? 0;
//
//       nextSet.weight = weight;
//       nextSet.reps = reps;
//       nextSet.isCompleted = true;
//
//       setState(() {
//         _expanded[i] = true;
//       });
//
//       final allDone = sets.every((s) => s.isCompleted);
//       if (allDone) {
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
//     // Check if all exercises are done
//     bool allDone = _exercises.asMap().entries.every((entry) {
//       final sets = _exerciseSets[entry.key] ?? [];
//       return sets.every((s) => s.isCompleted);
//     });
//
//     if (allDone) {
//       _stopTimer();
//
//       if (_sessionId != null) {
//         await WeightDB.instance.completeSession(_sessionId!);
//       }
//
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => WorkoutCompletedScreen(
//             durationSeconds: _seconds,
//             exercises: _buildCompletionData(),
//           ),
//         ),
//       );
//     }
//   }
//
//   List<CompletedExercise> _buildCompletionData() {
//     final List<CompletedExercise> result = [];
//
//     for (int i = 0; i < _exercises.length; i++) {
//       final exercise = _exercises[i];
//       final sets = _exerciseSets[i] ?? [];
//
//       result.add(
//         CompletedExercise(
//           workoutName: widget.workoutName,
//           name: exercise.displayName,
//           imageUrl: exercise.imageUrl,
//           sets: sets.length,
//           done: sets.where((s) => s.isCompleted).length,
//           weights: sets.map((s) => s.weight.toInt()).toList(),
//           reps: sets.map((s) => s.reps).toList(),
//         ),
//       );
//     }
//
//     return result;
//   }
//
//   void _addSetToExercise(int exerciseIndex) {
//     final sets = _exerciseSets[exerciseIndex] ?? [];
//     final newSetNumber = sets.isEmpty ? 1 : sets.last.setNumber + 1;
//
//     sets.add(
//       _UiSet(setNumber: newSetNumber, weight: 0, reps: 0, isCompleted: false),
//     );
//
//     setState(() {
//       _exerciseSets[exerciseIndex] = sets;
//     });
//   }
//
//   void _addExercisesToSession(List<int> selectedExerciseIds) {
//     final exerciseState = context.read<ExerciseBloc>().state;
//     if (exerciseState is! ExerciseLoaded &&
//         exerciseState is! ExercisePaginationLoading) {
//       return;
//     }
//
//     final allExercises = exerciseState is ExerciseLoaded
//         ? exerciseState.exercises
//         : (exerciseState as ExercisePaginationLoading).oldData;
//
//     final existingIds = _exercises.map((e) => e.id).toSet();
//
//     List<String> snackMessages = [];
//
//     for (var id in selectedExerciseIds) {
//       if (existingIds.contains(id)) {
//         final ex = allExercises.firstWhere((e) => e.id == id);
//         snackMessages.add("⚠️ '${ex.displayName}' already added");
//         continue;
//       }
//
//       final exercise = allExercises.firstWhere((e) => e.id == id);
//
//       // Add to UI
//       final newExercise = _UiExercise.fromExerciseModel(exercise);
//       _exercises.add(newExercise);
//
//       // Create initial sets in UI (4 sets by default)
//       final newIndex = _exercises.length - 1;
//       _exerciseSets[newIndex] = List.generate(
//         4,
//         (setIndex) => _UiSet(setNumber: setIndex + 1),
//       );
//
//       existingIds.add(id);
//       snackMessages.add("Added '${exercise.displayName}'");
//     }
//
//     setState(() {});
//
//     if (snackMessages.isNotEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: Colors.black87,
//           duration: const Duration(seconds: 3),
//           content: Text(
//             snackMessages.join("\n"),
//             style: const TextStyle(color: Colors.white, fontSize: 14),
//           ),
//         ),
//       );
//     }
//   }
//
//   Future<List<int>?> _openAddExerciseSheet({int? focusAreaId}) async {
//     context.read<ExerciseBloc>().add(
//       GetExercisesEvent(focusAreaId: focusAreaId),
//     );
//
//     Set<int> selectedExerciseIds = {};
//
//     return await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         final ScrollController scrollController = ScrollController();
//
//         scrollController.addListener(() {
//           if (scrollController.position.pixels >=
//               scrollController.position.maxScrollExtent - 100) {
//             context.read<ExerciseBloc>().add(LoadMoreExercisesEvent());
//           }
//         });
//
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           child: DraggableScrollableSheet(
//             initialChildSize: 0.85,
//             minChildSize: 0.5,
//             maxChildSize: 0.95,
//             expand: false,
//             builder: (context, _) {
//               return StatefulBuilder(
//                 builder: (context, setState) {
//                   return BlocBuilder<ExerciseBloc, ExerciseState>(
//                     builder: (context, state) {
//                       if (state is ExerciseLoading) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//
//                       if (state is ExerciseError) {
//                         return Center(
//                           child: Text(
//                             state.message,
//                             style: const TextStyle(color: Colors.red),
//                           ),
//                         );
//                       }
//
//                       final exercises = state is ExerciseLoaded
//                           ? state.exercises
//                           : state is ExercisePaginationLoading
//                           ? state.oldData
//                           : <ExerciseModel>[];
//
//                       final groupedExercises = _groupAndSortExercises(
//                         exercises,
//                       );
//
//                       return Stack(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).scaffoldBackgroundColor,
//                               borderRadius: const BorderRadius.only(
//                                 topLeft: Radius.circular(26),
//                                 topRight: Radius.circular(26),
//                               ),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       "Add Exercises",
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.w700,
//                                         color: AppColors.text(context),
//                                       ),
//                                     ),
//                                     Container(
//                                       height: 32,
//                                       width: 32,
//                                       decoration: BoxDecoration(
//                                         color: Colors.black,
//                                         shape: BoxShape.circle,
//                                         border: Border.all(
//                                           color: AppColors.border(context),
//                                         ),
//                                       ),
//                                       child: IconButton(
//                                         padding: EdgeInsets.zero,
//                                         icon: const Icon(
//                                           Icons.close,
//                                           color: Colors.white,
//                                           size: 18,
//                                         ),
//                                         onPressed: () => Navigator.pop(context),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 16),
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       height: 45,
//                                       width: 45,
//                                       decoration: BoxDecoration(
//                                         color: AppColors.card(context),
//                                         borderRadius: BorderRadius.circular(12),
//                                         border: Border.all(
//                                           color: AppColors.border(context),
//                                         ),
//                                       ),
//                                       child: Icon(
//                                         Icons.tune,
//                                         color: AppColors.text(context),
//                                       ),
//                                     ),
//                                     const SizedBox(width: 12),
//                                     Expanded(
//                                       child: Container(
//                                         height: 45,
//                                         padding: const EdgeInsets.symmetric(
//                                           horizontal: 16,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           color: AppColors.card(context),
//                                           borderRadius: BorderRadius.circular(
//                                             12,
//                                           ),
//                                           border: Border.all(
//                                             color: AppColors.border(context),
//                                           ),
//                                         ),
//                                         child: Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           children: [
//                                             Expanded(
//                                               child: TextField(
//                                                 controller: _searchController,
//                                                 focusNode: _searchFocusNode,
//                                                 textAlignVertical:
//                                                     TextAlignVertical.center,
//                                                 decoration:
//                                                     const InputDecoration(
//                                                       hintText: "Search",
//                                                       isDense: true,
//                                                       contentPadding:
//                                                           EdgeInsets.symmetric(
//                                                             vertical: 0,
//                                                           ),
//                                                       border: InputBorder.none,
//                                                     ),
//                                               ),
//                                             ),
//                                             Icon(
//                                               Icons.search,
//                                               color: AppColors.subText(context),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 16),
//                                 Expanded(
//                                   child: ListView.builder(
//                                     controller: scrollController,
//                                     itemCount: groupedExercises.length + 1,
//                                     itemBuilder: (context, index) {
//                                       if (index == groupedExercises.length) {
//                                         if (state
//                                             is ExercisePaginationLoading) {
//                                           return const Center(
//                                             child: Padding(
//                                               padding: EdgeInsets.symmetric(
//                                                 vertical: 8,
//                                               ),
//                                               child:
//                                                   CircularProgressIndicator(),
//                                             ),
//                                           );
//                                         }
//                                         return const SizedBox.shrink();
//                                       }
//
//                                       final letter = groupedExercises.keys
//                                           .elementAt(index);
//                                       final exercises =
//                                           groupedExercises[letter]!;
//
//                                       return Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                               vertical: 8,
//                                             ),
//                                             child: Text(
//                                               letter,
//                                               style: TextStyle(
//                                                 fontSize: 18,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: AppColors.text(context),
//                                               ),
//                                             ),
//                                           ),
//                                           ...exercises.map(
//                                             (item) => GestureDetector(
//                                               onTap: () {
//                                                 setState(() {
//                                                   if (selectedExerciseIds
//                                                       .contains(item.id)) {
//                                                     selectedExerciseIds.remove(
//                                                       item.id,
//                                                     );
//                                                   } else {
//                                                     selectedExerciseIds.add(
//                                                       item.id,
//                                                     );
//                                                   }
//                                                 });
//                                               },
//                                               child: Container(
//                                                 margin: const EdgeInsets.only(
//                                                   bottom: 12,
//                                                 ),
//                                                 padding: const EdgeInsets.all(
//                                                   12,
//                                                 ),
//                                                 decoration: BoxDecoration(
//                                                   color: AppColors.card(
//                                                     context,
//                                                   ),
//                                                   borderRadius:
//                                                       BorderRadius.circular(18),
//                                                   border: Border.all(
//                                                     color: AppColors.border(
//                                                       context,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 child: Row(
//                                                   children: [
//                                                     Container(
//                                                       height: 55,
//                                                       width: 55,
//                                                       decoration: BoxDecoration(
//                                                         borderRadius:
//                                                             BorderRadius.circular(
//                                                               12,
//                                                             ),
//                                                         image: DecorationImage(
//                                                           image: NetworkImage(
//                                                             Api.base +
//                                                                 item.imageUrl,
//                                                           ),
//                                                           fit: BoxFit.contain,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     const SizedBox(width: 12),
//                                                     Expanded(
//                                                       child: Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Text(
//                                                             item.displayName,
//                                                             style: TextStyle(
//                                                               fontSize: 16,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w700,
//                                                               color:
//                                                                   AppColors.text(
//                                                                     context,
//                                                                   ),
//                                                             ),
//                                                           ),
//                                                           const SizedBox(
//                                                             height: 4,
//                                                           ),
//                                                           Text(
//                                                             item
//                                                                     .focusAreas
//                                                                     .isNotEmpty
//                                                                 ? item.focusAreas
//                                                                       .map(
//                                                                         (e) => e
//                                                                             .displayName,
//                                                                       )
//                                                                       .join(
//                                                                         ", ",
//                                                                       )
//                                                                 : "",
//                                                             style: TextStyle(
//                                                               fontSize: 13,
//                                                               color:
//                                                                   AppColors.subText(
//                                                                     context,
//                                                                   ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     Icon(
//                                                       selectedExerciseIds
//                                                               .contains(item.id)
//                                                           ? Icons.check_circle
//                                                           : Icons
//                                                                 .circle_outlined,
//                                                       color: AppColors.text(
//                                                         context,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           if (selectedExerciseIds.isNotEmpty)
//                             Positioned(
//                               left: 16,
//                               right: 16,
//                               bottom: 16,
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   padding: const EdgeInsets.symmetric(
//                                     vertical: 16,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(16),
//                                   ),
//                                   backgroundColor: AppColors.primary(context),
//                                 ),
//                                 onPressed: () {
//                                   Navigator.pop(
//                                     context,
//                                     selectedExerciseIds.toList(),
//                                   );
//                                 },
//                                 child: Text(
//                                   "Add",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: AppColors.buttonText(context),
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   Map<String, List<ExerciseModel>> _groupAndSortExercises(
//     List<ExerciseModel> exercises,
//   ) {
//     exercises.sort(
//       (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
//     );
//     Map<String, List<ExerciseModel>> grouped = {};
//     for (var ex in exercises) {
//       String firstLetter = ex.name[0].toUpperCase();
//       grouped.putIfAbsent(firstLetter, () => []);
//       grouped[firstLetter]!.add(ex);
//     }
//     return grouped;
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
//         body: _isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : _body(context),
//         bottomNavigationBar: _isLoading ? null : _bottomButton(context),
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
//         "${widget.workoutName} Workout",
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
//           BlocListener<DashboardBloc, DashboardState>(
//             listener: (context, state) {
//               if (state is WorkoutDetailLoaded) {
//                 _populateExercisesFromApi(state.workoutDetail.data.exercises);
//               }
//             },
//             child: BlocBuilder<DashboardBloc, DashboardState>(
//               builder: (context, state) {
//                 if (state is WorkoutDetailLoading && _exercises.isEmpty) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (state is WorkoutDetailError) {
//                   return Center(child: Text(state.message));
//                 }
//
//                 if (_exercises.isEmpty) {
//                   return const Center(child: Text("No exercises found"));
//                 }
//
//                 return Column(
//                   children: [
//                     ...List.generate(
//                       _exercises.length,
//                       (index) => Column(
//                         children: [
//                           _exerciseCard(context, _exercises[index], index),
//                           const SizedBox(height: 16),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     GestureDetector(
//                       onTap: () async {
//                         final selectedIds = await _openAddExerciseSheet();
//                         if (selectedIds != null && selectedIds.isNotEmpty) {
//                           _addExercisesToSession(selectedIds);
//                         }
//                       },
//                       child: Container(
//                         height: 50,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: AppColors.primary(context),
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         child: Text(
//                           "+ Add Exercise",
//                           style: TextStyle(
//                             color: AppColors.buttonText(context),
//                             fontSize: 17,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 100),
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
//     final sets = _exerciseSets[index] ?? [];
//     final totalSets = sets.length;
//     final doneSets = sets.where((s) => s.isCompleted).length;
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
//           AnimatedCrossFade(
//             firstChild: const SizedBox.shrink(),
//             secondChild: Column(
//               children: [
//                 const SizedBox(height: 14),
//                 for (var set in sets) ...[
//                   _setRow(context, set, index),
//                   const SizedBox(height: 10),
//                 ],
//                 _exerciseBottomButtons(context, index),
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
//   Widget _setRow(BuildContext context, _UiSet set, int exerciseIndex) {
//     bool isCompleted = set.isCompleted;
//
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//       decoration: BoxDecoration(
//         color: isCompleted
//             ? Colors.green.withValues(alpha: 0.2)
//             : AppColors.rowAlternate(context),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Icon(
//             isCompleted ? Icons.check_circle : Icons.circle_outlined,
//             size: 22,
//             color: isCompleted ? Colors.green : AppColors.text(context),
//           ),
//           Text(
//             "${set.setNumber}",
//             style: TextStyle(
//               color: isCompleted ? Colors.green : AppColors.text(context),
//             ),
//           ),
//           _numberTextField(
//             context,
//             _getWeightController(exerciseIndex, set.setNumber, set.weight),
//             isCompleted,
//             (value) {
//               set.weight = double.tryParse(value) ?? 0;
//             },
//           ),
//           Text("kg", style: TextStyle(color: AppColors.subText(context))),
//           _numberTextField(
//             context,
//             _getRepsController(exerciseIndex, set.setNumber, set.reps),
//             isCompleted,
//             (value) {
//               set.reps = int.tryParse(value) ?? 0;
//             },
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
//     Function(String)? onChanged,
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
//         onChanged: onChanged,
//         onTapOutside: (_) => FocusScope.of(context).unfocus(),
//       ),
//     );
//   }
//
//   Widget _exerciseBottomButtons(BuildContext context, int index) {
//     final exercise = _exercises[index];
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
//                     builder: (context) => VideoPage(exerciseId: exercise.id),
//                   ),
//                 ).then((_) {
//                   context.read<DashboardBloc>().add(
//                     FetchWorkoutDetailEvent(widget.workoutId),
//                   );
//                 });
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
//               onPressed: () => _addSetToExercise(index),
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
//               onTap: _markCurrentExerciseAllDone,
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
//                 onTap: _logNextSet,
//                 child: Container(
//                   height: 55,
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: AppColors.primary(context),
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Text(
//                     "LOG NEXT SET",
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
import 'package:fitness_workout_app/features/workout_tab/presentation/pages/workout_tab/video_widget_page/video_page.dart';
import 'package:fitness_workout_app/features/workout_tab/presentation/pages/workout_tab/workouts_counter_screen/workout_complete_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../../../core/utils/api.dart';
import '../../../../../../local_database/daily_weight_database.dart';
import '../../../../../../local_database/database_model/session_complete_data.dart';
import '../../../../../../local_database/onboarding_storage.dart';
import '../../../../../../theme/color/colors.dart';
import '../../../../../exercises_tab/domain/model/exercise_model.dart';
import '../../../../../exercises_tab/presentation/bloc/exercise_bloc.dart';
import '../../../../domain/model/workout_details_model.dart';
import '../../../bloc/dashboard_bloc.dart';

class _UiExercise {
  final int id;
  final String displayName;
  final String imageUrl;

  _UiExercise({
    required this.id,
    required this.displayName,
    required this.imageUrl,
  });

  factory _UiExercise.fromWorkoutExercise(WorkoutExercise w) {
    return _UiExercise(
      id: w.id,
      displayName: w.displayName,
      imageUrl: w.imageUrl,
    );
  }

  factory _UiExercise.fromExerciseModel(ExerciseModel e) {
    return _UiExercise(
      id: e.id,
      displayName: e.displayName,
      imageUrl: e.imageUrl,
    );
  }
}

class _UiSet {
  final int setNumber;
  double weight;
  int reps;
  bool isCompleted;

  _UiSet({
    required this.setNumber,
    this.weight = 0,
    this.reps = 0,
    this.isCompleted = false,
  });
}

class CompletedExercise {
  final String workoutName;
  final String name;
  final String imageUrl;
  final int sets;
  final int done;
  final List<int> weights;
  final List<int> reps;

  CompletedExercise({
    required this.workoutName,
    required this.name,
    required this.sets,
    required this.imageUrl,
    required this.done,
    required this.weights,
    required this.reps,
  });
}

class WorkoutCounterScreen extends StatefulWidget {
  final int workoutId;
  final String workoutName;

  const WorkoutCounterScreen({
    super.key,
    required this.workoutId,
    required this.workoutName,
  });

  @override
  State<WorkoutCounterScreen> createState() => _WorkoutCounterScreenState();
}

class _WorkoutCounterScreenState extends State<WorkoutCounterScreen> {
  final Map<int, bool> _expanded = {};

  int? _sessionId;
  List<_UiExercise> _exercises = [];
  Map<int, List<_UiSet>> _exerciseSets = {};
  final Map<int, WorkoutExercise> _workoutExerciseMap = {};

  final ScrollController _scrollController = ScrollController();

  Timer? _timer;
  int _seconds = 0;
  bool _isLoading = true;
  final Map<int, Uint8List?> _videoThumbnails = {};
  String _gender = "male";

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  Map<int, Map<int, TextEditingController>> weightControllers = {};
  Map<int, Map<int, TextEditingController>> repsControllers = {};

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

  Future<Uint8List?> _generateThumbnail(int exerciseId, dynamic workout) async {
    if (_videoThumbnails.containsKey(exerciseId)) {
      return _videoThumbnails[exerciseId];
    }

    final videoPath = getVideoPath(workout);

    if (videoPath.isEmpty) return null;

    try {
      final bytes = await VideoThumbnail.thumbnailData(
        video: Api.base + videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 300,
        quality: 75,
      );

      _videoThumbnails[exerciseId] = bytes;
      return bytes;
    } catch (e) {
      debugPrint("Thumbnail error: $e");
      _videoThumbnails[exerciseId] = null;
      return null;
    }
  }

  TextEditingController _getWeightController(
    int exerciseIndex,
    int setNo,
    double initialValue,
  ) {
    weightControllers[exerciseIndex] ??= {};
    if (weightControllers[exerciseIndex]![setNo] == null) {
      weightControllers[exerciseIndex]![setNo] = TextEditingController(
        text: initialValue > 0 ? initialValue.toStringAsFixed(0) : "3",
      );
    }
    return weightControllers[exerciseIndex]![setNo]!;
  }

  TextEditingController _getRepsController(
    int exerciseIndex,
    int setNo,
    int initialValue,
  ) {
    repsControllers[exerciseIndex] ??= {};
    if (repsControllers[exerciseIndex]![setNo] == null) {
      repsControllers[exerciseIndex]![setNo] = TextEditingController(
        text: initialValue > 0 ? initialValue.toString() : "10",
      );
    }
    return repsControllers[exerciseIndex]![setNo]!;
  }

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(
      FetchWorkoutDetailEvent(widget.workoutId),
    );
    _loadGender();
  }

  Future<void> _initializeSessionAndPopulateExercises(
    List<WorkoutExercise> apiExercises,
  ) async {
    if (_exercises.isNotEmpty) return;

    try {
      for (final ex in apiExercises) {
        _workoutExerciseMap[ex.id] = ex;
      }

      final session = await WeightDB.instance.getOrCreateTodaySession(
        workoutId: widget.workoutId,
        workoutName: widget.workoutName,
      );

      _sessionId = session['id'] as int;
      _seconds = session['timer_seconds'] as int;

      _exercises = apiExercises
          .map((e) => _UiExercise.fromWorkoutExercise(e))
          .toList();

      Future.microtask(() async {
        for (final ex in apiExercises) {
          await _generateThumbnail(ex.id, ex);
        }

        if (mounted) setState(() {});
      });

      for (int i = 0; i < _exercises.length; i++) {
        _exerciseSets[i] = List.generate(
          4,
          (setIndex) => _UiSet(setNumber: setIndex + 1),
        );
      }

      _startTimer();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error initializing session: $e");

      _exercises = apiExercises
          .map((e) => _UiExercise.fromWorkoutExercise(e))
          .toList();

      for (int i = 0; i < _exercises.length; i++) {
        _exerciseSets[i] = List.generate(
          4,
          (setIndex) => _UiSet(setNumber: setIndex + 1),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      _seconds++;
      _saveTimer();
      setState(() {});
    });
  }

  void _saveTimer() async {
    if (_sessionId != null) {
      await WeightDB.instance.updateSessionTimer(_sessionId!, _seconds);
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _saveTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    _searchController.dispose();
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

  // Future<void> _markCurrentExerciseAllDone() async {
  //   for (int i = 0; i < _exercises.length; i++) {
  //     final sets = _exerciseSets[i] ?? [];
  //     final uncompletedSets = sets.where((s) => !s.isCompleted).toList();
  //
  //     if (uncompletedSets.isNotEmpty) {
  //       for (var set in uncompletedSets) {
  //         final weightController = weightControllers[i]?[set.setNumber];
  //         final repsController = repsControllers[i]?[set.setNumber];
  //
  //         final weight = double.tryParse(weightController?.text ?? '0') ?? 0;
  //         final reps = int.tryParse(repsController?.text ?? '0') ?? 0;
  //
  //         set.weight = weight;
  //         set.reps = reps;
  //         set.isCompleted = true;
  //       }
  //
  //       setState(() {
  //         _expanded[i] = false;
  //       });
  //       break;
  //     }
  //   }
  // }

  Future<void> _markCurrentExerciseAllDone() async {
    for (int i = 0; i < _exercises.length; i++) {
      final sets = _exerciseSets[i] ?? [];
      final uncompletedSets = sets.where((s) => !s.isCompleted).toList();

      if (uncompletedSets.isNotEmpty) {
        for (var set in uncompletedSets) {
          final weightController = weightControllers[i]?[set.setNumber];
          final repsController = repsControllers[i]?[set.setNumber];

          final weight = double.tryParse(weightController?.text ?? '0') ?? 0;
          final reps = int.tryParse(repsController?.text ?? '0') ?? 0;

          set.weight = weight;
          set.reps = reps;
          set.isCompleted = true;
        }

        // Save progress
        if (_sessionId != null) {
          await WeightDB.instance.saveSessionExercises(
            sessionId: _sessionId!,
            exercises: _buildSessionExerciseData(),
          );
        }

        setState(() {
          _expanded[i] = false;
        });
        break;
      }
    }
  }

  // Future<void> _logNextSet() async {
  //   for (int i = 0; i < _exercises.length; i++) {
  //     final sets = _exerciseSets[i] ?? [];
  //     final nextSet = sets.firstWhere(
  //       (s) => !s.isCompleted,
  //       orElse: () => _UiSet(setNumber: -1),
  //     );
  //
  //     if (nextSet.setNumber == -1) continue;
  //
  //     final weightController = weightControllers[i]?[nextSet.setNumber];
  //     final repsController = repsControllers[i]?[nextSet.setNumber];
  //
  //     final weight = double.tryParse(weightController?.text ?? '0') ?? 0;
  //     final reps = int.tryParse(repsController?.text ?? '0') ?? 0;
  //
  //     nextSet.weight = weight;
  //     nextSet.reps = reps;
  //     nextSet.isCompleted = true;
  //
  //     setState(() {
  //       _expanded[i] = true;
  //     });
  //
  //     final allDone = sets.every((s) => s.isCompleted);
  //     if (allDone) {
  //       Future.delayed(const Duration(milliseconds: 600), () {
  //         if (mounted) {
  //           setState(() {
  //             _expanded[i] = false;
  //           });
  //         }
  //       });
  //     }
  //
  //     return;
  //   }
  //
  //   bool allDone = _exercises.asMap().entries.every((entry) {
  //     final sets = _exerciseSets[entry.key] ?? [];
  //     return sets.every((s) => s.isCompleted);
  //   });
  //
  //   if (allDone) {
  //     _stopTimer();
  //
  //     if (_sessionId != null) {
  //       await WeightDB.instance.completeSession(_sessionId!);
  //     }
  //
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => WorkoutCompletedScreen(
  //           durationSeconds: _seconds,
  //           exercises: _buildCompletionData(),
  //         ),
  //       ),
  //     );
  //   }
  // }

  Future<void> _logNextSet() async {
    for (int i = 0; i < _exercises.length; i++) {
      final sets = _exerciseSets[i] ?? [];
      final nextSet = sets.firstWhere(
        (s) => !s.isCompleted,
        orElse: () => _UiSet(setNumber: -1),
      );

      if (nextSet.setNumber == -1) continue;

      final weightController = weightControllers[i]?[nextSet.setNumber];
      final repsController = repsControllers[i]?[nextSet.setNumber];

      final weight = double.tryParse(weightController?.text ?? '0') ?? 0;
      final reps = int.tryParse(repsController?.text ?? '0') ?? 0;

      nextSet.weight = weight;
      nextSet.reps = reps;
      nextSet.isCompleted = true;

      setState(() {
        _expanded[i] = true;
      });

      // Save progress periodically (optional - for crash recovery)
      if (_sessionId != null) {
        await WeightDB.instance.saveSessionExercises(
          sessionId: _sessionId!,
          exercises: _buildSessionExerciseData(),
        );
      }

      final allDone = sets.every((s) => s.isCompleted);
      if (allDone) {
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

    // Check if all exercises are done
    bool allDone = _exercises.asMap().entries.every((entry) {
      final sets = _exerciseSets[entry.key] ?? [];
      return sets.every((s) => s.isCompleted);
    });

    if (allDone) {
      _finishWorkout();
    }
  }

  bool get isWorkoutFullyCompleted {
    return _exercises.asMap().entries.every((entry) {
      final sets = _exerciseSets[entry.key] ?? [];
      return sets.isNotEmpty && sets.every((s) => s.isCompleted);
    });
  }

  List<CompletedExercise> _buildCompletionData() {
    final List<CompletedExercise> result = [];

    for (int i = 0; i < _exercises.length; i++) {
      final exercise = _exercises[i];
      final sets = _exerciseSets[i] ?? [];

      result.add(
        CompletedExercise(
          workoutName: widget.workoutName,
          name: exercise.displayName,
          imageUrl: exercise.imageUrl,
          sets: sets.length,
          done: sets.where((s) => s.isCompleted).length,
          weights: sets.map((s) => s.weight.toInt()).toList(),
          reps: sets.map((s) => s.reps).toList(),
        ),
      );
    }

    return result;
  }

  List<SessionExerciseData> _buildSessionExerciseData() {
    final List<SessionExerciseData> result = [];

    for (int i = 0; i < _exercises.length; i++) {
      final exercise = _exercises[i];
      final sets = _exerciseSets[i] ?? [];

      final setDataList = sets.map((s) {
        // Get values from controllers
        final weightController = weightControllers[i]?[s.setNumber];
        final repsController = repsControllers[i]?[s.setNumber];

        final weight =
            double.tryParse(weightController?.text ?? '0') ?? s.weight;
        final reps = int.tryParse(repsController?.text ?? '0') ?? s.reps;

        return SessionSetData(
          setNumber: s.setNumber,
          weight: weight,
          reps: reps,
          isCompleted: s.isCompleted,
        );
      }).toList();

      result.add(
        SessionExerciseData(
          exerciseId: exercise.id,
          exerciseName: exercise.displayName,
          imageUrl: exercise.imageUrl,
          sets: setDataList,
        ),
      );
    }

    return result;
  }

  void _addSetToExercise(int exerciseIndex) {
    final sets = _exerciseSets[exerciseIndex] ?? [];
    final newSetNumber = sets.isEmpty ? 1 : sets.last.setNumber + 1;

    sets.add(
      _UiSet(setNumber: newSetNumber, weight: 0, reps: 0, isCompleted: false),
    );

    setState(() {
      _exerciseSets[exerciseIndex] = sets;
    });
  }

  void _addExercisesToSession(List<int> selectedExerciseIds) {
    final exerciseState = context.read<ExerciseBloc>().state;
    if (exerciseState is! ExerciseLoaded &&
        exerciseState is! ExercisePaginationLoading) {
      return;
    }

    final allExercises = exerciseState is ExerciseLoaded
        ? exerciseState.exercises
        : (exerciseState as ExercisePaginationLoading).oldData;

    final existingIds = _exercises.map((e) => e.id).toSet();

    List<String> snackMessages = [];

    for (var id in selectedExerciseIds) {
      if (existingIds.contains(id)) {
        final ex = allExercises.firstWhere((e) => e.id == id);
        snackMessages.add("⚠️ '${ex.displayName}' already added");
        continue;
      }

      final exercise = allExercises.firstWhere((e) => e.id == id);

      final newExercise = _UiExercise.fromExerciseModel(exercise);
      _exercises.add(newExercise);

      final newIndex = _exercises.length - 1;
      _exerciseSets[newIndex] = List.generate(
        4,
        (setIndex) => _UiSet(setNumber: setIndex + 1),
      );

      existingIds.add(id);
      snackMessages.add("Added '${exercise.displayName}'");
    }

    setState(() {});

    if (snackMessages.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black87,
          duration: const Duration(seconds: 3),
          content: Text(
            snackMessages.join("\n"),
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      );
    }
  }

  // void _finishWorkout() {
  //   _stopTimer();
  //
  //   if (_sessionId != null) {
  //     WeightDB.instance.completeSession(_sessionId!);
  //   }
  //
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => WorkoutCompletedScreen(
  //         durationSeconds: _seconds,
  //         exercises: _buildCompletionData(),
  //       ),
  //     ),
  //   );
  // }

  void _finishWorkout() async {
    _stopTimer();

    if (_sessionId != null) {
      // Save exercises and sets, then complete session
      await WeightDB.instance.completeSessionWithExercises(
        sessionId: _sessionId!,
        exercises: _buildSessionExerciseData(),
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WorkoutCompletedScreen(
          durationSeconds: _seconds,
          exercises: _buildCompletionData(),
        ),
      ),
    );
  }

  Future<List<int>?> _openAddExerciseSheet({int? focusAreaId}) async {
    context.read<ExerciseBloc>().add(
      GetExercisesEvent(focusAreaId: focusAreaId),
    );

    Set<int> selectedExerciseIds = {};

    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final ScrollController scrollController = ScrollController();

        scrollController.addListener(() {
          if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100) {
            context.read<ExerciseBloc>().add(LoadMoreExercisesEvent());
          }
        });

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, _) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return BlocBuilder<ExerciseBloc, ExerciseState>(
                    builder: (context, state) {
                      if (state is ExerciseLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is ExerciseError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      final exercises = state is ExerciseLoaded
                          ? state.exercises
                          : state is ExercisePaginationLoading
                          ? state.oldData
                          : <ExerciseModel>[];

                      final groupedExercises = _groupAndSortExercises(
                        exercises,
                      );

                      return Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(26),
                                topRight: Radius.circular(26),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Add Exercises",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.text(context),
                                      ),
                                    ),
                                    Container(
                                      height: 32,
                                      width: 32,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.border(context),
                                        ),
                                      ),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: AppColors.card(context),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.border(context),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.tune,
                                        color: AppColors.text(context),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Container(
                                        height: 45,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.card(context),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: AppColors.border(context),
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: TextField(
                                                controller: _searchController,
                                                focusNode: _searchFocusNode,
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                decoration:
                                                    const InputDecoration(
                                                      hintText: "Search",
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 0,
                                                          ),
                                                      border: InputBorder.none,
                                                    ),
                                              ),
                                            ),
                                            Icon(
                                              Icons.search,
                                              color: AppColors.subText(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Expanded(
                                  child: ListView.builder(
                                    controller: scrollController,
                                    itemCount: groupedExercises.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == groupedExercises.length) {
                                        if (state
                                            is ExercisePaginationLoading) {
                                          return const Center(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 8,
                                              ),
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      }

                                      final letter = groupedExercises.keys
                                          .elementAt(index);
                                      final exercises =
                                          groupedExercises[letter]!;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                            ),
                                            child: Text(
                                              letter,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.text(context),
                                              ),
                                            ),
                                          ),
                                          ...exercises.map(
                                            (item) => GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (selectedExerciseIds
                                                      .contains(item.id)) {
                                                    selectedExerciseIds.remove(
                                                      item.id,
                                                    );
                                                  } else {
                                                    selectedExerciseIds.add(
                                                      item.id,
                                                    );
                                                  }
                                                });
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  bottom: 12,
                                                ),
                                                padding: const EdgeInsets.all(
                                                  12,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.card(
                                                    context,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                  border: Border.all(
                                                    color: AppColors.border(
                                                      context,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            6,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            AppColors.rowAlternate(
                                                              context,
                                                            ),
                                                        borderRadius:
                                                            const BorderRadius.only(
                                                              topLeft:
                                                                  Radius.circular(
                                                                    12,
                                                                  ),
                                                              bottomLeft:
                                                                  Radius.circular(
                                                                    12,
                                                                  ),
                                                            ),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                        child: Image.network(
                                                          "${Api.base}${item.imageUrl}",
                                                          height: 80,
                                                          width: 80,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    // Container(
                                                    //   height: 55,
                                                    //   width: 55,
                                                    //   decoration: BoxDecoration(
                                                    //     borderRadius:
                                                    //         BorderRadius.circular(
                                                    //           12,
                                                    //         ),
                                                    //     image: DecorationImage(
                                                    //       image: NetworkImage(
                                                    //         Api.base +
                                                    //             item.imageUrl,
                                                    //       ),
                                                    //       fit: BoxFit.contain,
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            item.displayName,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  AppColors.text(
                                                                    context,
                                                                  ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text(
                                                            item
                                                                    .focusAreas
                                                                    .isNotEmpty
                                                                ? item.focusAreas
                                                                      .map(
                                                                        (e) => e
                                                                            .displayName,
                                                                      )
                                                                      .join(
                                                                        ", ",
                                                                      )
                                                                : "",
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  AppColors.subText(
                                                                    context,
                                                                  ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Icon(
                                                      selectedExerciseIds
                                                              .contains(item.id)
                                                          ? Icons.check_circle
                                                          : Icons
                                                                .circle_outlined,
                                                      color: AppColors.text(
                                                        context,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (selectedExerciseIds.isNotEmpty)
                            Positioned(
                              left: 16,
                              right: 16,
                              bottom: 16,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  backgroundColor: AppColors.primary(context),
                                ),
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                    selectedExerciseIds.toList(),
                                  );
                                },
                                child: Text(
                                  "Add",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.buttonText(context),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Map<String, List<ExerciseModel>> _groupAndSortExercises(
    List<ExerciseModel> exercises,
  ) {
    exercises.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );
    Map<String, List<ExerciseModel>> grouped = {};
    for (var ex in exercises) {
      String firstLetter = ex.name[0].toUpperCase();
      grouped.putIfAbsent(firstLetter, () => []);
      grouped[firstLetter]!.add(ex);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _stopTimer();
          Navigator.pop(context, true);
        }
      },
      child: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is WorkoutDetailLoaded) {
            _initializeSessionAndPopulateExercises(
              state.workoutDetail.data.exercises,
            );
          } else if (state is WorkoutDetailError) {
            // Handle API error
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background(context),
          appBar: _appBar(context),
          body: _buildBody(context),
          bottomNavigationBar: _isLoading ? null : _bottomButton(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is WorkoutDetailError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.message,
                  style: TextStyle(color: AppColors.text(context)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    context.read<DashboardBloc>().add(
                      FetchWorkoutDetailEvent(widget.workoutId),
                    );
                  },
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        if (_exercises.isEmpty) {
          return const Center(child: Text("No exercises found"));
        }

        return _body(context);
      },
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
                onPressed: () {
                  _stopTimer();
                  Navigator.pop(context, true);
                },
              ),
            );
          },
        ),
      ),
      title: Text(
        "${widget.workoutName} Workout",
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
          ...List.generate(
            _exercises.length,
            (index) => Column(
              children: [
                _exerciseCard(context, _exercises[index], index),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              final selectedIds = await _openAddExerciseSheet();
              if (selectedIds != null && selectedIds.isNotEmpty) {
                _addExercisesToSession(selectedIds);
              }
            },
            child: Container(
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary(context),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "+ Add Exercise",
                style: TextStyle(
                  color: AppColors.buttonText(context),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
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
              color: Colors.green.withValues(alpha: 0.15),
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
        ],
      ),
    );
  }

  Widget _exerciseImage(_UiExercise uiExercise, WorkoutExercise workout) {
    final thumb = _videoThumbnails[uiExercise.id];

    if (thumb != null) {
      return Image.memory(thumb, fit: BoxFit.cover, gaplessPlayback: true);
    }

    if (uiExercise.imageUrl.isNotEmpty) {
      return Image.network(Api.base + uiExercise.imageUrl, fit: BoxFit.cover);
    }

    return Image.asset("assets/program/shoulders.png", fit: BoxFit.cover);
  }

  Widget _exerciseCard(BuildContext context, _UiExercise exercise, int index) {
    final isOpen = _expanded[index] ?? false;
    final sets = _exerciseSets[index] ?? [];
    final totalSets = sets.length;
    final doneSets = sets.where((s) => s.isCompleted).length;

    final image = (exercise.imageUrl.isNotEmpty)
        ? NetworkImage(Api.base + exercise.imageUrl)
        : const AssetImage("assets/program/shoulders.png") as ImageProvider;

    final workoutExercise = _workoutExerciseMap[exercise.id];

    // debugPrint("IMAGE URL: ${exercise.displayName} -> ${exercise.imageUrl}");

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
                // Container(
                //   height: 55,
                //   width: 55,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(12),
                //     image: DecorationImage(image: image, fit: BoxFit.cover),
                //   ),
                // ),
                Container(
                  height: 55,
                  width: 55,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: workoutExercise == null
                      ? Image.asset(
                          "assets/program/shoulders.png",
                          fit: BoxFit.cover,
                        )
                      : _exerciseImage(exercise, workoutExercise),
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
                    //   onPressed: () {},
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
                for (var set in sets) ...[
                  _setRow(context, set, index),
                  const SizedBox(height: 10),
                ],
                _exerciseBottomButtons(context, index),
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

  Widget _setRow(BuildContext context, _UiSet set, int exerciseIndex) {
    bool isCompleted = set.isCompleted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.green.withValues(alpha: 0.2)
            : AppColors.rowAlternate(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted ? Colors.lightGreen : AppColors.border(context),
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
            "${set.setNumber}",
            style: TextStyle(
              color: isCompleted ? Colors.green : AppColors.text(context),
            ),
          ),
          _numberTextField(
            context,
            _getWeightController(exerciseIndex, set.setNumber, set.weight),
            isCompleted,
            (value) {
              set.weight = double.tryParse(value) ?? 0;
            },
          ),
          Text("kg", style: TextStyle(color: AppColors.subText(context))),
          _numberTextField(
            context,
            _getRepsController(exerciseIndex, set.setNumber, set.reps),
            isCompleted,
            (value) {
              set.reps = int.tryParse(value) ?? 0;
            },
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
    Function(String)? onChanged,
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
        onChanged: onChanged,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
      ),
    );
  }

  Widget _exerciseBottomButtons(BuildContext context, int index) {
    final exercise = _exercises[index];
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
                    builder: (context) => VideoPage(exerciseId: exercise.id),
                  ),
                ).then((_) {
                  context.read<DashboardBloc>().add(
                    FetchWorkoutDetailEvent(widget.workoutId),
                  );
                });
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
              onPressed: () => _addSetToExercise(index),
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
              onTap: _markCurrentExerciseAllDone,
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
}
