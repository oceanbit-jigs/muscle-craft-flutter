import 'dart:typed_data';

import 'package:fitness_workout_app/features/workout_tab/presentation/bloc/dashboard_bloc.dart';
import 'package:fitness_workout_app/features/workout_tab/presentation/pages/workout_tab/video_widget_page/video_page.dart';
import 'package:fitness_workout_app/features/workout_tab/presentation/pages/workout_tab/workouts_counter_screen/workout_counter_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:html/parser.dart' as html_parser;

import '../../../../../core/utils/api.dart';
import '../../../../../local_database/onboarding_storage.dart';
import '../../../../../theme/color/colors.dart';
import '../../../domain/model/workout_details_model.dart';
import '../../../domain/model/workout_exercise_details_model.dart';

class WorkoutProgramDetailScreen extends StatefulWidget {
  // final String title;
  // final String image;
  // final String kcal;
  // final String duration;
  // final List<Exercise> exercises;
  final int workoutId;

  const WorkoutProgramDetailScreen({
    super.key,
    // required this.title,
    // required this.image,
    // required this.kcal,
    // required this.duration,
    // required this.exercises,
    required this.workoutId,
  });

  @override
  State<WorkoutProgramDetailScreen> createState() =>
      _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutProgramDetailScreen> {
  double _offset = 0.0;
  int lastCall = 0;
  bool headerCollapsed = false;
  String _gender = "male";
  final Map<String, Uint8List> _thumbnailCache = {};
  final Map<String, Future<Uint8List?>> _thumbnailFutureCache = {};

  @override
  void initState() {
    super.initState();
    _loadGender();
    final bloc = context.read<DashboardBloc>();
    bloc.add(FetchWorkoutDetailEvent(widget.workoutId));
  }

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

  String getVideoPath(WorkoutExercise model) {
    if (_gender == "female" && model.femaleVideoPath.isNotEmpty) {
      return model.femaleVideoPath;
    }
    return model.maleVideoPath;
  }

  String parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final double maxHeight = MediaQuery.of(context).size.height * 0.42;
    final double minHeight = kToolbarHeight + 30;

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is WorkoutDetailLoading || state is DashboardInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is WorkoutDetailError) {
          return Center(child: Text(state.message));
        }

        if (state is WorkoutDetailLoaded) {
          final workout = state.workoutDetail;

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) {
                Navigator.pop(context, true);
              }
            },
            child: Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Stack(
                    children: [
                      NotificationListener<ScrollNotification>(
                        onNotification: (scrollNotification) {
                          if (scrollNotification.metrics.axis ==
                              Axis.vertical) {
                            final newOffset = scrollNotification.metrics.pixels;

                            if (newOffset < _offset) {
                              headerCollapsed = false;
                            }

                            if (headerCollapsed && newOffset > _offset) {
                              return false;
                            }

                            setState(() {
                              _offset = newOffset;

                              if (_offset >= maxHeight - minHeight) {
                                _offset = maxHeight - minHeight;
                                headerCollapsed = true;
                              }
                            });
                          }
                          return true;
                        },

                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: (maxHeight - _offset).clamp(
                                    minHeight,
                                    maxHeight,
                                  ),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xff3B3B3B),
                                        Color(0xffA1A1A1),
                                      ],
                                    ),
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    ),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),

                                    // image: DecorationImage(
                                    //   image: AssetImage(widget.image),
                                    //   fit: BoxFit.cover,
                                    // ),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        Api.base + workout.data.imageUrl,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            bottomRight: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withValues(
                                                alpha: 0.8,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SafeArea(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 5,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: Colors.black45,
                                                radius: 20,
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.arrow_back_ios_new,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                  // onPressed: () =>
                                                  //     Navigator.pop(context),
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                        context,
                                                        true,
                                                      ),
                                                ),
                                              ),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(height: 15),
                                                  SvgPicture.asset(
                                                    'assets/workout/music.svg',
                                                    width: 28,
                                                    height: 28,
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                          Colors.white,
                                                          BlendMode.srcIn,
                                                        ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  SvgPicture.asset(
                                                    'assets/workout/like.svg',
                                                    width: 24,
                                                    height: 24,
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                          Colors.white,
                                                          BlendMode.srcIn,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        left: 15,
                                        child: Opacity(
                                          opacity:
                                              ((_offset < 100)
                                                      ? 1 - (_offset / 100)
                                                      : 0.0)
                                                  .clamp(0.0, 1.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                //widget.title,
                                                workout.data.displayName,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                // '${widget.kcal} kcal - ${widget.duration} mins',
                                                '${workout.data.kcalBurn} kcal - ${workout.data.timeInMin} mins',
                                                style: const TextStyle(
                                                  color: Color(0xffE9E9E9),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 10),

                                /// DOWN SCROLLABLE CONTAINER
                                // Container(
                                //   width: double.infinity,
                                //   decoration: BoxDecoration(
                                //     color: Colors.black,
                                //     borderRadius: const BorderRadius.only(
                                //       topLeft: Radius.circular(28),
                                //       topRight: Radius.circular(28),
                                //     ),
                                //     border: Border.all(color: Colors.grey, width: 1),
                                //   ),
                                //   padding: const EdgeInsets.symmetric(
                                //     horizontal: 20,
                                //     vertical: 24,
                                //   ),
                                //   child: Column(
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       SizedBox(
                                //         width: double.infinity,
                                //         height: 53,
                                //         child: ElevatedButton(
                                //           style: ElevatedButton.styleFrom(
                                //             backgroundColor: Colors.white,
                                //             shape: RoundedRectangleBorder(
                                //               borderRadius: BorderRadius.circular(30),
                                //             ),
                                //             elevation: 0,
                                //           ),
                                //           onPressed: () {},
                                //           child: const Row(
                                //             mainAxisSize: MainAxisSize.min,
                                //             mainAxisAlignment: MainAxisAlignment.center,
                                //             children: [
                                //               Icon(
                                //                 Icons.play_arrow,
                                //                 color: Colors.black,
                                //                 size: 24,
                                //               ),
                                //               SizedBox(width: 8),
                                //               Text(
                                //                 'Start Workout',
                                //                 style: TextStyle(
                                //                   color: Colors.black,
                                //                   fontSize: 19,
                                //                   fontWeight: FontWeight.w700,
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //       const SizedBox(height: 26),
                                //       const Text(
                                //         'Overview',
                                //         style: TextStyle(
                                //           color: Colors.white,
                                //           fontSize: 20,
                                //           fontWeight: FontWeight.w700,
                                //         ),
                                //       ),
                                //       const SizedBox(height: 16),
                                //       Column(
                                //         children: List.generate(workouts.length, (index) {
                                //           final item = workouts[index];
                                //
                                //           return Container(
                                //             margin: const EdgeInsets.only(bottom: 14),
                                //             decoration: BoxDecoration(
                                //               color: const Color(0xFF1C1C1C),
                                //               borderRadius: BorderRadius.circular(14),
                                //             ),
                                //             padding: const EdgeInsets.all(14),
                                //             child: Row(
                                //               children: [
                                //                 Container(
                                //                   width: 80,
                                //                   height: 80,
                                //                   decoration: BoxDecoration(
                                //                     borderRadius: BorderRadius.circular(
                                //                       12,
                                //                     ),
                                //                     gradient: const LinearGradient(
                                //                       colors: [
                                //                         Color(0xFF5D5D5D),
                                //                         Color(0xFF2D2D2D),
                                //                       ],
                                //                       begin: Alignment.topLeft,
                                //                       end: Alignment.bottomRight,
                                //                     ),
                                //                   ),
                                //                   child: Padding(
                                //                     padding: const EdgeInsets.all(6),
                                //                     child: Image.asset(
                                //                       item["image"],
                                //                       fit: BoxFit.contain,
                                //                     ),
                                //                   ),
                                //                 ),
                                //                 const SizedBox(width: 14),
                                //                 Expanded(
                                //                   child: Column(
                                //                     crossAxisAlignment:
                                //                         CrossAxisAlignment.start,
                                //                     children: [
                                //                       Text(
                                //                         item["title"],
                                //                         style: const TextStyle(
                                //                           color: Colors.white,
                                //                           fontSize: 15,
                                //                           fontWeight: FontWeight.w600,
                                //                         ),
                                //                       ),
                                //                       const SizedBox(height: 6),
                                //                       Row(
                                //                         children: [
                                //                           SvgPicture.asset(
                                //                             'assets/workout/timer.svg',
                                //                             width: 20,
                                //                             height: 20,
                                //                             colorFilter:
                                //                                 const ColorFilter.mode(
                                //                                   Colors.grey,
                                //                                   BlendMode.srcIn,
                                //                                 ),
                                //                           ),
                                //                           const SizedBox(width: 6),
                                //                           Text(
                                //                             item["time"],
                                //                             style: const TextStyle(
                                //                               color: Colors.white70,
                                //                               fontSize: 14,
                                //                               fontWeight: FontWeight.w500,
                                //                             ),
                                //                           ),
                                //                         ],
                                //                       ),
                                //                     ],
                                //                   ),
                                //                 ),
                                //                 GestureDetector(
                                //                   onTap: () {
                                //                     Navigator.push(
                                //                       context,
                                //                       MaterialPageRoute(
                                //                         builder: (context) => VideoPage(
                                //                           title: item["title"],
                                //                         ),
                                //                       ),
                                //                     );
                                //                   },
                                //                   child: const CircleAvatar(
                                //                     backgroundColor: Colors.white,
                                //                     radius: 20,
                                //                     child: Icon(
                                //                       Icons.arrow_forward,
                                //                       size: 20,
                                //                       color: Colors.black,
                                //                     ),
                                //                   ),
                                //                 ),
                                //               ],
                                //             ),
                                //           );
                                //         }),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.card(context),
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(28),
                                      topRight: Radius.circular(28),
                                    ),
                                    border: Border.all(
                                      color: AppColors.border(context),
                                      width: 1,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 24,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        height: 53,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary(
                                              context,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            elevation: 0,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    WorkoutCounterScreen(
                                                      workoutId:
                                                          workout.data.id,
                                                      workoutName: workout
                                                          .data
                                                          .displayName,
                                                    ),
                                              ),
                                            );
                                          },

                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.play_arrow,
                                                color: AppColors.buttonText(
                                                  context,
                                                ),
                                                size: 24,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Start Workout',
                                                style: TextStyle(
                                                  color: AppColors.buttonText(
                                                    context,
                                                  ),
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 26),
                                      Text(
                                        'Overview',
                                        style: TextStyle(
                                          color: AppColors.text(context),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // Column(
                                      //   children: List.generate(workout.data.exercises.length, (
                                      //     index,
                                      //   ) {
                                      //     //final item = widget.exercises[index];
                                      //     final item =
                                      //         workout.data.exercises[index];
                                      //     final videoPath = getVideoPath(item);
                                      //     return Container(
                                      //       margin: const EdgeInsets.only(
                                      //         bottom: 14,
                                      //       ),
                                      //       decoration: BoxDecoration(
                                      //         color: AppColors.card(context),
                                      //         borderRadius:
                                      //             BorderRadius.circular(14),
                                      //         border: Border.all(
                                      //           color: AppColors.border(
                                      //             context,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       padding: const EdgeInsets.all(14),
                                      //       child: Row(
                                      //         mainAxisAlignment:
                                      //             MainAxisAlignment.start,
                                      //         crossAxisAlignment:
                                      //             CrossAxisAlignment.start,
                                      //         children: [
                                      //           // Container(
                                      //           //   width: 80,
                                      //           //   height: 80,
                                      //           //   decoration: BoxDecoration(
                                      //           //     borderRadius:
                                      //           //         BorderRadius.circular(
                                      //           //           12,
                                      //           //         ),
                                      //           //     gradient: LinearGradient(
                                      //           //       colors: [
                                      //           //         AppColors.border(
                                      //           //           context,
                                      //           //         ),
                                      //           //         AppColors.card(context),
                                      //           //       ],
                                      //           //       begin: Alignment.topLeft,
                                      //           //       end:
                                      //           //           Alignment.bottomRight,
                                      //           //     ),
                                      //           //   ),
                                      //           //   child: Padding(
                                      //           //     padding:
                                      //           //         const EdgeInsets.all(6),
                                      //           //     child:
                                      //           //         // Image.asset(
                                      //           //         //   item["image"],
                                      //           //         //   fit: BoxFit.contain,
                                      //           //         // ),
                                      //           //         Image.network(
                                      //           //           Api.base +
                                      //           //               item.imageUrl,
                                      //           //           fit: BoxFit.contain,
                                      //           //           errorBuilder:
                                      //           //               (
                                      //           //                 context,
                                      //           //                 error,
                                      //           //                 stackTrace,
                                      //           //               ) {
                                      //           //                 return const Icon(
                                      //           //                   Icons
                                      //           //                       .image_not_supported,
                                      //           //                 );
                                      //           //               },
                                      //           //         ),
                                      //           //   ),
                                      //           // ),
                                      //           Container(
                                      //             width: 80,
                                      //             height: 80,
                                      //             decoration: BoxDecoration(
                                      //               borderRadius:
                                      //                   BorderRadius.circular(
                                      //                     12,
                                      //                   ),
                                      //               color: Colors.black12,
                                      //             ),
                                      //             clipBehavior: Clip.antiAlias,
                                      //             child: FutureBuilder<Uint8List?>(
                                      //               future: _getThumbnail(
                                      //                 getVideoPath(item),
                                      //               ),
                                      //               builder: (context, snapshot) {
                                      //                 if (snapshot
                                      //                         .connectionState ==
                                      //                     ConnectionState
                                      //                         .waiting) {
                                      //                   return const Center(
                                      //                     child:
                                      //                         CircularProgressIndicator(
                                      //                           strokeWidth: 2,
                                      //                         ),
                                      //                   );
                                      //                 }
                                      //
                                      //                 if (snapshot.hasData &&
                                      //                     snapshot.data !=
                                      //                         null) {
                                      //                   return Image.memory(
                                      //                     snapshot.data!,
                                      //                     fit: BoxFit.cover,
                                      //                   );
                                      //                 }
                                      //
                                      //                 return const Icon(
                                      //                   Icons
                                      //                       .play_circle_outline,
                                      //                   size: 40,
                                      //                   color: Colors.grey,
                                      //                 );
                                      //               },
                                      //             ),
                                      //           ),
                                      //
                                      //           const SizedBox(width: 14),
                                      //
                                      //           // Expanded(
                                      //           //   child: Column(
                                      //           //     crossAxisAlignment:
                                      //           //         CrossAxisAlignment
                                      //           //             .start,
                                      //           //     children: [
                                      //           //       Text(
                                      //           //         //item["title"],
                                      //           //         item.displayName,
                                      //           //
                                      //           //         style: TextStyle(
                                      //           //           color: AppColors.text(
                                      //           //             context,
                                      //           //           ),
                                      //           //           fontSize: 15,
                                      //           //           fontWeight:
                                      //           //               FontWeight.w600,
                                      //           //         ),
                                      //           //       ),
                                      //           //       const SizedBox(height: 6),
                                      //           //       Row(
                                      //           //         children: [
                                      //           //           // SvgPicture.asset(
                                      //           //           //   'assets/workout/timer.svg',
                                      //           //           //   width: 20,
                                      //           //           //   height: 20,
                                      //           //           //   colorFilter:
                                      //           //           //       ColorFilter.mode(
                                      //           //           //         AppColors.subText(
                                      //           //           //           context,
                                      //           //           //         ),
                                      //           //           //         BlendMode
                                      //           //           //             .srcIn,
                                      //           //           //       ),
                                      //           //           // ),
                                      //           //           // const SizedBox(
                                      //           //           //   width: 6,
                                      //           //           // ),
                                      //           //
                                      //           //           // Text(
                                      //           //           //   // item["time"],
                                      //           //           //   item.preparationText ??
                                      //           //           //       "",
                                      //           //           //   style: TextStyle(
                                      //           //           //     color:
                                      //           //           //         AppColors.subText(
                                      //           //           //           context,
                                      //           //           //         ),
                                      //           //           //     fontSize: 14,
                                      //           //           //     fontWeight:
                                      //           //           //         FontWeight
                                      //           //           //             .w500,
                                      //           //           //   ),
                                      //           //           // ),
                                      //           //           Html(
                                      //           //             data:
                                      //           //                 item.preparationText ??
                                      //           //                 "",
                                      //           //             style: {
                                      //           //               "body": Style(
                                      //           //                 color:
                                      //           //                     AppColors.subText(
                                      //           //                       context,
                                      //           //                     ),
                                      //           //                 fontSize:
                                      //           //                     FontSize(
                                      //           //                       14,
                                      //           //                     ),
                                      //           //                 fontWeight:
                                      //           //                     FontWeight
                                      //           //                         .w500,
                                      //           //                 margin: Margins
                                      //           //                     .zero,
                                      //           //                 padding:
                                      //           //                     HtmlPaddings
                                      //           //                         .zero,
                                      //           //               ),
                                      //           //             },
                                      //           //           ),
                                      //           //         ],
                                      //           //       ),
                                      //           //     ],
                                      //           //   ),
                                      //           // ),
                                      //           Expanded(
                                      //             child: Column(
                                      //               crossAxisAlignment:
                                      //                   CrossAxisAlignment
                                      //                       .start,
                                      //               children: [
                                      //                 Row(
                                      //                   crossAxisAlignment:
                                      //                       CrossAxisAlignment
                                      //                           .start,
                                      //                   children: [
                                      //                     Expanded(
                                      //                       child: Text(
                                      //                         item.displayName,
                                      //                         style: TextStyle(
                                      //                           color:
                                      //                               AppColors.text(
                                      //                                 context,
                                      //                               ),
                                      //                           fontSize: 15,
                                      //                           fontWeight:
                                      //                               FontWeight
                                      //                                   .w600,
                                      //                         ),
                                      //                       ),
                                      //                     ),
                                      //
                                      //                     GestureDetector(
                                      //                       onTap: () async {
                                      //                         final result = await Navigator.push(
                                      //                           context,
                                      //                           MaterialPageRoute(
                                      //                             builder: (_) =>
                                      //                                 VideoPage(
                                      //                                   exerciseId:
                                      //                                       item.id,
                                      //                                 ),
                                      //                           ),
                                      //                         );
                                      //
                                      //                         if (result ==
                                      //                             true) {
                                      //                           context
                                      //                               .read<
                                      //                                 DashboardBloc
                                      //                               >()
                                      //                               .add(
                                      //                                 FetchWorkoutDetailEvent(
                                      //                                   widget
                                      //                                       .workoutId,
                                      //                                 ),
                                      //                               );
                                      //                         }
                                      //                       },
                                      //                       child: CircleAvatar(
                                      //                         backgroundColor:
                                      //                             AppColors.primary(
                                      //                               context,
                                      //                             ),
                                      //                         radius: 18,
                                      //                         child: Icon(
                                      //                           Icons
                                      //                               .arrow_forward,
                                      //                           size: 18,
                                      //                           color:
                                      //                               AppColors.buttonText(
                                      //                                 context,
                                      //                               ),
                                      //                         ),
                                      //                       ),
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //
                                      //                 const SizedBox(height: 6),
                                      //
                                      //                 // Html(
                                      //                 //   data:
                                      //                 //       item.description ??
                                      //                 //       "",
                                      //                 //   style: {
                                      //                 //     "body": Style(
                                      //                 //       color:
                                      //                 //           AppColors.subText(
                                      //                 //             context,
                                      //                 //           ),
                                      //                 //       fontSize: FontSize(
                                      //                 //         14,
                                      //                 //       ),
                                      //                 //       fontWeight:
                                      //                 //           FontWeight.w500,
                                      //                 //       margin:
                                      //                 //           Margins.zero,
                                      //                 //       padding:
                                      //                 //           HtmlPaddings
                                      //                 //               .zero,
                                      //                 //     ),
                                      //                 //   },
                                      //                 // ),
                                      //                 Text(
                                      //                   parseHtmlString(
                                      //                     item.description ??
                                      //                         "",
                                      //                   ),
                                      //                   maxLines: 3,
                                      //                   overflow: TextOverflow
                                      //                       .ellipsis,
                                      //                   style: TextStyle(
                                      //                     color:
                                      //                         AppColors.subText(
                                      //                           context,
                                      //                         ),
                                      //                     fontSize: 14,
                                      //                     fontWeight:
                                      //                         FontWeight.w500,
                                      //                   ),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //           ),
                                      //
                                      //           // GestureDetector(
                                      //           //   onTap: () async {
                                      //           //     final videoUrl =
                                      //           //         Api.base +
                                      //           //         item.maleVideoPath;
                                      //           //     // Navigator.push(
                                      //           //     //   context,
                                      //           //     //   MaterialPageRoute(
                                      //           //     //     builder: (context) => VideoPage(
                                      //           //     //       // title: item["title"],
                                      //           //     //       // title: item
                                      //           //     //       //     .displayName,
                                      //           //     //       // videoUrl: videoUrl,
                                      //           //     //       exerciseId: item.id,
                                      //           //     //     ),
                                      //           //     //   ),
                                      //           //     // );
                                      //           //
                                      //           //     final result =
                                      //           //         await Navigator.push(
                                      //           //           context,
                                      //           //           MaterialPageRoute(
                                      //           //             builder: (_) =>
                                      //           //                 VideoPage(
                                      //           //                   exerciseId:
                                      //           //                       item.id,
                                      //           //                 ),
                                      //           //           ),
                                      //           //         );
                                      //           //
                                      //           //     if (result == true) {
                                      //           //       context
                                      //           //           .read<DashboardBloc>()
                                      //           //           .add(
                                      //           //             FetchWorkoutDetailEvent(
                                      //           //               widget.workoutId,
                                      //           //             ),
                                      //           //           );
                                      //           //     }
                                      //           //   },
                                      //           //   child: CircleAvatar(
                                      //           //     backgroundColor:
                                      //           //         AppColors.primary(
                                      //           //           context,
                                      //           //         ),
                                      //           //     radius: 20,
                                      //           //     child: Icon(
                                      //           //       Icons.arrow_forward,
                                      //           //       size: 20,
                                      //           //       color:
                                      //           //           AppColors.buttonText(
                                      //           //             context,
                                      //           //           ),
                                      //           //     ),
                                      //           //   ),
                                      //           // ),
                                      //         ],
                                      //       ),
                                      //     );
                                      //   }),
                                      // ),
                                      Column(
                                        children: List.generate(workout.data.exercises.length, (
                                          index,
                                        ) {
                                          final item =
                                              workout.data.exercises[index];
                                          final videoPath = getVideoPath(item);

                                          return Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              onTap: () async {
                                                final result =
                                                    await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            VideoPage(
                                                              exerciseId:
                                                                  item.id,
                                                            ),
                                                      ),
                                                    );

                                                if (result == true) {
                                                  context
                                                      .read<DashboardBloc>()
                                                      .add(
                                                        FetchWorkoutDetailEvent(
                                                          widget.workoutId,
                                                        ),
                                                      );
                                                }
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  bottom: 14,
                                                ),
                                                padding: const EdgeInsets.all(
                                                  14,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.card(
                                                    context,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  border: Border.all(
                                                    color: AppColors.border(
                                                      context,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Thumbnail
                                                    Container(
                                                      width: 80,
                                                      height: 80,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        color: Colors.black12,
                                                      ),
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      child: FutureBuilder<Uint8List?>(
                                                        future: _getThumbnail(
                                                          videoPath,
                                                        ),
                                                        builder: (context, snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                  ),
                                                            );
                                                          }

                                                          if (snapshot
                                                                  .hasData &&
                                                              snapshot.data !=
                                                                  null) {
                                                            return Image.memory(
                                                              snapshot.data!,
                                                              fit: BoxFit.cover,
                                                            );
                                                          }

                                                          return const Icon(
                                                            Icons
                                                                .play_circle_outline,
                                                            size: 40,
                                                            color: Colors.grey,
                                                          );
                                                        },
                                                      ),
                                                    ),

                                                    const SizedBox(width: 14),

                                                    // Text content
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            item.displayName,
                                                            style: TextStyle(
                                                              color:
                                                                  AppColors.text(
                                                                    context,
                                                                  ),
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 6,
                                                          ),
                                                          Text(
                                                            parseHtmlString(
                                                              item.description ??
                                                                  "",
                                                            ),
                                                            maxLines: 3,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              color:
                                                                  AppColors.subText(
                                                                    context,
                                                                  ),
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ),

                                // if (workout.data.exercises.length <= 1 ||
                                //     workout.data.exercises.length <= 2)
                                Transform.translate(
                                  offset: const Offset(0, -1),
                                  transformHitTests: true,
                                  child: Container(
                                    width: double.infinity,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: AppColors.card(context),
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(28),
                                        bottomRight: Radius.circular(28),
                                      ),

                                      // border: Border.all(
                                      //   color: AppColors.border(context),
                                      //   width: 1,
                                      // ),
                                      border: Border(
                                        left: BorderSide(
                                          color: AppColors.border(context),
                                          width: 1,
                                        ),
                                        right: BorderSide(
                                          color: AppColors.border(context),
                                          width: 1,
                                        ),
                                        bottom: BorderSide(
                                          color: AppColors.border(context),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ),

                      if (_offset > 120)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: AppBar(
                            backgroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.black.withValues(alpha: 1)
                                : Colors.white.withValues(alpha: 1),
                            title: Text(
                              // widget.title,
                              workout.data.displayName,
                              style: TextStyle(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            //centerTitle: true,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );

    // return Scaffold(
    //   body: CustomScrollView(
    //     slivers: [
    //       SliverPersistentHeader(
    //         pinned: true,
    //         delegate: _WorkoutHeaderDelegate(
    //           maxHeight: MediaQuery.of(context).size.height * 0.42,
    //           minHeight: kToolbarHeight + 30,
    //           title: widget.title,
    //           image: widget.image,
    //           kcal: widget.kcal,
    //           duration: widget.duration,
    //           showCollapsedTitle: true, // new flag
    //         ),
    //       ),
    //
    //       SliverToBoxAdapter(
    //         child: Padding(
    //           padding: const EdgeInsets.all(10.0), // padding from all sides
    //           child: Column(
    //             children: [
    //               // Lower container with border & padding intact
    //               Container(
    //                 width: double.infinity,
    //                 decoration: BoxDecoration(
    //                   color: AppColors.card(context),
    //                   borderRadius: const BorderRadius.only(
    //                     topLeft: Radius.circular(28),
    //                     topRight: Radius.circular(28),
    //                   ),
    //                   border: Border.all(
    //                     color: AppColors.border(context),
    //                     width: 1,
    //                   ),
    //                 ),
    //                 padding: const EdgeInsets.symmetric(
    //                   horizontal: 20,
    //                   vertical: 24,
    //                 ),
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     SizedBox(
    //                       width: double.infinity,
    //                       height: 53,
    //                       child: ElevatedButton(
    //                         style: ElevatedButton.styleFrom(
    //                           backgroundColor: AppColors.primary(context),
    //                           shape: RoundedRectangleBorder(
    //                             borderRadius: BorderRadius.circular(30),
    //                           ),
    //                           elevation: 0,
    //                         ),
    //                         onPressed: () {},
    //                         child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: [
    //                             Icon(
    //                               Icons.play_arrow,
    //                               color: AppColors.buttonText(context),
    //                             ),
    //                             const SizedBox(width: 8),
    //                             Text(
    //                               'Start Workout',
    //                               style: TextStyle(
    //                                 color: AppColors.buttonText(context),
    //                                 fontSize: 19,
    //                                 fontWeight: FontWeight.w700,
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                     const SizedBox(height: 26),
    //                     Text(
    //                       'Overview',
    //                       style: TextStyle(
    //                         color: AppColors.text(context),
    //                         fontSize: 20,
    //                         fontWeight: FontWeight.w700,
    //                       ),
    //                     ),
    //                     const SizedBox(height: 16),
    //                     Column(
    //                       children: List.generate(widget.exercises.length, (
    //                         index,
    //                       ) {
    //                         final item = widget.exercises[index];
    //                         return Container(
    //                           margin: const EdgeInsets.only(bottom: 14),
    //                           decoration: BoxDecoration(
    //                             color: AppColors.card(context),
    //                             borderRadius: BorderRadius.circular(14),
    //                             border: Border.all(
    //                               color: AppColors.border(context),
    //                             ),
    //                           ),
    //                           padding: const EdgeInsets.all(14),
    //                           child: Row(
    //                             children: [
    //                               Container(
    //                                 width: 80,
    //                                 height: 80,
    //                                 decoration: BoxDecoration(
    //                                   borderRadius: BorderRadius.circular(12),
    //                                   gradient: LinearGradient(
    //                                     colors: [
    //                                       AppColors.border(context),
    //                                       AppColors.card(context),
    //                                     ],
    //                                     begin: Alignment.topLeft,
    //                                     end: Alignment.bottomRight,
    //                                   ),
    //                                 ),
    //                                 child: Padding(
    //                                   padding: const EdgeInsets.all(6),
    //                                   child: Image.network(
    //                                     Api.base + item.imageUrl,
    //                                     fit: BoxFit.contain,
    //                                     errorBuilder:
    //                                         (context, error, stackTrace) {
    //                                           return const Icon(
    //                                             Icons.image_not_supported,
    //                                           );
    //                                         },
    //                                   ),
    //                                 ),
    //                               ),
    //                               const SizedBox(width: 14),
    //                               Expanded(
    //                                 child: Column(
    //                                   crossAxisAlignment:
    //                                       CrossAxisAlignment.start,
    //                                   children: [
    //                                     Text(
    //                                       item.displayName,
    //                                       style: TextStyle(
    //                                         color: AppColors.text(context),
    //                                         fontSize: 15,
    //                                         fontWeight: FontWeight.w600,
    //                                       ),
    //                                     ),
    //                                     const SizedBox(height: 6),
    //                                     Row(
    //                                       children: [
    //                                         SvgPicture.asset(
    //                                           'assets/workout/timer.svg',
    //                                           width: 20,
    //                                           height: 20,
    //                                           colorFilter: ColorFilter.mode(
    //                                             AppColors.subText(context),
    //                                             BlendMode.srcIn,
    //                                           ),
    //                                         ),
    //                                         const SizedBox(width: 6),
    //                                         Text(
    //                                           item.preparationText ?? "",
    //                                           style: TextStyle(
    //                                             color: AppColors.subText(
    //                                               context,
    //                                             ),
    //                                             fontSize: 14,
    //                                             fontWeight: FontWeight.w500,
    //                                           ),
    //                                         ),
    //                                       ],
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                               GestureDetector(
    //                                 onTap: () {
    //                                   final videoUrl =
    //                                       Api.base + item.maleVideoPath;
    //                                   Navigator.push(
    //                                     context,
    //                                     MaterialPageRoute(
    //                                       builder: (context) => VideoPage(
    //                                         title: item.displayName,
    //                                         videoUrl: videoUrl,
    //                                       ),
    //                                     ),
    //                                   );
    //                                 },
    //                                 child: CircleAvatar(
    //                                   backgroundColor: AppColors.primary(
    //                                     context,
    //                                   ),
    //                                   radius: 20,
    //                                   child: Icon(
    //                                     Icons.arrow_forward,
    //                                     size: 20,
    //                                     color: AppColors.buttonText(context),
    //                                   ),
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         );
    //                       }),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               const SizedBox(height: 20),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  // Widget _buildExerciseItem(Exercise item, BuildContext context) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 14),
  //     decoration: BoxDecoration(
  //       color: AppColors.card(context),
  //       borderRadius: BorderRadius.circular(14),
  //       border: Border.all(color: AppColors.border(context)),
  //     ),
  //     padding: const EdgeInsets.all(14),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: 80,
  //           height: 80,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(12),
  //             gradient: LinearGradient(
  //               colors: [AppColors.border(context), AppColors.card(context)],
  //               begin: Alignment.topLeft,
  //               end: Alignment.bottomRight,
  //             ),
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.all(6),
  //             child: Image.network(
  //               Api.base + item.imageUrl,
  //               fit: BoxFit.contain,
  //               errorBuilder: (_, __, ___) =>
  //                   const Icon(Icons.image_not_supported),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(width: 14),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 item.displayName,
  //                 style: TextStyle(
  //                   color: AppColors.text(context),
  //                   fontSize: 15,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //               const SizedBox(height: 6),
  //               Row(
  //                 children: [
  //                   SvgPicture.asset(
  //                     'assets/workout/timer.svg',
  //                     width: 20,
  //                     height: 20,
  //                     colorFilter: ColorFilter.mode(
  //                       AppColors.subText(context),
  //                       BlendMode.srcIn,
  //                     ),
  //                   ),
  //                   const SizedBox(width: 6),
  //                   Expanded(
  //                     child: Text(
  //                       item.preparationText,
  //                       style: TextStyle(
  //                         color: AppColors.subText(context),
  //                         fontSize: 14,
  //                         fontWeight: FontWeight.w500,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //         GestureDetector(
  //           onTap: () {
  //             final videoUrl = Api.base + item.maleVideoPath;
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) =>
  //                     VideoPage(title: item.displayName, videoUrl: videoUrl),
  //               ),
  //             );
  //           },
  //           child: CircleAvatar(
  //             backgroundColor: AppColors.primary(context),
  //             radius: 20,
  //             child: Icon(
  //               Icons.arrow_forward,
  //               size: 20,
  //               color: AppColors.buttonText(context),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class _WorkoutHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double maxHeight;
  final double minHeight;
  final String title;
  final String image;
  final String kcal;
  final String duration;
  final bool showCollapsedTitle;

  _WorkoutHeaderDelegate({
    required this.maxHeight,
    required this.minHeight,
    required this.title,
    required this.image,
    required this.kcal,
    required this.duration,
    required this.showCollapsedTitle,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double top = (maxHeight - shrinkOffset).clamp(minHeight, maxHeight);
    final bool collapsed = shrinkOffset > (maxHeight - minHeight - 10);

    return Padding(
      padding: const EdgeInsets.all(10.0), // padding from all sides
      child: Stack(
        children: [
          // Upper container
          Container(
            height: top,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff3B3B3B), Color(0xffA1A1A1)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey, width: 1),
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: top,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
              ),
            ),
          ),

          // Back button & top icons
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black45,
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/workout/music.svg',
                      width: 28,
                      height: 28,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SvgPicture.asset(
                      'assets/workout/like.svg',
                      width: 24,
                      height: 24,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Title + kcal/duration at bottom (fade out when collapsed)
          Positioned(
            bottom: 10,
            left: 15,
            child: Opacity(
              opacity: collapsed
                  ? 0.0
                  : ((100 - shrinkOffset) / 100).clamp(0.0, 1.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$kcal kcal - $duration mins',
                    style: const TextStyle(
                      color: Color(0xffE9E9E9),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Collapsed title on top AppBar
          if (showCollapsedTitle)
            Positioned(
              top: 10,
              left: 50,
              child: Opacity(
                opacity: collapsed ? 1.0 : 0.0,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
