import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../theme/color/colors.dart';

class CaloriesCalculatorDetails extends StatefulWidget {
  final String title;
  final Map<String, String> formulaInfo;

  const CaloriesCalculatorDetails({
    super.key,
    required this.title,
    required this.formulaInfo,
  });

  @override
  State<CaloriesCalculatorDetails> createState() =>
      _CaloriesCalculatorDetailsState();
}

class _CaloriesCalculatorDetailsState extends State<CaloriesCalculatorDetails> {
  bool isMale = true;
  bool isMetric = true;
  double age = 20;
  double bodyFat = 20;
  final heightController = TextEditingController(text: '170');
  final weightController = TextEditingController(text: '70');
  final feetController = TextEditingController(text: '5');
  final inchController = TextEditingController(text: '9');
  Map<String, dynamic>? _calorieResult;
  bool showResults = false;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Map<String, dynamic> _comparisonResults = {};

  Color get buttonColor {
    if (widget.title == "Compare All BMR Formulas") {
      return const Color(0xFF16A8CF);
    } else if (widget.title == "Mifflin-St Jeor Calculator") {
      return const Color(0xff60ADEE);
    } else if (widget.title == "Harris-Benedict Calculator") {
      return const Color(0xff2AC26D);
    } else if (widget.title == "Katch-McArdle Calculator") {
      return const Color(0xffFC4929);
    } else if (widget.title == "Cunningham Calculator") {
      return const Color(0xff7C53ED);
    } else if (widget.title == "Oxford Calculator") {
      return const Color(0xff4586F1);
    } else {
      return const Color(0xFF56A8F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      key: navigatorKey,
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
          //   title: Text(
          //     widget.title,
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
                  widget.title,
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
        child: Padding(
          padding: EdgeInsetsGeometry.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  // "The gold standard for BMR calculation -\n most accurate for general population",
                  widget.formulaInfo['intro'] ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    //color: Colors.white,
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: const Color(0xFF0D0D0F),
              //     borderRadius: BorderRadius.circular(12),
              //     border: Border.all(color: Colors.blue, width: 1),
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         // "How the Mifflin-St Jeor Formula Works",
              //         "How the ${widget.title} Formula Works",
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontWeight: FontWeight.w700,
              //           fontSize: 12,
              //         ),
              //       ),
              //       SizedBox(height: 8),
              //       Text(
              //         //"Developed in 1990, this formula is considered the most accurate for calculating Basal Metabolic Rate (BMR) in healthy adults. It’s more precise than the Harris-Benedict equation and is widely recommended by nutritionists and fitness professionals.",
              //         widget.formulaInfo['details'] ?? '',
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontSize: 10,
              //           //height: 1.4,
              //         ),
              //       ),
              //       SizedBox(height: 10),
              //       // Text(
              //       //   // "Men :  BMR = 10 × weight(kg) + 6.25 × height(cm) − 5 × age + 5",
              //       //   "Men :  ${widget.formulaInfo['men'] ?? ''}",
              //       //   style: TextStyle(
              //       //     color: Colors.white,
              //       //     fontSize: 8,
              //       //     fontWeight: FontWeight.w600,
              //       //     height: 1.4,
              //       //   ),
              //       // ),
              //       // SizedBox(height: 4),
              //       // Text(
              //       //   //"Women :  BMR = 10 × weight(kg) + 6.25 × height(cm) − 5 × age − 161",
              //       //   "Women :  ${widget.formulaInfo['women'] ?? ''}",
              //       //   style: TextStyle(
              //       //     color: Colors.white,
              //       //     fontSize: 8,
              //       //     fontWeight: FontWeight.w600,
              //       //   ),
              //       // ),
              //       if (widget.formulaInfo.containsKey('men')) ...[
              //         Text(
              //           "Men : ${widget.formulaInfo['men']}",
              //           style: const TextStyle(
              //             color: Colors.white,
              //             fontSize: 8,
              //             fontWeight: FontWeight.w600,
              //             height: 1.4,
              //           ),
              //         ),
              //         const SizedBox(height: 4),
              //       ],
              //       if (widget.formulaInfo.containsKey('women')) ...[
              //         Text(
              //           "Women : ${widget.formulaInfo['women']}",
              //           style: const TextStyle(
              //             color: Colors.white,
              //             fontSize: 8,
              //             fontWeight: FontWeight.w600,
              //           ),
              //         ),
              //         const SizedBox(height: 8),
              //       ],
              //       if (widget.formulaInfo.containsKey('lbmFormula')) ...[
              //         Text(
              //           "${widget.title}: ${widget.formulaInfo['lbmFormula']}",
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 8,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         // const SizedBox(height: 4),
              //         // Text(
              //         //   widget.formulaInfo['lbmFormula']!,
              //         //   style: const TextStyle(
              //         //     color: Colors.white70,
              //         //     fontSize: 9,
              //         //     height: 1.4,
              //         //   ),
              //         // ),
              //         const SizedBox(height: 8),
              //       ],
              //
              //       if (widget.formulaInfo.containsKey('formula'))
              //         Text(
              //           "Lean Body Mass: : ${widget.formulaInfo['formula']}",
              //           style: const TextStyle(
              //             color: Colors.white,
              //             fontSize: 8,
              //             fontWeight: FontWeight.w600,
              //             height: 1.4,
              //           ),
              //         ),
              //     ],
              //   ),
              // ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card(context), // adaptive background
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border(context)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "How the ${widget.title} Formula Works",
                      style: TextStyle(
                        color: AppColors.text(context), // adaptive title
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      widget.formulaInfo['details'] ?? '',
                      style: TextStyle(
                        color: AppColors.subText(context),
                        fontSize: 10,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ---------------- MEN ----------------
                    if (widget.formulaInfo.containsKey('men')) ...[
                      Text(
                        "Men : ${widget.formulaInfo['men']}",
                        style: TextStyle(
                          color: AppColors.text(context),
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],

                    if (widget.formulaInfo.containsKey('women')) ...[
                      Text(
                        "Women : ${widget.formulaInfo['women']}",
                        style: TextStyle(
                          color: AppColors.text(context),
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    if (widget.formulaInfo.containsKey('lbmFormula')) ...[
                      Text(
                        "${widget.title}: ${widget.formulaInfo['lbmFormula']}",
                        style: TextStyle(
                          color: AppColors.text(context),
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    if (widget.formulaInfo.containsKey('formula'))
                      Text(
                        "Lean Body Mass: ${widget.formulaInfo['formula']}",
                        style: TextStyle(
                          color: AppColors.text(context),
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border(context)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // GENDER
                    Text(
                      "GENDER",
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isMale = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isMale ? Colors.blue : Colors.black,
                                ),
                                color: isMale
                                    ? Colors.blue.withValues(alpha: 0.1)
                                    : Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      boxShadow: isMale
                                          ? [
                                              BoxShadow(
                                                color: Colors.blue.withValues(
                                                  alpha: 0.7,
                                                ),
                                                blurRadius: 8,
                                                spreadRadius: 2,
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/heartRateZoneIcons/male.svg',
                                      height: 18,
                                      // color: AppColors.text(context),
                                      colorFilter: ColorFilter.mode(
                                        AppColors.text(context),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Male',
                                    style: TextStyle(
                                      color: AppColors.text(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isMale = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: !isMale ? Colors.blue : Colors.black,
                                ),
                                color: !isMale
                                    ? Colors.blue.withValues(alpha: 0.1)
                                    : Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      boxShadow: !isMale
                                          ? [
                                              BoxShadow(
                                                color: Colors.blue.withValues(
                                                  alpha: 0.7,
                                                ),
                                                blurRadius: 8,
                                                spreadRadius: 2,
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/heartRateZoneIcons/female.svg',
                                      height: 18,
                                      //color: AppColors.text(context),
                                      colorFilter: ColorFilter.mode(
                                        AppColors.text(context),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Female',
                                    style: TextStyle(
                                      color: AppColors.text(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Text(
                      "UNITS",
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isMetric = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isMetric ? Colors.green : Colors.black,
                                ),
                                color: isMetric
                                    ? Colors.green.withValues(alpha: 0.1)
                                    : Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      boxShadow: isMetric
                                          ? [
                                              BoxShadow(
                                                color: Colors.green.withValues(
                                                  alpha: 0.7,
                                                ),
                                                blurRadius: 8,
                                                spreadRadius: 2,
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/heartRateZoneIcons/metric.svg',
                                      height: 18,
                                      //color: AppColors.text(context),
                                      colorFilter: ColorFilter.mode(
                                        AppColors.text(context),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Metric',
                                    style: TextStyle(
                                      color: AppColors.text(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => isMetric = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: !isMetric
                                      ? Colors.green
                                      : Colors.black,
                                ),
                                color: !isMetric
                                    ? Colors.green.withValues(alpha: 0.1)
                                    : Colors.transparent,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      boxShadow: !isMetric
                                          ? [
                                              BoxShadow(
                                                color: Colors.green.withValues(
                                                  alpha: 0.7,
                                                ),
                                                blurRadius: 8,
                                                spreadRadius: 2,
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/heartRateZoneIcons/imperial.svg',
                                      height: 18,
                                      //color: AppColors.text(context),
                                      colorFilter: ColorFilter.mode(
                                        AppColors.text(context),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Imperial',
                                    style: TextStyle(
                                      color: AppColors.text(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Text(
                      "AGE",
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border(context)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // AGE BOX
                          Container(
                            width: 70,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.border(context),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              age.toInt().toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                // color: Colors.white,
                                color: AppColors.text(context),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // SLIDER
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 6,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 7,
                                    ),
                                    overlayShape:
                                        SliderComponentShape.noOverlay,
                                  ),
                                  child: SizedBox(
                                    height: 30,
                                    child: Slider(
                                      value: age,
                                      min: 13,
                                      max: 100,
                                      divisions: 87,
                                      activeColor: Colors.blue,
                                      inactiveColor: const Color(0xff575B60),
                                      onChanged: (val) {
                                        setState(() => age = val);
                                      },
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "13",
                                        style: TextStyle(
                                          // color: Colors.white70,
                                          color: AppColors.text(context),
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        "100 years",
                                        style: TextStyle(
                                          // color: Colors.white70,
                                          color: AppColors.text(context),
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // if (isMetric) ...[
                    //   _buildInputField("HEIGHT", heightController, "cm"),
                    // ] else ...[
                    //   Text(
                    //     "HEIGHT",
                    //     style: TextStyle(
                    //       // color: Colors.white,
                    //       color: AppColors.text(context),
                    //       fontSize: 10,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    //   const SizedBox(height: 6),
                    //   Row(
                    //     children: [
                    //       Expanded(
                    //         child: Container(
                    //           height: 55,
                    //           padding: const EdgeInsets.symmetric(
                    //             horizontal: 14,
                    //           ),
                    //           decoration: BoxDecoration(
                    //             border: Border.all(
                    //               color: AppColors.border(context),
                    //             ),
                    //             borderRadius: BorderRadius.circular(10),
                    //             color: const Color(0xFF0D0D0F),
                    //           ),
                    //           child: Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               SizedBox(
                    //                 width: 40,
                    //                 child: TextField(
                    //                   controller: feetController,
                    //                   textAlign: TextAlign.left,
                    //                   style: const TextStyle(
                    //                     color: Colors.white,
                    //                     fontSize: 13,
                    //                     fontWeight: FontWeight.w500,
                    //                   ),
                    //                   keyboardType: TextInputType.number,
                    //                   decoration: const InputDecoration(
                    //                     isDense: true,
                    //                     border: InputBorder.none,
                    //                     contentPadding: EdgeInsets.zero,
                    //                   ),
                    //                 ),
                    //               ),
                    //               const Text(
                    //                 "feet",
                    //                 style: TextStyle(
                    //                   color: Colors.white70,
                    //                   fontSize: 12,
                    //                   fontWeight: FontWeight.w500,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       const SizedBox(width: 10),
                    //       // Inches container
                    //       Expanded(
                    //         child: Container(
                    //           height: 55,
                    //           padding: const EdgeInsets.symmetric(
                    //             horizontal: 14,
                    //           ),
                    //           decoration: BoxDecoration(
                    //             border: Border.all(color: Colors.white),
                    //             borderRadius: BorderRadius.circular(10),
                    //             color: const Color(0xFF0D0D0F),
                    //           ),
                    //           child: Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               SizedBox(
                    //                 width: 40,
                    //                 child: TextField(
                    //                   controller: inchController,
                    //                   textAlign: TextAlign.left,
                    //                   style: const TextStyle(
                    //                     color: Colors.white,
                    //                     fontSize: 13,
                    //                     fontWeight: FontWeight.w500,
                    //                   ),
                    //                   keyboardType: TextInputType.number,
                    //                   decoration: const InputDecoration(
                    //                     isDense: true,
                    //                     border: InputBorder.none,
                    //                     contentPadding: EdgeInsets.zero,
                    //                   ),
                    //                 ),
                    //               ),
                    //               const Text(
                    //                 "Inches",
                    //                 style: TextStyle(
                    //                   color: Colors.white70,
                    //                   fontSize: 12,
                    //                   fontWeight: FontWeight.w500,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ],
                    //
                    // const SizedBox(height: 12),
                    //
                    // // WEIGHT
                    // _buildInputField(
                    //   "WEIGHT",
                    //   weightController,
                    //   isMetric ? "kg" : "lbs",
                    // ),
                    if (isMetric) ...[
                      _buildInputField(
                        context,
                        "HEIGHT",
                        heightController,
                        "cm",
                      ),
                    ] else ...[
                      Text(
                        "HEIGHT",
                        style: TextStyle(
                          color: AppColors.text(context),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 55,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.border(context),
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.card(context),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 40,
                                    child: TextField(
                                      controller: feetController,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: AppColors.text(context),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "feet",
                                    style: TextStyle(
                                      color: AppColors.subText(context),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 55,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.border(context),
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.card(context),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 40,
                                    child: TextField(
                                      controller: inchController,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: AppColors.text(context),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Inches",
                                    style: TextStyle(
                                      color: AppColors.subText(context),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: 12),

                    // WEIGHT
                    _buildInputField(
                      context,
                      "WEIGHT",
                      weightController,
                      isMetric ? "kg" : "lbs",
                    ),

                    const SizedBox(height: 16),

                    if (widget.title == "Cunningham Calculator" ||
                        widget.title == "Katch-McArdle Calculator" ||
                        widget.title == "Compare All BMR Formulas") ...[
                      Text(
                        "BODY FAT PERCENTAGE",
                        style: TextStyle(
                          // color: Colors.white,
                          color: AppColors.text(context),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border(context)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // AGE BOX
                            Container(
                              width: 70,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.border(context),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                bodyFat.toInt().toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  // color: Colors.white,
                                  color: AppColors.text(context),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // SLIDER + LABEL COLUMN
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // SLIDER
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      trackHeight: 6,
                                      thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 7,
                                      ),
                                      overlayShape:
                                          SliderComponentShape.noOverlay,
                                    ),
                                    child: SizedBox(
                                      height: 30,
                                      child: Slider(
                                        value: bodyFat,
                                        min: 5,
                                        max: 50,
                                        divisions: 45,
                                        activeColor: const Color(0xffFC4929),
                                        inactiveColor: const Color(0xff575B60),
                                        onChanged: (val) {
                                          setState(() => bodyFat = val);
                                        },
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "5%",
                                          style: TextStyle(
                                            // color: Colors.white70,
                                            color: AppColors.text(context),
                                            fontSize: 10,
                                          ),
                                        ),
                                        Text(
                                          "50%",
                                          style: TextStyle(
                                            //color: Colors.white70,
                                            color: AppColors.text(context),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    Text(
                      "ACTIVITY LEVEL",
                      style: TextStyle(
                        // color: Colors.white,
                        color: AppColors.text(context),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Column(
                      children: [
                        _buildActivityOption(
                          title: "Sedentary",
                          subtitle:
                              "Little to no exercise, desk job, minimal walking",
                          icon: 'assets/heartRateZoneIcons/sedentary.svg',
                          index: 0,
                          group: "activity",
                        ),
                        _buildActivityOption(
                          title: "Lightly Active",
                          subtitle:
                              "Light exercise 1–3 days/week, or daily walking",
                          icon: 'assets/heartRateZoneIcons/lightly_active.svg',
                          index: 1,
                          group: "activity",
                        ),
                        _buildActivityOption(
                          title: "Moderately Active",
                          subtitle:
                              "Moderate exercise 3–5 days/week, active lifestyle",
                          icon:
                              'assets/heartRateZoneIcons/moderately_active.svg',
                          index: 2,
                          group: "activity",
                        ),
                        _buildActivityOption(
                          title: "Very Active",
                          subtitle:
                              "Heavy exercise 6–7 days/week, very active job",
                          icon: 'assets/heartRateZoneIcons/very_active.svg',
                          index: 3,
                          group: "activity",
                        ),
                        _buildActivityOption(
                          title: "Extremely Active",
                          subtitle: "Athlete, physical job + daily training",
                          icon:
                              'assets/heartRateZoneIcons/extremely_active.svg',
                          index: 4,
                          group: "activity",
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Text(
                      "GOAL",
                      style: TextStyle(
                        // color: Colors.white,
                        color: AppColors.text(context),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Column(
                      children: [
                        _buildActivityOption(
                          title: "Lose Weight Fast",
                          subtitle:
                              "Lose 2 lbs(1 kg)per week-Aggressive but effective",
                          icon: 'assets/heartRateZoneIcons/s1.svg',
                          index: 0,
                          group: "goal",
                        ),
                        _buildActivityOption(
                          title: "Lose Weight",
                          subtitle:
                              "Lose 1 lbs(0.5 kg)per week-Sustainable and healthy",
                          icon: 'assets/heartRateZoneIcons/s2.svg',
                          index: 1,
                          group: "goal",
                        ),
                        _buildActivityOption(
                          title: "Maintain Weight",
                          subtitle:
                              "Stay at current weight-Perfect for maninning your shape",
                          icon: 'assets/heartRateZoneIcons/s3.svg',
                          index: 2,
                          group: "goal",
                        ),
                        _buildActivityOption(
                          title: "Gain  Weight",
                          subtitle:
                              "Lose 1 lbs(0.5 kg)per week-Clean muscle building",
                          icon: 'assets/heartRateZoneIcons/s4.svg',
                          index: 3,
                          group: "goal",
                        ),
                        _buildActivityOption(
                          title: "Gain Weight Fast",
                          subtitle:
                              "Gain 2 lbs(1 kg)per week-Maximum muscle growth",
                          icon: 'assets/heartRateZoneIcons/s5.svg',
                          index: 4,
                          group: "goal",
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                // onTap: () {
                //   if (selectedActivity == null || selectedGoal == null) {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(
                //         content: Text(
                //           "Please select activity level and goal first",
                //         ),
                //         backgroundColor: Colors.red,
                //       ),
                //     );
                //     return;
                //   }
                //
                //   double height = isMetric
                //       ? double.tryParse(heightController.text) ?? 0
                //       : ((double.tryParse(feetController.text) ?? 0) * 12) +
                //             (double.tryParse(inchController.text) ?? 0);
                //
                //   double weight = double.tryParse(weightController.text) ?? 0;
                //
                //   final activityOptions = [
                //     "Sedentary",
                //     "Lightly Active",
                //     "Moderately Active",
                //     "Very Active",
                //     "Extremely Active",
                //   ];
                //
                //   final goalOptions = [
                //     "Lose Weight Fast",
                //     "Lose Weight",
                //     "Maintain Weight",
                //     "Gain Weight",
                //     "Gain Weight Fast",
                //   ];
                //
                //   final activity = activityOptions[selectedActivity!];
                //   final goal = goalOptions[selectedGoal!];
                //
                //   // ✅ For Compare Mode
                //   if (widget.title == "Compare All BMR Formulas") {
                //     final formulas = [
                //       "Mifflin-St Jeor",
                //       "Harris-Benedict",
                //       "Katch-McArdle",
                //       "Cunningham",
                //       "Oxford",
                //     ];
                //
                //     Map<String, Map<String, dynamic>> results = {};
                //
                //     for (var f in formulas) {
                //       results[f] = calculateCalorieResult(
                //         isMale: isMale,
                //         isMetric: isMetric,
                //         age: age.toInt(),
                //         height: height,
                //         weight: weight,
                //         activityLevel: activity,
                //         goal: goal,
                //         formulaType: f,
                //         bodyFatPercent:
                //             (f == "Katch-McArdle" || f == "Cunningham")
                //             ? bodyFat
                //             : null,
                //       );
                //     }
                //
                //     // 📊 Compare to Mifflin target calories
                //     double baseCalories =
                //         results["Mifflin-St Jeor"]!["Calories"];
                //
                //     String comparisonText = results.entries
                //         .map((entry) {
                //           final diff = entry.value["Calories"] - baseCalories;
                //           final symbol = diff > 0 ? "+" : "";
                //           return "${entry.key}:\n"
                //               "BMR: ${entry.value["BMR"].toStringAsFixed(0)} kcal\n"
                //               "TDEE: ${entry.value["TDEE"].toStringAsFixed(0)} kcal\n"
                //               "Target: ${entry.value["Calories"].toStringAsFixed(0)} kcal "
                //               "(${symbol}${diff.toStringAsFixed(0)} vs Mifflin)\n";
                //         })
                //         .join("\n");
                //
                //     showDialog(
                //       context: context,
                //       builder: (_) => AlertDialog(
                //         backgroundColor: const Color(0xFF0D0D0F),
                //         title: Text(
                //           "All BMR Formula Comparison (${isMale ? "Male" : "Female"})",
                //           style: const TextStyle(
                //             color: Colors.white,
                //             fontWeight: FontWeight.w600,
                //           ),
                //         ),
                //         content: SingleChildScrollView(
                //           child: Text(
                //             comparisonText,
                //             style: const TextStyle(
                //               color: Colors.white70,
                //               fontSize: 13,
                //               height: 1.5,
                //             ),
                //           ),
                //         ),
                //         actions: [
                //           TextButton(
                //             onPressed: () => Navigator.pop(context),
                //             child: const Text(
                //               "OK",
                //               style: TextStyle(color: Colors.blue),
                //             ),
                //           ),
                //         ],
                //       ),
                //     );
                //
                //     return;
                //   }
                //
                //   // ✅ Normal Single Calculator
                //   final formulaType =
                //       widget.title == "Harris-Benedict Calculator"
                //       ? "Harris-Benedict"
                //       : widget.title == "Katch-McArdle Calculator"
                //       ? "Katch-McArdle"
                //       : widget.title == "Cunningham Calculator"
                //       ? "Cunningham"
                //       : widget.title == "Oxford Calculator"
                //       ? "Oxford"
                //       : "Mifflin-St Jeor";
                //
                //   final result = calculateCalorieResult(
                //     isMale: isMale,
                //     isMetric: isMetric,
                //     age: age.toInt(),
                //     height: height,
                //     weight: weight,
                //     activityLevel: activity,
                //     goal: goal,
                //     formulaType: formulaType,
                //     bodyFatPercent:
                //         (formulaType == "Katch-McArdle" ||
                //             formulaType == "Cunningham")
                //         ? bodyFat
                //         : null,
                //   );
                //
                //   showDialog(
                //     context: context,
                //     builder: (_) => AlertDialog(
                //       backgroundColor: const Color(0xFF0D0D0F),
                //       title: Text(
                //         "${widget.title} Result (${isMale ? "Male" : "Female"})",
                //         style: const TextStyle(color: Colors.white),
                //       ),
                //       content: Text(
                //         "BMR: ${result['BMR'].toStringAsFixed(0)} kcal\n"
                //         "TDEE: ${result['TDEE'].toStringAsFixed(0)} kcal\n"
                //         "Target: ${result['Calories'].toStringAsFixed(0)} kcal/day\n\n"
                //         "Protein: ${result['Protein (g)'].toStringAsFixed(0)} g "
                //         "(${result['Protein (kcal)'].toStringAsFixed(0)} kcal)\n"
                //         "Carbs: ${result['Carbs (g)'].toStringAsFixed(0)} g "
                //         "(${result['Carbs (kcal)'].toStringAsFixed(0)} kcal)\n"
                //         "Fats: ${result['Fats (g)'].toStringAsFixed(0)} g "
                //         "(${result['Fats (kcal)'].toStringAsFixed(0)} kcal)",
                //         style: const TextStyle(
                //           color: Colors.white70,
                //           fontSize: 13,
                //         ),
                //       ),
                //       actions: [
                //         TextButton(
                //           onPressed: () => Navigator.pop(context),
                //           child: const Text(
                //             "OK",
                //             style: TextStyle(color: Colors.blue),
                //           ),
                //         ),
                //       ],
                //     ),
                //   );
                // },
                onTap: () {
                  if (selectedActivity == null || selectedGoal == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Please select activity level and goal first",
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  double height = isMetric
                      ? double.tryParse(heightController.text) ?? 0
                      : ((double.tryParse(feetController.text) ?? 0) * 12) +
                            (double.tryParse(inchController.text) ?? 0);

                  double weight = double.tryParse(weightController.text) ?? 0;

                  final activityOptions = [
                    "Sedentary",
                    "Lightly Active",
                    "Moderately Active",
                    "Very Active",
                    "Extremely Active",
                  ];

                  final goalOptions = [
                    "Lose Weight Fast",
                    "Lose Weight",
                    "Maintain Weight",
                    "Gain Weight",
                    "Gain Weight Fast",
                  ];

                  final activity = activityOptions[selectedActivity!];
                  final goal = goalOptions[selectedGoal!];

                  // Base Mifflin–St Jeor (default)
                  final mifflin = calculateCalorieResult(
                    isMale: isMale,
                    isMetric: isMetric,
                    age: age.toInt(),
                    height: height,
                    weight: weight,
                    activityLevel: activity,
                    goal: goal,
                    formulaType: "Mifflin-St Jeor",
                  );

                  // Other formulas for comparison
                  final harris = calculateCalorieResult(
                    isMale: isMale,
                    isMetric: isMetric,
                    age: age.toInt(),
                    height: height,
                    weight: weight,
                    activityLevel: activity,
                    goal: goal,
                    formulaType: "Harris-Benedict",
                  );

                  final katch = calculateCalorieResult(
                    isMale: isMale,
                    isMetric: isMetric,
                    age: age.toInt(),
                    height: height,
                    weight: weight,
                    activityLevel: activity,
                    goal: goal,
                    formulaType: "Katch-McArdle",
                    bodyFatPercent: bodyFat,
                  );

                  final cunningham = calculateCalorieResult(
                    isMale: isMale,
                    isMetric: isMetric,
                    age: age.toInt(),
                    height: height,
                    weight: weight,
                    activityLevel: activity,
                    goal: goal,
                    formulaType: "Cunningham",
                  );

                  final cunninghamBody = calculateCalorieResult(
                    isMale: isMale,
                    isMetric: isMetric,
                    age: age.toInt(),
                    height: height,
                    weight: weight,
                    activityLevel: activity,
                    goal: goal,
                    formulaType: "Cunningham",
                    bodyFatPercent: bodyFat,
                  );

                  setState(() {
                    _calorieResult = mifflin;
                    showResults = true;
                    _comparisonResults = {
                      "mifflin": mifflin,
                      "harris": harris,
                      "katch": katch,
                      "cunningham": cunningham,
                      "cunninghamBody": cunninghamBody,
                    };
                  });
                },

                // onTap: () {
                //   if (selectedActivity == null || selectedGoal == null) {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(
                //         content: Text(
                //           "Please select activity level and goal first",
                //         ),
                //         backgroundColor: Colors.red,
                //       ),
                //     );
                //     return;
                //   }
                //
                //   double height = isMetric
                //       ? double.tryParse(heightController.text) ?? 0
                //       : ((double.tryParse(feetController.text) ?? 0) * 12) +
                //             (double.tryParse(inchController.text) ?? 0);
                //
                //   double weight = double.tryParse(weightController.text) ?? 0;
                //
                //   final activityOptions = [
                //     "Sedentary",
                //     "Lightly Active",
                //     "Moderately Active",
                //     "Very Active",
                //     "Extremely Active",
                //   ];
                //
                //   final goalOptions = [
                //     "Lose Weight Fast",
                //     "Lose Weight",
                //     "Maintain Weight",
                //     "Gain Weight",
                //     "Gain Weight Fast",
                //   ];
                //
                //   final activity = activityOptions[selectedActivity!];
                //   final goal = goalOptions[selectedGoal!];
                //
                //   final formulaType =
                //       widget.title == "Harris-Benedict Calculator"
                //       ? "Harris-Benedict"
                //       : widget.title == "Katch-McArdle Calculator"
                //       ? "Katch-McArdle"
                //       : widget.title == "Cunningham Calculator"
                //       ? "Cunningham"
                //       : widget.title == "Oxford Calculator"
                //       ? "Oxford"
                //       : "Mifflin-St Jeor";
                //
                //   final result = calculateCalorieResult(
                //     isMale: isMale,
                //     isMetric: isMetric,
                //     age: age.toInt(),
                //     height: height,
                //     weight: weight,
                //     activityLevel: activity,
                //     goal: goal,
                //     formulaType: formulaType,
                //     bodyFatPercent:
                //         (formulaType == "Katch-McArdle" ||
                //             formulaType == "Cunningham")
                //         ? bodyFat
                //         : null,
                //   );
                //
                //   // ✅ Update state with real result
                //   setState(() {
                //     _calorieResult = result;
                //     showResults = true;
                //   });
                // },
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    // color: const Color(0xFF56A8F6),
                    color: buttonColor,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/heartRateZoneIcons/prime_calculator.svg',
                        height: 20,
                        //color: Colors.white,
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.title == "Compare All BMR Formulas"
                            ? "Calculate & Compare"
                            : "Calculate",
                        style: const TextStyle(
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
              // if (showResults &&
              //     _calorieResult != null &&
              //     widget.title != "Compare All BMR Formulas")
              //   buildResultsWidget(_calorieResult!),
              // const SizedBox(height: 20),
              if (showResults &&
                  _calorieResult != null &&
                  widget.title != "Compare All BMR Formulas")
                buildResultsWidget1(_calorieResult!),

              if (showResults && widget.title == "Compare All BMR Formulas")
                formulaComparisonWidget(
                  context,
                  mifflinResult: _comparisonResults["mifflin"],
                  harrisResult: _comparisonResults["harris"],
                  katchResult: _comparisonResults["katch"],
                  cunninghamResult: _comparisonResults["cunningham"],
                  cunninghamBodyResult: _comparisonResults["cunninghamBody"],
                ),
            ],
          ),
        ),
      ),
    );
  }

  int? selectedActivity;
  int? selectedGoal;

  // Widget _buildActivityOption({
  //   required String title,
  //   required String subtitle,
  //   required String icon,
  //   required int index,
  //   required String group,
  // }) {
  //   final bool isSelected = group == "activity"
  //       ? selectedActivity == index
  //       : selectedGoal == index;
  //
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         if (group == "activity") {
  //           selectedActivity = index;
  //         } else {
  //           selectedGoal = index;
  //         }
  //       });
  //     },
  //     child: Container(
  //       width: double.infinity,
  //       margin: const EdgeInsets.only(bottom: 8),
  //       padding: const EdgeInsets.all(12),
  //       decoration: BoxDecoration(
  //         color: isSelected
  //             ? Colors.green.withOpacity(0.1)
  //             : Colors.transparent,
  //         borderRadius: BorderRadius.circular(10),
  //         border: Border.all(color: isSelected ? Colors.green : Colors.white),
  //       ),
  //       child: Row(
  //         children: [
  //           SvgPicture.asset(icon, height: 14, color: Colors.white),
  //           const SizedBox(width: 10),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   title,
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.w600,
  //                     fontSize: 12,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 2),
  //                 Text(
  //                   subtitle,
  //                   style: const TextStyle(
  //                     color: Colors.white70,
  //                     fontSize: 9,
  //                     height: 1.2,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildActivityOption({
    required String title,
    required String subtitle,
    required String icon,
    required int index,
    required String group,
  }) {
    final bool isSelected = group == "activity"
        ? selectedActivity == index
        : selectedGoal == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          if (group == "activity") {
            selectedActivity = index;
          } else {
            selectedGoal = index;
          }
        });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondary(context).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.secondary(context)
                : AppColors.border(context),
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: 14,
              //color: AppColors.text(context),
              colorFilter: ColorFilter.mode(
                AppColors.text(context),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.text(context),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.subText(context),
                      fontSize: 9,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildResultsWidget(Map<String, dynamic> result) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(context), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "YOUR RESULTS",
            style: TextStyle(
              color: Color(0xff60ADEE),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // 🔥 BMR
          _buildResultCard(
            iconPath: "assets/heartRateZoneIcons/fireResult.svg",
            label: "BMR",
            value: result["BMR"].toStringAsFixed(0),
            unit: "kcal",
            labelColor: Colors.white,
            numberColor: Colors.white,
            unitColor: Colors.white54,
            iconColor: const Color(0xffFD4B28),
            optionIconPath: "assets/heartRateZoneIcons/info.svg",
          ),
          const SizedBox(height: 12),

          // ❤️‍🔥 TDEE
          _buildResultCard(
            iconPath: "assets/heartRateZoneIcons/tdee.svg",
            label: "TDEE",
            value: result["TDEE"].toStringAsFixed(0),
            unit: "kcal",
            labelColor: Colors.white,
            numberColor: Colors.white,
            unitColor: Colors.white54,
            iconColor: const Color(0xff4AC088),
            optionIconPath: "assets/heartRateZoneIcons/info.svg",
          ),
          const SizedBox(height: 12),

          // 🎯 Target Calories
          _buildResultCard(
            label: "TARGET CALORIES",
            value: result["Calories"].toStringAsFixed(0),
            unit: "kcal",
            labelColor: const Color(0xff60ADEE),
            numberColor: const Color(0xff60ADEE),
            unitColor: Colors.white54,
            isTarget: true,
          ),
          const SizedBox(height: 24),

          // 🍽 Recommended Macros
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Recommended Macros",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showBlurDialog(
                    context: context,
                    title: "Recommended Macros",
                    message:
                        "These macros represent an estimated breakdown of your daily calorie intake:\n\n"
                        "• Protein supports muscle repair and growth.\n"
                        "• Carbohydrates provide energy for your daily activities.\n"
                        "• Fats support hormones and brain function.\n\n"
                        "Adjusting your macros can help you achieve specific fitness goals.",
                  );
                },
                child: SvgPicture.asset(
                  "assets/heartRateZoneIcons/info.svg",
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildMacroBox(
                iconPath: "assets/heartRateZoneIcons/protein.svg",
                label: "Protein",
                grams: "${result["Protein (g)"].toStringAsFixed(0)}g",
                kcal: "${result["Protein (kcal)"].toStringAsFixed(0)} kcal",
                color: const Color(0xFFEF476F),
              ),
              _buildMacroBox(
                iconPath: "assets/heartRateZoneIcons/carbohydrates.svg",
                label: "Carbohydrates",
                grams: "${result["Carbs (g)"].toStringAsFixed(0)}g",
                kcal: "${result["Carbs (kcal)"].toStringAsFixed(0)} kcal",
                color: const Color(0xFFFBB13C),
                iconHeight: 15,
                iconWidth: 10,
              ),
              _buildMacroBox(
                iconPath: "assets/heartRateZoneIcons/fat.svg",
                label: "Fat",
                grams: "${result["Fats (g)"].toStringAsFixed(0)}g",
                kcal: "${result["Fats (kcal)"].toStringAsFixed(0)} kcal",
                color: const Color(0xFF118AB2),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 📘 Bottom Info Note
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xff60ADEE)),
            ),
            child: const Text(
              "These calculations are estimates based on average formulas. "
              "Actual caloric needs may vary based on individual factors. "
              "Consult with a healthcare professional or registered dietitian for personalized advice.",
              style: TextStyle(color: Colors.white, fontSize: 11, height: 1.4),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Widget buildResultsWidget1(Map<String, dynamic> result) {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFF1C1C1E),
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: const Color(0xff60ADEE), width: 1),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           "YOUR RESULTS",
  //           style: TextStyle(
  //             color: Color(0xff60ADEE),
  //             fontSize: 14,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //
  //         // 🔥 BMR
  //         _buildResultCard(
  //           iconPath: "assets/heartRateZoneIcons/fireResult.svg",
  //           label: "BMR",
  //           value: result["BMR"].toStringAsFixed(0),
  //           unit: "kcal",
  //           labelColor: Colors.white,
  //           numberColor: Colors.white,
  //           unitColor: Colors.white54,
  //           iconColor: const Color(0xffFD4B28),
  //           optionIconPath: "assets/heartRateZoneIcons/info.svg",
  //         ),
  //         const SizedBox(height: 12),
  //
  //         // ❤️‍🔥 TDEE
  //         _buildResultCard(
  //           iconPath: "assets/heartRateZoneIcons/tdee.svg",
  //           label: "TDEE",
  //           value: result["TDEE"].toStringAsFixed(0),
  //           unit: "kcal",
  //           labelColor: Colors.white,
  //           numberColor: Colors.white,
  //           unitColor: Colors.white54,
  //           iconColor: const Color(0xff4AC088),
  //           optionIconPath: "assets/heartRateZoneIcons/info.svg",
  //         ),
  //         const SizedBox(height: 12),
  //
  //         // 🎯 Target Calories
  //         _buildResultCard(
  //           label: "TARGET CALORIES",
  //           value: result["Calories"].toStringAsFixed(0),
  //           unit: "kcal",
  //           labelColor: const Color(0xff60ADEE),
  //           numberColor: const Color(0xff60ADEE),
  //           unitColor: Colors.white54,
  //           isTarget: true,
  //         ),
  //         const SizedBox(height: 24),
  //
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 const Text(
  //                   "Recommended Macros",
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 GestureDetector(
  //                   onTap: () {
  //                     showBlurDialog(
  //                       context: context,
  //                       title: "Recommended Macros",
  //                       message:
  //                           "These macros represent an estimated breakdown of your daily calorie intake:\n\n"
  //                           "• Protein supports muscle repair and growth.\n"
  //                           "• Carbohydrates provide energy for your daily activities.\n"
  //                           "• Fats support hormones and brain function.\n\n"
  //                           "Adjusting your macros can help you achieve specific fitness goals.",
  //                     );
  //                   },
  //                   child: SvgPicture.asset(
  //                     "assets/heartRateZoneIcons/info.svg",
  //                     width: 20,
  //                     height: 20,
  //                     colorFilter: const ColorFilter.mode(
  //                       Colors.white,
  //                       BlendMode.srcIn,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //
  //             const SizedBox(height: 12),
  //
  //             // 🤝 Macro Tiles – EXACT LAYOUT FROM YOUR SCREENSHOT
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: _buildMacroBox1(
  //                     iconPath: "assets/heartRateZoneIcons/protein.svg",
  //                     label: "Protein",
  //                     grams: "${result["Protein (g)"].toStringAsFixed(0)}g",
  //                     kcal:
  //                         "${result["Protein (kcal)"].toStringAsFixed(0)} kcal",
  //                     color: const Color(0xFFEF476F),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 12),
  //                 Expanded(
  //                   child: _buildMacroBox1(
  //                     iconPath: "assets/heartRateZoneIcons/carbohydrates.svg",
  //                     label: "Carbohydrates",
  //                     grams: "${result["Carbs (g)"].toStringAsFixed(0)}g",
  //                     kcal: "${result["Carbs (kcal)"].toStringAsFixed(0)} kcal",
  //                     color: const Color(0xFFFBB13C),
  //                     iconHeight: 15,
  //                     iconWidth: 10,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //
  //             const SizedBox(height: 12),
  //
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: _buildMacroBox1(
  //                     iconPath: "assets/heartRateZoneIcons/fat.svg",
  //                     label: "Fat",
  //                     grams: "${result["Fats (g)"].toStringAsFixed(0)}g",
  //                     kcal: "${result["Fats (kcal)"].toStringAsFixed(0)} kcal",
  //                     color: const Color(0xFF118AB2),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 12),
  //                 const Expanded(child: SizedBox()), // empty to align layout
  //               ],
  //             ),
  //           ],
  //         ),
  //
  //         const SizedBox(height: 20),
  //
  //         // 📘 Bottom Info Note
  //         Container(
  //           width: double.infinity,
  //           padding: const EdgeInsets.all(14),
  //           decoration: BoxDecoration(
  //             color: const Color(0xFF2C2C2E),
  //             borderRadius: BorderRadius.circular(10),
  //             border: Border.all(color: const Color(0xff60ADEE)),
  //           ),
  //           child: const Text(
  //             "These calculations are estimates based on average formulas. "
  //             "Actual caloric needs may vary based on individual factors. "
  //             "Consult with a healthcare professional or registered dietitian for personalized advice.",
  //             style: TextStyle(color: Colors.white, fontSize: 11, height: 1.4),
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget buildResultsWidget1(Map<String, dynamic> result) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(context), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "YOUR RESULTS",
            style: TextStyle(
              color: AppColors.secondary(context),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // 🔥 BMR
          _buildResultCard(
            iconPath: "assets/heartRateZoneIcons/fireResult.svg",
            label: "BMR",
            value: result["BMR"].toStringAsFixed(0),
            unit: "kcal",
            labelColor: AppColors.text(context),
            numberColor: AppColors.text(context),
            unitColor: AppColors.subText(context),
            iconColor: const Color(0xffFD4B28),
            optionIconPath: "assets/heartRateZoneIcons/info.svg",
          ),
          const SizedBox(height: 12),

          // ❤️‍🔥 TDEE
          _buildResultCard(
            iconPath: "assets/heartRateZoneIcons/tdee.svg",
            label: "TDEE",
            value: result["TDEE"].toStringAsFixed(0),
            unit: "kcal",
            labelColor: AppColors.text(context),
            numberColor: AppColors.text(context),
            unitColor: AppColors.subText(context),
            iconColor: const Color(0xff4AC088),
            optionIconPath: "assets/heartRateZoneIcons/info.svg",
          ),
          const SizedBox(height: 12),

          // 🎯 Target Calories
          _buildResultCard(
            label: "TARGET CALORIES",
            value: result["Calories"].toStringAsFixed(0),
            unit: "kcal",
            labelColor: AppColors.secondary(context),
            numberColor: AppColors.secondary(context),
            unitColor: AppColors.subText(context),
            isTarget: true,
          ),
          const SizedBox(height: 24),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Recommended Macros",
                    style: TextStyle(
                      color: AppColors.text(context),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showBlurDialog(
                        context: context,
                        title: "Recommended Macros",
                        message:
                            "These macros represent an estimated breakdown of your daily calorie intake:\n\n"
                            "• Protein supports muscle repair and growth.\n"
                            "• Carbohydrates provide energy for your daily activities.\n"
                            "• Fats support hormones and brain function.\n\n"
                            "Adjusting your macros can help you achieve specific fitness goals.",
                      );
                    },
                    child: SvgPicture.asset(
                      "assets/heartRateZoneIcons/info.svg",
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        AppColors.text(context),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 🤝 Macro Tiles (layout with _buildMacroBox1)
              Row(
                children: [
                  Expanded(
                    child: _buildMacroBox1(
                      iconPath: "assets/heartRateZoneIcons/protein.svg",
                      label: "Protein",
                      grams: "${result["Protein (g)"].toStringAsFixed(0)}g",
                      kcal:
                          "${result["Protein (kcal)"].toStringAsFixed(0)} kcal",
                      color: const Color(0xFFEF476F),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMacroBox1(
                      iconPath: "assets/heartRateZoneIcons/carbohydrates.svg",
                      label: "Carbohydrates",
                      grams: "${result["Carbs (g)"].toStringAsFixed(0)}g",
                      kcal: "${result["Carbs (kcal)"].toStringAsFixed(0)} kcal",
                      color: const Color(0xFFFBB13C),
                      iconHeight: 15,
                      iconWidth: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMacroBox1(
                      iconPath: "assets/heartRateZoneIcons/fat.svg",
                      label: "Fat",
                      grams: "${result["Fats (g)"].toStringAsFixed(0)}g",
                      kcal: "${result["Fats (kcal)"].toStringAsFixed(0)} kcal",
                      color: const Color(0xFF118AB2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.secondary(context)),
            ),
            child: Text(
              "These calculations are estimates based on average formulas. "
              "Actual caloric needs may vary based on individual factors. "
              "Consult with a healthcare professional or registered dietitian for personalized advice.",
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 11,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroBox1({
    required String iconPath,
    required String label,
    required String grams,
    required String kcal,
    required Color color,
    double iconWidth = 20,
    double iconHeight = 20,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(context), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    iconPath,
                    width: iconWidth,
                    height: iconHeight,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            grams,
            style: TextStyle(
              color: AppColors.text(context),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Text(
            kcal,
            style: TextStyle(color: AppColors.subText(context), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard({
    String? iconPath,
    required String label,
    required String value,
    required String unit,
    required Color numberColor,
    required Color labelColor,
    required Color unitColor,
    Color? iconColor,
    String? optionIconPath,
    bool isTarget = false,
  }) {
    final Map<String, String> infoMessages = {
      "BMR":
          "BMR (Basal Metabolic Rate) is the number of calories your body needs to maintain basic functions like breathing, heartbeat, and body temperature while at rest.",
      "TDEE":
          "TDEE (Total Daily Energy Expenditure) is the total number of calories you burn per day, including physical activity.",
      "TARGET CALORIES":
          "Target Calories represent your daily goal based on whether you want to lose, maintain, or gain weight.",
    };

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border(context), width: 1),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (iconPath != null && iconPath.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.text(context)).withValues(
                      alpha: 0.15,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    iconPath,
                    width: 18,
                    height: 18,
                    colorFilter: ColorFilter.mode(
                      iconColor ?? AppColors.text(context),
                      BlendMode.srcIn,
                    ),
                  ),
                ),

              if (iconPath != null && iconPath.isNotEmpty)
                const SizedBox(width: 8),

              Text(
                label,
                style: TextStyle(
                  color: labelColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),

              if (optionIconPath != null)
                GestureDetector(
                  onTap: () {
                    String message =
                        infoMessages[label] ??
                        "No additional information available.";

                    showGeneralDialog(
                      context: navigatorKey.currentContext!,
                      barrierLabel: "InfoDialog",
                      barrierDismissible: true,
                      barrierColor: Colors.black.withValues(alpha: 0.3),
                      transitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                          child: Center(
                            child: AlertDialog(
                              backgroundColor: AppColors.card(context),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: Text(
                                label,
                                style: TextStyle(
                                  color: AppColors.text(context),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              content: Text(
                                message,
                                style: TextStyle(
                                  color: AppColors.subText(context),
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    "OK",
                                    style: TextStyle(
                                      color: AppColors.secondary(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: SvgPicture.asset(
                      optionIconPath,
                      width: 20,
                      height: 20,
                      colorFilter: ColorFilter.mode(
                        AppColors.text(context),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            value,
            style: TextStyle(
              color: numberColor,
              fontSize: 22,
              fontWeight: FontWeight.w500,
            ),
          ),

          Text(unit, style: TextStyle(color: unitColor, fontSize: 15)),
        ],
      ),
    );
  }
}

// Widget _buildInputField(
//   String label,
//   TextEditingController controller,
//   String unit,
// ) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         label,
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 10,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//       const SizedBox(height: 6),
//       Container(
//         height: 55,
//         padding: const EdgeInsets.symmetric(horizontal: 14),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.white),
//           borderRadius: BorderRadius.circular(10),
//           color: const Color(0xFF0D0D0F),
//         ),
//         child: Row(
//           //crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SizedBox(
//               width: 80,
//               child: TextField(
//                 controller: controller,
//                 textAlign: TextAlign.left,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                   height: 1.0,
//                 ),
//                 keyboardType: TextInputType.number,
//                 textAlignVertical: TextAlignVertical.center,
//                 decoration: const InputDecoration(
//                   isDense: true,
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.zero,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             Text(
//               unit,
//               style: const TextStyle(
//                 color: Colors.white70,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }

// For metric height or weight
Widget _buildInputField(
  BuildContext context,
  String label,
  TextEditingController controller,
  String unit,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: AppColors.text(context),
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 6),
      Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border(context)),
          borderRadius: BorderRadius.circular(10),
          color: AppColors.card(context),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 80,
              child: TextField(
                controller: controller,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColors.text(context),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                ),
                keyboardType: TextInputType.number,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              unit,
              style: TextStyle(
                color: AppColors.subText(context),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

// For imperial height (feet + inches)
Widget _buildImperialHeightField(
  BuildContext context,
  TextEditingController feetController,
  TextEditingController inchController,
) {
  return Row(
    children: [
      Expanded(
        child: Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border(context)),
            borderRadius: BorderRadius.circular(10),
            color: AppColors.card(context),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 40,
                child: TextField(
                  controller: feetController,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Text(
                "feet",
                style: TextStyle(
                  color: AppColors.subText(context),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border(context)),
            borderRadius: BorderRadius.circular(10),
            color: AppColors.card(context),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 40,
                child: TextField(
                  controller: inchController,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Text(
                "Inches",
                style: TextStyle(
                  color: AppColors.subText(context),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Map<String, dynamic> calculateCalorieResult({
  required bool isMale,
  required bool isMetric,
  required int age,
  required double height,
  required double weight,
  required String activityLevel,
  required String goal,
  required String formulaType,
  double? bodyFatPercent,
}) {
  double heightCm = isMetric ? height : height * 2.54;
  double weightKg = isMetric ? weight : weight * 0.453592;
  double heightM = heightCm / 100;

  // 2️⃣ Base BMR calculation
  double bmr = 0;

  if (formulaType == "Harris-Benedict") {
    if (isMale) {
      bmr = 88.362 + (13.397 * weightKg) + (4.799 * heightCm) - (5.677 * age);
    } else {
      bmr = 447.593 + (9.247 * weightKg) + (3.098 * heightCm) - (4.330 * age);
    }
  } else if (formulaType == "Katch-McArdle") {
    double leanBodyMass = weightKg * (1 - (bodyFatPercent ?? 0) / 100);
    bmr = 370 + (21.6 * leanBodyMass);
  } else if (formulaType == "Cunningham") {
    double leanBodyMass = weightKg * (1 - (bodyFatPercent ?? 0) / 100);
    bmr = 500 + (22 * leanBodyMass);
  } else if (formulaType == "Oxford") {
    // ✅ Oxford (Internal PA) version — matches workout.cool
    // Includes internal PA (~0.7) and later multiplies by activity
    double paInternal = 0.7025;

    if (isMale) {
      // Men: 662 - (9.53 × age) + PA × (15.9 × weight + 539.6 × height)
      bmr =
          662 -
          (9.53 * age) +
          paInternal * ((15.9 * weightKg) + (539.6 * heightM));
    } else {
      // Women: 354 - (6.91 × age) + PA × (9.36 × weight + 726 × height)
      bmr =
          354 -
          (6.91 * age) +
          paInternal * ((9.36 * weightKg) + (726 * heightM));
    }
  } else {
    // 🔹 Mifflin–St Jeor
    if (isMale) {
      bmr = 10 * weightKg + 6.25 * heightCm - 5 * age + 5;
    } else {
      bmr = 10 * weightKg + 6.25 * heightCm - 5 * age - 161;
    }
  }

  // 3️⃣ Activity multiplier (for all except Oxford, handled separately)
  double activityMultiplier;
  switch (activityLevel.toLowerCase()) {
    case "sedentary":
      activityMultiplier = 1.2;
      break;
    case "lightly active":
      activityMultiplier = 1.375;
      break;
    case "moderately active":
      activityMultiplier = 1.55;
      break;
    case "very active":
      activityMultiplier = 1.725;
      break;
    case "extremely active":
      activityMultiplier = 1.9;
      break;
    default:
      activityMultiplier = 1.2;
  }

  double tdee;
  if (formulaType == "Oxford") {
    // Oxford BMR already has internal PA (~0.7), now multiply by external activity
    tdee = bmr * activityMultiplier;
  } else {
    tdee = bmr * activityMultiplier;
  }

  // 4️⃣ Goal adjustment
  double goalCalories = tdee;
  switch (goal.toLowerCase()) {
    case "lose weight fast":
      goalCalories = tdee - 750;
      break;
    case "lose weight":
      goalCalories = tdee - 500;
      break;
    case "gain weight":
      goalCalories = tdee + 500;
      break;
    case "gain weight fast":
      goalCalories = tdee + 750;
      break;
    default:
      goalCalories = tdee;
  }

  // 5️⃣ Fixed macro ratio 30/40/30
  double proteinRatio = 0.30;
  double carbRatio = 0.40;
  double fatRatio = 0.30;

  // 6️⃣ Convert kcal → grams
  double proteinGrams = (goalCalories * proteinRatio) / 4;
  double carbGrams = (goalCalories * carbRatio) / 4;
  double fatGrams = (goalCalories * fatRatio) / 9;

  // 7️⃣ kcal values for macros
  double proteinKcal = proteinGrams * 4;
  double carbKcal = carbGrams * 4;
  double fatKcal = fatGrams * 9;

  return {
    "BMR": bmr,
    "TDEE": tdee,
    "Calories": goalCalories,
    "Protein (g)": proteinGrams,
    "Carbs (g)": carbGrams,
    "Fats (g)": fatGrams,
    "Protein (kcal)": proteinKcal,
    "Carbs (kcal)": carbKcal,
    "Fats (kcal)": fatKcal,
  };
}

// Widget _buildResultCard({
//   String? iconPath,
//   required String label,
//   required String value,
//   required String unit,
//   required Color numberColor,
//   required Color labelColor,
//   required Color unitColor,
//   Color? iconColor,
//   String? optionIconPath,
//   bool isTarget = false,
// }) {
//   return Container(
//     width: double.infinity,
//     decoration: BoxDecoration(
//       color: const Color(0xFF000000),
//       borderRadius: BorderRadius.circular(10),
//       border: Border.all(color: const Color(0xffFFFFFF), width: 1),
//     ),
//     padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//     child: Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // 🔥 Left icon
//             if (iconPath != null && iconPath.isNotEmpty)
//               SvgPicture.asset(
//                 iconPath,
//                 width: 20,
//                 height: 20,
//                 colorFilter: ColorFilter.mode(
//                   iconColor ?? Colors.white,
//                   BlendMode.srcIn,
//                 ),
//               ),
//
//             if (iconPath != null && iconPath.isNotEmpty)
//               const SizedBox(width: 6),
//
//             // 🏷 Label
//             Text(
//               label,
//               style: TextStyle(
//                 color: labelColor,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//
//             // ℹ️ Option icon (right side)
//             if (optionIconPath != null) ...[
//               const SizedBox(width: 6),
//               SvgPicture.asset(
//                 optionIconPath,
//                 width: 20,
//                 height: 20,
//                 colorFilter: const ColorFilter.mode(
//                   Colors.white,
//                   BlendMode.srcIn,
//                 ),
//               ),
//             ],
//           ],
//         ),
//
//         const SizedBox(height: 8),
//
//         // 🔢 Value
//         Text(
//           value,
//           style: TextStyle(
//             color: numberColor,
//             fontSize: 22,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//
//         // ⚡ kcal
//         Text(unit, style: TextStyle(color: unitColor, fontSize: 15)),
//       ],
//     ),
//   );
// }

// Widget _buildResultCard({
//   String? iconPath,
//   required String label,
//   required String value,
//   required String unit,
//   required Color numberColor,
//   required Color labelColor,
//   required Color unitColor,
//   Color? iconColor,
//   String? optionIconPath,
//   bool isTarget = false,
// }) {
//   final Map<String, String> infoMessages = {
//     "BMR":
//         "BMR (Basal Metabolic Rate) is the number of calories your body needs to maintain basic functions like breathing, heartbeat, and body temperature while at rest.",
//     "TDEE":
//         "TDEE (Total Daily Energy Expenditure) is the total number of calories you burn per day, including physical activity.",
//     "TARGET CALORIES":
//         "Target Calories represent your daily goal based on whether you want to lose, maintain, or gain weight.",
//   };
//
//   return Container(
//     width: double.infinity,
//     decoration: BoxDecoration(
//       color: const Color(0xFF000000),
//       borderRadius: BorderRadius.circular(10),
//       border: Border.all(color: const Color(0xffFFFFFF), width: 1),
//     ),
//     padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//     child: Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // 🔥 Left icon inside a colored background container with opacity
//             if (iconPath != null && iconPath.isNotEmpty)
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(
//                   color: (iconColor ?? Colors.white).withOpacity(0.15),
//                   shape: BoxShape.circle,
//                 ),
//                 child: SvgPicture.asset(
//                   iconPath,
//                   width: 18,
//                   height: 18,
//                   colorFilter: ColorFilter.mode(
//                     iconColor ?? Colors.white,
//                     BlendMode.srcIn,
//                   ),
//                 ),
//               ),
//
//             if (iconPath != null && iconPath.isNotEmpty)
//               const SizedBox(width: 8),
//
//             // 🏷 Label
//             Text(
//               label,
//               style: TextStyle(
//                 color: labelColor,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//
//             if (optionIconPath != null)
//               GestureDetector(
//                 onTap: () {
//                   String message =
//                       infoMessages[label] ??
//                       "No additional information available for this section.";
//
//                   showGeneralDialog(
//                     context: navigatorKey.currentContext!,
//                     barrierLabel: "InfoDialog",
//                     barrierDismissible: true,
//                     barrierColor: Colors.black.withOpacity(
//                       0.3,
//                     ), // transparent overlay
//                     transitionDuration: const Duration(milliseconds: 200),
//                     pageBuilder: (context, animation, secondaryAnimation) {
//                       return BackdropFilter(
//                         filter: ImageFilter.blur(
//                           sigmaX: 6,
//                           sigmaY: 6,
//                         ), // 🌫 blur background
//                         child: Center(
//                           child: AlertDialog(
//                             backgroundColor: const Color(0xFF1C1C1E),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             title: Text(
//                               label,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                             content: Text(
//                               message,
//                               style: const TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 13,
//                                 height: 1.4,
//                               ),
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () => Navigator.pop(context),
//                                 child: const Text(
//                                   "OK",
//                                   style: TextStyle(color: Color(0xff60ADEE)),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 6),
//                   child: SvgPicture.asset(
//                     optionIconPath,
//                     width: 20,
//                     height: 20,
//                     colorFilter: const ColorFilter.mode(
//                       Colors.white,
//                       BlendMode.srcIn,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//
//         const SizedBox(height: 8),
//
//         // 🔢 Value
//         Text(
//           value,
//           style: TextStyle(
//             color: numberColor,
//             fontSize: 22,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//
//         // ⚡ kcal
//         Text(unit, style: TextStyle(color: unitColor, fontSize: 15)),
//       ],
//     ),
//   );
// }

Widget _buildMacroBox({
  required String iconPath,
  required String label,
  required String grams,
  required String kcal,
  required Color color,
  double iconWidth = 20,
  double iconHeight = 20,
}) {
  return Container(
    // width: 135,
    // height: 106,
    decoration: BoxDecoration(
      color: const Color(0xFF000000),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFFFFFFFF), width: 1),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                iconPath,
                width: iconWidth,
                height: iconHeight,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          grams,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(kcal, style: const TextStyle(color: Colors.white54, fontSize: 15)),
      ],
    ),
  );
}

// Widget _buildMacroBox1({
//   required String iconPath,
//   required String label,
//   required String grams,
//   required String kcal,
//   required Color color,
//   double iconWidth = 20,
//   double iconHeight = 20,
// }) {
//   return Container(
//     padding: const EdgeInsets.all(14),
//     decoration: BoxDecoration(
//       color: const Color(0xFF1A1A1C),
//       borderRadius: BorderRadius.circular(12),
//       border: Border.all(color: Colors.white, width: 1),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Container(
//               width: 30,
//               height: 30,
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               alignment: Alignment.center,
//               child: SvgPicture.asset(
//                 iconPath,
//                 width: iconWidth,
//                 height: iconHeight,
//                 colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
//               ),
//             ),
//             const SizedBox(width: 8),
//             Text(
//               label,
//               style: TextStyle(
//                 color: color,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 10,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Text(
//           grams,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//             fontSize: 16,
//           ),
//         ),
//         Text(kcal, style: const TextStyle(color: Colors.white54, fontSize: 12)),
//       ],
//     ),
//   );
// }

Widget formulaComparisonWidget(
  BuildContext context, {
  required Map<String, dynamic> mifflinResult,
  required Map<String, dynamic> harrisResult,
  required Map<String, dynamic> katchResult,
  required Map<String, dynamic> cunninghamResult,
  required Map<String, dynamic> cunninghamBodyResult,
}) {
  int getCal(Map r) => (r['targetCalories'] ?? r['Calories'] ?? 0).round();
  int getBmr(Map r) => (r['bmr'] ?? r['BMR'] ?? 0).round();
  int getTdee(Map r) => (r['tdee'] ?? r['TDEE'] ?? 0).round();

  final mifCal = getCal(mifflinResult);
  final harCal = getCal(harrisResult);
  final katCal = getCal(katchResult);
  final cunCal = getCal(cunninghamResult);
  final cunBodyCal = getCal(cunninghamBodyResult);

  String diffText(int cal) {
    if (mifCal == 0) return "0 cal (0%)";
    final diffCal = cal - mifCal;
    final diffPercent = (((cal / mifCal) - 1) * 100).round();
    final calSign = diffCal > 0 ? "+" : "";
    final percentSign = diffPercent > 0 ? "+" : "";
    return "$calSign$diffCal cal ($percentSign$diffPercent%)";
  }

  final formulas = [
    {
      "rank": "#1",
      "name": "Mifflin-St Jeor (Recommended)",
      "color": Colors.blueAccent,
      "cal": "$mifCal cal",
      "bmr": "${getBmr(mifflinResult)} BMR",
      "tdee": "${getTdee(mifflinResult)} TDEE",
      "diff": "Reference",
    },
    {
      "rank": "#2",
      "name": "Harris-Benedict (Classic)",
      "color": Colors.greenAccent.shade400,
      "cal": "$harCal cal",
      "bmr": "${getBmr(harrisResult)} BMR",
      "tdee": "${getTdee(harrisResult)} TDEE",
      "diff": diffText(harCal),
    },
    {
      "rank": "#3",
      "name": "Katch-McArdle (Athletes)",
      "color": Colors.redAccent,
      "cal": "$katCal cal",
      "bmr": "${getBmr(katchResult)} BMR",
      "tdee": "${getTdee(katchResult)} TDEE",
      "diff": diffText(katCal),
    },
    {
      "rank": "#4",
      "name": "Cunningham (Bodybuilders)",
      "color": Colors.purpleAccent,
      "cal": "$cunCal cal",
      "bmr": "${getBmr(cunninghamResult)} BMR",
      "tdee": "${getTdee(cunninghamResult)} TDEE",
      "diff": diffText(cunCal),
    },
    {
      "rank": "#5",
      "name": "Cunningham (Lean Mass)",
      "color": Colors.orangeAccent,
      "cal": "$cunBodyCal cal",
      "bmr": "${getBmr(cunninghamBodyResult)} BMR",
      "tdee": "${getTdee(cunninghamBodyResult)} TDEE",
      "diff": diffText(cunBodyCal),
    },
  ];

  final cardColor = Theme.of(
    context,
  ).cardColor; // background of each formula card
  final borderColor = Theme.of(context).dividerColor; // card borders
  final textColor =
      Theme.of(context).textTheme.bodyLarge!.color ?? Colors.white;
  final subTextColor =
      Theme.of(context).textTheme.bodySmall!.color ?? Colors.white54;
  final summaryCardColor = Theme.of(context).canvasColor;

  return SingleChildScrollView(
    padding: const EdgeInsets.all(5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Formula Comparison Results",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        const SizedBox(height: 12),

        ...formulas.map(
          (f) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 35,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: (f["color"] as Color),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          f["rank"].toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        f["name"].toString(),
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  f["cal"].toString(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  "Target calories",
                  style: TextStyle(fontSize: 13, color: subTextColor),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      f["bmr"].toString(),
                      style: TextStyle(color: textColor),
                    ),
                    Text(
                      f["tdee"].toString(),
                      style: TextStyle(color: textColor),
                    ),
                  ],
                ),
                if (f["diff"] != "Reference") ...[
                  Divider(color: borderColor, thickness: 1.2),
                  Text(
                    "vs Mifflin-St Jeor",
                    style: TextStyle(color: subTextColor, fontSize: 12),
                  ),
                  Text(
                    f["diff"].toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: f["diff"].toString().contains("-")
                          ? Colors.greenAccent
                          : Colors.redAccent,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        Container(
          decoration: BoxDecoration(
            color: summaryCardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border(context)),
          ),
          padding: const EdgeInsets.all(16),
          child: Text(
            "Summary & Recommendations\n\n"
            "Different formulas give slightly varying results. "
            "Mifflin–St Jeor and Katch–McArdle are commonly used and expected.\n\n"
            "For most people, Mifflin–St Jeor provides the most balanced estimate. "
            "Athletes may prefer the Katch–McArdle formula if they know their body fat percentage.",
            style: TextStyle(color: textColor, fontSize: 14, height: 1.5),
          ),
        ),
      ],
    ),
  );
}

// Widget formulaComparisonWidget(
//   BuildContext context, {
//   required Map<String, dynamic> mifflinResult,
//   required Map<String, dynamic> harrisResult,
//   required Map<String, dynamic> katchResult,
//   required Map<String, dynamic> cunninghamResult,
//   required Map<String, dynamic> cunninghamBodyResult,
// }) {
//   int getCal(Map r) => (r['targetCalories'] ?? r['Calories'] ?? 0).round();
//   int getBmr(Map r) => (r['bmr'] ?? r['BMR'] ?? 0).round();
//   int getTdee(Map r) => (r['tdee'] ?? r['TDEE'] ?? 0).round();
//
//   final mifCal = getCal(mifflinResult);
//   final harCal = getCal(harrisResult);
//   final katCal = getCal(katchResult);
//   final cunCal = getCal(cunninghamResult);
//   final cunBodyCal = getCal(cunninghamBodyResult);
//
//   String diffText(int cal) {
//     if (mifCal == 0) return "0 cal (0%)";
//
//     final diffCal = cal - mifCal;
//     final diffPercent = (((cal / mifCal) - 1) * 100).round();
//
//     final calSign = diffCal > 0 ? "+" : "";
//     final percentSign = diffPercent > 0 ? "+" : "";
//
//     return "$calSign$diffCal cal ($percentSign$diffPercent%)";
//   }
//
//   final formulas = [
//     {
//       "rank": "#1",
//       "name": "Mifflin-St Jeor (Recommended)",
//       "color": Colors.blueAccent,
//       "cal": "$mifCal cal",
//       "bmr": "${getBmr(mifflinResult)} BMR",
//       "tdee": "${getTdee(mifflinResult)} TDEE",
//       "diff": "Reference",
//     },
//     {
//       "rank": "#2",
//       "name": "Harris-Benedict (Classic)",
//       "color": Colors.greenAccent.shade400,
//       "cal": "$harCal cal",
//       "bmr": "${getBmr(harrisResult)} BMR",
//       "tdee": "${getTdee(harrisResult)} TDEE",
//       "diff": diffText(harCal),
//     },
//     {
//       "rank": "#3",
//       "name": "Katch-McArdle (Athletes)",
//       "color": Colors.redAccent,
//       "cal": "$katCal cal",
//       "bmr": "${getBmr(katchResult)} BMR",
//       "tdee": "${getTdee(katchResult)} TDEE",
//       "diff": diffText(katCal),
//     },
//     {
//       "rank": "#4",
//       "name": "Cunningham (Bodybuilders)",
//       "color": Colors.purpleAccent,
//       "cal": "$cunCal cal",
//       "bmr": "${getBmr(cunninghamResult)} BMR",
//       "tdee": "${getTdee(cunninghamResult)} TDEE",
//       "diff": diffText(cunCal),
//     },
//     {
//       "rank": "#5",
//       "name": "Cunningham (Lean Mass)",
//       "color": Colors.orangeAccent,
//       "cal": "$cunBodyCal cal",
//       "bmr": "${getBmr(cunninghamBodyResult)} BMR",
//       "tdee": "${getTdee(cunninghamBodyResult)} TDEE",
//       "diff": diffText(cunBodyCal),
//     },
//   ];
//
//   return SingleChildScrollView(
//     padding: const EdgeInsets.all(5),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Formula Comparison Results",
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.w500,
//             color: Colors.white,
//           ),
//         ),
//         const SizedBox(height: 12),
//
//         ...formulas.map(
//           (f) => Container(
//             margin: const EdgeInsets.only(bottom: 12),
//             decoration: BoxDecoration(
//               color: const Color(0xFF1E1E1E),
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(color: Colors.white),
//             ),
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Container(
//                       height: 35,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: (f["color"] as Color),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Center(
//                         child: Text(
//                           f["rank"].toString(),
//                           style: TextStyle(
//                             fontSize: 16,
//                             // color: f["color"] as Color,
//                             color: Colors.white,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         f["name"].toString(),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 8),
//
//                 Text(
//                   f["cal"].toString(),
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//
//                 Text(
//                   "Target calories",
//                   style: const TextStyle(fontSize: 13, color: Colors.white),
//                 ),
//
//                 const SizedBox(height: 8),
//
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       f["bmr"].toString(),
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                     Text(
//                       f["tdee"].toString(),
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ],
//                 ),
//
//                 // const Divider(color: Colors.white, thickness: 1.2),
//                 //
//                 // const Text(
//                 //   "vs Mifflin-St Jeor",
//                 //   style: TextStyle(color: Colors.white, fontSize: 12),
//                 // ),
//                 //
//                 // Text(
//                 //   f["diff"].toString(),
//                 //   style: TextStyle(
//                 //     fontSize: 12,
//                 //     color: f["diff"].toString().contains("-")
//                 //         ? Colors.greenAccent
//                 //         : Colors.redAccent,
//                 //   ),
//                 // ),
//                 if (f["diff"] != "Reference") ...[
//                   const Divider(color: Colors.white, thickness: 1.2),
//
//                   const Text(
//                     "vs Mifflin-St Jeor",
//                     style: TextStyle(color: Colors.white, fontSize: 12),
//                   ),
//
//                   Text(
//                     f["diff"].toString(),
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: f["diff"].toString().contains("-")
//                           ? Colors.greenAccent
//                           : Colors.redAccent,
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//
//         Container(
//           decoration: BoxDecoration(
//             color: const Color(0xFF1E1E2E),
//             borderRadius: BorderRadius.circular(16),
//           ),
//           padding: const EdgeInsets.all(16),
//           child: const Text(
//             "Summary & Recommendations\n\n"
//             "Different formulas give slightly varying results. "
//             "Mifflin–St Jeor and Katch–McArdle are commonly used and expected.\n\n"
//             "For most people, Mifflin–St Jeor provides the most balanced estimate. "
//             "Athletes may prefer the Katch–McArdle formula if they know their body fat percentage.",
//             style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
//           ),
//         ),
//       ],
//     ),
//   );
// }

void showBlurDialog({
  required BuildContext context,
  required String title,
  required String message,
}) {
  showGeneralDialog(
    context: context,
    barrierLabel: "InfoDialog",
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.3),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (_, _, _) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Center(
          child: AlertDialog(
            backgroundColor: const Color(0xFF1C1C1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            content: Text(
              message,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "OK",
                  style: TextStyle(color: Color(0xff60ADEE)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
