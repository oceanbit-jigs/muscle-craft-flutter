import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../theme/color/colors.dart';

class BmiCalculatorsScreen extends StatefulWidget {
  const BmiCalculatorsScreen({super.key});

  @override
  State<BmiCalculatorsScreen> createState() => _BmiCalculatorsScreenState();
}

class _BmiCalculatorsScreenState extends State<BmiCalculatorsScreen> {
  bool isMetric = true;

  final heightController = TextEditingController(text: '170');
  final weightController = TextEditingController(text: '70');
  final feetController = TextEditingController(text: '5');
  final inchController = TextEditingController(text: '7');
  final lbsController = TextEditingController(text: '154.3');

  @override
  void initState() {
    super.initState();

    // Add listeners for real-time BMI update
    heightController.addListener(_updateBMI);
    weightController.addListener(_updateBMI);
    feetController.addListener(_updateBMI);
    inchController.addListener(_updateBMI);
    lbsController.addListener(_updateBMI);
  }

  @override
  void dispose() {
    heightController.removeListener(_updateBMI);
    weightController.removeListener(_updateBMI);
    feetController.removeListener(_updateBMI);
    inchController.removeListener(_updateBMI);
    lbsController.removeListener(_updateBMI);
    super.dispose();
  }

  void _updateBMI() {
    setState(() {}); // triggers rebuild so the BMI widget updates automatically
  }

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
          //     'Standard BMI Calculator',
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
                  "Standard BMI Calculator",
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                );
              },
            ),
            centerTitle: true,
          ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Calculate your Body Mass Index using\n'
              'the standard WHO formula. Get\n'
              'instant results with health category\n'
              'and personalized recommendations.',
              textAlign: TextAlign.center,
              style: TextStyle(
                // color: Colors.white,
                color: isDark ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            buildUnitSelectionWidget(context),
            SizedBox(height: 20),
            buildBmiResultWidget(),
          ],
        ),
      ),
    );
  }

  // Widget buildUnitSelectionWidget(BuildContext context) {
  //   Widget buildMetricField(String unit, TextEditingController controller) {
  //     return Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 16),
  //       decoration: BoxDecoration(
  //         color: const Color(0xFF3A3A3C),
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(color: Colors.white),
  //       ),
  //       child: Row(
  //         children: [
  //           Expanded(
  //             child: TextField(
  //               controller: controller,
  //               style: const TextStyle(color: Colors.white, fontSize: 14),
  //               keyboardType: TextInputType.number,
  //               decoration: const InputDecoration(border: InputBorder.none),
  //             ),
  //           ),
  //           Text(
  //             unit,
  //             style: const TextStyle(color: Colors.white, fontSize: 13),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //
  //   Widget buildImperialHeight() {
  //     return Row(
  //       children: [
  //         Expanded(child: buildMetricField("ft", feetController)),
  //         const SizedBox(width: 10),
  //         Expanded(child: buildMetricField("in", inchController)),
  //       ],
  //     );
  //   }
  //
  //   return Container(
  //     padding: const EdgeInsets.all(14),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFF1C1C1E),
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(color: Colors.white),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           "UNITS",
  //           style: TextStyle(color: Colors.white, fontSize: 10),
  //         ),
  //         const SizedBox(height: 8),
  //
  //         Container(
  //           decoration: BoxDecoration(
  //             border: Border.all(color: Colors.white),
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Row(
  //             children: [
  //               Expanded(
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     if (!isMetric) {
  //                       // Convert Imperial → Metric
  //                       double feet = double.tryParse(feetController.text) ?? 0;
  //                       double inches =
  //                           double.tryParse(inchController.text) ?? 0;
  //                       double totalInches = (feet * 12) + inches;
  //                       double cm = totalInches * 2.54;
  //
  //                       double lbs = double.tryParse(lbsController.text) ?? 0;
  //                       double kg = lbs / 2.20462;
  //
  //                       // Round to nearest integer
  //                       heightController.text = cm.round().toString();
  //                       weightController.text = kg.round().toString();
  //                     }
  //                     setState(() => isMetric = true);
  //                   },
  //                   child: Container(
  //                     padding: const EdgeInsets.symmetric(vertical: 10),
  //                     decoration: BoxDecoration(
  //                       color: isMetric
  //                           ? Colors.black
  //                           : const Color(0xFFA1A1A1),
  //                       borderRadius: const BorderRadius.only(
  //                         topLeft: Radius.circular(10),
  //                         bottomLeft: Radius.circular(10),
  //                       ),
  //                     ),
  //                     alignment: Alignment.center,
  //                     child: Text(
  //                       "Metric (kg/cm)",
  //                       style: TextStyle(
  //                         color: isMetric ? Colors.white : Colors.black,
  //                         fontWeight: FontWeight.w500,
  //                         fontSize: 13,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               Expanded(
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     if (isMetric) {
  //                       // Convert Metric → Imperial
  //                       double cm = double.tryParse(heightController.text) ?? 0;
  //                       double inches = cm / 2.54;
  //                       int feet = (inches ~/ 12);
  //                       double remainingInches = inches - (feet * 12);
  //
  //                       double kg = double.tryParse(weightController.text) ?? 0;
  //                       double lbs = kg * 2.20462;
  //
  //                       // Round all values to nearest whole number
  //                       feetController.text = feet.toString();
  //                       inchController.text = remainingInches
  //                           .round()
  //                           .toString();
  //                       lbsController.text = lbs.round().toString();
  //                     }
  //                     setState(() => isMetric = false);
  //                   },
  //                   child: Container(
  //                     padding: const EdgeInsets.symmetric(vertical: 10),
  //                     decoration: BoxDecoration(
  //                       color: !isMetric
  //                           ? Colors.black
  //                           : const Color(0xFFA1A1A1),
  //                       borderRadius: const BorderRadius.only(
  //                         topRight: Radius.circular(10),
  //                         bottomRight: Radius.circular(10),
  //                       ),
  //                     ),
  //                     alignment: Alignment.center,
  //                     child: Text(
  //                       "Imperial (lbs/feet)",
  //                       style: TextStyle(
  //                         color: !isMetric ? Colors.white : Colors.black,
  //                         fontWeight: FontWeight.w500,
  //                         fontSize: 13,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //
  //         const SizedBox(height: 20),
  //
  //         const Text(
  //           "HEIGHT",
  //           style: TextStyle(color: Colors.white, fontSize: 10),
  //         ),
  //         const SizedBox(height: 8),
  //         isMetric
  //             ? buildMetricField("cm", heightController)
  //             : buildImperialHeight(),
  //
  //         const SizedBox(height: 20),
  //
  //         const Text(
  //           "WEIGHT",
  //           style: TextStyle(color: Colors.white, fontSize: 10),
  //         ),
  //         const SizedBox(height: 8),
  //         isMetric
  //             ? buildMetricField("kg", weightController)
  //             : buildMetricField("lbs", lbsController),
  //       ],
  //     ),
  //   );
  // }

  Widget metricFormulaBox(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardDark(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border(context)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Metric Formula",
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "BMI = ",
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 5),
                Column(
                  children: [
                    Text(
                      "weight (kg)",
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "───────────",
                      style: TextStyle(
                        color: AppColors.subText(context),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "height² (m)",
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Center(
            child: Text(
              "Standard international formula using\nkilograms and meters",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.subText(context),
                fontSize: 10,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 10),
          Divider(color: AppColors.divider(context)),
          const SizedBox(height: 10),

          Text(
            "Example:",
            style: TextStyle(
              color: AppColors.text(context),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "22.9 = ",
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 5),
                Column(
                  children: [
                    Text(
                      "70",
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "───────",
                      style: TextStyle(
                        color: AppColors.subText(context),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "1.75²",
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget imperialFormulaBox(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardDark(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border(context)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Imperial Formula",
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "BMI = 703 × ",
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 5),
                Column(
                  children: [
                    Text(
                      "weight (lbs)",
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "───────────",
                      style: TextStyle(
                        color: AppColors.subText(context),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "height² (in)",
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Center(
            child: Text(
              "US customary units formula with\nconversion factor",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.subText(context),
                fontSize: 10,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 10),
          Divider(color: AppColors.divider(context)),
          const SizedBox(height: 10),

          Text(
            "Example:",
            style: TextStyle(
              color: AppColors.text(context),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "703 × ",
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 14,
                  ),
                ),

                Column(
                  children: [
                    Text(
                      "154",
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "────",
                      style: TextStyle(
                        color: AppColors.subText(context),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "69²",
                      style: TextStyle(
                        color: AppColors.text(context),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 8),

                Text(
                  "= 22.9",
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUnitSelectionWidget(BuildContext context) {
    Widget buildMetricField(String unit, TextEditingController controller) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.card(context), // card background for light/dark
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border(context)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: TextStyle(color: AppColors.text(context), fontSize: 14),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            Text(
              unit,
              style: TextStyle(color: AppColors.text(context), fontSize: 13),
            ),
          ],
        ),
      );
    }

    Widget buildImperialHeight() {
      return Row(
        children: [
          Expanded(child: buildMetricField("ft", feetController)),
          const SizedBox(width: 10),
          Expanded(child: buildMetricField("in", inchController)),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "UNITS",
            style: TextStyle(
              color: AppColors.subText(context),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          // Toggle buttons for Metric/Imperial
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border(context)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (!isMetric) {
                        // Convert Imperial → Metric
                        double feet = double.tryParse(feetController.text) ?? 0;
                        double inches =
                            double.tryParse(inchController.text) ?? 0;
                        double totalInches = (feet * 12) + inches;
                        double cm = totalInches * 2.54;

                        double lbs = double.tryParse(lbsController.text) ?? 0;
                        double kg = lbs / 2.20462;

                        // Round values
                        heightController.text = cm.round().toString();
                        weightController.text = kg.round().toString();
                      }
                      setState(() => isMetric = true);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isMetric
                            ? AppColors.primary(context)
                            : AppColors.card(context),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Metric (kg/cm)",
                        style: TextStyle(
                          color: isMetric
                              ? AppColors.buttonText(context)
                              : AppColors.text(context),
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (isMetric) {
                        // Convert Metric → Imperial
                        double cm = double.tryParse(heightController.text) ?? 0;
                        double inches = cm / 2.54;
                        int feet = (inches ~/ 12);
                        double remainingInches = inches - (feet * 12);

                        double kg = double.tryParse(weightController.text) ?? 0;
                        double lbs = kg * 2.20462;

                        feetController.text = feet.toString();
                        inchController.text = remainingInches
                            .round()
                            .toString();
                        lbsController.text = lbs.round().toString();
                      }
                      setState(() => isMetric = false);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !isMetric
                            ? AppColors.primary(context)
                            : AppColors.card(context),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Imperial (lbs/feet)",
                        style: TextStyle(
                          color: !isMetric
                              ? AppColors.buttonText(context)
                              : AppColors.text(context),
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // HEIGHT
          Text(
            "HEIGHT",
            style: TextStyle(color: AppColors.subText(context), fontSize: 10),
          ),
          const SizedBox(height: 8),
          isMetric
              ? buildMetricField("cm", heightController)
              : buildImperialHeight(),

          const SizedBox(height: 20),

          // WEIGHT
          Text(
            "WEIGHT",
            style: TextStyle(color: AppColors.subText(context), fontSize: 10),
          ),
          const SizedBox(height: 8),
          isMetric
              ? buildMetricField("kg", weightController)
              : buildMetricField("lbs", lbsController),
        ],
      ),
    );
  }

  Widget buildBmiResultWidget() {
    double heightCm;
    double weightKg;

    if (isMetric) {
      heightCm = double.tryParse(heightController.text) ?? 0;
      weightKg = double.tryParse(weightController.text) ?? 0;
    } else {
      double feet = double.tryParse(feetController.text) ?? 0;
      double inches = double.tryParse(inchController.text) ?? 0;
      double lbs = double.tryParse(lbsController.text) ?? 0;

      heightCm = ((feet * 12) + inches) * 2.54; // Convert to cm
      weightKg = lbs * 0.453592; // Convert to kg
    }

    // 2️⃣ Calculate BMI, BMI Prime & Ponderal Index
    double heightM = heightCm / 100;
    double bmi = 0;
    double bmiPrime = 0;
    double ponderalIndex = 0;

    if (heightM > 0) {
      bmi = weightKg / (heightM * heightM);
      bmiPrime = bmi / 25.0;
      ponderalIndex = weightKg / (heightM * heightM * heightM);
    }

    // 3️⃣ Determine BMI Category and Color
    String bmiCategory = "";
    Color bmiColor = Colors.white;

    if (bmi < 16) {
      bmiCategory = "Severe Thinness";
      bmiColor = Colors.red;
    } else if (bmi < 17) {
      bmiCategory = "Moderate Thinness";
      bmiColor = Colors.deepOrange;
    } else if (bmi < 18.5) {
      bmiCategory = "Mild Thinness";
      bmiColor = Colors.amber;
    } else if (bmi < 25) {
      bmiCategory = "Normal Weight";
      bmiColor = Colors.greenAccent;
    } else if (bmi < 30) {
      bmiCategory = "Overweight";
      bmiColor = Colors.yellowAccent;
    } else if (bmi < 35) {
      bmiCategory = "Obesity Class I";
      bmiColor = Colors.orange;
    } else if (bmi < 40) {
      bmiCategory = "Obesity Class II";
      bmiColor = Colors.deepOrange;
    } else {
      bmiCategory = "Obesity Class III";
      bmiColor = Colors.redAccent;
    }
    // ✅ BMI categories and target ranges
    double minBmiTarget;
    double maxBmiTarget;
    String bmiTargetLabel;

    // Dynamic BMI range based on current BMI
    if (bmi < 18.5) {
      // Underweight → target to reach normal range
      minBmiTarget = 18.5;
      maxBmiTarget = 24.9;
      bmiTargetLabel = "Target BMI range: 18.5 – 24.9";
    } else if (bmi < 25) {
      // Normal → maintain range
      minBmiTarget = 18.5;
      maxBmiTarget = 24.9;
      bmiTargetLabel = "Maintain BMI: 18.5 – 24.9";
    } else if (bmi < 30) {
      // Overweight → aim to return to upper normal
      minBmiTarget = 18.5;
      maxBmiTarget = 24.9;
      bmiTargetLabel = "Target BMI range: 18.5 – 24.9";
    } else {
      // Obese → also aim for healthy range
      minBmiTarget = 18.5;
      maxBmiTarget = 24.9;
      bmiTargetLabel = "Target BMI range: 18.5 – 24.9";
    }

    // ✅ Compute ideal weight range (kg)
    double minIdealWeight = minBmiTarget * (heightM * heightM);
    double maxIdealWeight = maxBmiTarget * (heightM * heightM);
    String idealWeightRange =
        "${minIdealWeight.toStringAsFixed(1)} – ${maxIdealWeight.toStringAsFixed(1)} kg";

    String weightTitle = "";
    String weightValue = "";
    Color weightColor = Colors.white;

    if (bmi < 18.5) {
      double gain = (minIdealWeight - weightKg).clamp(0, double.infinity);
      weightTitle = "Weight to Gain";
      weightValue = "↑ ${gain.toStringAsFixed(1)} kg";
      weightColor = Colors.blueAccent;
    } else if (bmi >= 25) {
      double lose = (weightKg - maxIdealWeight).clamp(0, double.infinity);
      weightTitle = "Weight to Lose";
      weightValue = "↓ ${lose.toStringAsFixed(1)} kg";
      weightColor = Colors.redAccent;
    } else {
      weightTitle = "Healthy Weight";
      weightValue = "✓ Stable";
      weightColor = Colors.greenAccent;
    }

    String getHealthRiskIcon(double bmi) {
      if (bmi < 18.5) {
        return "assets/icons/high.svg";
      } else if (bmi < 25) {
        return "assets/icons/checkDone.svg";
      } else if (bmi < 30) {
        return "assets/icons/increased.svg";
      } else {
        return "assets/icons/high.svg";
      }
    }

    Widget buildCircleStat(
      String value,
      String label,
      Color color, {
      List<Color>? gradientColors,
    }) {
      final gradient = LinearGradient(
        colors:
            gradientColors ??
            [
              color,
              color.withValues(alpha: 0.3),
              Colors.white.withValues(alpha: 0.1),
            ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

      return Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: (gradientColors != null ? gradientColors.first : color)
                  .withValues(alpha: 0.5),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                // color: Colors.white,
                color: AppColors.text(context),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                // color: Colors.white,
                color: AppColors.text(context),
                fontSize: 8,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Widget buildInfoCard(
    //   String title,
    //   String value,
    //   Color color, {
    //   String? subtext,
    //   String? iconPath,
    // }) {
    //   return Container(
    //     height: 110,
    //     padding: const EdgeInsets.all(20),
    //     decoration: BoxDecoration(
    //       color: Colors.black,
    //       border: Border.all(color: Colors.white),
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text(
    //           title,
    //           style: const TextStyle(
    //             color: Colors.white,
    //             fontWeight: FontWeight.bold,
    //             fontSize: 12,
    //           ),
    //         ),
    //         const SizedBox(height: 6),
    //         Row(
    //           children: [
    //             if (iconPath != null) ...[
    //               SvgPicture.asset(
    //                 iconPath,
    //                 height: 16,
    //                 width: 16,
    //                 colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    //               ),
    //               const SizedBox(width: 6),
    //             ],
    //             Flexible(
    //               child: Text(
    //                 value,
    //                 style: TextStyle(
    //                   color: color,
    //                   fontSize: 12,
    //                   fontWeight: FontWeight.w500,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //         if (subtext != null) ...[
    //           const SizedBox(height: 4),
    //           Text(
    //             subtext,
    //             style: const TextStyle(
    //               color: Colors.white,
    //               fontSize: 10,
    //               fontWeight: FontWeight.w400,
    //             ),
    //           ),
    //         ],
    //       ],
    //     ),
    //   );
    // }

    Widget buildInfoCard(
      BuildContext context,
      String title,
      String value,
      Color valueColor, {
      String? subtext,
      String? iconPath,
    }) {
      return Container(
        height: 110,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card(context), // theme-aware background
          border: Border.all(color: AppColors.border(context)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.text(context), // theme-aware title
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                if (iconPath != null) ...[
                  SvgPicture.asset(
                    iconPath,
                    height: 16,
                    width: 16,
                    colorFilter: ColorFilter.mode(
                      valueColor,
                      BlendMode.srcIn,
                    ), // keep icon color
                  ),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: valueColor, // keep value color
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            if (subtext != null) ...[
              const SizedBox(height: 4),
              Text(
                subtext,
                style: TextStyle(
                  color: AppColors.subText(context), // theme-aware subtext
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ],
        ),
      );
    }

    // Widget buildRangeBox(String range, String label, Color strokeColor) {
    //   return Expanded(
    //     child: Container(
    //       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
    //       margin: const EdgeInsets.all(6),
    //       decoration: BoxDecoration(color: const Color(0xFF000624)),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           Text(
    //             range,
    //             style: TextStyle(
    //               color: strokeColor,
    //               fontWeight: FontWeight.bold,
    //               fontSize: 13,
    //             ),
    //           ),
    //           const SizedBox(height: 4),
    //           Text(
    //             label,
    //             style: const TextStyle(color: Colors.white70, fontSize: 12),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }

    Widget buildRangeBox(
      BuildContext context,
      String range,
      String label,
      Color strokeColor,
    ) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.card(context), // match main container theme
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: AppColors.border(context),
            ), // theme-aware border
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                range,
                style: TextStyle(
                  color: strokeColor, // keep number color same
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.subText(context), // theme-aware label
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Widget buildBmiRow(String label, String range, Color color) {
    //   return Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 2),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Text(label, style: TextStyle(color: color, fontSize: 10)),
    //         Text(range, style: TextStyle(color: Colors.white, fontSize: 10)),
    //       ],
    //     ),
    //   );
    // }

    Widget buildBmiRow(
      BuildContext context,
      String classification,
      String range,
      Color color,
    ) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.rowEven(context), // alternate row color if needed
          border: Border(
            bottom: BorderSide(color: AppColors.divider(context), width: 0.6),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              classification,
              style: TextStyle(
                color: AppColors.text(context), // theme-aware text
                fontSize: 10,
              ),
            ),
            Text(
              range,
              style: TextStyle(
                color: color, // keep range color intact
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
    }

    // Widget buildRecommendationRow(String text, String iconPath) {
    //   return Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 4),
    //     child: Row(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         SvgPicture.asset(
    //           iconPath,
    //           height: 17,
    //           width: 17,
    //           colorFilter: const ColorFilter.mode(
    //             Color(0xFF00B1C5),
    //             BlendMode.srcIn,
    //           ),
    //         ),
    //         const SizedBox(width: 10),
    //         Expanded(
    //           child: Text(
    //             text,
    //             style: const TextStyle(
    //               color: Colors.white,
    //               fontSize: 10,
    //               height: 1.4,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    Widget buildRecommendationRow(
      BuildContext context,
      String text,
      String iconPath,
    ) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              iconPath,
              height: 16,
              width: 16,
              colorFilter: ColorFilter.mode(
                AppColors.primary(context), // using your AppColors primary
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: AppColors.text(context), // using your AppColors text
                  fontSize: 10,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Widget buildBmiRow1(String classification, String range) {
    //   return Container(
    //     decoration: BoxDecoration(
    //       color: const Color(0xFF000624),
    //       border: Border(
    //         bottom: BorderSide(color: Colors.grey.shade900, width: 0.6),
    //       ),
    //     ),
    //     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Text(
    //           classification,
    //           style: const TextStyle(color: Colors.white, fontSize: 8),
    //         ),
    //         Text(
    //           range,
    //           style: const TextStyle(color: Colors.white70, fontSize: 8),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    Widget buildBmiRow1(
      BuildContext context,
      String classification,
      String range,
    ) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.card(context), // Dynamic card background
          border: Border(
            bottom: BorderSide(
              color: AppColors.divider(context), // Dynamic divider color
              width: 0.6,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Text
            Text(
              classification,
              style: TextStyle(
                color: AppColors.text(context), // Dynamic text
                fontSize: 8,
              ),
            ),

            // Right Text
            Text(
              range,
              style: TextStyle(
                color: AppColors.subText(context), // Dynamic subtext
                fontSize: 8,
              ),
            ),
          ],
        ),
      );
    }

    // Widget buildRiskItem(String text, {Color color = Colors.pinkAccent}) {
    //   return Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 4),
    //     child: Row(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Container(
    //           width: 6,
    //           height: 6,
    //           margin: const EdgeInsets.only(top: 5, right: 10),
    //           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    //         ),
    //         Expanded(
    //           child: Text(
    //             text,
    //             style: const TextStyle(
    //               color: Colors.white,
    //               fontSize: 10,
    //               height: 1.4,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    Widget buildRiskItem(BuildContext context, String text, {Color? color}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bullet Dot
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(top: 5, right: 10),
              decoration: BoxDecoration(
                color: color ?? AppColors.primary(context),
                shape: BoxShape.circle,
              ),
            ),

            // Text
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: AppColors.text(context),
                  fontSize: 10,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      // decoration: BoxDecoration(
      //   color: Colors.black,
      //   borderRadius: BorderRadius.circular(16),
      //   border: Border.all(color: Colors.white),
      // ),
      decoration: BoxDecoration(
        color: AppColors.card(context), // background adapts to light/dark theme
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border(context),
        ), // border adapts to theme
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildCircleStat(
                // "24.2",
                bmi.isFinite ? bmi.toStringAsFixed(1) : "--",
                "Your BMI",
                Colors.tealAccent,
                gradientColors: [
                  const Color(0xFF00B1C5),
                  const Color(0xFF3EA78D),
                ],
              ),
              buildCircleStat(
                // "0.47",
                bmiPrime.isFinite ? bmiPrime.toStringAsFixed(2) : "--",
                "BMI Prime",
                Colors.purpleAccent,
                gradientColors: [
                  const Color(0xffD57AFF),
                  const Color(0xff8C00FF),
                ],
              ),
              buildCircleStat(
                // "14.2",
                ponderalIndex.isFinite
                    ? ponderalIndex.toStringAsFixed(1)
                    : "--",
                "Ponderal Index",
                Colors.blueAccent,
                gradientColors: [
                  const Color(0xff0099FF),
                  const Color(0xff3B39CD),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: buildInfoCard(
                  context,
                  "BMI Category",
                  // "Normal Weight",
                  bmiCategory,
                  //Colors.greenAccent,
                  bmiColor,
                  // subtext: "BMI: 18.5 - 24.9",
                  subtext: "BMI: ${bmi.toStringAsFixed(1)}",
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: buildInfoCard(
                  context,
                  "Health Risk",
                  // "Normal",
                  (bmi < 18.5)
                      ? "Very High"
                      : (bmi < 25)
                      ? "Normal"
                      : (bmi < 30)
                      ? "Increased"
                      : "High",
                  // Colors.greenAccent,
                  bmiColor,
                  //iconPath: "assets/icons/checkDone.svg",
                  iconPath: getHealthRiskIcon(bmi),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          buildInfoCard(
            context,
            "Ideal Weight Range",
            // "53.5 - 72 kg",
            idealWeightRange,
            //subtext: "Normal BMI range: 18.5 - 24.9",
            subtext: bmiTargetLabel,
            Colors.greenAccent,
          ),
          const SizedBox(height: 12),
          buildInfoCard(context, weightTitle, weightValue, weightColor),

          const SizedBox(height: 16),

          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.black,
          //     borderRadius: BorderRadius.circular(12),
          //     border: Border.all(color: Colors.blueAccent),
          //   ),
          //   padding: const EdgeInsets.all(20),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const Text(
          //         "BMI Range (WHO Classification)",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 12,
          //         ),
          //       ),
          //       const SizedBox(height: 8),
          //       buildBmiRow("Severe Thinness", "<16", Color(0xffFF0000)),
          //       buildBmiRow(
          //         "Moderate Thinness",
          //         "16.0–16.9",
          //         Colors.deepOrange,
          //       ),
          //       buildBmiRow("Mild Thinness", "17.0–18.4", Colors.amber),
          //       buildBmiRow("Normal Weight", "18.5–24.9", Colors.greenAccent),
          //       buildBmiRow("Overweight", "25.0–29.9", Colors.yellowAccent),
          //       buildBmiRow("Obesity Class I", "30.0–34.9", Colors.orange),
          //       buildBmiRow("Obesity Class II", "35.0–39.9", Colors.deepOrange),
          //       buildBmiRow("Obesity Class III", "≥40.0", Colors.red),
          //     ],
          //   ),
          // ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.card(context), // adapts to light/dark theme
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border(context)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "BMI Range (WHO Classification)",
                  style: TextStyle(
                    color: AppColors.text(context), // theme-aware title
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                buildBmiRow(
                  context,
                  "Severe Thinness",
                  "<16",
                  Color(0xffFF0000),
                ),
                buildBmiRow(
                  context,
                  "Moderate Thinness",
                  "16.0–16.9",
                  Colors.deepOrange,
                ),
                buildBmiRow(
                  context,
                  "Mild Thinness",
                  "17.0–18.4",
                  Colors.amber,
                ),
                buildBmiRow(
                  context,
                  "Normal Weight",
                  "18.5–24.9",
                  Colors.greenAccent,
                ),
                buildBmiRow(
                  context,
                  "Overweight",
                  "25.0–29.9",
                  Colors.yellowAccent,
                ),
                buildBmiRow(
                  context,
                  "Obesity Class I",
                  "30.0–34.9",
                  Colors.orange,
                ),
                buildBmiRow(
                  context,
                  "Obesity Class II",
                  "35.0–39.9",
                  Colors.deepOrange,
                ),
                buildBmiRow(context, "Obesity Class III", "≥40.0", Colors.red),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.black,
          //     borderRadius: BorderRadius.circular(12),
          //     border: Border.all(color: Colors.white),
          //   ),
          //   padding: const EdgeInsets.all(12),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       const Text(
          //         "About BMI Prime",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 14,
          //           fontWeight: FontWeight.w700,
          //         ),
          //       ),
          //       const SizedBox(height: 8),
          //       const Text(
          //         "BMI Prime is the ratio of your BMI to the upper limit of normal BMI (25). "
          //         "A value of 1.0 means you’re at the upper limit of normal weight.",
          //         style: TextStyle(color: Colors.white, fontSize: 12),
          //         textAlign: TextAlign.center,
          //       ),
          //       const SizedBox(height: 12),
          //
          //       Row(
          //         children: [
          //           buildRangeBox("< 0.74", "Underweight", Colors.blueAccent),
          //           buildRangeBox("0.74 - 1.0", "Normal", Colors.greenAccent),
          //         ],
          //       ),
          //
          //       Row(
          //         children: [
          //           buildRangeBox(
          //             "1.0 - 1.2",
          //             "Overweight",
          //             Colors.orangeAccent,
          //           ),
          //           buildRangeBox("> 1.2", "Obese", Colors.redAccent),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.card(
                context,
              ), // container adapts to light/dark theme
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.border(context),
              ), // theme-aware border
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "About BMI Prime",
                  style: TextStyle(
                    color: AppColors.text(context), // theme-aware text
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "BMI Prime is the ratio of your BMI to the upper limit of normal BMI (25). "
                  "A value of 1.0 means you’re at the upper limit of normal weight.",
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    buildRangeBox(
                      context,
                      "< 0.74",
                      "Underweight",
                      Colors.blueAccent,
                    ),
                    buildRangeBox(
                      context,
                      "0.74 - 1.0",
                      "Normal",
                      Colors.greenAccent,
                    ),
                  ],
                ),

                Row(
                  children: [
                    buildRangeBox(
                      context,
                      "1.0 - 1.2",
                      "Overweight",
                      Colors.orangeAccent,
                    ),
                    buildRangeBox(context, "> 1.2", "Obese", Colors.redAccent),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.black,
          //     borderRadius: BorderRadius.circular(12),
          //     border: Border.all(color: Colors.white),
          //   ),
          //   padding: const EdgeInsets.all(20),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const Text(
          //         "Recommendations",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 14,
          //           fontWeight: FontWeight.w700,
          //         ),
          //       ),
          //       const SizedBox(height: 10),
          //
          //       buildRecommendationRow(
          //         "Maintain your current healthy weight",
          //         "assets/icons/checkDone1.svg",
          //       ),
          //       buildRecommendationRow(
          //         "Continue regular physical activity (150+ minutes per week)",
          //         "assets/icons/checkDone1.svg",
          //       ),
          //       buildRecommendationRow(
          //         "Eat a balanced, nutritious diet",
          //         "assets/icons/checkDone1.svg",
          //       ),
          //       buildRecommendationRow(
          //         "Regular health check-ups",
          //         "assets/icons/checkDone1.svg",
          //       ),
          //       buildRecommendationRow(
          //         "Focus on overall wellness and body composition",
          //         "assets/icons/checkDone1.svg",
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border(context), width: 1),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Recommendations",
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),

                buildRecommendationRow(
                  context,
                  "Maintain your current healthy weight",
                  "assets/icons/checkDone1.svg",
                ),

                buildRecommendationRow(
                  context,
                  "Continue regular physical activity (150+ minutes per week)",
                  "assets/icons/checkDone1.svg",
                ),

                buildRecommendationRow(
                  context,
                  "Eat a balanced, nutritious diet",
                  "assets/icons/checkDone1.svg",
                ),

                buildRecommendationRow(
                  context,
                  "Regular health check-ups",
                  "assets/icons/checkDone1.svg",
                ),

                buildRecommendationRow(
                  context,
                  "Focus on overall wellness and body composition",
                  "assets/icons/checkDone1.svg",
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Container(
          //   decoration: BoxDecoration(
          //     color: Colors.black,
          //     borderRadius: BorderRadius.circular(12),
          //     border: Border.all(color: Colors.white),
          //   ),
          //   padding: const EdgeInsets.all(20),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const Text(
          //         "BMI Introduction",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 16,
          //           fontWeight: FontWeight.w700,
          //         ),
          //       ),
          //       const SizedBox(height: 8),
          //       const Text(
          //         "BMI is a measurement of a person's leanness or corpulence based on their height and weight, and is intended to quantify tissue mass. It is widely used as a general indicator of whether a person has a healthy body weight for their height.",
          //         style: TextStyle(
          //           color: Color(0xffD0CCCC),
          //           fontSize: 12,
          //           height: 1.5,
          //         ),
          //       ),
          //       const SizedBox(height: 8),
          //       const Text(
          //         "Specifically, the value obtained from the calculation of BMI is used to categorize whether a person is underweight, normal weight, overweight, or obese depending on what range the value falls between. These ranges of BMI vary based on factors such as region and age, and are sometimes further divided into subcategories such as severely underweight or very severely obese.",
          //         style: TextStyle(
          //           color: Colors.white70,
          //           fontSize: 12,
          //           height: 1.5,
          //         ),
          //       ),
          //       const SizedBox(height: 12),
          //       Divider(color: Colors.white, thickness: 1),
          //       const SizedBox(height: 12),
          //
          //       const Text(
          //         "BMI Table for Adults",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 16,
          //           fontWeight: FontWeight.w700,
          //         ),
          //       ),
          //       const SizedBox(height: 6),
          //       const Text(
          //         "This is the World Health Organization's (WHO) recommended body weight based on BMI values for adults. It is used for both men and women, age 20 or older.",
          //         style: TextStyle(
          //           color: Colors.white70,
          //           fontSize: 10,
          //           height: 1.4,
          //         ),
          //       ),
          //       const SizedBox(height: 12),
          //
          //       Container(
          //         decoration: BoxDecoration(
          //           color: const Color(0xFF00B1C5),
          //           borderRadius: BorderRadius.circular(6),
          //         ),
          //         padding: const EdgeInsets.symmetric(
          //           vertical: 10,
          //           horizontal: 12,
          //         ),
          //         child: const Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text(
          //               "Classification",
          //               style: TextStyle(
          //                 color: Colors.white,
          //                 fontSize: 10,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //             Text(
          //               "BMI Range – kg/m²",
          //               style: TextStyle(
          //                 color: Colors.white,
          //                 fontSize: 10,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //
          //       buildBmiRow1("Severe Thinness", "< 16"),
          //       buildBmiRow1("Moderate Thinness", "16 – 17"),
          //       buildBmiRow1("Mild Thinness", "17 – 18.5"),
          //       buildBmiRow1("Normal Weight", "18.5 – 25"),
          //       buildBmiRow1("Overweight", "25 – 30"),
          //       buildBmiRow1("Obesity Class I", "30 – 35"),
          //       buildBmiRow1("Obesity Class II", "35 – 40"),
          //       buildBmiRow1("Obesity Class III", "> 40"),
          //
          //       const SizedBox(height: 16),
          //
          //       const Text(
          //         "Risks Associated with Being Overweight",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 16,
          //           fontWeight: FontWeight.w700,
          //         ),
          //       ),
          //       const SizedBox(height: 8),
          //       const Text(
          //         "Being overweight increases the risk of a number of serious diseases and health conditions. Below is a list of said risks, according to the Centers for Disease Control and Prevention (CDC):",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 10,
          //           height: 1.5,
          //         ),
          //       ),
          //       const SizedBox(height: 14),
          //
          //       const Text(
          //         "Cardiovascular Risks",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 12,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       const SizedBox(height: 8),
          //       buildRiskItem("High blood pressure"),
          //       buildRiskItem(
          //         "Higher levels of LDL cholesterol, lower levels of HDL cholesterol, and high levels of triglycerides",
          //       ),
          //       buildRiskItem("Coronary heart disease"),
          //       buildRiskItem("Stroke"),
          //
          //       const SizedBox(height: 10),
          //
          //       const Text(
          //         "Metabolic Risks",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 12,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       const SizedBox(height: 8),
          //       buildRiskItem("Type II diabetes"),
          //       buildRiskItem("Gallbladder disease"),
          //       buildRiskItem("Sleep apnea and breathing problems"),
          //       buildRiskItem(
          //         "Osteoarthritis, a type of joint disease caused by breakdown of joint cartilage",
          //       ),
          //
          //       const SizedBox(height: 14),
          //
          //       const Text(
          //         "Other Health Risks",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 12,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       const SizedBox(height: 8),
          //       buildRiskItem(
          //         "Certain cancers (endometrial, breast, colon, kidney, gallbladder, liver)",
          //       ),
          //       buildRiskItem(
          //         "Mental illnesses such as clinical depression, anxiety, and others",
          //       ),
          //       buildRiskItem("Low quality of life and body pains"),
          //       buildRiskItem(
          //         "Generally, an increased risk of mortality compared to those with a healthy BMI",
          //       ),
          //       const SizedBox(height: 10),
          //
          //       const Text(
          //         "Risks Associated with Being Underweight",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 16,
          //           fontWeight: FontWeight.w700,
          //         ),
          //       ),
          //       const SizedBox(height: 8),
          //       const Text(
          //         "Being underweight has its own associated risks, listed below.",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 10,
          //           height: 1.5,
          //         ),
          //       ),
          //       const SizedBox(height: 12),
          //       buildRiskItem(
          //         "Malnutrition, vitamin deficiencies, anemia (lowered ability to carry oxygen)",
          //         color: Colors.orange,
          //       ),
          //       buildRiskItem(
          //         "Osteoporosis (weakened bones, fracture risk)",
          //         color: Colors.orange,
          //       ),
          //       buildRiskItem(
          //         "Decreased immune function",
          //         color: Colors.orange,
          //       ),
          //       buildRiskItem(
          //         "Growth and development issues in children and teenagers",
          //         color: Colors.orange,
          //       ),
          //       buildRiskItem(
          //         "Reproductive issues in women (hormonal imbalances)",
          //         color: Colors.orange,
          //       ),
          //       buildRiskItem(
          //         "Complications after surgery",
          //         color: Colors.orange,
          //       ),
          //       buildRiskItem(
          //         "Increased risk of mortality compared to those with a healthy BMI",
          //         color: Colors.orange,
          //       ),
          //
          //       const SizedBox(height: 10),
          //
          //       const Text(
          //         "BMI Limitations",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 16,
          //           fontWeight: FontWeight.w700,
          //         ),
          //       ),
          //       const SizedBox(height: 8),
          //       const Text(
          //         "BMI doesn’t distinguish between muscle and fat mass. Athletes and muscular individuals may have high BMI despite low body fat.",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 10,
          //           height: 1.5,
          //         ),
          //       ),
          //       const SizedBox(height: 12),
          //
          //       const Text(
          //         "In Adults",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 12,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //       const SizedBox(height: 8),
          //       buildRiskItem(
          //         "Older adults tend to have more body fat than younger adults with the same BMI",
          //         color: Colors.blueAccent,
          //       ),
          //       buildRiskItem(
          //         "Women generally have more body fat than men for an equivalent BMI",
          //         color: Colors.blueAccent,
          //       ),
          //       buildRiskItem(
          //         "Muscular individuals and athletes may have higher BMI due to muscle mass",
          //         color: Colors.blueAccent,
          //       ),
          //
          //       const SizedBox(height: 12),
          //
          //       const Text(
          //         "In Children and Adolescents",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 12,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       const SizedBox(height: 8),
          //       buildRiskItem(
          //         "Height and sexual maturation influence BMI and body fat in children",
          //         color: Colors.blueAccent,
          //       ),
          //       buildRiskItem(
          //         "BMI could be high due to lean mass, not fat",
          //         color: Colors.blueAccent,
          //       ),
          //       buildRiskItem(
          //         "BMI is a fair indicator for 90–95% of the population",
          //         color: Colors.blueAccent,
          //       ),
          //       const SizedBox(height: 10),
          //
          //       const Text(
          //         "BMI Formula",
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 16,
          //           fontWeight: FontWeight.w700,
          //         ),
          //       ),
          //       SizedBox(height: 10),
          //
          //       Container(
          //         width: double.infinity,
          //         decoration: BoxDecoration(
          //           color: Color(0xFF07122B),
          //           borderRadius: BorderRadius.circular(8),
          //         ),
          //         padding: const EdgeInsets.all(20),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             const Center(
          //               child: Text(
          //                 "Metric Formula",
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontSize: 12,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ),
          //             const SizedBox(height: 20),
          //             const Center(
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   Text(
          //                     "BMI = ",
          //                     style: TextStyle(
          //                       color: Colors.white,
          //                       fontSize: 12,
          //                       // fontWeight: FontWeight.w600,
          //                     ),
          //                   ),
          //                   SizedBox(width: 5),
          //                   Column(
          //                     mainAxisSize: MainAxisSize.min,
          //                     children: [
          //                       Text(
          //                         "weight (kg)",
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 10,
          //                         ),
          //                       ),
          //                       SizedBox(height: 2),
          //                       Text(
          //                         "───────────",
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 12,
          //                         ),
          //                       ),
          //                       SizedBox(height: 2),
          //                       Text(
          //                         "height² (m)",
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 10,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             const SizedBox(height: 20),
          //             const Center(
          //               child: Text(
          //                 "Standard international formula using\nkilograms and meters",
          //                 textAlign: TextAlign.center,
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontSize: 10,
          //                   height: 1.4,
          //                 ),
          //               ),
          //             ),
          //             const SizedBox(height: 10),
          //             const Divider(color: Colors.white),
          //             const SizedBox(height: 10),
          //             const Text(
          //               "Example:",
          //               style: TextStyle(
          //                 color: Colors.white,
          //                 fontSize: 12,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //             const SizedBox(height: 6),
          //             const Center(
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   Text(
          //                     "22.9 = ",
          //                     style: TextStyle(
          //                       color: Colors.white,
          //                       fontSize: 14,
          //                       // fontWeight: FontWeight.w600,
          //                     ),
          //                   ),
          //                   SizedBox(width: 5),
          //                   Column(
          //                     mainAxisSize: MainAxisSize.min,
          //                     children: [
          //                       Text(
          //                         "70",
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 12,
          //                         ),
          //                       ),
          //                       SizedBox(height: 2),
          //                       Text(
          //                         "───────",
          //                         style: TextStyle(
          //                           color: Colors.white70,
          //                           fontSize: 12,
          //                         ),
          //                       ),
          //                       SizedBox(height: 2),
          //                       Text(
          //                         "1.75²",
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 12,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //
          //       SizedBox(height: 10),
          //
          //       Container(
          //         width: double.infinity,
          //         decoration: BoxDecoration(
          //           color: Color(0xFF07122B),
          //           borderRadius: BorderRadius.circular(8),
          //         ),
          //         padding: const EdgeInsets.all(20),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             const Center(
          //               child: Text(
          //                 "Imperial Formula",
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontSize: 12,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //             ),
          //             const SizedBox(height: 20),
          //             const Center(
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 crossAxisAlignment: CrossAxisAlignment.center,
          //                 children: [
          //                   Text(
          //                     "BMI = 703 × ",
          //                     style: TextStyle(
          //                       color: Colors.white,
          //                       fontSize: 12,
          //                       //fontWeight: FontWeight.w600,
          //                     ),
          //                   ),
          //                   SizedBox(width: 5),
          //                   Column(
          //                     mainAxisSize: MainAxisSize.min,
          //                     children: [
          //                       Text(
          //                         "weight (kg)",
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 10,
          //                         ),
          //                       ),
          //                       SizedBox(height: 2),
          //                       Text(
          //                         "───────────",
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 12,
          //                         ),
          //                       ),
          //                       SizedBox(height: 2),
          //                       Text(
          //                         "height² (m)",
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 10,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             const SizedBox(height: 20),
          //             const Center(
          //               child: Text(
          //                 "US customary units formula with\nconversion factor",
          //                 textAlign: TextAlign.center,
          //                 style: TextStyle(
          //                   color: Colors.white,
          //                   fontSize: 10,
          //                   height: 1.4,
          //                 ),
          //               ),
          //             ),
          //             const SizedBox(height: 10),
          //             const Divider(color: Colors.white),
          //             const SizedBox(height: 10),
          //             const Text(
          //               "Example:",
          //               style: TextStyle(
          //                 color: Colors.white,
          //                 fontSize: 12,
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //             const SizedBox(height: 6),
          //             const Center(
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   Text(
          //                     "703 × ",
          //                     style: TextStyle(
          //                       color: Colors.white,
          //                       fontSize: 14,
          //                       // fontWeight: FontWeight.w600,
          //                     ),
          //                   ),
          //                   Column(
          //                     mainAxisSize: MainAxisSize.min,
          //                     children: [
          //                       Text(
          //                         "154",
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 13,
          //                         ),
          //                       ),
          //                       SizedBox(height: 2),
          //                       Text(
          //                         "────",
          //                         style: TextStyle(
          //                           color: Colors.white70,
          //                           fontSize: 12,
          //                         ),
          //                       ),
          //                       SizedBox(height: 2),
          //                       Text(
          //                         "69²",
          //                         style: TextStyle(
          //                           color: Colors.white,
          //                           fontSize: 13,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                   SizedBox(width: 8),
          //                   Text(
          //                     "= 22.9",
          //                     style: TextStyle(
          //                       color: Colors.white,
          //                       fontSize: 14,
          //                       //fontWeight: FontWeight.w600,
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border(context)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "BMI Introduction",
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "BMI is a measurement of a person's leanness or corpulence based on their height and weight, and is intended to quantify tissue mass. It is widely used as a general indicator of whether a person has a healthy body weight for their height.",
                  style: TextStyle(
                    color: AppColors.subText(context),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Specifically, the value obtained from the calculation of BMI is used to categorize whether a person is underweight, normal weight, overweight, or obese depending on what range the value falls between. These ranges of BMI vary based on factors such as region and age, and are sometimes further divided into subcategories such as severely underweight or very severely obese.",
                  style: TextStyle(
                    color: AppColors.subText(context),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 12),

                Divider(color: AppColors.divider(context), thickness: 1),

                const SizedBox(height: 12),

                Text(
                  "BMI Table for Adults",
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "This is the World Health Organization's (WHO) recommended body weight based on BMI values for adults. It is used for both men and women, age 20 or older.",
                  style: TextStyle(
                    color: AppColors.subText(context),
                    fontSize: 10,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 12),

                // Header Row
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary(context),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Classification",
                        style: TextStyle(
                          color: AppColors.buttonText(context),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "BMI Range – kg/m²",
                        style: TextStyle(
                          color: AppColors.buttonText(context),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                buildBmiRow1(context, "Severe Thinness", "< 16"),
                buildBmiRow1(context, "Moderate Thinness", "16 – 17"),
                buildBmiRow1(context, "Mild Thinness", "17 – 18.5"),
                buildBmiRow1(context, "Normal Weight", "18.5 – 25"),
                buildBmiRow1(context, "Overweight", "25 – 30"),
                buildBmiRow1(context, "Obesity Class I", "30 – 35"),
                buildBmiRow1(context, "Obesity Class II", "35 – 40"),
                buildBmiRow1(context, "Obesity Class III", "> 40"),

                const SizedBox(height: 16),

                Text(
                  "Risks Associated with Being Overweight",
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Being overweight increases the risk of a number of serious diseases and health conditions. Below is a list of said risks, according to the Centers for Disease Control and Prevention (CDC):",
                  style: TextStyle(
                    color: AppColors.subText(context),
                    fontSize: 10,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  "Cardiovascular Risks",
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),
                buildRiskItem(context, "High blood pressure"),
                buildRiskItem(
                  context,
                  "Higher levels of LDL cholesterol, lower levels of HDL cholesterol, and high levels of triglycerides",
                ),
                buildRiskItem(context, "Coronary heart disease"),
                buildRiskItem(context, "Stroke"),

                const SizedBox(height: 10),

                Text(
                  "Metabolic Risks",
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),
                buildRiskItem(context, "Type II diabetes"),
                buildRiskItem(context, "Gallbladder disease"),
                buildRiskItem(context, "Sleep apnea..."),
                buildRiskItem(
                  context,
                  "Osteoarthritis, a type of joint disease caused by breakdown of joint cartilage",
                ),

                const SizedBox(height: 14),

                Text(
                  "Other Health Risks",
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),
                buildRiskItem(
                  context,
                  "Certain cancers (endometrial, breast, colon, kidney, gallbladder, liver)",
                ),
                buildRiskItem(
                  context,
                  "Mental illnesses such as clinical depression, anxiety, and others",
                ),
                buildRiskItem(context, "Low quality of life and body pains"),
                buildRiskItem(
                  context,
                  "Generally, an increased risk of mortality compared to those with a healthy BMI",
                ),

                const SizedBox(height: 10),

                Text(
                  "Risks Associated with Being Underweight",
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Being underweight has its own associated risks, listed below",
                  style: TextStyle(
                    color: AppColors.subText(context),
                    fontSize: 10,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 12),

                buildRiskItem(
                  context,
                  "Malnutrition, vitamin deficiencies, anemia (lowered ability to carry oxygen).",
                  color: AppColors.warning(context),
                ),
                buildRiskItem(
                  context,
                  "Osteoporosis (weakened bones, fracture risk)",
                  color: AppColors.warning(context),
                ),
                buildRiskItem(
                  context,
                  "Decreased immune function",
                  color: AppColors.warning(context),
                ),
                buildRiskItem(
                  context,
                  "Growth and development issues in children and teenagers",
                  color: AppColors.warning(context),
                ),
                buildRiskItem(
                  context,
                  "Reproductive issues in women (hormonal imbalances)",
                  color: AppColors.warning(context),
                ),
                buildRiskItem(
                  context,
                  "Complications after surgery",
                  color: AppColors.warning(context),
                ),
                buildRiskItem(
                  context,
                  "Increased risk of mortality compared to those with a healthy BMI",
                  color: AppColors.warning(context),
                ),

                const SizedBox(height: 10),

                Text(
                  "BMI Limitations",
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "BMI doesn’t distinguish between muscle and fat mass. Athletes and muscular individuals may have high BMI despite low body fat.",
                  style: TextStyle(
                    color: AppColors.subText(context),
                    fontSize: 10,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  "In Adults",
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                buildRiskItem(
                  context,
                  "Older adults tend to have more body fat than younger adults with the same BMI",
                ),
                buildRiskItem(
                  context,
                  "Women generally have more body fat than men for an equivalent BMI",
                ),
                buildRiskItem(
                  context,
                  "Muscular individuals and athletes may have higher BMI due to muscle mass",
                ),

                const SizedBox(height: 12),

                Text(
                  "In Children and Adolescents",
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                buildRiskItem(
                  context,
                  "Height and sexual maturation influence BMI and body fat in children",
                ),
                buildRiskItem(
                  context,
                  "BMI could be high due to lean mass, not fat",
                ),
                buildRiskItem(
                  context,
                  "BMI is a fair indicator for 90–95% of the population",
                ),

                const SizedBox(height: 10),

                Text(
                  "BMI Formula",
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                metricFormulaBox(context),
                const SizedBox(height: 10),
                imperialFormulaBox(context),
              ],
            ),
          ),

          const SizedBox(height: 16),
          bmiPrimeWidget(context),

          const SizedBox(height: 16),
          ponderalIndexWidget(context),

          const SizedBox(height: 16),
          medicalWarning(context),
        ],
      ),
    );
  }
}

// Widget bmiPrimeWidget() {
//   return Container(
//     width: double.infinity,
//     padding: const EdgeInsets.all(20),
//     decoration: BoxDecoration(
//       color: const Color(0xFF0B1122),
//       borderRadius: BorderRadius.circular(12),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Title
//         const Text(
//           "About BMI Prime",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         const SizedBox(height: 8),
//
//         // Description
//         const Text(
//           "BMI Prime is the ratio of your BMI to the upper limit of normal BMI (25). "
//           "A value of 1.0 means you're at the upper limit of normal weight.",
//           style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
//         ),
//         const SizedBox(height: 20),
//
//         // Formula Box
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(vertical: 20),
//           decoration: BoxDecoration(
//             color: const Color(0xFF091530),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Column(
//             children: const [
//               Text(
//                 "BMI Prime Formula",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 14,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//               SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "BMI Prime = ",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         "BMI",
//                         style: TextStyle(color: Colors.white, fontSize: 12),
//                       ),
//                       SizedBox(height: 2),
//                       Text(
//                         "────",
//                         style: TextStyle(color: Colors.white70, fontSize: 12),
//                       ),
//                       SizedBox(height: 2),
//                       Text(
//                         "25",
//                         style: TextStyle(color: Colors.white, fontSize: 12),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10),
//               Text(
//                 "Ratio of your BMI to the upper limit of normal BMI (25)",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.white70, fontSize: 10),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 20),
//
//         // Table Header
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//           decoration: const BoxDecoration(
//             color: Color(0xFF0E7BC4),
//             borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
//           ),
//           child: Row(
//             children: const [
//               Expanded(
//                 flex: 2,
//                 child: Text(
//                   "Classification",
//                   textAlign: TextAlign.start,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 11,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Text(
//                   "BMI",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 11,
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Text(
//                   "BMI Prime",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 11,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         // Table Rows
//         Container(
//           decoration: const BoxDecoration(
//             borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
//           ),
//           child: Column(
//             children: List.generate(_bmiRows.length, (index) {
//               final item = _bmiRows[index];
//               final isEven = index % 2 == 0;
//               return _bmiRow(
//                 item['label']!,
//                 item['bmi']!,
//                 item['prime']!,
//                 isEven ? const Color(0xFF081C2D) : const Color(0xFF000D18),
//               );
//             }),
//           ),
//         ),
//       ],
//     ),
//   );
// }

Widget bmiPrimeWidget(BuildContext context) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.card(context),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border(context)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          "About BMI Prime",
          style: TextStyle(
            color: AppColors.text(context),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),

        // Description
        Text(
          "BMI Prime is the ratio of your BMI to the upper limit of normal BMI (25). "
          "A value of 1.0 means you're at the upper limit of normal weight.",
          style: TextStyle(
            color: AppColors.subText(context),
            fontSize: 14,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),

        // Formula Box
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.cardDark(context),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border(context)),
          ),
          child: Column(
            children: [
              Text(
                "BMI Prime Formula",
                style: TextStyle(color: AppColors.text(context), fontSize: 14),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "BMI Prime = ",
                    style: TextStyle(
                      color: AppColors.text(context),
                      fontSize: 12,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "BMI",
                        style: TextStyle(
                          color: AppColors.text(context),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "────",
                        style: TextStyle(
                          color: AppColors.subText(context),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "25",
                        style: TextStyle(
                          color: AppColors.text(context),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Ratio of your BMI to the upper limit of normal BMI (25)",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.subText(context),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Header Row
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.primary(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Classification",
                  style: TextStyle(
                    color: AppColors.buttonText(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "BMI",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.buttonText(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "BMI Prime",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.buttonText(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Table rows
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(8),
            ),
            border: Border.all(color: AppColors.border(context)),
          ),
          child: Column(
            children: List.generate(_bmiRows.length, (index) {
              final item = _bmiRows[index];
              final isEven = index % 2 == 0;

              return _bmiRow(
                context,
                item['label']!,
                item['bmi']!,
                item['prime']!,
                isEven ? AppColors.rowEven(context) : AppColors.rowOdd(context),
              );
            }),
          ),
        ),
      ],
    ),
  );
}

final List<Map<String, String>> _bmiRows = [
  {"label": "Severe Thinness", "bmi": "< 16", "prime": "< 0.64"},
  {"label": "Moderate Thinness", "bmi": "16–17", "prime": "0.64–0.68"},
  {"label": "Mild Thinness", "bmi": "17–18.5", "prime": "0.68–0.74"},
  {"label": "Normal Weight", "bmi": "18.5–25", "prime": "0.74–1.0"},
  {"label": "Overweight", "bmi": "25–30", "prime": "1.0–1.2"},
  {"label": "Obesity Class I", "bmi": "30–35", "prime": "1.2–1.4"},
  {"label": "Obesity Class II", "bmi": "35–40", "prime": "1.4–1.6"},
  {"label": "Obesity Class III", "bmi": "> 40", "prime": "> 1.6"},
];

// Widget _bmiRow(String label, String bmi, String prime, Color bgColor) =>
//     Container(
//       color: bgColor,
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               textAlign: TextAlign.start,
//               style: const TextStyle(color: Colors.white, fontSize: 10),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Text(
//               bmi,
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: Colors.white70, fontSize: 10),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Text(
//               prime,
//               textAlign: TextAlign.center,
//               style: const TextStyle(color: Colors.white70, fontSize: 10),
//             ),
//           ),
//         ],
//       ),
//     );

Widget _bmiRow(
  BuildContext context,
  String label,
  String bmi,
  String prime,
  Color bgColor,
) => Container(
  color: bgColor,
  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
  child: Row(
    children: [
      Expanded(
        flex: 2,
        child: Text(
          label,
          textAlign: TextAlign.start,
          style: AppColors.bmiLabelStyle.copyWith(
            color: AppColors.text(context),
          ),
        ),
      ),
      Expanded(
        flex: 1,
        child: Text(
          bmi,
          textAlign: TextAlign.center,
          style: AppColors.bmiValueStyle.copyWith(
            color: AppColors.subText(context),
          ),
        ),
      ),
      Expanded(
        flex: 1,
        child: Text(
          prime,
          textAlign: TextAlign.center,
          style: AppColors.bmiValueStyle.copyWith(
            color: AppColors.subText(context),
          ),
        ),
      ),
    ],
  ),
);

// Widget ponderalIndexWidget() {
//   return Container(
//     width: double.infinity,
//     padding: const EdgeInsets.all(20),
//     decoration: BoxDecoration(
//       color: const Color(0xFF0B1122),
//       borderRadius: BorderRadius.circular(12),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Title
//         const Text(
//           "Ponderal Index",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         const SizedBox(height: 8),
//
//         // Description
//         const Text(
//           "The Ponderal Index (PI) is similar to BMI in that it measures the leanness or corpulence of a person based on their height and weight. "
//           "The main difference between the PI and BMI is the cubing rather than squaring of the height in the formula. "
//           "While BMI can be a useful tool when considering large populations, it is not reliable for determining leanness or corpulence in individuals.",
//           style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
//         ),
//         const SizedBox(height: 20),
//
//         // Metric Formula Box
//         _formulaBox(
//           title: "Metric Formula",
//           formulaTop: "weight (kg)",
//           formulaBottom: "height³ (m)",
//           caption: "Ponderal Index using metric units",
//         ),
//         const SizedBox(height: 10),
//
//         // Imperial Formula Box
//         _formulaBox(
//           title: "Imperial Formula",
//           formulaTop: "height³ (in)",
//           formulaBottom: "√weight (lbs)",
//           caption: "Ponderal Index using imperial units",
//         ),
//       ],
//     ),
//   );
// }

Widget ponderalIndexWidget(BuildContext context) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.card(context),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          "Ponderal Index",
          style: TextStyle(
            color: AppColors.text(context),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),

        // Description
        Text(
          "The Ponderal Index (PI) is similar to BMI in that it measures the leanness or corpulence of a person based on their height and weight. "
          "The main difference between the PI and BMI is the cubing rather than squaring of the height in the formula. "
          "While BMI can be a useful tool when considering large populations, it is not reliable for determining leanness or corpulence in individuals.",
          style: TextStyle(
            color: AppColors.subText(context),
            fontSize: 13,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),

        _formulaBox(
          context: context,
          title: "Metric Formula",
          formulaTop: "weight (kg)",
          formulaBottom: "height³ (m)",
          caption: "Ponderal Index using metric units",
        ),
        const SizedBox(height: 10),

        _formulaBox(
          context: context,
          title: "Imperial Formula",
          formulaTop: "height³ (in)",
          formulaBottom: "√weight (lbs)",
          caption: "Ponderal Index using imperial units",
        ),
      ],
    ),
  );
}

// Widget _formulaBox({
//   required String title,
//   required String formulaTop,
//   required String formulaBottom,
//   required String caption,
// }) {
//   return Container(
//     width: double.infinity,
//     padding: const EdgeInsets.symmetric(vertical: 20),
//     decoration: BoxDecoration(
//       color: const Color(0xFF091530),
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: Column(
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               "PI = ",
//               style: TextStyle(color: Colors.white, fontSize: 13),
//             ),
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   formulaTop,
//                   style: const TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//                 const SizedBox(height: 2),
//                 const Text(
//                   "──────",
//                   style: TextStyle(color: Colors.white70, fontSize: 12),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   formulaBottom,
//                   style: const TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         Text(
//           caption,
//           style: const TextStyle(color: Colors.white70, fontSize: 11),
//         ),
//       ],
//     ),
//   );
// }

Widget _formulaBox({
  required BuildContext context,
  required String title,
  required String formulaTop,
  required String formulaBottom,
  required String caption,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 20),
    decoration: BoxDecoration(
      color: AppColors.cardDark(context),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppColors.border(context)),
    ),
    child: Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.text(context),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),

        // Formula layout
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "PI = ",
              style: TextStyle(color: AppColors.text(context), fontSize: 13),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formulaTop,
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "──────",
                  style: TextStyle(
                    color: AppColors.subText(context),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formulaBottom,
                  style: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),

        Text(
          caption,
          style: TextStyle(color: AppColors.subText(context), fontSize: 11),
        ),
      ],
    ),
  );
}

// Widget medicalWarning() {
//   return Container(
//     width: double.infinity,
//     padding: const EdgeInsets.all(20),
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
//           'BMI is a screening tool and may not reflect body composition. Consult healthcare professionals for personalized advice.',
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
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.cardDark(context), // Card background
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: AppColors.warning(context), // Dynamic warning color
        width: 1,
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.warning_amber_rounded,
          color: AppColors.warning(context), // Warning icon color
          size: 30,
        ),
        const SizedBox(height: 8),

        Text(
          'Medical Warning',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.text(context), // Title text color
          ),
        ),
        const SizedBox(height: 8),

        Text(
          'BMI is a screening tool and may not reflect body composition. '
          'Consult healthcare professionals for personalized advice.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            height: 1.4,
            color: AppColors.subText(context), // Subtitle text color
          ),
        ),
      ],
    ),
  );
}
