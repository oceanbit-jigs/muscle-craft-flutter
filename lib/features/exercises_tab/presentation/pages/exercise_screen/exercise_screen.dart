import 'dart:typed_data';

import 'package:fitness_workout_app/core/utils/api.dart';
import 'package:fitness_workout_app/features/workout_tab/presentation/pages/workout_tab/video_widget_page/video_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../../local_database/onboarding_storage.dart';
import '../../../../../theme/color/colors.dart';
import '../../../domain/model/exercise_model.dart';
import '../../bloc/exercise_bloc.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final ScrollController _scrollController = ScrollController();
  String _gender = "male";
  final Map<String, Uint8List> _thumbnailCache = {};
  final Map<String, Future<Uint8List?>> _thumbnailFutureCache = {};

  @override
  void initState() {
    super.initState();

    context.read<ExerciseBloc>().add(GetExercisesEvent());

    _scrollController.addListener(_onScroll);
    _loadGender();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ExerciseBloc>().add(LoadMoreExercisesEvent());
    }
  }

  // Future<Uint8List?> _getThumbnail(String videoPath) async {
  //   if (_thumbnailCache.containsKey(videoPath)) {
  //     return _thumbnailCache[videoPath];
  //   }
  //
  //   final data = await VideoThumbnail.thumbnailData(
  //     video: "${Api.base}$videoPath",
  //     imageFormat: ImageFormat.PNG,
  //     maxWidth: 720,
  //     quality: 100,
  //   );
  //
  //   if (data != null) {
  //     _thumbnailCache[videoPath] = data;
  //   }
  //
  //   return data;
  // }

  Future<Uint8List?> _getThumbnail(String videoPath) {
    if (_thumbnailFutureCache.containsKey(videoPath)) {
      return _thumbnailFutureCache[videoPath]!;
    }

    final future = VideoThumbnail.thumbnailData(
      video: "${Api.base}$videoPath",
      imageFormat: ImageFormat.PNG,
      maxWidth: 720,
      quality: 100,
    );

    _thumbnailFutureCache[videoPath] = future;
    return future;
  }

  Future<void> _loadGender() async {
    final gender = await OnboardingStorage.getString("gender");
    print("Saved gender from storage: $gender");

    if (gender != null) {
      setState(() {
        _gender = gender.toLowerCase();
      });
      print("Gender applied in UI: $_gender");
    }
  }

  Map<String, List<ExerciseModel>> _groupByAlphabet(List<ExerciseModel> list) {
    final map = <String, List<ExerciseModel>>{};

    for (var ex in list) {
      final letter = ex.displayName.isNotEmpty
          ? ex.displayName[0].toUpperCase()
          : "#";

      map.putIfAbsent(letter, () => []);
      map[letter]!.add(ex);
    }

    final sortedKeys = map.keys.toList()..sort();

    return {for (var k in sortedKeys) k: map[k]!};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      appBar: AppBar(
        title: Text(
          "Exercises",
          style: TextStyle(
            color: AppColors.text(context),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background(context),
        centerTitle: false,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.icon(context)),
      ),
      body: BlocBuilder<ExerciseBloc, ExerciseState>(
        builder: (context, state) {
          if (state is ExerciseLoading) {
            return _buildLoader();
          }

          if (state is ExerciseError) {
            return _buildError(state.message);
          }

          if (state is ExerciseLoaded || state is ExercisePaginationLoading) {
            final exercises = state is ExerciseLoaded
                ? state.exercises
                : (state as ExercisePaginationLoading).oldData;

            final hasMore = state is ExerciseLoaded && state.hasMore;

            final grouped = _groupByAlphabet(exercises);

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ExerciseBloc>().add(RefreshExercisesEvent());
              },
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  for (var letter in grouped.keys) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Text(
                        letter,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text(context),
                        ),
                      ),
                    ),

                    for (var item in grouped[letter]!)
                      _exerciseCard(context, item),
                  ],

                  if (hasMore) _paginationLoader(),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  // Widget _exerciseCard(BuildContext context, ExerciseModel model) {
  //   final focusText = model.focusAreas.isNotEmpty
  //       ? model.focusAreas.map((e) => e.displayName).join(", ")
  //       : "No focus area";
  //
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 10),
  //     decoration: BoxDecoration(
  //       color: AppColors.card(context),
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: AppColors.border(context)),
  //     ),
  //     child: Row(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.only(left: 8.0),
  //           child: Container(
  //             padding: const EdgeInsets.all(6),
  //             decoration: BoxDecoration(
  //               color: AppColors.rowAlternate(context),
  //               borderRadius: const BorderRadius.only(
  //                 topLeft: Radius.circular(12),
  //                 bottomLeft: Radius.circular(12),
  //               ),
  //             ),
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(10),
  //               child: model.imageUrl.isNotEmpty
  //                   ? Image.network(
  //                       "${Api.base}${model.imageUrl}",
  //                       height: 80,
  //                       width: 80,
  //                       fit: BoxFit.cover,
  //                     )
  //                   : Icon(
  //                       Icons.fitness_center,
  //                       size: 40,
  //                       color: AppColors.icon(context),
  //                     ),
  //             ),
  //           ),
  //         ),
  //
  //         const SizedBox(width: 8),
  //
  //         Expanded(
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         model.displayName,
  //                         style: TextStyle(
  //                           color: AppColors.text(context),
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                       ),
  //
  //                       const SizedBox(height: 6),
  //
  //                       Text(
  //                         "Focus Areas: $focusText",
  //                         style: TextStyle(
  //                           color: AppColors.subText(context),
  //                           fontSize: 12,
  //                         ),
  //                         maxLines: 2,
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //
  //                 GestureDetector(
  //                   onTap: () {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => VideoPage(exerciseId: model.id),
  //                       ),
  //                     );
  //                   },
  //                   child: CircleAvatar(
  //                     backgroundColor: AppColors.primary(context),
  //                     radius: 20,
  //                     child: Icon(
  //                       Icons.arrow_forward,
  //                       size: 20,
  //                       color: AppColors.buttonText(context),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _exerciseCard(BuildContext context, ExerciseModel model) {
    final focusText = model.focusAreas.isNotEmpty
        ? model.focusAreas.map((e) => e.displayName).join(", ")
        : "No focus area";

    String getVideoPath(ExerciseModel model) {
      if (_gender == "female" && model.femaleVideoPath.isNotEmpty) {
        return model.femaleVideoPath;
      }
      return model.maleVideoPath;
    }

    final videoPath = getVideoPath(model);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.rowAlternate(context),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: videoPath.isNotEmpty
                  ? FutureBuilder<Uint8List?>(
                      future: _getThumbnail(videoPath),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            height: 80,
                            width: 80,
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }

                        if (snapshot.hasData) {
                          return Image.memory(
                            snapshot.data!,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          );
                        }

                        return Icon(
                          Icons.fitness_center,
                          size: 40,
                          color: AppColors.icon(context),
                        );
                      },
                    )
                  : Icon(
                      Icons.fitness_center,
                      size: 40,
                      color: AppColors.icon(context),
                    ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            model.displayName,
                            style: TextStyle(
                              color: AppColors.text(context),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Text(
                          //   "Focus Areas: $focusText",
                          //   style: TextStyle(
                          //     color: AppColors.subText(context),
                          //     fontSize: 12,
                          //   ),
                          //   maxLines: 2,
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VideoPage(exerciseId: model.id),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: AppColors.primary(context),
                        radius: 20,
                        child: Icon(
                          Icons.arrow_forward,
                          size: 20,
                          color: AppColors.buttonText(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoader() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _paginationLoader() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Text(message, style: const TextStyle(color: Colors.red)),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
