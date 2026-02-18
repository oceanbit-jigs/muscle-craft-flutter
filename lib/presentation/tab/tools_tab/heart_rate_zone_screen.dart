import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../theme/color/colors.dart';
import 'bmi_calculators.dart';
import 'calories_calculator.dart';

class HeartRateZoneScreen extends StatefulWidget {
  const HeartRateZoneScreen({super.key});

  @override
  State<HeartRateZoneScreen> createState() => _HeartRateZoneScreenState();
}

class _HeartRateZoneScreenState extends State<HeartRateZoneScreen> {
  double age = 17;
  int? expandedFaqIndex;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final maxHeartRate = 220 - age.toInt();
    return Scaffold(
      appBar:
          // AppBar(
          //   // backgroundColor: Colors.black,
          //   elevation: 0,
          //   leading: Padding(
          //     padding: const EdgeInsets.only(left: 12),
          //     child: Container(
          //       height: 36,
          //       width: 36,
          //       decoration: const BoxDecoration(
          //         color: Colors.white,
          //         shape: BoxShape.circle,
          //       ),
          //       child: IconButton(
          //         icon: const Icon(Icons.arrow_back, color: Colors.black, size: 18),
          //         onPressed: () => Navigator.pop(context),
          //       ),
          //     ),
          //   ),
          //   title: const Text(
          //     'Heart Rate Zone',
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontWeight: FontWeight.bold,
          //       fontSize: 20,
          //     ),
          //   ),
          //   centerTitle: false,
          // ),
          AppBar(
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
                      onPressed: () => Navigator.pop(context),
                    ),
                  );
                },
              ),
            ),
            title: Builder(
              builder: (context) {
                bool isDark = Theme.of(context).brightness == Brightness.dark;
                return Text(
                  'Heart Rate Zone',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                );
              },
            ),
            centerTitle: false,
          ),
      body: SingleChildScrollView(
        //padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        controller: _scrollController,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Discover your ideal heart rate training zones for optimal workouts",
              textAlign: TextAlign.center,
              style: TextStyle(
                // color: Colors.white,
                color: isDark ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Discover your personalized training zones to optimize performance, burn more fat, and improve cardiovascular fitness",
              textAlign: TextAlign.center,
              style: TextStyle(
                // color: Colors.white70,
                color: isDark ? Colors.white : Colors.black,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Container(
            //   height: 250,
            //   // width: 300,
            //   decoration: BoxDecoration(
            //     color: const Color(0xFF040C1B),
            //     borderRadius: BorderRadius.circular(16),
            //     border: Border.all(color: Colors.white),
            //   ),
            //   padding: const EdgeInsets.all(10),
            //   child: Column(
            //     children: [
            //       SvgPicture.asset("assets/icons/birthday.svg", height: 46),
            //       const SizedBox(height: 12),
            //       const Text(
            //         "Age",
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 16,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //       const SizedBox(height: 4),
            //       const Text(
            //         "Enter Your Age",
            //         style: TextStyle(color: Colors.white, fontSize: 12),
            //       ),
            //       const SizedBox(height: 10),
            //       Text(
            //         age.toInt().toString(),
            //         style: const TextStyle(
            //           color: Colors.blue,
            //           fontSize: 28,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       SliderTheme(
            //         data: SliderTheme.of(context).copyWith(
            //           activeTrackColor: Colors.blue,
            //           inactiveTrackColor: Color(0xffD9D9D9),
            //           thumbColor: Colors.blueAccent,
            //           overlayColor: Colors.blue.withOpacity(0.2),
            //         ),
            //         child: Slider(
            //           value: age,
            //           min: 1,
            //           max: 100,
            //           divisions: 99,
            //           onChanged: (val) {
            //             setState(() {
            //               age = val;
            //             });
            //           },
            //         ),
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: const [
            //           Text(
            //             "1",
            //             style: TextStyle(color: Colors.white70, fontSize: 12),
            //           ),
            //           Text(
            //             "100",
            //             style: TextStyle(color: Colors.white70, fontSize: 12),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: AppColors.card(
                  context,
                ), // container background adapts to theme
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.border(context),
                ), // border adapts to theme
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  SvgPicture.asset(
                    "assets/icons/birthday.svg",
                    height: 46,
                    // colorFilter: ColorFilter.mode(
                    //   AppColors.icon(context), // icon color adapts to theme
                    //   BlendMode.srcIn,
                    // ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Age",
                    style: TextStyle(
                      color: AppColors.text(context),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Enter Your Age",
                    style: TextStyle(
                      color: AppColors.subText(
                        context,
                      ), // subtext adapts to theme
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    age.toInt().toString(),
                    style: const TextStyle(
                      color: Colors
                          .blue, // keeping numeric value color as requested
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.blue,
                      inactiveTrackColor: Colors.grey.shade400,
                      thumbColor: Colors.blueAccent,
                      overlayColor: Colors.blue.withValues(alpha: 0.2),
                    ),
                    child: Slider(
                      value: age,
                      min: 1,
                      max: 100,
                      divisions: 99,
                      onChanged: (val) {
                        setState(() {
                          age = val;
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "1",
                        style: TextStyle(
                          color: AppColors.subText(context), // theme-aware
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "100",
                        style: TextStyle(
                          color: AppColors.subText(context), // theme-aware
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Container(
            //   height: 250,
            //   width: 300,
            //   decoration: BoxDecoration(
            //     color: const Color(0xFF040C1B),
            //     borderRadius: BorderRadius.circular(16),
            //     border: Border.all(color: Colors.white),
            //   ),
            //   padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 18),
            //   child: Column(
            //     children: [
            //       SvgPicture.asset("assets/icons/heart1.svg", height: 42),
            //       const SizedBox(height: 14),
            //       const Text(
            //         "Maximum Heart Rate",
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 14,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //       const SizedBox(height: 8),
            //       Text(
            //         "${(220 - age.toInt())}",
            //         style: const TextStyle(
            //           color: Color(0xffFF5E78),
            //           fontSize: 32,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       const Text(
            //         "bpm",
            //         style: TextStyle(color: Colors.white70, fontSize: 12),
            //       ),
            //     ],
            //   ),
            // ),
            buildMaxHeartRateCard(maxHeartRate, context),
            const SizedBox(height: 20),

            buildTrainingZones(maxHeartRate, context),

            const SizedBox(height: 20),
            buildTrainingTipsCard(context),

            const SizedBox(height: 20),
            buildHeartRateTrainingCard(context),

            const SizedBox(height: 20),
            practicalTipsCard(context),

            const SizedBox(height: 20),
            didYouKnowCard(context),

            const SizedBox(height: 20),
            typicalWeeklyPlanCard(context),

            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                height: 55,
                margin: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF007AFF),
                      Color(0xFF00C6FF),
                    ], // blue gradient
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/heartRateZoneIcons/up_arrow.png",
                      height: 22,
                      width: 22,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Calculate my zones now",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.all(20),
            //   decoration: BoxDecoration(
            //     color: const Color(0xFF1E293B),
            //     borderRadius: BorderRadius.circular(16),
            //     border: Border.all(color: Color(0xff003A74)),
            //   ),
            //   child: const Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         'Complete Guide to Heart Rate Zones for Training',
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 16,
            //           fontWeight: FontWeight.w700,
            //         ),
            //       ),
            //       SizedBox(height: 12),
            //       Text(
            //         'Heart rate zones are a scientific tool essential for optimizing your training and achieving your fitness goals. Whether you\'re looking to lose weight, improve endurance, or increase performance, understanding and using heart rate zones will transform your approach to exercise.',
            //         style: TextStyle(
            //           color: Colors.white70,
            //           fontSize: 12,
            //           height: 1.5,
            //         ),
            //       ),
            //       SizedBox(height: 12),
            //       Text(
            //         'This calculator uses scientifically proven formulas to determine your personalized zones based on your age and, optionally, your resting heart rate. Each zone corresponds to a specific intensity and offers unique benefits for your cardiovascular health.',
            //         style: TextStyle(
            //           color: Colors.white70,
            //           fontSize: 12,
            //           height: 1.5,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // After the "Calculate my zones now" button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card(context), // adaptive background
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.border(context), // adaptive border color
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Complete Guide to Heart Rate Zones for Training',
                    style: TextStyle(
                      color: AppColors.text(context), // adaptive text color
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Heart rate zones are a scientific tool essential for optimizing your training and achieving your fitness goals. Whether you\'re looking to lose weight, improve endurance, or increase performance, understanding and using heart rate zones will transform your approach to exercise.',
                    style: TextStyle(
                      color: AppColors.subText(
                        context,
                      ), // adaptive subtext color
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This calculator uses scientifically proven formulas to determine your personalized zones based on your age and, optionally, your resting heart rate. Each zone corresponds to a specific intensity and offers unique benefits for your cardiovascular health.',
                    style: TextStyle(
                      color: AppColors.subText(
                        context,
                      ), // adaptive subtext color
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Container(
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     color: const Color(0xFF040C1B),
            //     borderRadius: BorderRadius.circular(16),
            //     border: Border.all(color: Colors.white.withOpacity(0.2)),
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       // Header
            //       Container(
            //         width: double.infinity,
            //         decoration: const BoxDecoration(
            //           color: Color(0xFF040C1B), // dark blue header background
            //           borderRadius: BorderRadius.only(
            //             topLeft: Radius.circular(16),
            //             topRight: Radius.circular(16),
            //           ),
            //         ),
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 16,
            //           vertical: 12,
            //         ),
            //         child: const Text(
            //           "Reference Table of Heart Rates by Age",
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //             fontSize: 14,
            //           ),
            //         ),
            //       ),
            //
            //       // Table Header Row
            //       Container(
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 16,
            //           vertical: 10,
            //         ),
            //         color: const Color(0xFF00264D),
            //         child: const Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Expanded(
            //               flex: 2,
            //               child: Text(
            //                 "Age",
            //                 style: TextStyle(
            //                   color: Colors.white,
            //                   fontWeight: FontWeight.w600,
            //                   fontSize: 10,
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //               flex: 2,
            //               child: Text(
            //                 "FCM",
            //                 style: TextStyle(
            //                   color: Colors.white,
            //                   fontWeight: FontWeight.w600,
            //                   fontSize: 10,
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //               flex: 3,
            //               child: Text(
            //                 "50% Intensity",
            //                 style: TextStyle(
            //                   color: Colors.white,
            //                   fontWeight: FontWeight.w600,
            //                   fontSize: 10,
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //               flex: 3,
            //               child: Text(
            //                 "85% Intensity",
            //                 style: TextStyle(
            //                   color: Colors.white,
            //                   fontWeight: FontWeight.w600,
            //                   fontSize: 10,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //
            //       // Table Rows
            //       _buildTableRow(
            //         "20–29",
            //         "190–200",
            //         "95–100",
            //         "162–170",
            //         Colors.transparent,
            //       ),
            //       _buildTableRow(
            //         "30–39",
            //         "180–190",
            //         "90–95",
            //         "153–162",
            //         const Color(0xFF1A1A1A),
            //       ),
            //       _buildTableRow(
            //         "40–49",
            //         "170–180",
            //         "85–90",
            //         "145–153",
            //         Colors.transparent,
            //       ),
            //       _buildTableRow(
            //         "50–59",
            //         "160–170",
            //         "80–85",
            //         "136–145",
            //         const Color(0xFF1A1A1A),
            //       ),
            //       _buildTableRow(
            //         "60–69",
            //         "150–160",
            //         "75–80",
            //         "128–136",
            //         Colors.transparent,
            //       ),
            //       _buildTableRow(
            //         "70+",
            //         "140–150",
            //         "70–75",
            //         "119–128",
            //         const Color(0xFF1A1A1A),
            //       ),
            //
            //       // Footer note
            //       const Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //         child: Text(
            //           "* These values are averages. Your actual FCM may vary by ±10–15 bpm.",
            //           style: TextStyle(
            //             color: Colors.white54,
            //             fontSize: 12,
            //             height: 1.4,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.card(context), // adaptive background
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.border(context),
                ), // adaptive border
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.card(
                        context,
                      ), // adaptive header background
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      "Reference Table of Heart Rates by Age",
                      style: TextStyle(
                        color: AppColors.text(context), // adaptive text color
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  // Table Header Row
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    color: AppColors.secondary(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Age",
                            style: TextStyle(
                              color: AppColors.text(context),
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "FCM",
                            style: TextStyle(
                              color: AppColors.text(context),
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "50% Intensity",
                            style: TextStyle(
                              color: AppColors.text(context),
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "85% Intensity",
                            style: TextStyle(
                              color: AppColors.text(context),
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Table Rows
                  _buildTableRow(
                    context,
                    "20–29",
                    "190–200",
                    "95–100",
                    "162–170",
                    Colors.transparent,
                  ),
                  _buildTableRow(
                    context,
                    "30–39",
                    "180–190",
                    "90–95",
                    "153–162",
                    AppColors.rowAlternate(context),
                  ),
                  _buildTableRow(
                    context,
                    "40–49",
                    "170–180",
                    "85–90",
                    "145–153",
                    Colors.transparent,
                  ),
                  _buildTableRow(
                    context,
                    "50–59",
                    "160–170",
                    "80–85",
                    "136–145",
                    AppColors.rowAlternate(context),
                  ),
                  _buildTableRow(
                    context,
                    "60–69",
                    "150–160",
                    "75–80",
                    "128–136",
                    Colors.transparent,
                  ),
                  _buildTableRow(
                    context,
                    "70+",
                    "140–150",
                    "70–75",
                    "119–128",
                    AppColors.rowAlternate(context),
                  ),

                  // Footer note
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      "* These values are averages. Your actual FCM may vary by ±10–15 bpm.",
                      style: TextStyle(
                        color: AppColors.subText(context), // adaptive subtext
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            buildTrainingZonesSection(context),

            const SizedBox(height: 20),
            trainingTips(context),

            const SizedBox(height: 20),
            buildFAQSection(context),

            const SizedBox(height: 20),
            buildOptimizeTrainingSection(),

            const SizedBox(height: 20),
            medicalWarning(context),
          ],
        ),
      ),
    );
  }

  // Widget buildFAQSection(BuildContext context) {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFF1C293F),
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           'Frequently Asked Questions\nabout Heart Rate Zones',
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontSize: 16,
  //             fontWeight: FontWeight.w600,
  //             height: 1.3,
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //
  //         ...faqList.asMap().entries.map((entry) {
  //           final index = entry.key;
  //           final question = entry.value["q"]!;
  //           final answer = entry.value["a"]!;
  //           final isExpanded = expandedFaqIndex == index;
  //
  //           return GestureDetector(
  //             onTap: () {
  //               setState(() {
  //                 expandedFaqIndex = isExpanded ? null : index;
  //               });
  //             },
  //             child: AnimatedContainer(
  //               duration: const Duration(milliseconds: 250),
  //               curve: Curves.easeInOut,
  //               margin: const EdgeInsets.only(bottom: 10),
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 16,
  //                 vertical: 14,
  //               ),
  //               decoration: BoxDecoration(
  //                 color: const Color(0xFF000624),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Expanded(
  //                         child: Text(
  //                           question,
  //                           style: const TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 14,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                       ),
  //                       Icon(
  //                         isExpanded ? Icons.remove : Icons.add,
  //                         color: Colors.white70,
  //                         size: 18,
  //                       ),
  //                     ],
  //                   ),
  //                   AnimatedCrossFade(
  //                     firstChild: const SizedBox.shrink(),
  //                     secondChild: Column(
  //                       children: [
  //                         const SizedBox(height: 10),
  //                         Container(height: 1, color: Colors.white24),
  //                         const SizedBox(height: 10),
  //                         Text(
  //                           answer,
  //                           style: const TextStyle(
  //                             color: Colors.white70,
  //                             fontSize: 12,
  //                             height: 1.4,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     crossFadeState: isExpanded
  //                         ? CrossFadeState.showSecond
  //                         : CrossFadeState.showFirst,
  //                     duration: const Duration(milliseconds: 250),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         }),
  //       ],
  //     ),
  //   );
  // }

  Widget buildFAQSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card(context), // Theme adaptive
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Frequently Asked Questions\nabout Heart Rate Zones',
            style: TextStyle(
              color: AppColors.text(context), // Adaptive
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),

          ...faqList.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value["q"]!;
            final answer = entry.value["a"]!;
            final isExpanded = expandedFaqIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  expandedFaqIndex = isExpanded ? null : index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cardDark(context), // FAQ tile adaptive
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            question,
                            style: TextStyle(
                              color: AppColors.text(context), // Adaptive
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Icon(
                          isExpanded ? Icons.remove : Icons.add,
                          color: AppColors.subText(context), // Adaptive icon
                          size: 18,
                        ),
                      ],
                    ),

                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Column(
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            height: 1,
                            color: AppColors.divider(
                              context,
                            ), // Adaptive divider
                          ),
                          const SizedBox(height: 10),
                          Text(
                            answer,
                            style: TextStyle(
                              color: AppColors.subText(
                                context,
                              ), // Light/Dark subtitle text
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                      crossFadeState: isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 250),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget buildOptimizeTrainingSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6A8DFF), Color(0xFFA355A9)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Ready to Optimize Your Training?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: const Text(
              "Use our calculator to discover your personalized zones and transform your fitness",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 12, height: 1.4),
            ),
          ),
          const SizedBox(height: 24),

          GestureDetector(
            onTap: () {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF456DFF), Color(0xFFC936DE)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    offset: const Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  "Calculate My Zones Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 BMI Calculator Card
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BmiCalculatorsScreen()),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Color(0xffD0D0D0).withValues(alpha: 0.3),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BMI Calculator",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Evaluate your body mass index",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // 🔹 Calorie Calculator Card
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CalorieFormulaScreen()),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Color(0xffD0D0D0).withValues(alpha: 0.3),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Calorie Calculator",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Determine your daily calorie needs",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget buildMaxHeartRateCard(int maxHeartRate) {
//   return Container(
//     height: 250,
//     // width: 300,
//     width: double.infinity,
//     decoration: BoxDecoration(
//       color: const Color(0xFF040C1B),
//       borderRadius: BorderRadius.circular(16),
//       border: Border.all(color: Colors.white),
//     ),
//     padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 18),
//     child: Column(
//       children: [
//         SvgPicture.asset("assets/icons/heart1.svg", height: 42),
//         const SizedBox(height: 14),
//         const Text(
//           "Maximum Heart Rate",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           "$maxHeartRate",
//           style: const TextStyle(
//             color: Colors.redAccent,
//             fontSize: 32,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const Text(
//           "bpm",
//           style: TextStyle(color: Colors.white70, fontSize: 12),
//         ),
//       ],
//     ),
//   );
// }

Widget buildMaxHeartRateCard(int maxHeartRate, BuildContext context) {
  return Container(
    height: 250,
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.card(context),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: AppColors.border(context),
      ), // border adapts to theme
    ),
    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 18),
    child: Column(
      children: [
        SvgPicture.asset(
          "assets/icons/heart1.svg",
          height: 42,
          // colorFilter: ColorFilter.mode(
          //   AppColors.icon(context), // icon adapts to theme
          //   BlendMode.srcIn,
          // ),
        ),
        const SizedBox(height: 14),
        Text(
          "Maximum Heart Rate",
          style: TextStyle(
            color: AppColors.text(context), // text adapts to theme
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "$maxHeartRate",
          style: const TextStyle(
            color: Colors.redAccent, // numeric value color remains
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "bpm",
          style: TextStyle(
            color: AppColors.subText(context), // adapts to theme
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

// Widget buildHeartRateOverviewBar() {
//   return Container(
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: const Color(0xFF2E3440),
//       borderRadius: BorderRadius.circular(14),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Overview of your heart rate zones",
//           style: TextStyle(
//             color: Colors.white70,
//             fontSize: 13,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 14),
//
//         // Main segmented bar
//         ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: Row(
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: Container(
//                   height: 20,
//                   color: const Color(0xFF9199A5),
//                 ), // gray
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   height: 20,
//                   color: const Color(0xFF366AD6),
//                 ), // blue
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   height: 20,
//                   color: const Color(0xFF449572),
//                 ), // green
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   height: 20,
//                   color: const Color(0xFFB8833A),
//                 ), // orange
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   height: 20,
//                   color: const Color(0xFFE85B41),
//                 ), // pink-red
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Container(height: 20, color: const Color(0xFFC8393F)),
//               ),
//             ],
//           ),
//         ),
//
//         const SizedBox(height: 8),
//
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: const [
//             Text("1", style: TextStyle(color: Colors.white70, fontSize: 10)),
//             Text("102", style: TextStyle(color: Colors.white70, fontSize: 10)),
//             Text("152", style: TextStyle(color: Colors.white70, fontSize: 10)),
//             Text(
//               "203bpm",
//               style: TextStyle(color: Colors.white70, fontSize: 10),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

// Widget buildHeartRateOverviewBar(int maxHeartRate) {
//   final List<Map<String, dynamic>> zones = [
//     {"color": const Color(0xFF9199A5), "max": 0.60}, // Warm-up
//     {"color": const Color(0xFF366AD6), "max": 0.70}, // Fat Burn
//     {"color": const Color(0xFF449572), "max": 0.80}, // Aerobic
//     {"color": const Color(0xFFB8833A), "max": 0.90}, // Anaerobic
//     {"color": const Color(0xFFE85B41), "max": 1.00}, // VO₂ Max
//   ];
//
//   return Container(
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: const Color(0xFF2E3440),
//       borderRadius: BorderRadius.circular(14),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Overview of your heart rate zones",
//           style: TextStyle(
//             color: Colors.white70,
//             fontSize: 13,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 14),
//
//         // 🔹 Heart Rate Zone Bar
//         ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: Row(
//             children: [
//               // Each colored segment
//               for (int i = 0; i < zones.length; i++)
//                 Expanded(
//                   flex:
//                       ((zones[i]["max"] -
//                                   (i == 0 ? 0.5 : zones[i - 1]["max"])) *
//                               1000)
//                           .round(),
//                   child: Container(height: 20, color: zones[i]["color"]),
//                 ),
//             ],
//           ),
//         ),
//
//         const SizedBox(height: 8),
//
//         // 🔹 BPM labels (0 + last value of each zone)
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               "0",
//               style: TextStyle(color: Colors.white54, fontSize: 10),
//             ),
//             ...zones.map((zone) {
//               final bpm = (zone["max"] * maxHeartRate).round();
//               return Text(
//                 "$bpm",
//                 style: const TextStyle(color: Colors.white54, fontSize: 10),
//               );
//             }),
//           ],
//         ),
//       ],
//     ),
//   );
// }

Widget buildHeartRateOverviewBar(int maxHeartRate, BuildContext context) {
  final List<Map<String, dynamic>> zones = [
    {"color": const Color(0xFF9199A5), "max": 0.60}, // Warm-up
    {"color": const Color(0xFF366AD6), "max": 0.70}, // Fat Burn
    {"color": const Color(0xFF449572), "max": 0.80}, // Aerobic
    {"color": const Color(0xFFB8833A), "max": 0.90}, // Anaerobic
    {"color": const Color(0xFFE85B41), "max": 1.00}, // VO₂ Max
  ];

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.card(context),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border(context)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Overview of your heart rate zones",
          style: TextStyle(
            color: AppColors.subText(context),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 14),

        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              for (int i = 0; i < zones.length; i++)
                Expanded(
                  flex:
                      ((zones[i]["max"] -
                                  (i == 0 ? 0.5 : zones[i - 1]["max"])) *
                              1000)
                          .round(),
                  child: Container(height: 20, color: zones[i]["color"]),
                ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "0",
              style: TextStyle(color: AppColors.subText(context), fontSize: 10),
            ),
            ...zones.map((zone) {
              final bpm = (zone["max"] * maxHeartRate).round();
              return Text(
                "$bpm",
                style: TextStyle(
                  color: AppColors.subText(context),
                  fontSize: 10,
                ),
              );
            }),
          ],
        ),
      ],
    ),
  );
}

// Widget buildTrainingZones(int maxHeartRate) {
//   return Container(
//     width: double.infinity,
//     decoration: BoxDecoration(
//       color: const Color(0xFF040C1B),
//       borderRadius: BorderRadius.circular(16),
//       border: Border.all(color: Colors.white),
//     ),
//     padding: const EdgeInsets.all(18),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         const Text(
//           "Target Training Zones 🎯",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 10),
//
//         buildHeartRateOverviewBar(),
//
//         const SizedBox(height: 22),
//
//         // 🔹 Zones List
//         _zoneCard(
//           bgColor: const Color(0xFFD6E7FD),
//           color: const Color(0xFF5B8FF9),
//           icon: "assets/heartRateZoneIcons/walking.png",
//           title: "Warm Up Zone",
//           subtitle: "Very light intensity for warming up and cooling down",
//           bpmRange: "102–122",
//           percentage: "60% de FCM",
//           sliderValue: 0.6,
//         ),
//         _zoneCard(
//           bgColor: const Color(0xFFD8FBE4),
//           color: const Color(0xFF52C41A),
//           icon: "assets/heartRateZoneIcons/fire.png",
//           title: "Fat Burn Zone",
//           subtitle: "Light intensity, comfortable pace for longer workouts",
//           bpmRange: "122–142",
//           percentage: "70% de FCM",
//           sliderValue: 0.7,
//         ),
//         _zoneCard(
//           bgColor: const Color(0xFFFEF7BF),
//           color: const Color(0xFFC27D1F),
//           icon: "assets/heartRateZoneIcons/running.png",
//           title: "Aerobic Zone",
//           subtitle: "Moderate intensity, sustainable for extended periods",
//           bpmRange: "142–162",
//           percentage: "80% de FCM",
//           sliderValue: 0.8,
//         ),
//         _zoneCard(
//           bgColor: const Color(0xFFFEF0C3),
//           color: const Color(0xFFFD4B28),
//           icon: "assets/heartRateZoneIcons/muscle.png",
//           title: "Anaerobic Zone",
//           subtitle: "Hard intensity, sustainable for short periods",
//           bpmRange: "162–183",
//           percentage: "90% de FCM",
//           sliderValue: 0.9,
//         ),
//         _zoneCard(
//           bgColor: const Color(0xFFFDDEDE),
//           color: const Color(0xFFD52026),
//           icon: "assets/heartRateZoneIcons/rocket.png",
//           title: "VO2 Max Zone",
//           subtitle: "Maximum intensity, sustainable for very short bursts",
//           bpmRange: "183–203",
//           percentage: "100% de FCM",
//           sliderValue: 1,
//         ),
//       ],
//     ),
//   );
// }

Widget buildTrainingZones(int maxHeartRate, BuildContext context) {
  List<Map<String, dynamic>> zones = [
    {
      "bgColor": const Color(0xFFD6E7FD),
      "color": const Color(0xFF5B8FF9),
      "icon": "assets/heartRateZoneIcons/walking.png",
      "title": "Warm Up Zone",
      "subtitle": "Very light intensity for warming up and cooling down",
      "min": 0.50,
      "max": 0.60,
      "slider": 0.6,
    },
    {
      "bgColor": const Color(0xFFD8FBE4),
      "color": const Color(0xFF52C41A),
      "icon": "assets/heartRateZoneIcons/fire.png",
      "title": "Fat Burn Zone",
      "subtitle": "Light intensity, comfortable pace for longer workouts",
      "min": 0.60,
      "max": 0.70,
      "slider": 0.7,
    },
    {
      "bgColor": const Color(0xFFFEF7BF),
      "color": const Color(0xFFC27D1F),
      "icon": "assets/heartRateZoneIcons/running.png",
      "title": "Aerobic Zone",
      "subtitle": "Moderate intensity, sustainable for extended periods",
      "min": 0.70,
      "max": 0.80,
      "slider": 0.8,
    },
    {
      "bgColor": const Color(0xFFFEF0C3),
      "color": const Color(0xFFFD4B28),
      "icon": "assets/heartRateZoneIcons/muscle.png",
      "title": "Anaerobic Zone",
      "subtitle": "Hard intensity, sustainable for short periods",
      "min": 0.80,
      "max": 0.90,
      "slider": 0.9,
    },
    {
      "bgColor": const Color(0xFFFDDEDE),
      "color": const Color(0xFFD52026),
      "icon": "assets/heartRateZoneIcons/rocket.png",
      "title": "VO₂ Max Zone",
      "subtitle": "Maximum intensity, sustainable for very short bursts",
      "min": 0.90,
      "max": 1.00,
      "slider": 1.0,
    },
  ];

  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.card(context),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border(context)),
    ),
    padding: const EdgeInsets.all(18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Target Training Zones 🎯",
          style: TextStyle(
            color: AppColors.text(context),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        buildHeartRateOverviewBar(maxHeartRate, context),
        const SizedBox(height: 22),

        // 🔹 Generate dynamic zones
        ...zones.map((z) {
          final minBpm = (z["min"] * maxHeartRate).round();
          final maxBpm = (z["max"] * maxHeartRate).round();

          return _zoneCard(
            context: context,
            bgColor: z["bgColor"],
            color: z["color"],
            icon: z["icon"],
            title: z["title"],
            subtitle: z["subtitle"],
            bpmRange: "$minBpm–$maxBpm",
            percentage: "${(z["max"] * 100).toStringAsFixed(0)}% of MHR",
            sliderValue: z["slider"],
          );
        }),
      ],
    ),
  );
}

// Widget buildTrainingZones(int maxHeartRate) {
//   List<Map<String, dynamic>> zones = [
//     {
//       "bgColor": const Color(0xFFD6E7FD),
//       "color": const Color(0xFF5B8FF9),
//       "icon": "assets/heartRateZoneIcons/walking.png",
//       "title": "Warm Up Zone",
//       "subtitle": "Very light intensity for warming up and cooling down",
//       "min": 0.50,
//       "max": 0.60,
//       "slider": 0.6,
//     },
//     {
//       "bgColor": const Color(0xFFD8FBE4),
//       "color": const Color(0xFF52C41A),
//       "icon": "assets/heartRateZoneIcons/fire.png",
//       "title": "Fat Burn Zone",
//       "subtitle": "Light intensity, comfortable pace for longer workouts",
//       "min": 0.60,
//       "max": 0.70,
//       "slider": 0.7,
//     },
//     {
//       "bgColor": const Color(0xFFFEF7BF),
//       "color": const Color(0xFFC27D1F),
//       "icon": "assets/heartRateZoneIcons/running.png",
//       "title": "Aerobic Zone",
//       "subtitle": "Moderate intensity, sustainable for extended periods",
//       "min": 0.70,
//       "max": 0.80,
//       "slider": 0.8,
//     },
//     {
//       "bgColor": const Color(0xFFFEF0C3),
//       "color": const Color(0xFFFD4B28),
//       "icon": "assets/heartRateZoneIcons/muscle.png",
//       "title": "Anaerobic Zone",
//       "subtitle": "Hard intensity, sustainable for short periods",
//       "min": 0.80,
//       "max": 0.90,
//       "slider": 0.9,
//     },
//     {
//       "bgColor": const Color(0xFFFDDEDE),
//       "color": const Color(0xFFD52026),
//       "icon": "assets/heartRateZoneIcons/rocket.png",
//       "title": "VO₂ Max Zone",
//       "subtitle": "Maximum intensity, sustainable for very short bursts",
//       "min": 0.90,
//       "max": 1.00,
//       "slider": 1.0,
//     },
//   ];
//
//   return Container(
//     width: double.infinity,
//     decoration: BoxDecoration(
//       color: const Color(0xFF040C1B),
//       borderRadius: BorderRadius.circular(16),
//       border: Border.all(color: Colors.white),
//     ),
//     padding: const EdgeInsets.all(18),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         const Text(
//           "Target Training Zones 🎯",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 10),
//         buildHeartRateOverviewBar(maxHeartRate),
//         const SizedBox(height: 22),
//
//         // 🔹 Generate dynamic zones
//         ...zones.map((z) {
//           final minBpm = (z["min"] * maxHeartRate).round();
//           final maxBpm = (z["max"] * maxHeartRate).round();
//
//           return _zoneCard(
//             bgColor: z["bgColor"],
//             color: z["color"],
//             icon: z["icon"],
//             title: z["title"],
//             subtitle: z["subtitle"],
//             bpmRange: "$minBpm–$maxBpm",
//             percentage: "${(z["max"] * 100).toStringAsFixed(0)}% of MHR",
//             sliderValue: z["slider"],
//           );
//         }),
//       ],
//     ),
//   );
// }

Widget _zoneCard({
  required BuildContext context,
  required Color bgColor,
  required Color color,
  required String icon,
  required String title,
  required String subtitle,
  required String bpmRange,
  required String percentage,
  required double sliderValue,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    decoration: BoxDecoration(
      color: bgColor, // keep zone color as is
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border(context)), // adapt border
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(icon, height: 40, fit: BoxFit.contain),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: color, // keep title color as is
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      //color: AppColors.text(context), // adapt subtitle
                      color: Colors.black,
                      fontSize: 8,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.divider(
                        context,
                      ), // background track adapts
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: sliderValue.clamp(0.0, 1.0),
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              bpmRange,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              percentage,
              style: TextStyle(color: Colors.black, fontSize: 9),
            ),
            const SizedBox(width: 4),
            Text(
              "bpm",
              style: TextStyle(color: AppColors.subText(context), fontSize: 9),
            ),
          ],
        ),
      ],
    ),
  );
}

// Widget _zoneCard({
//   required Color bgColor,
//   required Color color,
//   required String icon,
//   required String title,
//   required String subtitle,
//   required String bpmRange,
//   required String percentage,
//   required double sliderValue,
// }) {
//   return Container(
//     margin: const EdgeInsets.only(bottom: 14),
//     padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
//     decoration: BoxDecoration(
//       color: bgColor,
//       borderRadius: BorderRadius.circular(12),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.asset(icon, height: 40, fit: BoxFit.contain),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       color: color,
//                       fontWeight: FontWeight.w700,
//                       fontSize: 12,
//                     ),
//                   ),
//                   const SizedBox(height: 3),
//                   Text(
//                     subtitle,
//                     style: const TextStyle(
//                       color: Colors.black87,
//                       fontSize: 8,
//                       height: 1.3,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 12),
//
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Expanded(
//               child: Stack(
//                 children: [
//                   Container(
//                     height: 6,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),
//                   FractionallySizedBox(
//                     widthFactor: sliderValue.clamp(0.0, 1.0),
//                     child: Container(
//                       height: 6,
//                       decoration: BoxDecoration(
//                         color: color,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 10),
//             Text(
//               bpmRange,
//               style: TextStyle(
//                 color: color,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               percentage,
//               style: const TextStyle(color: Colors.black54, fontSize: 9),
//             ),
//             const SizedBox(width: 4),
//             const Text(
//               "bpm",
//               style: TextStyle(color: Colors.black54, fontSize: 9),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

Widget buildTrainingTipsCard(BuildContext context) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.card(context),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border(context)),
    ),
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
    child: Column(
      children: [
        Image.asset(
          'assets/heartRateZoneIcons/lightBulb.png',
          height: 23,
          color: Colors.amberAccent, // Keep tip icon color
        ),
        const SizedBox(height: 6),
        Text(
          "Training Tips",
          style: TextStyle(
            color: AppColors.text(context),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 18),

        // 2x2 GRID
        Wrap(
          spacing: 16, // horizontal spacing
          runSpacing: 16, // vertical spacing
          alignment: WrapAlignment.center,
          children: [
            _tipContainer(
              context: context,
              icon: 'assets/heartRateZoneIcons/circle.png',
              text:
                  "Start with lower intensity zones if you're new to exercise",
            ),
            _tipContainer(
              context: context,
              icon: 'assets/heartRateZoneIcons/monitor.png',
              text:
                  "Use a heart rate monitor for accurate tracking during workouts",
            ),
            _tipContainer(
              context: context,
              icon: 'assets/heartRateZoneIcons/timer.png',
              text:
                  "Mix different zones in your weekly training for best results",
            ),
            _tipContainer(
              context: context,
              icon: 'assets/heartRateZoneIcons/user.png',
              text:
                  "Your zones may change as your fitness improves – recalculate periodically",
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _tipContainer({
  required BuildContext context,
  required String icon,
  required String text,
}) {
  return Container(
    width: 150,
    height: 150,
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
    decoration: BoxDecoration(
      color: AppColors.card(context), // adapts to light/dark theme
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border(context)), // optional border
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(icon, height: 26, width: 26),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.text(context), // adapts to light/dark theme
            fontSize: 10,
          ),
        ),
      ],
    ),
  );
}

// Widget buildTrainingTipsCard() {
//   return Container(
//     width: double.infinity,
//     decoration: BoxDecoration(
//       color: const Color(0xFF2E3440),
//       borderRadius: BorderRadius.circular(16),
//       border: Border.all(color: Colors.white),
//     ),
//     padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//     child: Column(
//       children: [
//         Image.asset(
//           'assets/heartRateZoneIcons/lightBulb.png',
//           height: 23,
//           color: Colors.amberAccent,
//         ),
//         const SizedBox(height: 6),
//         const Text(
//           "Training Tips",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 18),
//
//         // 2x2 GRID
//         Wrap(
//           spacing: 16, // horizontal spacing
//           runSpacing: 16, // vertical spacing
//           alignment: WrapAlignment.center,
//           children: [
//             // Tip 1
//             _tipContainer(
//               icon: 'assets/heartRateZoneIcons/circle.png',
//               text:
//                   "Start with lower intensity zones if you're new to exercise",
//             ),
//
//             // Tip 2
//             _tipContainer(
//               icon: 'assets/heartRateZoneIcons/monitor.png',
//               text:
//                   "Use a heart rate monitor for accurate tracking during workouts",
//             ),
//
//             _tipContainer(
//               icon: 'assets/heartRateZoneIcons/timer.png',
//               text:
//                   "Mix different zones in your weekly training for best results",
//             ),
//
//             _tipContainer(
//               icon: 'assets/heartRateZoneIcons/user.png',
//               text:
//                   "Your zones may change as your fitness improves – recalculate periodically",
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
//
// Widget _tipContainer({required String icon, required String text}) {
//   return Container(
//     width: 150,
//     height: 150,
//     padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
//     decoration: BoxDecoration(
//       color: const Color(0xFF3B4252),
//       borderRadius: BorderRadius.circular(12),
//     ),
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Image.asset(icon, height: 26, width: 26),
//         const SizedBox(height: 8),
//         Text(
//           text,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 10,
//             //height: 1.3,
//           ),
//         ),
//       ],
//     ),
//   );
// }

Widget buildHeartRateTrainingCard(BuildContext context) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.card(context), // adapts to light/dark theme
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border(context)),
    ),
    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/heartRateZoneIcons/pallete.png', height: 35),
        const SizedBox(height: 8),

        // Title
        Text(
          "Understanding Heart Rate Training",
          style: TextStyle(
            color: AppColors.text(context),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),

        // Subtitle
        Text(
          "Visualize each training zone easily",
          style: TextStyle(color: AppColors.subText(context), fontSize: 10),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 20),

        // 🟦 Zone Cards
        Column(
          children: [
            _zoneCard1(
              icon: 'assets/heartRateZoneIcons/walking.png',
              color: const Color(0xFFD6E7FD),
              title: 'Warm Up Zone',
              range: '50–60%',
              rightTitle: 'Perfect warm-up',
              example: 'Ex: Slow walk',
            ),
            _zoneCard1(
              icon: 'assets/heartRateZoneIcons/fire.png',
              color: const Color(0xFFD8FBE4),
              title: 'Fat Burn Zone',
              range: '60–70%',
              rightTitle: 'Maximum fat burning',
              example: 'Ex: Light jogging',
            ),
            _zoneCard1(
              icon: 'assets/heartRateZoneIcons/running.png',
              color: const Color(0xFFFEF7BF),
              title: 'Aerobic Zone',
              range: '70–80%',
              rightTitle: 'Improves cardiovascular',
              example: 'Ex: Moderate run',
            ),
            _zoneCard1(
              icon: 'assets/heartRateZoneIcons/muscle.png',
              color: const Color(0xFFFEF0C3),
              title: 'Anaerobic Zone',
              range: '80–90%',
              rightTitle: 'Increases speed',
              example: 'Ex: Short sprint',
            ),
            _zoneCard1(
              icon: 'assets/heartRateZoneIcons/rocket.png',
              color: const Color(0xFFFDDEDE),
              title: 'VO2 Max Zone',
              range: '90–100%',
              rightTitle: 'Maximum effort',
              example: 'Ex: High effort',
            ),
          ],
        ),
      ],
    ),
  );
}

// Inner zone card remains the same
Widget _zoneCard1({
  required String icon,
  required Color color,
  required String title,
  required String range,
  required String rightTitle,
  required String example,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.8),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(icon, height: 30, width: 30),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Color(0xff205DE3), fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                range,
                style: const TextStyle(
                  color: Color(0xff205DE3),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              rightTitle,
              style: const TextStyle(color: Color(0xff205DE3), fontSize: 11),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 4),
            Text(
              example,
              style: const TextStyle(color: Color(0xff205DE3), fontSize: 10),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ],
    ),
  );
}

// Widget buildHeartRateTrainingCard() {
//   return Container(
//     width: double.infinity,
//     decoration: BoxDecoration(
//       color: const Color(0xFF1C1E26),
//       borderRadius: BorderRadius.circular(16),
//       border: Border.all(color: Colors.white),
//     ),
//     padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Image.asset('assets/heartRateZoneIcons/pallete.png', height: 35),
//         const SizedBox(height: 8),
//
//         // Title
//         const Text(
//           "Understanding Heart Rate Training",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//             fontWeight: FontWeight.w600,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 4),
//
//         // Subtitle
//         const Text(
//           "Visualize each training zone easily",
//           style: TextStyle(color: Colors.white70, fontSize: 10),
//           textAlign: TextAlign.center,
//         ),
//
//         const SizedBox(height: 20),
//
//         // 🟦 Zone Cards
//         Column(
//           children: [
//             _zoneCard1(
//               icon: 'assets/heartRateZoneIcons/walking.png',
//               color: const Color(0xFFD6E7FD),
//               title: 'Warm Up Zone',
//               range: '50–60%',
//               rightTitle: 'Perfect warm-up',
//               example: 'Ex: Slow walk',
//             ),
//             _zoneCard1(
//               icon: 'assets/heartRateZoneIcons/fire.png',
//               color: const Color(0xFFD8FBE4),
//               title: 'Fat Burn Zone',
//               range: '60–70%',
//               rightTitle: 'Maximum fat burning',
//               example: 'Ex: Light jogging',
//             ),
//             _zoneCard1(
//               icon: 'assets/heartRateZoneIcons/running.png',
//               color: const Color(0xFFFEF7BF),
//               title: 'Aerobic Zone',
//               range: '70–80%',
//               rightTitle: 'Improves cardiovascular',
//               example: 'Ex: Moderate run',
//             ),
//             _zoneCard1(
//               icon: 'assets/heartRateZoneIcons/muscle.png',
//               color: const Color(0xFFFEF0C3),
//               title: 'Anaerobic Zone',
//               range: '80–90%',
//               rightTitle: 'Increases speed',
//               example: 'Ex: Short sprint',
//             ),
//             _zoneCard1(
//               icon: 'assets/heartRateZoneIcons/rocket.png',
//               color: const Color(0xFFFDDEDE),
//               title: 'VO2 Max Zone',
//               range: '90–100%',
//               rightTitle: 'Perfect warm-up',
//               example: 'Ex: High effort',
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
//
// Widget _zoneCard1({
//   required String icon,
//   required Color color,
//   required String title,
//   required String range,
//   required String rightTitle,
//   required String example,
// }) {
//   return Container(
//     margin: const EdgeInsets.only(bottom: 14),
//     padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
//     decoration: BoxDecoration(
//       color: color.withOpacity(0.8),
//       borderRadius: BorderRadius.circular(12),
//     ),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Left icon
//         Image.asset(icon, height: 30, width: 30),
//
//         const SizedBox(width: 12),
//
//         // Title + range
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(color: Color(0xff205DE3), fontSize: 12),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 range,
//                 style: TextStyle(
//                   color: Color(0xff205DE3),
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         // Right side info
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               rightTitle,
//               style: const TextStyle(
//                 color: Color(0xff205DE3),
//                 fontSize: 11,
//                 fontWeight: FontWeight.w400,
//               ),
//               textAlign: TextAlign.right,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               example,
//               style: const TextStyle(color: Color(0xff205DE3), fontSize: 10),
//               textAlign: TextAlign.right,
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

Widget practicalTipsCard(BuildContext context) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.card(context), // adapts to light/dark theme
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border(context)),
    ),
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/heartRateZoneIcons/lightBulb.png",
          height: 36,
          color: Colors.amberAccent, // icon color stays same
        ),
        const SizedBox(height: 12),
        Text(
          "Practical Tips",
          style: TextStyle(
            color: AppColors.text(context),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),

        // Tip 1
        _buildTipCard(
          context: context,
          icon: "assets/heartRateZoneIcons/target.png",
          title: "Practical Tips",
          description:
              "Each zone has a different goal.\nChoose based on your goal!",
        ),
        const SizedBox(height: 14),

        // Tip 2
        _buildTipCard(
          context: context,
          icon: "assets/heartRateZoneIcons/timer.png",
          title: "Recommended Duration",
          description: "The higher the intensity,\nthe shorter the duration.",
        ),
        const SizedBox(height: 14),

        // Tip 3
        _buildTipCard(
          context: context,
          icon: "assets/heartRateZoneIcons/grow.png",
          title: "Progression",
          description: "Start slowly and gradually\nincrease the intensity.",
        ),
        const SizedBox(height: 14),

        // Tip 4
        _buildTipCard(
          context: context,
          icon: "assets/heartRateZoneIcons/heart.png",
          title: "Listen to your body",
          description: "If you feel bad,\nslow down immediately.",
        ),
      ],
    ),
  );
}

Widget _buildTipCard({
  required BuildContext context, // add context
  required String icon,
  required String title,
  required String description,
}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.card(context), // adapts to light/dark theme
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(icon, height: 22), // keep icon color as-is
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.text(context),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  // color: Colors.white, // keep text white
                  color: AppColors.text(context),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Widget practicalTipsCard() {
//   return Container(
//     width: double.infinity,
//     decoration: BoxDecoration(
//       color: const Color(0xFF040C1B),
//       borderRadius: BorderRadius.circular(16),
//       border: Border.all(color: Colors.white.withOpacity(0.3)),
//     ),
//     padding: const EdgeInsets.all(20),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Image.asset("assets/heartRateZoneIcons/lightBulb.png", height: 36),
//         const SizedBox(height: 12),
//         const Text(
//           "Practical Tips",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 20),
//
//         // Tip 1
//         _buildTipCard(
//           icon: "assets/heartRateZoneIcons/target.png",
//           title: "Practical Tips",
//           description:
//               "Each zone has a different goal.\nChoose based on your goal!",
//         ),
//         const SizedBox(height: 14),
//
//         // Tip 2
//         _buildTipCard(
//           icon: "assets/heartRateZoneIcons/timer.png",
//           title: "Recommended Duration",
//           description: "The higher the intensity,\nthe shorter the duration.",
//         ),
//         const SizedBox(height: 14),
//
//         // Tip 3
//         _buildTipCard(
//           icon: "assets/heartRateZoneIcons/grow.png",
//           title: "Progression",
//           description: "Start slowly and gradually\nincrease the intensity.",
//         ),
//         const SizedBox(height: 14),
//
//         // Tip 4
//         _buildTipCard(
//           icon: "assets/heartRateZoneIcons/heart.png",
//           title: "Listen to your body",
//           description: "If you feel bad,\nslow down immediately.",
//         ),
//       ],
//     ),
//   );
// }
//
// Widget _buildTipCard({
//   required String icon,
//   required String title,
//   required String description,
// }) {
//   return Container(
//     width: double.infinity,
//     decoration: BoxDecoration(
//       color: const Color(0xFF0B162B),
//       borderRadius: BorderRadius.circular(12),
//     ),
//     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Image.asset(icon, height: 22),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 description,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 13,
//                   height: 1.4,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

Widget didYouKnowCard(BuildContext context) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.card(context), // adapts to light/dark theme
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border(context)),
    ),
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset("assets/heartRateZoneIcons/smile.png", height: 40),
        const SizedBox(height: 12),
        Text(
          "Did you know?",
          style: TextStyle(
            color: AppColors.text(context),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),

        _buildDidYouKnowTile(
          context,
          icon: "assets/heartRateZoneIcons/1.png",
          text: "220 - your age = approximate maximum heart rate",
        ),
        const SizedBox(height: 12),

        _buildDidYouKnowTile(
          context,
          icon: "assets/heartRateZoneIcons/2.png",
          text:
              "Measure your pulse in the morning to know your resting heart rate",
        ),
        const SizedBox(height: 12),

        _buildDidYouKnowTile(
          context,
          icon: "assets/heartRateZoneIcons/3.png",
          text: "A smartwatch can track your heart rate in real time",
        ),
        const SizedBox(height: 12),

        _buildDidYouKnowTile(
          context,
          icon: "assets/heartRateZoneIcons/4.png",
          text: "80% of your training should be in zones 1–3",
        ),
      ],
    ),
  );
}

Widget _buildDidYouKnowTile(
  BuildContext context, {
  required String icon,
  required String text,
}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.card(context),
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(icon, height: 22, width: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              // color: Colors.white, // keep text white
              color: AppColors.text(context),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ),
      ],
    ),
  );
}

// Widget didYouKnowCard() {
//   return Container(
//     width: double.infinity,
//     decoration: BoxDecoration(
//       color: const Color(0xFF040C1B),
//       borderRadius: BorderRadius.circular(16),
//       border: Border.all(color: Colors.white.withOpacity(0.3)),
//     ),
//     padding: const EdgeInsets.all(20),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Image.asset("assets/heartRateZoneIcons/smile.png", height: 40),
//         const SizedBox(height: 12),
//         const Text(
//           "Did you know?",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 20),
//
//         // Tip 1
//         _buildDidYouKnowTile(
//           icon: "assets/heartRateZoneIcons/1.png",
//           text: "220 - your age = approximate maximum heart rate",
//         ),
//         const SizedBox(height: 12),
//
//         // Tip 2
//         _buildDidYouKnowTile(
//           icon: "assets/heartRateZoneIcons/2.png",
//           text:
//               "Measure your pulse in the morning to know your resting heart rate",
//         ),
//         const SizedBox(height: 12),
//
//         // Tip 3
//         _buildDidYouKnowTile(
//           icon: "assets/heartRateZoneIcons/3.png",
//           text: "A smartwatch can track your heart rate in real time",
//         ),
//         const SizedBox(height: 12),
//
//         // Tip 4
//         _buildDidYouKnowTile(
//           icon: "assets/heartRateZoneIcons/4.png",
//           text: "80% of your training should be in zones 1–3",
//         ),
//       ],
//     ),
//   );
// }
//
// Widget _buildDidYouKnowTile({required String icon, required String text}) {
//   return Container(
//     width: double.infinity,
//     decoration: BoxDecoration(
//       color: const Color(0xFF0B162B),
//       borderRadius: BorderRadius.circular(12),
//     ),
//     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Image.asset(icon, height: 22, width: 22),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Text(
//             text,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 13,
//               height: 1.4,
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

Widget typicalWeeklyPlanCard(BuildContext context) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.card(context), // adapts to light/dark theme
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border(context)),
    ),
    padding: const EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset("assets/heartRateZoneIcons/calander.png", height: 40),
        const SizedBox(height: 12),
        Text(
          "Typical Weekly Plan",
          style: TextStyle(
            color: AppColors.text(context),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "An example of a balanced weekly training plan",
          style: TextStyle(color: AppColors.text(context), fontSize: 10),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),

        _buildDayTile(
          context: context,
          day: "Monday",
          icon: "assets/heartRateZoneIcons/walking.png",
          zone: "Zone 1–2",
          duration: "30–45 min",
          color: const Color(0xFF1D2C3D),
          dayColor: Color(0xff88BFFA),
        ),
        const SizedBox(height: 10),

        _buildDayTile(
          context: context,
          day: "Tuesday",
          icon: "assets/heartRateZoneIcons/fire.png",
          zone: "Zone 2–3",
          duration: "45–60 min",
          color: const Color(0xFF1B3225),
          dayColor: Color(0xffB6F2DC),
        ),
        const SizedBox(height: 10),

        _buildDayTile(
          context: context,
          day: "Wednesday",
          icon: "assets/heartRateZoneIcons/sleep.png",
          zone: "Rest",
          duration: "Recovery",
          color: const Color(0xFF1D2530),
          dayColor: Color(0xffEFF1F3),
        ),
        const SizedBox(height: 10),

        _buildDayTile(
          context: context,
          day: "Thursday",
          icon: "assets/heartRateZoneIcons/running.png",
          zone: "Zone 3–4",
          duration: "30–40 min",
          color: const Color(0xFF342C1F),
          dayColor: Color(0xffFDD94F),
        ),
        const SizedBox(height: 10),

        _buildDayTile(
          context: context,
          day: "Friday",
          icon: "assets/heartRateZoneIcons/walking.png",
          zone: "Zone 1–2",
          duration: "30 min",
          color: const Color(0xFF1C2C3D),
          dayColor: const Color(0xFF88BFFA),
        ),
        const SizedBox(height: 10),

        _buildDayTile(
          context: context,
          day: "Saturday",
          icon: "assets/heartRateZoneIcons/muscle.png",
          zone: "Zone 4–5",
          duration: "20–30 min",
          color: const Color(0xFF261F1C),
          dayColor: const Color(0xFFFE9669),
        ),
        const SizedBox(height: 14),

        Text(
          "💡 Adapt this plan according to your level and goals!",
          style: TextStyle(color: AppColors.text(context), fontSize: 10),
        ),
      ],
    ),
  );
}

Widget _buildDayTile({
  required String day,
  required String icon,
  required String zone,
  required String duration,
  required Color color,
  required Color dayColor,
  required BuildContext context,
}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: color, // keep tile color as-is
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          day,
          style: TextStyle(
            color: dayColor,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Image.asset(icon, height: 30), // keep image as-is
        const SizedBox(height: 6),
        Text(
          zone,
          style: TextStyle(
            //color: AppColors.text(context),
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(duration, style: TextStyle(color: Colors.white, fontSize: 10)),
      ],
    ),
  );
}

// Widget typicalWeeklyPlanCard() {
//   return Container(
//     width: double.infinity,
//     decoration: BoxDecoration(
//       color: const Color(0xFF040C1B),
//       borderRadius: BorderRadius.circular(16),
//       border: Border.all(color: Colors.white),
//     ),
//     padding: const EdgeInsets.all(20),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Image.asset("assets/heartRateZoneIcons/calander.png", height: 40),
//         const SizedBox(height: 12),
//         const Text(
//           "Typical Weekly Plan",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 4),
//         const Text(
//           "An example of a balanced weekly training plan",
//           style: TextStyle(color: Colors.white, fontSize: 10),
//           textAlign: TextAlign.center,
//         ),
//         const SizedBox(height: 20),
//
//         _buildDayTile(
//           day: "Monday",
//           icon: "assets/heartRateZoneIcons/walking.png",
//           zone: "Zone 1–2",
//           duration: "30–45 min",
//           color: const Color(0xFF1D2C3D),
//           dayColor: Color(0xff88BFFA),
//         ),
//         const SizedBox(height: 10),
//
//         _buildDayTile(
//           day: "Tuesday",
//           icon: "assets/heartRateZoneIcons/fire.png",
//           zone: "Zone 2–3",
//           duration: "45–60 min",
//           color: const Color(0xFF1B3225),
//           dayColor: Color(0xffB6F2DC),
//         ),
//         const SizedBox(height: 10),
//
//         _buildDayTile(
//           day: "Wednesday",
//           icon: "assets/heartRateZoneIcons/sleep.png",
//           zone: "Rest",
//           duration: "Recovery",
//           color: const Color(0xFF1D2530),
//           dayColor: Color(0xffEFF1F3),
//         ),
//         const SizedBox(height: 10),
//
//         _buildDayTile(
//           day: "Thursday",
//           icon: "assets/heartRateZoneIcons/running.png",
//           zone: "Zone 3–4",
//           duration: "30–40 min",
//           color: const Color(0xFF342C1F),
//           dayColor: Color(0xffFDD94F),
//         ),
//         const SizedBox(height: 10),
//
//         _buildDayTile(
//           day: "Friday",
//           icon: "assets/heartRateZoneIcons/walking.png",
//           zone: "Zone 1–2",
//           duration: "30 min",
//           color: const Color(0xFF1C2C3D),
//           dayColor: const Color(0xFF88BFFA),
//         ),
//         const SizedBox(height: 10),
//
//         _buildDayTile(
//           day: "Saturday",
//           icon: "assets/heartRateZoneIcons/muscle.png",
//           zone: "Zone 4–5",
//           duration: "20–30 min",
//           color: const Color(0xFF261F1C),
//           dayColor: const Color(0xFFFE9669),
//         ),
//         const SizedBox(height: 14),
//
//         const Text(
//           "💡 Adapt this plan according to your level and goals!",
//           style: TextStyle(color: Colors.white70, fontSize: 10),
//         ),
//       ],
//     ),
//   );
// }

// Widget _buildDayTile({
//   required String day,
//   required String icon,
//   required String zone,
//   required String duration,
//   required Color color,
//   required Color dayColor,
// }) {
//   return Container(
//     width: double.infinity,
//     decoration: BoxDecoration(
//       color: color,
//       borderRadius: BorderRadius.circular(12),
//     ),
//     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text(
//           day,
//           style: TextStyle(
//             color: dayColor,
//             fontSize: 14,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         const SizedBox(height: 6),
//         Image.asset(icon, height: 30),
//         const SizedBox(height: 6),
//         Text(
//           zone,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           duration,
//           style: const TextStyle(color: Colors.white, fontSize: 10),
//         ),
//       ],
//     ),
//   );
// }

Widget _buildTableRow(
  BuildContext context,
  String age,
  String fcm,
  String intensity50,
  String intensity85,
  Color bgColor,
) {
  return Container(
    color: bgColor == Colors.transparent
        ? bgColor
        : bgColor.withValues(alpha: 0.2),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            age,
            style: TextStyle(color: AppColors.text(context), fontSize: 10),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            fcm,
            style: TextStyle(color: AppColors.text(context), fontSize: 10),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            intensity50,
            style: TextStyle(color: AppColors.text(context), fontSize: 10),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            intensity85,
            style: TextStyle(color: AppColors.text(context), fontSize: 10),
          ),
        ),
      ],
    ),
  );
}

// Widget _buildTableRow(
//   String age,
//   String fcm,
//   String intensity50,
//   String intensity85,
//   Color bgColor,
// ) {
//   return Container(
//     color: bgColor,
//     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(
//           flex: 2,
//           child: Text(
//             age,
//             style: const TextStyle(color: Colors.white, fontSize: 10),
//           ),
//         ),
//         Expanded(
//           flex: 2,
//           child: Text(
//             fcm,
//             style: const TextStyle(color: Colors.white, fontSize: 10),
//           ),
//         ),
//         Expanded(
//           flex: 3,
//           child: Text(
//             intensity50,
//             style: const TextStyle(color: Colors.white, fontSize: 10),
//           ),
//         ),
//         Expanded(
//           flex: 3,
//           child: Text(
//             intensity85,
//             style: const TextStyle(color: Colors.white, fontSize: 10),
//           ),
//         ),
//       ],
//     ),
//   );
// }

Widget buildTrainingZonesSection(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(20),
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.card(context), // dark/light theme adaptive
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border(context)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "The 5 Training Zones\nExplained in Detail",
          style: TextStyle(
            // color: Colors.white,
            color: AppColors.text(context),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        buildZoneCard(
          context: context,
          imagePath: "assets/heartRateZoneIcons/walking.png",
          title: "Zone 1: Warp Up",
          subtitle: "(50–60% FCM)",
          description:
              "The warm up zone is ideal for starting a session, recovering between intervals, or finishing a workout. At this intensity, you can maintain a normal conversation without getting out of breath.",
          benefits: [
            "Improves blood circulation",
            "Prepares muscles and joints",
            "Reduces the risk of injury",
            "Favorizes active recovery",
          ],
          recommended: [
            "5–10 minutes at the beginning/end of a session",
            "20–30 minutes for active recovery",
          ],
          titleColor: const Color(0xFF88BFFA),
          subtitleColor: const Color(0xFF88BFFA),
          backgroundColor: const Color(0xFF1C293F),
        ),
        const SizedBox(height: 16),
        buildZoneCard(
          context: context,
          imagePath: "assets/heartRateZoneIcons/fire.png",
          title: "Zone 2: Fat Burn",
          subtitle: "(60–70% FCM)",
          description:
              "In this zone, your body primarily uses fat as fuel. It’s the optimal intensity for developing your aerobic base and improving metabolic efficiency.",
          benefits: [
            "Maximizes fat utilization",
            "Develops aerobic endurance",
            "Improves cardiac efficiency",
            "Strengthens the immune system",
          ],
          recommended: [
            "30–90 minutes for endurance",
            "45–60 minutes for weight loss",
          ],
          backgroundColor: const Color(0xFF1B2D2E),
          titleColor: const Color(0xFFB6F2DC),
          subtitleColor: const Color(0xFFB6F2DC),
        ),
        const SizedBox(height: 16),
        buildZoneCard(
          context: context,
          imagePath: "assets/heartRateZoneIcons/running.png",
          title: "Zone 3 : Aerobic",
          subtitle: "(70–80% FCM)",
          description:
              "The aerobic zone significantly improves your cardiovascular capacity. You breathe harder but can still speak in short sentences. It's the main training zone for most athletes.",
          benefits: [
            "Increases pulmonary capacity",
            "Improves cardiovascular endurance",
            "Strengthens the heart",
            "Optimizes oxygen utilization",
          ],
          recommended: [
            "20–60 minutes continuously",
            "Intervals of 5–15 minutes",
          ],
          backgroundColor: const Color(0xFF2B292B),
          titleColor: const Color(0xFFFDD94F),
          subtitleColor: const Color(0xFFFDD94F),
        ),
        const SizedBox(height: 16),
        buildZoneCard(
          context: context,
          imagePath: "assets/heartRateZoneIcons/muscle.png",
          title: "Zone 4 : Anaerobic",
          subtitle: "(80–90% FCM)",
          description:
              "In the anaerobic zone, your body produces lactic acid faster than it can eliminate it. This intensity develops power and speed but can't be sustained for long periods.",
          benefits: [
            "Increases muscle power",
            "Improves lactate tolerance",
            "Develops speed",
            "Strengthens the mind",
          ],
          recommended: ["Intervals of 2–8 minutes", "Equal or double recovery"],
          backgroundColor: const Color(0xFF232028),
          titleColor: const Color(0xFFFE9669),
          subtitleColor: const Color(0xFFFE9669),
        ),
        const SizedBox(height: 16),
        buildZoneCard(
          context: context,
          imagePath: "assets/heartRateZoneIcons/rocket.png",
          title: "Zone 5 : VO2 Max",
          subtitle: "(90–100% FCM)",
          description:
              "The VO2 Max zone represents the maximum effort. At this intensity, you can only pronounce a few words and the effort is unbearable beyond a few minutes. Reserved for experienced athletes.",
          benefits: [
            "Maximizes aerobic capacity",
            "Improves running economy",
            "Develops maximum power",
            "Pushes mental limits",
          ],
          recommended: [
            "Intervals of 30s to 2 minutes",
            "Maximum 1–2 times per week",
          ],
          backgroundColor: const Color(0xFF2E232C),
          titleColor: const Color(0xFFFA9B9C),
          subtitleColor: const Color(0xFFFA9B9C),
        ),
      ],
    ),
  );
}

Widget buildZoneCard({
  required BuildContext context,
  required String imagePath,
  required String title,
  required String subtitle,
  required String description,
  required List<String> benefits,
  required List<String> recommended,
  required Color backgroundColor,
  required Color titleColor,
  required Color subtitleColor,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: backgroundColor, // zone-specific background
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(imagePath, height: 36, width: 36),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor, // keep as-is
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: subtitleColor, // keep as-is
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Description adapts to theme
        Text(
          description,
          style: TextStyle(
            //color: AppColors.text(context),
            color: Colors.white,
            fontSize: 12,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Benefits :",
          style: TextStyle(
            //color: AppColors.text(context),
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        ...benefits.map(
          (b) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• ", style: TextStyle(color: Colors.white)),
              Expanded(
                child: Text(
                  b,
                  style: TextStyle(
                    // color: AppColors.text(context),
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Recommended Duration :",
          style: TextStyle(
            //color: AppColors.text(context),
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 6),
        ...recommended.map(
          (r) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("• ", style: TextStyle(color: Colors.white)),
              Expanded(
                child: Text(
                  r,
                  style: TextStyle(
                    //color: AppColors.text(context),
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Widget buildTrainingZonesSection() {
//   return Container(
//     padding: EdgeInsetsGeometry.all(20),
//     width: double.infinity,
//     decoration: BoxDecoration(
//       color: const Color(0xFF040C1B),
//       borderRadius: BorderRadius.circular(16),
//       border: Border.all(color: Colors.white.withOpacity(0.2)),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "The 5 Training Zones\nExplained in Detail",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         const SizedBox(height: 16),
//         buildZoneCard(
//           imagePath: "assets/heartRateZoneIcons/walking.png",
//           title: "Zone 1: Warp Up",
//           subtitle: "(50–60% FCM)",
//           description:
//               "The warm up zone is ideal for starting a session, recovering between intervals, or finishing a workout. At this intensity, you can maintain a normal conversation without getting out of breath.",
//           benefits: [
//             "Improves blood circulation",
//             "Prepares muscles and joints",
//             "Reduces the risk of injury",
//             "Favorizes active recovery",
//           ],
//           recommended: [
//             "5–10 minutes at the beginning/end of a session",
//             "20–30 minutes for active recovery",
//           ],
//           titleColor: const Color(0xFF88BFFA),
//           subtitleColor: const Color(0xFF88BFFA),
//           backgroundColor: const Color(0xFF1C293F),
//         ),
//         const SizedBox(height: 16),
//         buildZoneCard(
//           imagePath: "assets/heartRateZoneIcons/fire.png",
//           title: "Zone 2: Fat Burn",
//           subtitle: "(60–70% FCM)",
//           description:
//               "In this zone, your body primarily uses fat as fuel. It’s the optimal intensity for developing your aerobic base and improving metabolic efficiency.",
//           benefits: [
//             "Maximizes fat utilization",
//             "Develops aerobic endurance",
//             "Improves cardiac efficiency",
//             "Strengthens the immune system",
//           ],
//           recommended: [
//             "30–90 minutes for endurance",
//             "45–60 minutes for weight loss",
//           ],
//           backgroundColor: const Color(0xFF1B2D2E),
//           titleColor: const Color(0xFFB6F2DC),
//           subtitleColor: const Color(0xFFB6F2DC),
//         ),
//         const SizedBox(height: 16),
//         buildZoneCard(
//           imagePath: "assets/heartRateZoneIcons/running.png",
//           title: "Zone 3 : Aerobic",
//           subtitle: "(70-80% FCM)",
//           description:
//               "The aerobic zone significantly improves your cardiovascular capacity. You breathe harder but can still speak in short sentences. It's the main training zone for most athletes.",
//           benefits: [
//             "Increases pulmonary capacity",
//             "Improves cardiovascular endurance",
//             "Strengthens the heart",
//             "Optimizes oxygen utilization",
//           ],
//           recommended: [
//             "20-60 minutes continuously",
//             "Intervals of 5-15 minutes",
//           ],
//           backgroundColor: const Color(0xFF2B292B),
//           titleColor: const Color(0xFFFDD94F),
//           subtitleColor: const Color(0xFFFDD94F),
//         ),
//         const SizedBox(height: 16),
//         buildZoneCard(
//           imagePath: "assets/heartRateZoneIcons/muscle.png",
//           title: "Zone 4 : Anaerobic",
//           subtitle: "(80-90% FCM)",
//           description:
//               "In the anaerobic zone, your body produces lactic acid faster than it can eliminate it. This intensity develops power and speed but can't be sustained for long periods.",
//           benefits: [
//             "Increases muscle power",
//             "Improves lactate tolerance",
//             "Develops speed",
//             "Strengthens the mind",
//           ],
//           recommended: ["Intervals of 2-8 minutes", "Equal or double recovery"],
//           backgroundColor: const Color(0xFF232028),
//           titleColor: const Color(0xFFFE9669),
//           subtitleColor: const Color(0xFFFE9669),
//         ),
//         const SizedBox(height: 16),
//         buildZoneCard(
//           imagePath: "assets/heartRateZoneIcons/rocket.png",
//           title: "Zone 5 : VO2 Max",
//           subtitle: "(90-100% FCM)",
//           description:
//               "The VO2 Max zone represents the maximum effort. At this intensity, you can only pronounce a few words and the effort is unbearable beyond a few minutes. Reserved for experienced athletes.",
//           benefits: [
//             "Maximizes aerobic capacity",
//             "Improves running economy",
//             "Develops maximum power",
//             "Pushes mental limits",
//           ],
//           recommended: [
//             "Intervals of 30s to 2 minutes",
//             "Maximum 1-2 times per week",
//           ],
//           backgroundColor: const Color(0xFF2E232C),
//           titleColor: const Color(0xFFFA9B9C),
//           subtitleColor: const Color(0xFFFA9B9C),
//         ),
//       ],
//     ),
//   );
// }
//
// Widget buildZoneCard({
//   required String imagePath,
//   required String title,
//   required String subtitle,
//   required String description,
//   required List<String> benefits,
//   required List<String> recommended,
//   required Color backgroundColor,
//   required Color titleColor,
//   required Color subtitleColor,
// }) {
//   return Container(
//     width: double.infinity,
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: backgroundColor,
//       borderRadius: BorderRadius.circular(16),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // 🔹 Top Row with Image + Zone Titles
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.asset(imagePath, height: 36, width: 36),
//             const SizedBox(width: 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     color: titleColor,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//                 Text(
//                   subtitle,
//                   style: TextStyle(
//                     color: subtitleColor,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 10),
//
//         // 🔹 Description
//         Text(
//           description,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 12,
//             height: 1.4,
//           ),
//         ),
//
//         const SizedBox(height: 10),
//
//         // 🔹 Benefits
//         const Text(
//           "Benefits :",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w500,
//             fontSize: 12,
//           ),
//         ),
//         const SizedBox(height: 6),
//         ...benefits.map(
//           (b) => Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text("• ", style: TextStyle(color: Colors.white)),
//               Expanded(
//                 child: Text(
//                   b,
//                   style: const TextStyle(color: Colors.white, fontSize: 10),
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         const SizedBox(height: 10),
//
//         // 🔹 Recommended Duration
//         const Text(
//           "Recommended Duration :",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w500,
//             fontSize: 12,
//           ),
//         ),
//         const SizedBox(height: 6),
//         ...recommended.map(
//           (r) => Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text("• ", style: TextStyle(color: Colors.white)),
//               Expanded(
//                 child: Text(
//                   r,
//                   style: const TextStyle(color: Colors.white, fontSize: 10),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

Widget trainingTips(BuildContext context) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.card(context), // adapts to dark/light theme
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border(context)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Expert Training Tips to\nOptimize Your Training',
          style: TextStyle(
            color: AppColors.text(context),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 16),
        buildTipItem(
          context,
          'assets/heartRateZoneIcons/fire.png',
          'Progressive Warm-up',
          'Always start with 5–10 minutes in Zone 1 (50–60%) to prepare your cardiovascular system.',
        ),
        buildTipItem(
          context,
          'assets/heartRateZoneIcons/graph.png',
          '80/20 Rule',
          '80% of your training in Zones 1–3 (aerobic), 20% in Zones 4–5 (anaerobic) for optimal development.',
        ),
        buildTipItem(
          context,
          'assets/heartRateZoneIcons/recovery.png',
          'Active Recovery',
          'After an intense effort, gradually return to Zone 1–2 for 5–10 minutes.',
        ),
        buildTipItem(
          context,
          'assets/heartRateZoneIcons/hydration.png',
          'Constant Hydration',
          'Drink before, during, and after exercise. Dehydration increases heart rate.',
        ),
        buildTipItem(
          context,
          'assets/heartRateZoneIcons/sleep.png',
          'Restorative Sleep',
          '7–9 hours of sleep allows better recovery and a lower resting heart rate.',
        ),
        buildTipItem(
          context,
          'assets/heartRateZoneIcons/progression.png',
          'Gradual Progression',
          'Increase intensity or duration by 10% maximum per week to avoid overtraining.',
        ),
      ],
    ),
  );
}

Widget buildTipItem(
  BuildContext context,
  String image,
  String title,
  String subtitle,
) {
  return Container(
    height: 100,
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: AppColors.cardDark(context), // adaptive background
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.all(12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(image, width: 28, height: 28, fit: BoxFit.contain),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  // color: Colors.white, // keep title color
                  color: AppColors.text(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: AppColors.text(context), // adaptive for description
                  fontSize: 10,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

//
// Widget trainingTips() {
//   return Container(
//     width: double.infinity,
//     padding: const EdgeInsets.all(20),
//     decoration: BoxDecoration(
//       color: const Color(0xFF2B292B),
//       borderRadius: BorderRadius.circular(16),
//       border: Border.all(color: Colors.white.withOpacity(0.2)),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Expert Training Tips to\nOptimize Your Training',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//             height: 1.3,
//           ),
//         ),
//         const SizedBox(height: 16),
//         buildTipItem(
//           'assets/heartRateZoneIcons/fire.png',
//           'Progressive Warm-up',
//           'Always start with 5–10 minutes in Zone 1 (50–60%) to prepare your cardiovascular system.',
//         ),
//         buildTipItem(
//           'assets/heartRateZoneIcons/graph.png',
//           '80/20 Rule',
//           '80% of your training in Zones 1–3 (aerobic), 20% in Zones 4–5 (anaerobic) for optimal development.',
//         ),
//         buildTipItem(
//           'assets/heartRateZoneIcons/recovery.png',
//           'Active Recovery',
//           'After an intense effort, gradually return to Zone 1–2 for 5–10 minutes.',
//         ),
//         buildTipItem(
//           'assets/heartRateZoneIcons/hydration.png',
//           'Constant Hydration',
//           'Drink before, during, and after exercise. Dehydration increases heart rate.',
//         ),
//         buildTipItem(
//           'assets/heartRateZoneIcons/sleep.png',
//           'Restorative Sleep',
//           '7–9 hours of sleep allows better recovery and a lower resting heart rate.',
//         ),
//         buildTipItem(
//           'assets/heartRateZoneIcons/progression.png',
//           'Gradual Progression',
//           'Increase intensity or duration by 10% maximum per week to avoid overtraining.',
//         ),
//       ],
//     ),
//   );
// }
//
// Widget buildTipItem(String image, String title, String subtitle) {
//   return Container(
//     height: 110,
//     margin: const EdgeInsets.only(bottom: 12),
//     decoration: BoxDecoration(
//       color: const Color(0xFF000624),
//       borderRadius: BorderRadius.circular(12),
//     ),
//     padding: const EdgeInsets.all(12),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Image.asset(image, width: 28, height: 28, fit: BoxFit.contain),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 subtitle,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 10,
//                   height: 1.3,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget buildFAQSection() {
//   return Container(
//     width: double.infinity,
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: const Color(0xFF1C293F),
//       borderRadius: BorderRadius.circular(16),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Frequently Asked Questions\nabout Heart Rate Zones',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             height: 1.3,
//           ),
//         ),
//         const SizedBox(height: 16),
//
//         buildFAQItem('What is the maximum heart rate (FCM)?'),
//         buildFAQItem('How to measure my resting heart rate?'),
//         buildFAQItem('What zone is best for weight loss?'),
//         buildFAQItem('Can I train in the VO₂ Max zone every day?'),
//         buildFAQItem('Is the 220–age formula accurate?'),
//         buildFAQItem('How to know if I’m in the right zone?'),
//         buildFAQItem('Do zones change with improving fitness?'),
//         buildFAQItem(
//           'What is the difference between the Basic and Karvonen formulas?',
//         ),
//       ],
//     ),
//   );
// }
//
// Widget buildFAQItem(String question) {
//   return Container(
//     height: 76,
//     margin: const EdgeInsets.only(bottom: 10),
//     decoration: BoxDecoration(
//       color: const Color(0xFF000624),
//       borderRadius: BorderRadius.circular(12),
//     ),
//     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(
//           child: Text(
//             question,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//         const Icon(Icons.add, color: Colors.white70, size: 18),
//       ],
//     ),
//   );
// }

List<Map<String, String>> faqList = [
  {
    "q": "What is the maximum heart rate (FCM)?",
    "a":
        "Your maximum heart rate (MHR) is the highest number of beats per minute your heart can reach during maximum effort. It is often estimated as 220 minus your age.",
  },
  {
    "q": "How to measure my resting heart rate?",
    "a":
        "Measure your resting heart rate (RHR) right after waking up, before getting out of bed. Count your pulse for 60 seconds or use a smartwatch or heart rate monitor.",
  },
  {
    "q": "What zone is best for weight loss?",
    "a":
        "The Fat Burn Zone (60–70% of your maximum heart rate) is ideal for weight loss, as your body uses more fat as a fuel source during lower-intensity exercise.",
  },
  {
    "q": "Can I train in the VO₂ Max zone every day?",
    "a":
        "No. VO₂ Max training is very intense and should be done only 1–2 times per week to allow recovery and prevent overtraining.",
  },
  {
    "q": "Is the 220–age formula accurate?",
    "a":
        "It’s a general estimate and can vary individually. Fitness level, genetics, and health conditions can influence your true maximum heart rate.",
  },
  {
    "q": "How to know if I’m in the right zone?",
    "a":
        "You can use a heart rate monitor or smartwatch to track your BPM during exercise and compare it to your calculated target zones.",
  },
  {
    "q": "Do zones change with improving fitness?",
    "a":
        "Yes. As your fitness improves, your heart becomes more efficient, which can change your resting and working heart rates over time.",
  },
  {
    "q": "What is the difference between the Basic and Karvonen formulas?",
    "a":
        "The Basic formula uses 220–age, while the Karvonen formula considers your resting heart rate for more personalized target zones.",
  },
];

// Widget medicalWarning() {
//   return Container(
//     width: double.infinity,
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: const Color(0xFF1E1B1E),
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(color: const Color(0xFFB23C3C), width: 1.5),
//     ),
//     child: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const Icon(
//           Icons.warning_amber_rounded,
//           color: Color(0xFFF9D65C),
//           size: 30,
//         ),
//         const SizedBox(height: 8),
//         const Text(
//           'Medical Warning',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//         const SizedBox(height: 8),
//         const Text(
//           'This calculator provides estimates based on general formulas. Results may vary based on your physical condition, medications, and health status. Always consult a healthcare professional before starting a new exercise program, particularly if you have pre-existing medical conditions or experience unusual symptoms during exercise.',
//           textAlign: TextAlign.center,
//           style: TextStyle(fontSize: 13, height: 1.4, color: Color(0xFFCCCCCC)),
//         ),
//       ],
//     ),
//   );
// }

Widget medicalWarning(BuildContext context) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.card(context), // adaptive background
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xFFB23C3C), // keep red border
        width: 1.5,
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.warning_amber_rounded,
          color: Color(0xFFF9D65C), // keep same
          size: 30,
        ),

        const SizedBox(height: 8),

        Text(
          'Medical Warning',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.text(context), // adaptive title
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'This calculator provides estimates based on general formulas. Results may vary based on your physical condition, medications, and health status. Always consult a healthcare professional before starting a new exercise program, particularly if you have pre-existing medical conditions or experience unusual symptoms during exercise.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            height: 1.4,
            color: AppColors.subText(context), // adaptive paragraph
          ),
        ),
      ],
    ),
  );
}
