import 'dart:typed_data';

import 'package:fitness_workout_app/features/workout_tab/presentation/pages/workout_tab/video_widget_page/video_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../../../core/utils/api.dart';
import '../../../../../local_database/onboarding_storage.dart';
import '../../../../../theme/color/colors.dart';
import '../../../../exercises_tab/domain/model/exercise_model.dart';
import '../../../../exercises_tab/presentation/bloc/exercise_bloc.dart';
import '../exercise_counter_screen/exercise_counter_screen.dart';

class FocusAreaExerciseScreen extends StatefulWidget {
  final String focusAreaName;
  final String focusAreaImage;
  final int focusAreaId;

  const FocusAreaExerciseScreen({
    super.key,
    required this.focusAreaName,
    required this.focusAreaImage,
    required this.focusAreaId,
  });

  @override
  State<FocusAreaExerciseScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<FocusAreaExerciseScreen> {
  double _offset = 0.0;
  int lastCall = 0;
  bool headerCollapsed = false;
  final Map<String, Future<Uint8List?>> _thumbnailFutureCache = {};
  String _gender = "male";

  @override
  void initState() {
    super.initState();

    context.read<ExerciseBloc>().add(
      GetExercisesEvent(focusAreaId: widget.focusAreaId),
    );
    _loadGender();
  }

  Future<void> _loadGender() async {
    final gender = await OnboardingStorage.getString("gender");
    print("Saved gender from storage: $gender");

    if (gender != null) {
      setState(() {
        _gender = gender.toLowerCase();
        _thumbnailFutureCache.clear();
      });
      print("Gender applied in UI: $_gender");
    }
  }

  String getVideoPath(ExerciseModel model) {
    if (_gender == "female" && model.femaleVideoPath.isNotEmpty) {
      return model.femaleVideoPath;
    }
    return model.maleVideoPath;
  }

  Future<Uint8List?> _getThumbnail(ExerciseModel item) {
    final videoPath = getVideoPath(item);
    final cacheKey = "${item.id}_$_gender";

    if (_thumbnailFutureCache.containsKey(cacheKey)) {
      return _thumbnailFutureCache[cacheKey]!;
    }

    final future = VideoThumbnail.thumbnailData(
      video: "${Api.base}$videoPath",
      imageFormat: ImageFormat.PNG,
      maxWidth: 720,
      quality: 100,
    );

    _thumbnailFutureCache[cacheKey] = future;
    return future;
  }

  String parseHtmlString(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final double maxHeight = MediaQuery.of(context).size.height * 0.42;
    final double minHeight = kToolbarHeight + 30;

    return Scaffold(
      body: BlocBuilder<ExerciseBloc, ExerciseState>(
        builder: (context, state) {
          if (state is ExerciseLoading || state is ExerciseInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ExerciseError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: AppColors.text(context), fontSize: 20),
              ),
            );
          }
          if (state is ExerciseLoaded) {
            final exercise = state.exercises;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  children: [
                    NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification.metrics.axis == Axis.vertical) {
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

                                  image: DecorationImage(
                                    image: NetworkImage(widget.focusAreaImage),
                                    fit: BoxFit.cover,
                                    onError: (_, _) {},
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
                                            Colors.black.withValues(alpha: 0.8),
                                          ],
                                        ),
                                      ),
                                    ),

                                    SafeArea(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 8.0,
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
                                                onPressed: () => Navigator.pop(
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
                                                  width: 24,
                                                  height: 24,
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
                                        child: Text(
                                          widget.focusAreaName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 10),

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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          elevation: 0,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ExerciseCounterScreen(
                                                    focusAreaId:
                                                        widget.focusAreaId,
                                                    focusAreaName:
                                                        widget.focusAreaName,
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
                                              'Start Exercise',
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
                                    //   children: List.generate(exercise.length, (
                                    //     index,
                                    //   ) {
                                    //     final item = exercise[index];
                                    //     final videoPath = getVideoPath(item);
                                    //
                                    //     return Container(
                                    //       margin: const EdgeInsets.only(
                                    //         bottom: 14,
                                    //       ),
                                    //       decoration: BoxDecoration(
                                    //         color: AppColors.card(context),
                                    //         borderRadius: BorderRadius.circular(
                                    //           14,
                                    //         ),
                                    //         border: Border.all(
                                    //           color: AppColors.border(context),
                                    //         ),
                                    //       ),
                                    //       padding: const EdgeInsets.all(14),
                                    //       child: Row(
                                    //         children: [
                                    //           // Container(
                                    //           //   width: 80,
                                    //           //   height: 80,
                                    //           //   decoration: BoxDecoration(
                                    //           //     borderRadius:
                                    //           //         BorderRadius.circular(12),
                                    //           //     gradient: LinearGradient(
                                    //           //       colors: [
                                    //           //         AppColors.border(context),
                                    //           //         AppColors.card(context),
                                    //           //       ],
                                    //           //       begin: Alignment.topLeft,
                                    //           //       end: Alignment.bottomRight,
                                    //           //     ),
                                    //           //   ),
                                    //           //   child: Padding(
                                    //           //     padding: const EdgeInsets.all(
                                    //           //       6,
                                    //           //     ),
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
                                    //           ClipRRect(
                                    //             borderRadius:
                                    //                 BorderRadius.circular(10),
                                    //             child: Container(
                                    //               width: 80,
                                    //               height: 80,
                                    //               decoration: BoxDecoration(
                                    //                 borderRadius:
                                    //                     BorderRadius.circular(
                                    //                       12,
                                    //                     ),
                                    //                 gradient: LinearGradient(
                                    //                   colors: [
                                    //                     AppColors.border(
                                    //                       context,
                                    //                     ),
                                    //                     AppColors.card(context),
                                    //                   ],
                                    //                   begin: Alignment.topLeft,
                                    //                   end:
                                    //                       Alignment.bottomRight,
                                    //                 ),
                                    //               ),
                                    //
                                    //               // child: ClipRRect(
                                    //               //   borderRadius:
                                    //               //       BorderRadius.circular(12),
                                    //               //   child: Image.network(
                                    //               //     Api.base + item.imageUrl,
                                    //               //     fit: BoxFit.cover,
                                    //               //     errorBuilder: (_, _, _) =>
                                    //               //         const Icon(
                                    //               //           Icons
                                    //               //               .image_not_supported,
                                    //               //         ),
                                    //               //   ),
                                    //               // ),
                                    //               child: videoPath.isNotEmpty
                                    //                   ? FutureBuilder<
                                    //                       Uint8List?
                                    //                     >(
                                    //                       future: _getThumbnail(
                                    //                         item,
                                    //                       ),
                                    //                       builder: (context, snapshot) {
                                    //                         if (snapshot
                                    //                                 .connectionState ==
                                    //                             ConnectionState
                                    //                                 .waiting) {
                                    //                           return const Center(
                                    //                             child:
                                    //                                 CircularProgressIndicator(
                                    //                                   strokeWidth:
                                    //                                       2,
                                    //                                 ),
                                    //                           );
                                    //                         }
                                    //
                                    //                         if (snapshot
                                    //                             .hasData) {
                                    //                           return Image.memory(
                                    //                             snapshot.data!,
                                    //                             fit: BoxFit
                                    //                                 .cover,
                                    //                           );
                                    //                         }
                                    //
                                    //                         return const Icon(
                                    //                           Icons
                                    //                               .fitness_center,
                                    //                         );
                                    //                       },
                                    //                     )
                                    //                   : const Icon(
                                    //                       Icons.fitness_center,
                                    //                     ),
                                    //             ),
                                    //           ),
                                    //
                                    //           const SizedBox(width: 14),
                                    //
                                    //           Expanded(
                                    //             child: Column(
                                    //               crossAxisAlignment:
                                    //                   CrossAxisAlignment.start,
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
                                    //                                 ExerciseBloc
                                    //                               >()
                                    //                               .add(
                                    //                                 GetExercisesEvent(
                                    //                                   focusAreaId:
                                    //                                       widget
                                    //                                           .focusAreaId,
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
                                    //                 const SizedBox(height: 1),
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
                                    //                 //       margin: Margins.zero,
                                    //                 //       padding:
                                    //                 //           HtmlPaddings.zero,
                                    //                 //     ),
                                    //                 //   },
                                    //                 // ),
                                    //                 Text(
                                    //                   parseHtmlString(
                                    //                     item.description ?? "",
                                    //                   ),
                                    //                   maxLines: 3,
                                    //                   overflow:
                                    //                       TextOverflow.ellipsis,
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
                                    //         ],
                                    //       ),
                                    //     );
                                    //   }),
                                    // ),
                                    Column(
                                      children: List.generate(exercise.length, (
                                        index,
                                      ) {
                                        final item = exercise[index];
                                        final videoPath = getVideoPath(item);

                                        return Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            onTap: () async {
                                              final result =
                                                  await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => VideoPage(
                                                        exerciseId: item.id,
                                                      ),
                                                    ),
                                                  );

                                              if (result == true) {
                                                context
                                                    .read<ExerciseBloc>()
                                                    .add(
                                                      GetExercisesEvent(
                                                        focusAreaId:
                                                            widget.focusAreaId,
                                                      ),
                                                    );
                                              }
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 14,
                                              ),
                                              padding: const EdgeInsets.all(14),
                                              decoration: BoxDecoration(
                                                color: AppColors.card(context),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                border: Border.all(
                                                  color: AppColors.border(
                                                    context,
                                                  ),
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  // Thumbnail
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    child: Container(
                                                      width: 80,
                                                      height: 80,
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            AppColors.border(
                                                              context,
                                                            ),
                                                            AppColors.card(
                                                              context,
                                                            ),
                                                          ],
                                                          begin:
                                                              Alignment.topLeft,
                                                          end: Alignment
                                                              .bottomRight,
                                                        ),
                                                      ),
                                                      child:
                                                          videoPath.isNotEmpty
                                                          ? FutureBuilder<
                                                              Uint8List?
                                                            >(
                                                              future:
                                                                  _getThumbnail(
                                                                    item,
                                                                  ),
                                                              builder: (context, snapshot) {
                                                                if (snapshot
                                                                        .connectionState ==
                                                                    ConnectionState
                                                                        .waiting) {
                                                                  return const Center(
                                                                    child: CircularProgressIndicator(
                                                                      strokeWidth:
                                                                          2,
                                                                    ),
                                                                  );
                                                                }
                                                                if (snapshot
                                                                    .hasData) {
                                                                  return Image.memory(
                                                                    snapshot
                                                                        .data!,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  );
                                                                }
                                                                return const Icon(
                                                                  Icons
                                                                      .fitness_center,
                                                                );
                                                              },
                                                            )
                                                          : const Icon(
                                                              Icons
                                                                  .fitness_center,
                                                            ),
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
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Text(
                                                          parseHtmlString(
                                                            item.description ??
                                                                "",
                                                          ),
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            color:
                                                                AppColors.subText(
                                                                  context,
                                                                ),
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
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

                              // if (exercise.length <= 2)
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
                            widget.focusAreaName,
                            //  workout.data.displayName,
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
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
