import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common_widget/common_chart_view_widget.dart';
import '../../../common_widget/common_dynamic_card_with_chart.dart';
import '../../../local_database/daily_weight_database.dart';
import '../../../theme/color/colors.dart';

class CustomTrackingPage extends StatefulWidget {
  const CustomTrackingPage({super.key});

  @override
  State<CustomTrackingPage> createState() => _CustomTrackingPageState();
}

class _CustomTrackingPageState extends State<CustomTrackingPage> {
  List<Map<String, dynamic>> customTrackers = [];

  final List<String> monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  @override
  void initState() {
    super.initState();
    _loadTrackers();
  }

  Future<void> _loadTrackers() async {
    final data = await WeightDB.instance.getAllTrackers();

    List<Map<String, dynamic>> temp = [];

    for (var t in data) {
      // double latest = await WeightDB.instance.getLatestLogValue(t["id"]) ?? 0;
      double latest =
          await WeightDB.instance.getLatestTrackerValue(t["id"], t["type"]) ??
          0;

      List<double> chartVals = await WeightDB.instance.getTrackerLogs(
        t["id"],
        t["type"],
      );

      chartVals = chartVals;

      debugPrint("Chart Values : $chartVals");

      temp.add({
        "id": t["id"],
        "name": t["name"],
        "unit": t["unit"],
        "type": t["type"],
        "chartValues": chartVals,
        "latest": latest,
      });

      debugPrint(
        "PrintID: ${t["id"]}, PrintName: ${t["name"]}, PrintUnit: ${t["unit"]}, PrintChartValues: $chartVals, PrintLatest: ${t["latest"]} ",
      );
    }

    setState(() => customTrackers = temp);
  }

  void _openCustomTrackingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameCtrl = TextEditingController();
        TextEditingController unitCtrl = TextEditingController();

        String selectedType = "Daily";

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: Colors.black,
              shadowColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: AppColors.border(context)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: const Text(
                        "Custom Tracking",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text("Name", style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: nameCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white10,
                        hintText: "Enter name",
                        hintStyle: const TextStyle(color: Colors.white38),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white24),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "Units",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: unitCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white10,
                        hintText: "Enter units (kg, mins, steps...)",
                        hintStyle: const TextStyle(color: Colors.white38),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white24),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTypeButton(
                          "Daily",
                          selectedType,
                          (val) => setStateDialog(() => selectedType = val),
                        ),
                        _buildTypeButton(
                          "Weekly",
                          selectedType,
                          (val) => setStateDialog(() => selectedType = val),
                        ),
                        _buildTypeButton(
                          "Monthly",
                          selectedType,
                          (val) => setStateDialog(() => selectedType = val),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (nameCtrl.text.isEmpty || unitCtrl.text.isEmpty) {
                            return;
                          }

                          /// ---- 1. INSERT INTO DB FIRST (async allowed) ----
                          final id = await WeightDB.instance.insertTracker(
                            nameCtrl.text,
                            unitCtrl.text,
                            selectedType,
                            [],
                          );

                          /// ---- 2. UPDATE PARENT STATE (sync only) ----
                          setState(() {
                            List<double> initialValues = [];

                            // if (selectedType == "Daily") {
                            //   initialLabels = List.generate(
                            //     31,
                            //     (i) => "${i + 1}",
                            //   );
                            //   initialValues = List.generate(31, (i) => 0.0);
                            // }

                            if (selectedType == "Daily") {
                              // Get the current month and year
                              final now = DateTime.now();
                              final year = now.year;
                              final month = now.month;

                              // Calculate number of days in the month
                              final lastDayOfMonth = DateTime(
                                year,
                                month + 1,
                                0,
                              ).day;

                              initialValues = List.generate(
                                lastDayOfMonth,
                                (i) => 0.0,
                              );
                            }

                            if (selectedType == "Weekly") {
                              int totalWeeks =
                                  ((DateTime(DateTime.now().year, 12, 31)
                                              .difference(
                                                DateTime(
                                                  DateTime.now().year,
                                                  1,
                                                  1,
                                                ),
                                              )
                                              .inDays +
                                          1) ~/
                                      7) +
                                  1;

                              initialValues = List.generate(
                                totalWeeks,
                                (i) => 0.0,
                              );
                            }

                            if (selectedType == "Monthly") {
                              initialValues = List.generate(12, (i) => 0.0);
                            }

                            customTrackers.add({
                              "id": id,
                              "name": nameCtrl.text,
                              "unit": unitCtrl.text,
                              "type": selectedType,
                              "chartValues": initialValues,
                            });
                          });

                          // Navigator.pop(context);

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "Add",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
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
    );
  }

  Widget _buildTypeButton(
    String label,
    String selectedType,
    Function(String) onSelect,
  ) {
    final bool isSelected = label == selectedType;

    return GestureDetector(
      onTap: () {
        onSelect(label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white10,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white24),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _openCustomTrackerLogDialog(
    int id,
    String title,
    String unit,
    String type,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController valueCtrl = TextEditingController();
        DateTime selectedDate = DateTime.now();

        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              elevation: 5,
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: AppColors.border(context)),
              ),
              shadowColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Log Your $title",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: valueCtrl,
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: "0",
                        hintStyle: const TextStyle(color: Colors.white24),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 10),
                          child: Text(
                            unit,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        suffixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        border: InputBorder.none,
                      ),
                    ),

                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: () async {
                        DateTime now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          // firstDate: DateTime(now.year, now.month, 1),
                          firstDate: DateTime(2000, 1, 1),
                          lastDate: now,
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: Colors.redAccent,
                                  onPrimary: Colors.white,
                                  surface: Colors.black,
                                  onSurface: Colors.white,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (picked != null) {
                          setState(() => selectedDate = picked);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              color: Colors.white70,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat("dd MMM, yyyy").format(selectedDate),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    ElevatedButton(
                      onPressed: () async {
                        if (valueCtrl.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter a value"),
                            ),
                          );
                          return;
                        }

                        final double enteredValue =
                            double.tryParse(valueCtrl.text.trim()) ?? 0;

                        await WeightDB.instance.insertOrUpdateCustomTrackerLog(
                          trackerId: id,
                          fieldName: title,
                          value: enteredValue,
                          date: selectedDate,
                          type: type,
                        );

                        // await _loadTrackers();
                        // setState(() {});

                        // Navigator.pop(context);

                        if (context.mounted) {
                          Navigator.pop(context);
                        }

                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          await _loadTrackers();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "SAVE",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentMonth = monthNames[DateTime.now().month - 1];
    return Scaffold(
      appBar: AppBar(
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
              "Custom Tracking",
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
      // AppBar(
      //   // backgroundColor: Colors.black,
      //   elevation: 0,
      //   scrolledUnderElevation: 0,
      //   leading: Padding(
      //     padding: const EdgeInsets.only(left: 12),
      //     child: Container(
      //       height: 25,
      //       width: 25,
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
      //     "Custom Tracking",
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontWeight: FontWeight.w700,
      //       fontSize: 18,
      //     ),
      //   ),
      //   centerTitle: true,
      // ),
      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          ...customTrackers.map((tracker) {
            final List<double> chartVals =
                (tracker["chartValues"] as List<dynamic>?)
                    ?.map((e) => (e as num).toDouble())
                    .toList() ??
                [];

            debugPrint("chart Latest val : ${chartVals.last}");

            return Padding(
              padding: EdgeInsets.only(bottom: 15),
              child: CommonWeightCard(
                title: tracker["name"],
                monthName: currentMonth,
                // showKg: true,
                //latestKg: (tracker["values"].last as double),
                latestKg: tracker["latest"] ?? 0,
                latestLbs: 0,
                unitLabel: tracker["unit"],
                monthlyWeight: chartVals,
                monthlyWeightLbs: [],
                onLogTap: () {
                  _openCustomTrackerLogDialog(
                    tracker["id"],
                    tracker["name"],
                    tracker["unit"],
                    tracker["type"],
                  );
                },

                onToggleKgLbs: () {},
                chartWidget: CommonLineChartView(
                  // xAxisLabel: "DATE",
                  xAxisLabel: tracker["type"],
                  yAxisLabel: tracker["unit"],
                  // values: tracker["chartValues"],
                  values: chartVals,
                  showKg: true,
                  chartType: tracker["type"],
                  generatePoints: (vals) {
                    return List.generate(vals.length, (i) {
                      return FlSpot((i + 1).toDouble(), vals[i]);
                    });
                  },
                ),
              ),
            );
          }),
        ],
      ),

      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.white,
      //   onPressed: _openCustomTrackingDialog,
      //   child: const Icon(Icons.add),
      // ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        onPressed: _openCustomTrackingDialog,
        child: Icon(
          Icons.add,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
