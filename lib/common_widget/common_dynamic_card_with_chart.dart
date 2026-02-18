import 'package:flutter/material.dart';
//
// class CommonWeightCard extends StatelessWidget {
//   final String title; // My Weight (dynamic)
//   final String monthName;
//   final bool? showKg;
//   final double? latestKg;
//   final double? latestLbs;
//   final List<double> monthlyWeight;
//   final List<double> monthlyWeightLbs;
//   final VoidCallback onLogTap;
//   final VoidCallback onToggleKgLbs;
//   final Widget chartWidget;
//   final String? unitLabel;
//
//   const CommonWeightCard({
//     super.key,
//     required this.title,
//     required this.monthName,
//     this.showKg,
//     this.latestKg,
//     this.latestLbs,
//     required this.monthlyWeight,
//     required this.monthlyWeightLbs,
//     required this.onLogTap,
//     required this.onToggleKgLbs,
//     required this.chartWidget,
//     this.unitLabel,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.only(
//             top: 35,
//             left: 18,
//             right: 18,
//             bottom: 18,
//           ),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: Colors.white),
//           ),
//
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// ROW 1
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   /// LOG BUTTON
//                   GestureDetector(
//                     onTap: onLogTap,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 6,
//                         horizontal: 20,
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(20),
//                         color: Colors.white,
//                       ),
//                       child: const Text(
//                         "Log",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   /// KG/LBS Toggle
//                   GestureDetector(
//                     onTap: onToggleKgLbs,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         // Text(
//                         //   showKg ? "Current(kg)" : "Current(lbs)",
//                         //   style: const TextStyle(
//                         //     color: Colors.white,
//                         //     fontSize: 14,
//                         //   ),
//                         // ),
//                         // SizedBox(height: 2),
//                         // Text(
//                         //   showKg ? latestKg.toString() : latestLbs.toString(),
//                         //   style: const TextStyle(
//                         //     color: Colors.redAccent,
//                         //     fontSize: 22,
//                         //     fontWeight: FontWeight.bold,
//                         //   ),
//                         // ),
//                         Text(
//                           "Current(${unitLabel ?? (showKg! ? "kg" : "lbs")})",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         Text(
//                           (unitLabel != null)
//                               ? latestKg.toString()
//                               : (showKg!
//                                     ? latestKg.toString()
//                                     : latestLbs.toString()),
//
//                           style: const TextStyle(
//                             color: Colors.redAccent,
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 8),
//
//               /// ROW 2 — Month + Last 30 Days
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     monthName,
//                     style: const TextStyle(color: Colors.white70, fontSize: 14),
//                   ),
//                   const Text(
//                     "▲ Last 30 days",
//                     style: TextStyle(color: Colors.redAccent, fontSize: 12),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 10),
//
//               /// LINE CHART (PASS AS WIDGET)
//               chartWidget,
//             ],
//           ),
//         ),
//
//         /// TITLE (POSITIONED)
//         Positioned(
//           top: -5,
//           left: 16,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             color: Colors.black,
//             child: Text(
//               title, // DYNAMIC
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w500,
//                 fontSize: 14,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class CommonWeightCard extends StatelessWidget {
  final String title; // My Weight (dynamic)
  final String monthName;
  final bool? showKg;
  final double? latestKg;
  final double? latestLbs;
  final List<double> monthlyWeight;
  final List<double> monthlyWeightLbs;
  final VoidCallback onLogTap;
  final VoidCallback onToggleKgLbs;
  final Widget chartWidget;
  final String? unitLabel;

  const CommonWeightCard({
    super.key,
    required this.title,
    required this.monthName,
    this.showKg,
    this.latestKg,
    this.latestLbs,
    required this.monthlyWeight,
    required this.monthlyWeightLbs,
    required this.onLogTap,
    required this.onToggleKgLbs,
    required this.chartWidget,
    this.unitLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 35,
            left: 18,
            right: 18,
            bottom: 18,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white : Colors.black,
              width: 1,
            ),
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ROW 1 — LOG & KG/LBS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// LOG BUTTON
                  GestureDetector(
                    onTap: onLogTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      child: Text(
                        "Log",
                        style: TextStyle(
                          color: isDark ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  /// KG/LBS Toggle
                  GestureDetector(
                    onTap: onToggleKgLbs,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Current(${unitLabel ?? (showKg! ? "kg" : "lbs")})",
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          (unitLabel != null)
                              ? latestKg.toString()
                              : (showKg!
                                    ? latestKg.toString()
                                    : latestLbs.toString()),
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// ROW 2 — Month + Last 30 Days
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    monthName,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    "▲ Last 30 days",
                    style: TextStyle(color: Colors.redAccent, fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// LINE CHART (PASS AS WIDGET)
              chartWidget,
            ],
          ),
        ),

        /// TITLE (POSITIONED)
        Positioned(
          top: -5,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            color: isDark ? Colors.black : Colors.white,
            child: Text(
              title, // DYNAMIC
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
