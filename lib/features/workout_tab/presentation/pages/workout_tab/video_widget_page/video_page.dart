import 'package:fitness_workout_app/core/utils/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

import '../../../../../../local_database/daily_weight_database.dart';
import '../../../../../../local_database/database_model/excercise_history_data.dart';
import '../../../../../../local_database/onboarding_storage.dart';
import '../../../../../../theme/color/colors.dart';
import '../../../bloc/dashboard_bloc.dart';

class VideoPage extends StatefulWidget {
  // final String title;
  // final String videoUrl;
  final int exerciseId;
  const VideoPage({
    super.key,
    // required this.title,
    // required this.videoUrl,
    required this.exerciseId,
  });

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  int selectedTab = 0;
  int switchTab = 0;
  late VideoPlayerController _controller;
  bool isVideoReady = false;
  String _gender = "male";
  // List<Map<String, dynamic>> exerciseHistory = [];
  bool isHistoryLoading = true;

  Map<String, dynamic> exerciseStats = {};
  List<ExerciseHistoryData> exerciseHistory = [];

  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(
      FetchWorkoutExerciseDetailEvent(widget.exerciseId),
    );
    _loadGender();
    _loadExerciseHistory();
  }

  Future<void> _loadGender() async {
    final gender = await OnboardingStorage.getString("gender");
    if (gender != null) {
      _gender = gender.toLowerCase();
    }
  }

  Future<void> _loadExerciseHistory() async {
    setState(() => isHistoryLoading = true);

    try {
      final history = await WeightDB.instance.getExerciseHistoryGrouped(
        widget.exerciseId,
      );
      final stats = await WeightDB.instance.getExerciseStats(widget.exerciseId);

      setState(() {
        exerciseHistory = history;
        exerciseStats = stats;
        isHistoryLoading = false;
      });

      debugPrint(
        "Loaded ${history.length} history records for exercise ${widget.exerciseId}",
      );
    } catch (e) {
      debugPrint("Error loading exercise history: $e");
      setState(() => isHistoryLoading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getVideoPath(dynamic workout) {
    if (_gender == "female" &&
        workout.femaleVideoPath != null &&
        workout.femaleVideoPath.isNotEmpty) {
      return workout.femaleVideoPath;
    }
    return workout.maleVideoPath;
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String _formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;

    if (hours > 0) {
      return "${hours}h ${minutes}m";
    }
    return "$minutes min";
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is WorkoutExerciseDetailLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is WorkoutExerciseDetailError) {
          return Scaffold(
            body: Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }
        if (state is WorkoutExerciseDetailLoaded) {
          final workout = state.exerciseDetail.data;
          final videoPath = getVideoPath(workout);

          debugPrint("videoURl : ${Api.base}$videoPath");

          if (!isVideoReady) {
            _controller =
                VideoPlayerController.networkUrl(
                    // Uri.parse("${Api.base}${workout.maleVideoPath}"),
                    Uri.parse("${Api.base}$videoPath"),
                  )
                  ..initialize().then((_) {
                    setState(() {
                      isVideoReady = true;
                    });
                  });

            _controller.setLooping(true);
          }

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) {
                Navigator.pop(context, true);
              }
            },
            child: Scaffold(
              backgroundColor: AppColors.background(context),
              appBar: AppBar(
                backgroundColor: AppColors.card(context),
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Builder(
                    builder: (context) {
                      bool isDark =
                          Theme.of(context).brightness == Brightness.dark;
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
                          //onPressed: () => Navigator.pop(context),
                          onPressed: () => Navigator.pop(context, true),
                        ),
                      );
                    },
                  ),
                ),
                title: Text(
                  //  widget.title,
                  workout.displayName,
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                centerTitle: true,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ---------------- TAB BAR ----------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _tabButton("Instruction", 0),
                        Container(
                          width: 1.5,
                          height: 25,
                          color: AppColors.divider(context),
                          margin: const EdgeInsets.symmetric(horizontal: 40),
                        ),
                        _tabButton("Record", 1),
                      ],
                    ),
                    const SizedBox(height: 20),

                    if (selectedTab == 0) ...[
                      /// VIDEO BOX
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.card(context),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border(context)),
                        ),
                        child: isVideoReady
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _controller.value.isPlaying
                                        ? _controller.pause()
                                        : _controller.play();
                                  });
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SizedBox.expand(
                                        child: FittedBox(
                                          fit: BoxFit.cover,
                                          clipBehavior: Clip.hardEdge,
                                          child: SizedBox(
                                            width: _controller.value.size.width,
                                            height:
                                                _controller.value.size.height,
                                            child: VideoPlayer(_controller),
                                          ),
                                        ),
                                      ),
                                      if (!_controller.value.isPlaying)
                                        Icon(
                                          Icons.play_circle_fill,
                                          size: 50,
                                          color: AppColors.icon(context),
                                        ),
                                    ],
                                  ),
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary(context),
                                ),
                              ),
                      ),

                      const SizedBox(height: 20),

                      /// MUSCLE / HOW TO DO SWITCH
                      _muscleHowToSwitch(),
                      const SizedBox(height: 20),

                      /// INSTRUCTION CONTENT
                      Expanded(child: _instructionSection(workout)),
                    ] else ...[
                      /// RECORD CONTENT ONLY
                      Expanded(child: _recordSection()),
                    ],
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  /// ---------------- TAB BUTTON ----------------
  Widget _tabButton(String text, int index) {
    bool isActive = selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: isActive
                  ? AppColors.text(context)
                  : AppColors.subText(context),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 2.5,
            width: 100,
            color: isActive ? AppColors.videoDivider : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _muscleHowToSwitch() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: AppColors.card(context).withValues(alpha: 0.5),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => switchTab = 0),
              child: Container(
                decoration: BoxDecoration(
                  color: switchTab == 0
                      ? AppColors.primary(context)
                      : AppColors.card(context),
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Muscle",
                  style: TextStyle(
                    color: switchTab == 0
                        ? AppColors.buttonText(context)
                        : AppColors.text(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => switchTab = 1),
              child: Container(
                decoration: BoxDecoration(
                  color: switchTab == 1
                      ? AppColors.primary(context)
                      : AppColors.card(context),
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Text(
                  "How to do",
                  style: TextStyle(
                    color: switchTab == 1
                        ? AppColors.buttonText(context)
                        : AppColors.text(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _instructionSection(dynamic workout) {
    return switchTab == 0 ? _muscleSection(workout) : _howToDoSection(workout);
  }

  Widget _muscleSection(dynamic workout) {
    final focusAreas = workout.focusAreas ?? [];
    final equipments = workout.equipments ?? [];

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (focusAreas.isNotEmpty) ...[
                    Text(
                      "Focus Area",
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: focusAreas.map<Widget>((item) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.card(
                              context,
                            ).withValues(alpha: 0.2),
                            border: Border.all(
                              color: AppColors.border(context),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "• ",
                                style: TextStyle(
                                  color: AppColors.videoDivider,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                item.displayName,
                                style: TextStyle(
                                  color: AppColors.subText(context),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),
                  ],

                  // Spacer(),
                  if (equipments.isNotEmpty) ...[
                    Text(
                      "Equipment",
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: equipments.map<Widget>((item) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.border(context),
                            ),
                          ),
                          child: Text(
                            item.displayName,
                            style: TextStyle(color: AppColors.subText(context)),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _howToDoSection(dynamic workout) {
    return ListView(
      children: [
        Text(
          "Preparation",
          style: TextStyle(
            color: AppColors.text(context),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),

        Html(
          data: workout.preparationText ?? "",
          style: {
            "body": Style(
              color: AppColors.subText(context),
              fontSize: FontSize(14),
              fontWeight: FontWeight.w500,
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
            ),
          },
        ),

        const SizedBox(height: 20),
        Text(
          "Execution",
          style: TextStyle(
            color: AppColors.text(context),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Html(
          data: workout.executionPoint ?? "",
          style: {
            "body": Style(
              color: AppColors.subText(context),
              fontSize: FontSize(14),
              fontWeight: FontWeight.w500,
              margin: Margins.zero,
              padding: HtmlPaddings.zero,
            ),
          },
        ),
        if (workout.keyTips != null && workout.keyTips!.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            "Key Tips",
            style: TextStyle(
              color: AppColors.text(context),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Html(
            data: workout.keyTips ?? "",
            style: {
              "body": Style(
                color: AppColors.subText(context),
                fontSize: FontSize(14),
                fontWeight: FontWeight.w500,
                margin: Margins.zero,
                padding: HtmlPaddings.zero,
              ),
            },
          ),
        ],
        const SizedBox(height: 20),
      ],
    );
  }

  // Widget _recordSection() {
  //   return Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Image.asset("assets/icons/noWorkout.png", height: 205),
  //         const SizedBox(height: 20),
  //         Text(
  //           "No Workouts History",
  //           style: TextStyle(
  //             color: AppColors.text(context),
  //             fontSize: 18,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //         const SizedBox(height: 6),
  //         Text(
  //           "Here shows your completed workouts",
  //           style: TextStyle(color: AppColors.subText(context)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _recordSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isHistoryLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppColors.primary(context)),
      );
    }

    if (exerciseHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icons/noWorkout.png", height: 150),
            const SizedBox(height: 20),
            Text(
              "No Workout History",
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Complete a workout with this exercise\nto see your records here",
              style: TextStyle(color: AppColors.subText(context)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: exerciseHistory.length,
            itemBuilder: (context, index) {
              final record = exerciseHistory[index];
              return _buildHistoryCard(record, isDark);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard(ExerciseHistoryData record, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.subText(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(record.date),
                    style: TextStyle(
                      color: AppColors.text(context),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      size: 14,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDuration(record.timerSeconds),
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Workout Name
          Text(
            record.workoutName,
            style: TextStyle(color: AppColors.subText(context), fontSize: 13),
          ),

          const SizedBox(height: 12),

          // Divider
          Container(height: 1, color: AppColors.border(context)),

          const SizedBox(height: 12),

          // Sets Header
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "Set",
                  style: TextStyle(
                    color: AppColors.subText(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Weight",
                  style: TextStyle(
                    color: AppColors.subText(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  "Reps",
                  style: TextStyle(
                    color: AppColors.subText(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ...record.sets.map((set) => _buildSetRow(set)),
        ],
      ),
    );
  }

  Widget _buildSetRow(ExerciseSetRecord set) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                "${set.setNumber}",
                style: TextStyle(
                  color: AppColors.text(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          // Weight
          Expanded(
            flex: 2,
            child: Text(
              "${set.weight.toStringAsFixed(1)} kg",
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Reps
          Expanded(
            flex: 2,
            child: Text(
              "${set.reps} reps",
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
