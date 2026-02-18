import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../theme/color/colors.dart';
import '../../../../../../core/utils/api.dart';
import 'exercise_counter_screen.dart';

class ExerciseCompletedScreen extends StatefulWidget {
  final int durationSeconds;
  final List<CompletedExercise1> exercises;

  const ExerciseCompletedScreen({
    super.key,
    required this.durationSeconds,
    required this.exercises,
  });

  @override
  State<ExerciseCompletedScreen> createState() =>
      _ExerciseCompletedScreenState();
}

class _ExerciseCompletedScreenState extends State<ExerciseCompletedScreen> {
  String _formatTime(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final workoutName = widget.exercises.isNotEmpty
        ? widget.exercises.first.workoutName
        : "Exercise";

    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: Column(
          children: [
            // ------------------ HEADER ------------------
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(45),
                    bottomRight: Radius.circular(45),
                  ),
                  child: Image.asset(
                    "assets/workout/select_photo.jpg",
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  left: 20,
                  top: 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Great Job!",
                        style: TextStyle(
                          color: AppColors.text(context),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "EXERCISES\nCOMPLETED!",
                        style: TextStyle(
                          color: AppColors.text(context),
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  right: 20,
                  bottom: 20,
                  child: Transform.rotate(
                    angle: -0.3,
                    child: Image.asset(
                      "assets/workout/trophy.png",
                      width: 100,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ------------------ MAIN INFO CARD ------------------
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card(context),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.border(context)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        workoutName,
                        style: TextStyle(
                          fontSize: 22,
                          color: AppColors.text(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.verified_rounded,
                        color: AppColors.text(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Duration",
                            style: TextStyle(color: AppColors.subText(context)),
                          ),
                          Text(
                            _formatTime(widget.durationSeconds),
                            style: TextStyle(
                              fontSize: 22,
                              color: AppColors.text(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            "Date",
                            style: TextStyle(color: AppColors.subText(context)),
                          ),
                          Text(
                            DateFormat("hh:mm MMM d").format(DateTime.now()),
                            style: TextStyle(
                              fontSize: 22,
                              color: AppColors.text(context),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ------------------ EXERCISE LIST ------------------
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: widget.exercises.map((ex) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.card(context),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border(context)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (ex.imageUrl.isNotEmpty)
                                Container(
                                  width: 50,
                                  height: 50,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        Api.base + ex.imageUrl,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ex.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.text(context),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${ex.done}/${ex.sets} Done",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.subText(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          ...List.generate(ex.sets, (setIndex) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary(context),
                                    ),
                                    child: Text(
                                      "${setIndex + 1}",
                                      style: TextStyle(
                                        color: AppColors.buttonText(context),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    "${ex.weights[setIndex]} kg",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.text(context),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "x ${ex.reps[setIndex]}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.text(context),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    "Done",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.buttonText(context),
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
