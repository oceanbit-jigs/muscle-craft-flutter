import 'package:fitness_workout_app/core/utils/api.dart';
import 'package:fitness_workout_app/features/workout_tab/presentation/pages/workout_tab/see_all_programs_screen.dart';
import 'package:fitness_workout_app/features/workout_tab/presentation/pages/workout_tab/workout_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../theme/color/colors.dart';
import '../../bloc/dashboard_bloc.dart';
import 'focus_area_exercise_screen.dart';

class ProgramsScreen extends StatefulWidget {
  const ProgramsScreen({super.key});

  @override
  State<ProgramsScreen> createState() => _ProgramsScreenState();
}

class _ProgramsScreenState extends State<ProgramsScreen> {
  // void initState() {
  //   super.initState();
  //   context.read<DashboardBloc>().add(const FetchDashboardEvent());
  // }
  @override
  void initState() {
    super.initState();
    final bloc = context.read<DashboardBloc>();
    if (bloc.state is! DashboardLoaded) {
      bloc.add(const FetchDashboardEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text(
            'Workout',
            style: TextStyle(
              // color: Theme.of(context).colorScheme.onBackground,
              color: AppColors.text(context),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Focus Areas',
                style: TextStyle(
                  //color: Colors.white,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),

              BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  if (state is DashboardLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DashboardError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (state is DashboardLoaded) {
                    final focusAreas = state.dashboard.data.focusAreas;

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: focusAreas.map((area) {
                          debugPrint("full url : ${Api.base}${area.imageUrl}");
                          final image =
                              area.imageUrl != null && area.imageUrl!.isNotEmpty
                              ? Api.base + area.imageUrl!
                              : "assets/program/shoulders.png";
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () async {
                                final dashboardBloc = context
                                    .read<DashboardBloc>();

                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FocusAreaExerciseScreen(
                                      focusAreaName: area.displayName,
                                      focusAreaImage: image,
                                      focusAreaId: area.id,
                                    ),
                                  ),
                                );

                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (_) => FocusAreaExerciseScreen(
                                //       focusAreaName: area.displayName,
                                //       focusAreaImage: image,
                                //       focusAreaId: area.id,
                                //     ),
                                //   ),
                                // );

                                if (result == true) {
                                  dashboardBloc.add(
                                    const FetchDashboardEvent(),
                                  );
                                }
                              },
                              child: _buildTargetCard(area.displayName, image),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),

              const SizedBox(height: 10),

              // ...categories.map((category) {
              //   final programs =
              //       category['programs'] as List<Map<String, String>>;
              //   return Padding(
              //     padding: const EdgeInsets.only(top: 10),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               (category['title'] as String),
              //               style: TextStyle(
              //                 // color: Colors.white,
              //                 color: Theme.of(context).colorScheme.onBackground,
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.w700,
              //               ),
              //             ),
              //             GestureDetector(
              //               onTap: () {
              //                 Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                     builder: (_) => SeeAllProgramsScreen(
              //                       title: category['title'] as String,
              //                       programs: programs,
              //                     ),
              //                   ),
              //                 );
              //               },
              //               child: Text(
              //                 'See all',
              //                 style: TextStyle(
              //                   //  color: Colors.white54,
              //                   color: Theme.of(context).colorScheme.onBackground,
              //                   fontSize: 14,
              //                   fontWeight: FontWeight.w500,
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //         const SizedBox(height: 12),
              //
              //         SizedBox(
              //           height: 180,
              //           child: ListView.separated(
              //             scrollDirection: Axis.horizontal,
              //             itemCount: programs.length,
              //             separatorBuilder: (_, _) => const SizedBox(width: 14),
              //             itemBuilder: (context, i) {
              //               final program = programs[i];
              //               return _buildProgramCard(
              //                 context,
              //                 program,
              //                 onTap: () {
              //                   Navigator.push(
              //                     context,
              //                     MaterialPageRoute(
              //                       builder: (_) => WorkoutProgramDetailScreen(
              //                         title: program['title']!,
              //                         image: program['image']!,
              //                         kcal: program['kcal']!,
              //                         duration: program['time']!,
              //                       ),
              //                     ),
              //                   );
              //                 },
              //               );
              //             },
              //           ),
              //         ),
              //         SizedBox(height: 20),
              //       ],
              //     ),
              //   );
              // }),
              BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  if (state is DashboardError) {
                    return Text(state.message);
                  }

                  if (state is DashboardLoaded) {
                    final categories = state.dashboard.data.categories;

                    return Column(
                      children: categories.map((category) {
                        final programs = category.workouts;

                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      category.displayName,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final dashboardBloc = context
                                          .read<DashboardBloc>();

                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => SeeAllProgramsScreen(
                                            title: category.displayName,
                                            categoryId: category.id,
                                            // programs: programs,
                                          ),
                                        ),
                                      );

                                      if (result == true) {
                                        dashboardBloc.add(
                                          const FetchDashboardEvent(),
                                        );
                                      }
                                    },
                                    child: Text(
                                      'See all',
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              SizedBox(
                                height: 180,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: programs.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(width: 14),
                                  itemBuilder: (context, i) {
                                    final program = programs[i];

                                    final imageUrl =
                                        Api.base + program.imageUrl;

                                    return _buildProgramCard(
                                      context,
                                      {
                                        'image': imageUrl,
                                        'title': program.displayName,
                                        'kcal': "${program.kcalBurn} kcal",
                                        'time': "${program.timeInMin} mins",
                                      },
                                      onTap: () async {
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (_) => WorkoutProgramDetailScreen(
                                        //       // title: program.displayName,
                                        //       // image: imageUrl,
                                        //       // kcal:
                                        //       //     "${program.kcalBurn} kcal",
                                        //       // duration:
                                        //       //     "${program.timeInMin} mins",
                                        //       // exercises: program.exercises,
                                        //       workoutId: program.id,
                                        //     ),
                                        //   ),
                                        // );

                                        final dashboardBloc = context
                                            .read<DashboardBloc>();

                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                WorkoutProgramDetailScreen(
                                                  workoutId: program.id,
                                                ),
                                          ),
                                        );

                                        if (result == true) {
                                          dashboardBloc.add(
                                            const FetchDashboardEvent(),
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildTargetCard(String title, String imagePath) {
  //   return Container(
  //     width: 120,
  //     height: 140,
  //     decoration: BoxDecoration(
  //       color: const Color(0xFF1A1A1A),
  //       borderRadius: BorderRadius.circular(20),
  //       border: Border.all(color: Colors.grey),
  //     ),
  //     child: ClipRRect(
  //       borderRadius: BorderRadius.circular(20),
  //       child: Stack(
  //         clipBehavior: Clip.none,
  //         fit: StackFit.expand,
  //         children: [
  //           Align(
  //             alignment: Alignment.center,
  //             child: Image.asset(
  //               imagePath,
  //               width: 100,
  //               height: 100,
  //               //fit: BoxFit.cover,
  //             ),
  //           ),
  //
  //           Align(
  //             alignment: Alignment.bottomCenter,
  //             child: Container(
  //               height: 15,
  //               padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
  //               width: double.infinity,
  //               alignment: Alignment.bottomCenter,
  //               decoration: BoxDecoration(
  //                 //color: Colors.black.withOpacity(0.5),
  //                 // borderRadius: const BorderRadius.all(Radius.circular(50)),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.black,
  //                     blurRadius: 10,
  //                     offset: Offset(-2, -15),
  //                   ),
  //                 ],
  //                 color: Colors.black,
  //               ),
  //             ),
  //           ),
  //
  //           Align(
  //             alignment: Alignment(0, 0.8),
  //             child: Text(
  //               title,
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 //color: Theme.of(context).colorScheme.onBackground,
  //                 fontSize: 14,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTargetCard(String title, String imagePath) {
    return Container(
      width: 120,
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.center,
              child: imagePath.startsWith('http')
                  ? Image.network(
                      imagePath,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // fallback if network image fails
                        return Image.asset(
                          'assets/program/shoulders.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      imagePath,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 15,
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 12,
                ),
                width: double.infinity,
                alignment: Alignment.bottomCenter,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 10,
                      offset: Offset(-2, -15),
                    ),
                  ],
                  color: Colors.black,
                ),
              ),
            ),

            Align(
              alignment: const Alignment(0, 0.8),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildProgramCard(
  //   BuildContext context,
  //   Map<String, String> program, {
  //   required VoidCallback onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       width: 250,
  //       height: 150,
  //       decoration: BoxDecoration(
  //         color: AppColors.card(context),
  //         borderRadius: BorderRadius.circular(16),
  //         border: Border.all(
  //           color: AppColors.border(context),
  //         ), // Theme-aware border
  //         image: DecorationImage(
  //           image: AssetImage(program['image']!),
  //           fit: BoxFit.cover,
  //           colorFilter: ColorFilter.mode(
  //             AppColors.background(context).withOpacity(0.4),
  //             BlendMode.darken,
  //           ),
  //         ),
  //       ),
  //       padding: const EdgeInsets.all(12),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Program title
  //           Text(
  //             program['title']!,
  //             maxLines: 2,
  //             overflow: TextOverflow.ellipsis,
  //             style: TextStyle(
  //               color: AppColors.text(context),
  //               fontWeight: FontWeight.w500,
  //               fontSize: 14,
  //               height: 1.3,
  //             ),
  //           ),
  //           const SizedBox(height: 6),
  //           Row(
  //             children: [
  //               Text(
  //                 program['kcal']!,
  //                 style: TextStyle(
  //                   color: AppColors.subText(context),
  //                   fontSize: 12,
  //                 ),
  //               ),
  //               const SizedBox(width: 8),
  //               Text(
  //                 '•',
  //                 style: TextStyle(
  //                   color: AppColors.subText(context).withOpacity(0.6),
  //                   fontSize: 12,
  //                 ),
  //               ),
  //               const SizedBox(width: 8),
  //               Text(
  //                 program['time']!,
  //                 style: TextStyle(
  //                   color: AppColors.subText(context),
  //                   fontSize: 12,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildProgramCard(
    BuildContext context,
    Map<String, String> program, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        height: 150,
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border(context)),
          image: DecorationImage(
            image: NetworkImage(program['image']!),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              AppColors.background(context).withValues(alpha: 0.4),
              BlendMode.darken,
            ),
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              program['title']!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.text(context),
                fontWeight: FontWeight.w500,
                fontSize: 14,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  program['kcal']!,
                  style: TextStyle(
                    color: AppColors.subText(context),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '•',
                  style: TextStyle(
                    color: AppColors.subText(context).withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  program['time']!,
                  style: TextStyle(
                    color: AppColors.subText(context),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
