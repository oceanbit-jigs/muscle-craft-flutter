import 'package:fitness_workout_app/presentation/tab/tools_tab/widgets/calories_calculator_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../theme/color/colors.dart';

class CalorieFormulaScreen extends StatelessWidget {
  const CalorieFormulaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar:
          // AppBar(
          //   // backgroundColor: Colors.black,
          //   elevation: 0,
          //   leading: Padding(
          //     padding: const EdgeInsets.only(left: 12),
          //     child: Container(
          //       height: 30,
          //       width: 30,
          //       decoration: const BoxDecoration(
          //         color: Colors.white,
          //         shape: BoxShape.circle,
          //       ),
          //       child: IconButton(
          //         icon: const Icon(Icons.arrow_back, color: Colors.black, size: 21),
          //         onPressed: () => Navigator.pop(context),
          //       ),
          //     ),
          //   ),
          //   title: const Text(
          //     'Calorie Calculator Formulas',
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
                  'Calorie Calculator Formulas',
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Choose the best formula for your needs\nand get accurate calorie calculations',
              style: TextStyle(
                // color: Colors.white70,
                color: isDark ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),

            _buildFormulaCard(
              context,
              color: const Color(0xFF3E5399),
              icon: 'assets/caloryCalculator/first.svg',
              title: 'Mifflin-St Jeor (Recommended)',
              since: 'Since 1990',
              description:
                  'Most accurate formula for general population, developed in 1990. Currently the gold standard for BMR calculations.',
              popularity: '⭐️⭐️⭐️⭐️⭐️',
              accuracy: 'High',
              bestFor: 'General use',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CaloriesCalculatorDetails(
                      title: 'Mifflin-St Jeor Calculator',
                      formulaInfo: {
                        'intro':
                            'The gold standard for BMR calculation — most accurate for general population.',
                        'details':
                            'Developed in 1990, this formula is considered the most accurate for calculating Basal Metabolic Rate (BMR) in healthy adults. It’s more precise than the Harris-Benedict equation and is widely recommended by nutritionists and fitness professionals.',
                        'men':
                            'BMR = 10 × weight(kg) + 6.25 × height(cm) − 5 × age + 5',
                        'women':
                            'BMR = 10 × weight(kg) + 6.25 × height(cm) − 5 × age − 161',
                      },
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            // Harris-Benedict
            _buildFormulaCard(
              context,
              color: const Color(0xFF3E994D),
              icon: 'assets/caloryCalculator/second.svg',
              title: 'Harris-Benedict (Classic)',
              since: 'Since 1919',
              description:
                  'Revised 1984 version of the classic formula. Widely used but tends to overestimate calories for some people.',
              popularity: '⭐️⭐️⭐️⭐️⭐️',
              accuracy: 'Good',
              bestFor: 'Traditional',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CaloriesCalculatorDetails(
                      title: 'Harris-Benedict Calculator',
                      formulaInfo: {
                        'intro':
                            'Classic BMR formula - the traditional approach to calorie calculation.',
                        'details':
                            'Originally developed in 1919 and revised in 1984, the Harris-Benedict equation was one of the first formulas to calculate BMR. While slightly less accurate than newer formulas, it remains widely used and provides good estimates for most people.',
                        'men':
                            'BMR = 88.362 + (13.397 × weight) + (4.799 × height) - (5.677 × age)',
                        'women':
                            'BMR = 447.593 + (9.247 × weight) + (3.098 × height) -(4.330 × age)',
                      },
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            // Katch-McArdle
            _buildFormulaCard(
              context,
              color: const Color(0xFF993E3F),
              icon: 'assets/caloryCalculator/third.svg',
              title: 'Katch-McArdle (Athletes)',
              since: 'Since 1985',
              description:
                  'Based on lean body mass. Most accurate for people who know their body fat percentage and are physically active.',
              popularity: '⭐️⭐️⭐️',
              accuracy: 'High',
              bestFor: 'Athletes',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CaloriesCalculatorDetails(
                      title: 'Katch-McArdle Calculator',
                      formulaInfo: {
                        'intro':
                            'Precise BMR calculation based on lean body mass - ideal for athletes.',
                        'details':
                            'This formula calculates BMR based on lean body mass rather than total body weight, making it more accurate for people who know their body fat percentage. Its particularly useful for athletes and physically active individuals.',
                        'formula': 'Weight(kg) × (1 - body fat %/100)',
                        'lbmFormula': 'BMR = 370 + (21.6 × lean body mass)',
                      },
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            _buildFormulaCard(
              context,
              color: const Color(0xFF473E99),
              icon: 'assets/caloryCalculator/four.svg',
              title: 'Cunningham (Bodybuilders)',
              since: 'Since 1980',
              description:
                  'Designed for very lean athletes and bodybuilders with low body fat. Uses lean body mass calculation.',
              popularity: '⭐️⭐️',
              accuracy: 'High',
              bestFor: 'Bodybuilders',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CaloriesCalculatorDetails(
                      title: 'Cunningham Calculator',
                      formulaInfo: {
                        'intro':
                            'BMR formula designed for very lean athletes and bodybuilders.',
                        'details':
                            'Developed specifically for very lean individuals with low body fat percentages, this formula provides higher BMR estimates than other equations. Its most accurate for competitive athletes and bodybuilders in contest preparation.',
                        'formula': 'Weight(kg) × (1 - body fat %/100)',
                        'lbmFormula': 'BMR = 500 + (22 × lean body mass)',
                      },
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            _buildFormulaCard(
              context,
              color: const Color(0xFFFFA667),
              icon: 'assets/caloryCalculator/five.svg',
              title: 'Oxford (European)',
              since: 'Since 1980',
              description:
                  'Designed for very lean athletes and bodybuilders with low body fat. Uses lean body mass calculation.',
              popularity: '⭐️⭐️',
              accuracy: 'High',
              bestFor: 'European population',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CaloriesCalculatorDetails(
                      title: 'Oxford Calculator',
                      formulaInfo: {
                        'intro':
                            'Modern BMR formula based on European populations with age considerations.',
                        'details':
                            'Published in 2005, this is one of the more recent BMR formulas. It was developed using data from European populations and takes age brackets into account, providing different equations for people under and over 30 years old.',
                        'men':
                            'BMR = 662 - (9.53 × age) + PA × (15.91 × weight + 539.6 × height)',
                        'women':
                            'BMR = 354 - (6.91 × age) + PA × (9.36 × weight + 726 × height)',
                      },
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            _buildFormulaCard(
              context,
              color: const Color(0xFF3E8799),
              icon: 'assets/caloryCalculator/six.svg',
              title: 'Compare All Formulas',
              since: 'Since 1980',
              description:
                  'Designed for very lean athletes and bodybuilders with low body fat. Uses lean body mass calculation.',
              popularity: '⭐️⭐️⭐️⭐️⭐️',
              accuracy: 'High',
              bestFor: 'Compare all',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CaloriesCalculatorDetails(
                      title: 'Compare All BMR Formulas',
                      formulaInfo: {
                        'intro':
                            'See how different BMR formulas calculate your calorie needs side by side.',
                        'details':
                            'Enter your details once and see how all major BMR formulas calculate your daily calorie needs. This helps you understand the differences and choose the most suitable formula for your goals.',
                      },
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Color(0xFF0C1226),
            //     borderRadius: BorderRadius.circular(12),
            //     border: Border.all(color: Color(0xff003562), width: 2),
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const Text(
            //         'Which Formula Should I Choose?',
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontSize: 14,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       const SizedBox(height: 8),
            //       const Text(
            //         "Different formulas work better for different people. Here's a quick guide to help you choose:",
            //         style: TextStyle(color: Colors.white70, fontSize: 12),
            //       ),
            //       const SizedBox(height: 14),
            //
            //       // 🔹 Mifflin-St Jeor
            //       Row(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: const [
            //           Padding(
            //             padding: EdgeInsets.only(top: 6),
            //             child: Icon(
            //               Icons.circle,
            //               color: Color(0xFF4F83FF),
            //               size: 6,
            //             ),
            //           ),
            //           SizedBox(width: 8),
            //           Expanded(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   'Mifflin-St Jeor (Recommended):',
            //                   style: TextStyle(
            //                     color: Colors.white,
            //                     fontWeight: FontWeight.w600,
            //                     fontSize: 12,
            //                   ),
            //                 ),
            //                 SizedBox(height: 4),
            //                 Text(
            //                   'Best overall formula, most accurate for general population',
            //                   style: TextStyle(
            //                     color: Colors.white70,
            //                     fontSize: 12,
            //                     height: 1.4,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 10),
            //
            //       // 🔹 Harris-Benedict
            //       Row(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: const [
            //           Padding(
            //             padding: EdgeInsets.only(top: 6),
            //             child: Icon(
            //               Icons.circle,
            //               color: Color(0xFF4F83FF),
            //               size: 6,
            //             ),
            //           ),
            //           SizedBox(width: 8),
            //           Expanded(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   'Harris-Benedict (Classic):',
            //                   style: TextStyle(
            //                     color: Colors.white,
            //                     fontWeight: FontWeight.w600,
            //                     fontSize: 12,
            //                   ),
            //                 ),
            //                 SizedBox(height: 4),
            //                 Text(
            //                   'Classic formula, widely used but slightly less accurate',
            //                   style: TextStyle(
            //                     color: Colors.white70,
            //                     fontSize: 12,
            //                     height: 1.4,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //       const SizedBox(height: 10),
            //
            //       // 🔹 Katch-McArdle
            //       Row(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: const [
            //           Padding(
            //             padding: EdgeInsets.only(top: 6),
            //             child: Icon(
            //               Icons.circle,
            //               color: Color(0xFF4F83FF),
            //               size: 6,
            //             ),
            //           ),
            //           SizedBox(width: 8),
            //           Expanded(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   'Katch-McArdle (Athletes):',
            //                   style: TextStyle(
            //                     color: Colors.white,
            //                     fontWeight: FontWeight.w600,
            //                     fontSize: 12,
            //                   ),
            //                 ),
            //                 SizedBox(height: 4),
            //                 Text(
            //                   'Most accurate if you know your body fat percentage',
            //                   style: TextStyle(
            //                     color: Colors.white70,
            //                     fontSize: 12,
            //                     height: 1.4,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card(
                  context,
                ), // card background for light/dark
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border(context), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Which Formula Should I Choose?',
                    style: TextStyle(
                      color: AppColors.text(context),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Different formulas work better for different people. Here's a quick guide to help you choose:",
                    style: TextStyle(
                      color: AppColors.subText(context),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 🔹 Mifflin-St Jeor
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Icon(
                          Icons.circle,
                          color: Colors
                              .blue
                              .shade400, // you can create a global functional color if needed
                          size: 6,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mifflin-St Jeor (Recommended):',
                              style: TextStyle(
                                color: AppColors.text(context),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Best overall formula, most accurate for general population',
                              style: TextStyle(
                                color: AppColors.subText(context),
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 🔹 Harris-Benedict
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Icon(
                          Icons.circle,
                          color: Colors.blue.shade400,
                          size: 6,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Harris-Benedict (Classic):',
                              style: TextStyle(
                                color: AppColors.text(context),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Classic formula, widely used but slightly less accurate',
                              style: TextStyle(
                                color: AppColors.subText(context),
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 🔹 Katch-McArdle
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Icon(
                          Icons.circle,
                          color: Colors.blue.shade400,
                          size: 6,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Katch-McArdle (Athletes):',
                              style: TextStyle(
                                color: AppColors.text(context),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Most accurate if you know your body fat percentage',
                              style: TextStyle(
                                color: AppColors.subText(context),
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildFormulaCard(
  //   BuildContext context, {
  //   required Color color,
  //   required String icon,
  //   required String title,
  //   required String since,
  //   required String description,
  //   required String popularity,
  //   required String accuracy,
  //   required String bestFor,
  //   VoidCallback? onTap,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: Container(
  //       height: 280,
  //       padding: const EdgeInsets.all(14),
  //       decoration: BoxDecoration(
  //         color: const Color(0xFF1C1C1E),
  //         borderRadius: BorderRadius.circular(14),
  //         border: Border.all(color: Colors.white, width: 1),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Top Row
  //           Row(
  //             children: [
  //               Container(
  //                 width: 58,
  //                 height: 58,
  //                 padding: const EdgeInsets.all(10),
  //                 decoration: BoxDecoration(
  //                   color: color.withOpacity(1),
  //                   borderRadius: BorderRadius.circular(12),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: color.withOpacity(0.5),
  //                       blurRadius: 10,
  //                       spreadRadius: 1,
  //                       offset: const Offset(0, 3),
  //                     ),
  //                   ],
  //                 ),
  //                 child: SvgPicture.asset(
  //                   icon,
  //                   colorFilter: const ColorFilter.mode(
  //                     Colors.white,
  //                     BlendMode.srcIn,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(width: 10),
  //               Expanded(
  //                 child: Text(
  //                   title,
  //                   style: const TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.w700,
  //                     fontSize: 20,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 10),
  //           Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  //             decoration: BoxDecoration(
  //               border: Border.all(color: Colors.white),
  //               borderRadius: BorderRadius.circular(10),
  //               color: Colors.black,
  //             ),
  //             child: Text(
  //               since,
  //               style: const TextStyle(color: Colors.white, fontSize: 11),
  //             ),
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             description,
  //             style: const TextStyle(
  //               color: Colors.white,
  //               fontSize: 12,
  //               height: 1.3,
  //             ),
  //           ),
  //           const SizedBox(height: 10),
  //           const Divider(color: Colors.white10, thickness: 1),
  //           const SizedBox(height: 8),
  //
  //           // Bottom details
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               _buildLabel('Popularity', popularity),
  //               _buildLabel('Accuracy', accuracy),
  //               _buildLabel('Best for', bestFor),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildLabel(String label, String value) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         label,
  //         style: const TextStyle(color: Colors.white54, fontSize: 12),
  //       ),
  //       const SizedBox(height: 4),
  //       Text(
  //         value,
  //         style: const TextStyle(
  //           color: Colors.white,
  //           fontSize: 13,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildFormulaCard(
    BuildContext context, {
    required Color color,
    required String icon,
    required String title,
    required String since,
    required String description,
    required String popularity,
    required String accuracy,
    required String bestFor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 280,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card(context), // card background
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border(context), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row
            Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 1),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    icon,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: AppColors.text(context),
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border(context)),
                borderRadius: BorderRadius.circular(10),
                color: AppColors.card(context), // background of label
              ),
              child: Text(
                since,
                style: TextStyle(
                  color: AppColors.subText(context),
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 12,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 10),
            Divider(
              color: AppColors.divider(context).withValues(alpha: 0.3),
              thickness: 1,
            ),
            const SizedBox(height: 8),

            // Bottom details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLabel(context, 'Popularity', popularity),
                _buildLabel(context, 'Accuracy', accuracy),
                _buildLabel(context, 'Best for', bestFor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.subText(context), fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: AppColors.text(context),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
