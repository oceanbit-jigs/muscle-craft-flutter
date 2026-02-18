import 'package:fitness_workout_app/presentation/tab/tracking_tab/history_screen.dart';
import 'package:fitness_workout_app/theme/color/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common_widget/common_chart_view_widget.dart';
import '../../../local_database/daily_weight_database.dart';
import '../../../local_database/local_storage.dart';
import 'custome_tracking_page.dart';

class CloudBubbleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double rSmall = 30;
    double rBig = 60;

    Path path = Path();

    // Start top-left corner
    path.moveTo(rSmall, 0);

    // Top-left curve
    path.quadraticBezierTo(0, 0, 0, rSmall);

    // Left side down
    path.lineTo(0, size.height - rSmall);

    // Bottom-left curve
    path.quadraticBezierTo(0, size.height, rSmall, size.height);

    // Bottom side
    path.lineTo(size.width - rSmall, size.height);

    // Bottom-right curve
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width,
      size.height - rSmall,
    );

    // Right side up until big bump
    path.lineTo(size.width, rBig + 10);

    // Big top-right bump
    path.quadraticBezierTo(size.width, 0, size.width - rBig, 0);

    // Top side
    path.lineTo(rSmall, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  DateTime selectedDate = DateTime.now();
  final ScrollController _scrollController = ScrollController();
  final String monthName = DateFormat('MMMM').format(DateTime.now());
  List<double> monthlyWeight = [];
  List<double> monthlyWeightLbs = [];
  double latestKg = 0.0;
  double latestLbs = 0;
  bool showKg = true;
  bool isTotal = false;
  String userName = "User";
  bool isWeekly = true;

  int todaySeconds = 0;
  int weekSeconds = 0;
  int monthSeconds = 0;

  int weeklyWorkoutCount = 0;
  int monthlyWorkoutCount = 0;
  int totalWorkoutCount = 0;

  Map<String, Map<String, String>> latestHistory = {};
  bool isLoading = true;
  List<int> weeklyDailySeconds = [];
  List<int> monthlyDailySeconds = [];

  late List<DateTime> monthDates;

  // List<double> dailyWorkouts = [
  //   1,
  //   0,
  //   2,
  //   3,
  //   1,
  //   2,
  //   0,
  //   4,
  //   3,
  //   1,
  //   2,
  //   3,
  //   0,
  //   1,
  //   2,
  //   4,
  //   3,
  //   2,
  //   1,
  //   0,
  //   2,
  //   2,
  //   3,
  //   1,
  //   2,
  //   3,
  //   3,
  //   2,
  //   1,
  //   1,
  //   2,
  //   3,
  // ];

  List<FlSpot> generateMonthLineChart(List<double> values) {
    final now = DateTime.now();
    final days = DateTime(now.year, now.month + 1, 0).day;

    List<FlSpot> spots = [];

    for (int i = 1; i <= days; i++) {
      double v = (i <= values.length) ? values[i - 1] : 0;
      spots.add(FlSpot(i.toDouble(), v));
    }

    return spots;
  }

  List<FlSpot> generateMonthLineChart1(List<int> values) {
    final now = DateTime.now();
    final days = DateTime(now.year, now.month + 1, 0).day;

    List<FlSpot> spots = [];

    for (int i = 1; i <= days; i++) {
      int v = (i <= values.length) ? values[i - 1] : 0;
      spots.add(FlSpot(i.toDouble(), v.toDouble()));
    }

    return spots;
  }

  List<FlSpot> generateWeekLineChart(List<int> data) {
    return List.generate(data.length, (index) {
      final minutes = data[index] / 60;
      return FlSpot(index.toDouble() + 1, minutes);
    });
  }

  final Map<String, Map<String, dynamic>> workoutHistory = {
    "2025-11-15": {
      "totalTime": "20 mins",
      "workouts": ["Shoulder Workout"],
    },
    "2025-11-21": {
      "totalTime": "45 mins",
      "workouts": ["Chest Workout", "Pushups", "Bench Press"],
    },
    "2025-11-22": {
      "totalTime": "30 mins",
      "workouts": ["Leg Workout", "Squats"],
    },
    "2025-11-23": {
      "totalTime": "40 mins",
      "workouts": ["Core Workout", "Planks", "Crunches"],
    },
    "2025-11-25": {
      "totalTime": "25 mins",
      "workouts": ["Pushups", "Planks"],
    },
  };

  void _openWeightLogDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String unit = "kg";
        TextEditingController weightCtrl = TextEditingController();

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
              insetAnimationCurve: Curves.linear,
              clipBehavior: Clip.none,
              insetAnimationDuration: Duration(microseconds: 200),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Log Your Weight",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    ToggleButtons(
                      isSelected: [unit == "kg", unit == "lbs"],
                      borderRadius: BorderRadius.circular(30),
                      selectedColor: Colors.white,
                      fillColor: Colors.transparent,
                      color: Colors.white70,
                      renderBorder: false,
                      constraints: const BoxConstraints(
                        minHeight: 40,
                        minWidth: 100,
                      ),

                      onPressed: (index) {
                        setState(() {
                          String newUnit = index == 0 ? "kg" : "lbs";

                          if (weightCtrl.text.isNotEmpty) {
                            double value =
                                double.tryParse(weightCtrl.text) ?? 0;

                            if (unit == "kg" && newUnit == "lbs") {
                              value = value * 2.20462;
                            } else if (unit == "lbs" && newUnit == "kg") {
                              value = value / 2.20462;
                            }

                            weightCtrl.text = value.toStringAsFixed(1);
                          }

                          unit = newUnit;
                        });
                      },

                      children: List.generate(2, (index) {
                        bool selected = unit == (index == 0 ? "kg" : "lbs");

                        return Container(
                          width: 120,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: selected
                              ? BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.grey,
                                      Colors.black,
                                      Colors.white,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Colors.grey),
                                )
                              : null,
                          alignment: Alignment.center,
                          child: Text(
                            index == 0 ? "KG" : "LBS",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 20),

                    /// -------------------- WEIGHT Textfield --------------------
                    TextField(
                      controller: weightCtrl,
                      textAlign: TextAlign.center,
                      cursorColor: Colors.white,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        hintText: "0",
                        hintStyle: TextStyle(color: Colors.white24),
                        border: InputBorder.none,
                      ),
                    ),

                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: () async {
                        DateTime now = DateTime.now();

                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          barrierDismissible: true,
                          firstDate: DateTime(now.year, now.month, 1),
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
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// -------------------- OK BUTTON --------------------
                    ElevatedButton(
                      onPressed: () async {
                        double weight = double.tryParse(weightCtrl.text) ?? 0;

                        await WeightDB.instance.insertWeight(
                          weight,
                          unit,
                          selectedDate,
                        );

                        await _loadMonthlyWeight();
                        await _loadLatestWeight();

                        final all = await WeightDB.instance.getAll();
                        debugPrint("------------ DB CONTENT ------------");

                        // all.sort((a, b) => a['id'].compareTo(b['id']));
                        for (var item in all) {
                          debugPrint(
                            "ID: ${item['id']} | KG: ${item['kg']} | LBS: ${item['lbs']} | DATE: ${item['date']}",
                          );
                        }
                        debugPrint("------------------------------------");

                        // Navigator.pop(context);

                        if (context.mounted) {
                          Navigator.pop(context);
                        }

                        debugPrint("Weight: ${weightCtrl.text} $unit");
                        debugPrint("Date: $selectedDate");
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "OK",
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

  String formatMinutes(int seconds) {
    return (seconds ~/ 60).toString();
  }

  List<FlSpot> generateDayPoints(List<double> values) {
    return List.generate(values.length, (index) {
      return FlSpot(index.toDouble() + 1, values[index]);
    });
  }

  List<double> get weeklyMinutes =>
      weeklyDailySeconds.map((e) => e / 60).toList();

  List<double> get monthlyMinutes =>
      monthlyDailySeconds.map((e) => e / 60).toList();

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    int daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    monthDates = List.generate(
      daysInMonth,
      (i) => DateTime(now.year, now.month, i + 1),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });

    _loadMonthlyWeight();
    _loadLatestWeight();
    _loadUserData();
    _loadDashboardData();
    _loadChartData();
  }

  Future<void> _loadUserData() async {
    final userData = await LocalStorage.getUserData();
    if (userData != null) {
      debugPrint("printUserdata : $userData");
      setState(() {
        userName = userData['name'] ?? "User";
      });
    }
  }

  Future<void> _loadMonthlyWeight() async {
    final now = DateTime.now();
    int daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    monthlyWeight = List.filled(daysInMonth, 0);
    monthlyWeightLbs = List.filled(daysInMonth, 0);

    final result = await WeightDB.instance.getMonthWeights(now.year, now.month);

    for (var row in result) {
      DateTime date = DateTime.parse(row["date"]);
      int index = date.day - 1;

      if (index >= 0 && index < daysInMonth) {
        monthlyWeight[index] = (row["kg"] * 1.0);
        monthlyWeightLbs[index] = (row["lbs"] * 1.0);
      }
    }

    debugPrint("Monthly Weight List (KG):");
    for (int i = 0; i < monthlyWeight.length; i++) {
      debugPrint("Day ${i + 1}: ${monthlyWeight[i]} kg");
    }

    debugPrint("Monthly Weight List (LBS):");
    for (int i = 0; i < monthlyWeightLbs.length; i++) {
      debugPrint("Day ${i + 1}: ${monthlyWeightLbs[i]} lbs");
    }

    debugPrint("Raw DB Rows:");
    for (var row in result) {
      print(row);
    }

    setState(() {});
  }

  Future<void> _loadLatestWeight() async {
    debugPrint("Fetching latest weight from DB...");

    final row = await WeightDB.instance.getLatestWeight();

    if (row != null) {
      debugPrint("Latest DB Row: $row");

      setState(() {
        latestKg = (row["kg"] * 1.0);
        latestLbs = (row["lbs"] * 1.0);
      });

      debugPrint("Latest KG: $latestKg");
      debugPrint("Latest LBS: $latestLbs");
    } else {
      debugPrint("No weight entry found in DB.");

      setState(() {
        latestKg = 0.0;
        latestLbs = 0.0;
      });
    }
  }

  Future<void> _loadDashboardData() async {
    final today = await WeightDB.instance.getTodayTotalTime();
    final week = await WeightDB.instance.getThisWeekTotalTime();
    final month = await WeightDB.instance.getThisMonthTotalTime();
    final history = await WeightDB.instance.getLatestThreeHistory();

    final weeklyCount = await WeightDB.instance.getThisWeekWorkoutCount();
    final monthlyCount = await WeightDB.instance.getThisMonthWorkoutCount();
    final totalCount = await WeightDB.instance.getTotalWorkoutCount();

    print("printCount : $totalCount");

    setState(() {
      todaySeconds = today;
      weekSeconds = week;
      monthSeconds = month;
      weeklyWorkoutCount = weeklyCount;
      monthlyWorkoutCount = monthlyCount;
      totalWorkoutCount = totalCount;
      latestHistory = history;
      isLoading = false;
    });
  }

  Future<void> _loadChartData() async {
    final weekly = await WeightDB.instance.getCurrentWeekDailyWorkoutTime();
    final monthly = await WeightDB.instance.getCurrentMonthDailyWorkoutTime();

    setState(() {
      weeklyDailySeconds = weekly;
      monthlyDailySeconds = monthly;
    });
  }

  void _scrollToToday() {
    int todayIndex = monthDates.indexWhere(
      (d) =>
          d.day == DateTime.now().day &&
          d.month == DateTime.now().month &&
          d.year == DateTime.now().year,
    );

    if (todayIndex != -1) {
      double itemWidth = 65 + 16;

      _scrollController.animateTo(
        todayIndex * itemWidth,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static Widget _dayBox({
    required String day,
    required String date,
    required bool isSelected,
    required bool isToday,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedBgColor = isDark ? Colors.white : Colors.black;
    final selectedTextColor = isDark ? Colors.black : Colors.white;
    final todayBorderColor = isDark ? Colors.white70 : Colors.black54;
    final defaultTextColor = isDark ? Colors.white70 : Colors.black54;

    return Container(
      width: 65,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: isSelected ? selectedBgColor : Colors.transparent,
        border: Border.all(
          color: isSelected
              ? selectedBgColor
              : isToday
              ? todayBorderColor
              : Colors.transparent,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              color: isSelected
                  ? selectedTextColor
                  : isToday
                  ? (isDark ? Colors.white : Colors.black)
                  : defaultTextColor,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              color: isSelected
                  ? selectedTextColor
                  : isToday
                  ? (isDark ? Colors.white : Colors.black)
                  : defaultTextColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isToday) ...[
            const SizedBox(height: 2),
            Image.asset("assets/icons/right.png", height: 10),
          ],
        ],
      ),
    );
  }

  final List<String> monthName1 = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];

  String dayShort(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return "Mon";
      case DateTime.tuesday:
        return "Tue";
      case DateTime.wednesday:
        return "Wed";
      case DateTime.thursday:
        return "Thu";
      case DateTime.friday:
        return "Fri";
      case DateTime.saturday:
        return "Sat";
      case DateTime.sunday:
        return "Sun";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = workoutHistory.length > 3 ? 3 : workoutHistory.length;
    final keys = latestHistory.keys.toList();

    int dynamicCrossAxisCount = itemCount <= 2 ? itemCount : 3;

    if (kDebugMode) {
      print("monthName : $monthName");
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tracking",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  //color: Colors.white,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  const Text("👋", style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        userName,
                        style: TextStyle(
                          //color: Colors.white,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// ------------------ INFINITE SCROLL DAYS ------------------
              SizedBox(
                height: 80,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: monthDates.length,
                  itemBuilder: (context, index) {
                    DateTime date = monthDates[index];

                    String dayName = dayShort(date.weekday);
                    String dayNum = date.day.toString();

                    bool isSelected = isSameDate(date, selectedDate);
                    bool isToday = isSameDate(date, DateTime.now());

                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedDate = date);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _dayBox(
                          day: dayName,
                          date: dayNum,
                          isSelected: isSelected,
                          isToday: isToday,
                          context: context,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              /// ------------------ WEEKLY CARD ------------------
              Row(
                //crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// BODYBUILDER IMAGE
                  Expanded(
                    child: Image.asset(
                      "assets/icons/bodyBuilder.png",
                      height: 150,
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// WHITE CURVED BUBBLE CARD
                  Expanded(
                    child: ClipPath(
                      clipper: CloudBubbleClipper(),
                      child: Container(
                        width: 185,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              isTotal ? "Total" : "Weekly",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              isTotal ? "Total" : "Average",
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.2,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Exercises",
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.2,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Completed!",
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.2,
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              isTotal
                                  ? totalWorkoutCount.toString()
                                  : weeklyWorkoutCount.toString(),
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isTotal = !isTotal;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black
                                        : Colors.white,
                                    border: Border.all(
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    size: 25,
                                  ),
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

              const SizedBox(height: 30),

              /// ------------------ TOTAL BOX ------------------
              Stack(
                children: [
                  // Main container
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
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        /// ------- TOP STAT NUMBERS -------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            StatColumn(
                              "Workouts",
                              isWeekly
                                  ? weeklyWorkoutCount.toString()
                                  : monthlyWorkoutCount.toString(),
                              titleColor:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              valueFontSize: 20,
                            ),
                            StatColumn(
                              "Time (min)",
                              ((isWeekly ? weekSeconds : monthSeconds) ~/ 60)
                                  .toString(),
                              titleColor:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              valueFontSize: 20,
                            ),

                            // GestureDetector(
                            //   onTap: () {
                            //     setState(() {
                            //       isWeekly = !isWeekly;
                            //     });
                            //   },
                            //   child: StatColumn(
                            //     "Volume",
                            //     isWeekly ? "Weekly" : "Monthly",
                            //     titleColor:
                            //         Theme.of(context).brightness ==
                            //             Brightness.dark
                            //         ? Colors.white
                            //         : Colors.black,
                            //     valueFontSize: 20,
                            //   ),
                            // ),
                            StatColumn(
                              "Volume",
                              "",
                              titleColor:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              valueWidget: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: isWeekly ? "Weekly" : "Monthly",
                                  dropdownColor:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? const Color(0xFF303030)
                                      : Colors.white,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: "Weekly",
                                      child: Text("Weekly"),
                                    ),
                                    DropdownMenuItem(
                                      value: "Monthly",
                                      child: Text("Monthly"),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      isWeekly = value == "Weekly";
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        /// Divider line
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white24
                              : Colors.black26,
                        ),

                        const SizedBox(height: 20),

                        /// ------- TITLE INSIDE CONTAINER -------
                        Text(
                          "Workouts times per week",
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 15),

                        /// ------- CHART AREA -------
                        // Container(
                        //   height: 200,
                        //   padding: const EdgeInsets.all(5),
                        //   decoration: BoxDecoration(
                        //     color: const Color(0xFF404040),
                        //     borderRadius: BorderRadius.circular(20),
                        //   ),
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(5.0),
                        //
                        //     child: LayoutBuilder(
                        //       builder: (context, constraints) {
                        //         final now = DateTime.now();
                        //         // final days = DateTime(
                        //         //   now.year,
                        //         //   now.month + 1,
                        //         //   0,
                        //         // ).day;
                        //
                        //         final days = isWeekly
                        //             ? 7
                        //             : DateTime(now.year, now.month + 1, 0).day;
                        //
                        //         return SingleChildScrollView(
                        //           scrollDirection: Axis.horizontal,
                        //           child: Row(
                        //             children: [
                        //               SizedBox(
                        //                 width: days * 30,
                        //                 height: 160,
                        //                 child: Padding(
                        //                   padding: const EdgeInsets.only(
                        //                     left: 10,
                        //                     right: 10,
                        //                   ),
                        //                   child: LineChart(
                        //                     LineChartData(
                        //                       minX: 1,
                        //                       maxX: days.toDouble(),
                        //                       minY: 0,
                        //                       clipData: FlClipData.none(),
                        //
                        //                       // lineTouchData: LineTouchData(
                        //                       //   enabled: false,
                        //                       // ),
                        //                       gridData: FlGridData(show: false),
                        //                       borderData: FlBorderData(
                        //                         show: false,
                        //                       ),
                        //
                        //                       titlesData: FlTitlesData(
                        //                         leftTitles: AxisTitles(
                        //                           sideTitles: SideTitles(
                        //                             showTitles: false,
                        //                           ),
                        //                         ),
                        //                         topTitles: AxisTitles(
                        //                           sideTitles: SideTitles(
                        //                             showTitles: false,
                        //                           ),
                        //                         ),
                        //                         rightTitles: AxisTitles(
                        //                           sideTitles: SideTitles(
                        //                             showTitles: false,
                        //                           ),
                        //                         ),
                        //                         bottomTitles: AxisTitles(
                        //                           sideTitles: SideTitles(
                        //                             showTitles: true,
                        //                             interval: 1,
                        //                             reservedSize: 20,
                        //                             // getTitlesWidget: (value, meta) {
                        //                             //   return SideTitleWidget(
                        //                             //     axisSide: meta.axisSide,
                        //                             //     space: 8,
                        //                             //     child: Text(
                        //                             //       value
                        //                             //           .toInt()
                        //                             //           .toString(),
                        //                             //       style:
                        //                             //           const TextStyle(
                        //                             //             color: Colors
                        //                             //                 .white70,
                        //                             //             fontSize: 10,
                        //                             //           ),
                        //                             //     ),
                        //                             //   );
                        //                             // },
                        //                             getTitlesWidget: (value, meta) {
                        //                               if (isWeekly) {
                        //                                 const days = [
                        //                                   'M',
                        //                                   'T',
                        //                                   'W',
                        //                                   'T',
                        //                                   'F',
                        //                                   'S',
                        //                                   'S',
                        //                                 ];
                        //                                 final index =
                        //                                     value.toInt() - 1;
                        //
                        //                                 if (index < 0 ||
                        //                                     index >= 7)
                        //                                   return const SizedBox();
                        //                                 return Text(
                        //                                   days[index],
                        //                                   style:
                        //                                       const TextStyle(
                        //                                         color: Colors
                        //                                             .white70,
                        //                                         fontSize: 10,
                        //                                       ),
                        //                                 );
                        //                               }
                        //
                        //                               // Monthly (default)
                        //                               return Text(
                        //                                 value
                        //                                     .toInt()
                        //                                     .toString(),
                        //                                 style: const TextStyle(
                        //                                   color: Colors.white70,
                        //                                   fontSize: 10,
                        //                                 ),
                        //                               );
                        //                             },
                        //                           ),
                        //                         ),
                        //                       ),
                        //
                        //                       lineBarsData: [
                        //                         LineChartBarData(
                        //                           // spots: generateMonthLineChart(
                        //                           //   dailyWorkouts,
                        //                           // ),
                        //                           spots: isWeekly
                        //                               ? generateWeekLineChart(
                        //                                   weeklyDailySeconds,
                        //                                 )
                        //                               : generateMonthLineChart1(
                        //                                   monthlyDailySeconds,
                        //                                 ),
                        //
                        //                           isCurved: true,
                        //                           barWidth: 3,
                        //                           color: Colors.orangeAccent,
                        //                           dotData: FlDotData(
                        //                             show: true,
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         );
                        //       },
                        //     ),
                        //   ),
                        // ),
                        CommonLineChartView(
                          xAxisLabel: isWeekly ? "Days" : "Days of Month",
                          yAxisLabel: "Minutes",
                          values: isWeekly ? weeklyMinutes : monthlyMinutes,
                          showKg: true, // not relevant here, but required
                          chartType:
                              "Daily", // IMPORTANT (enables Mon–Sun logic)
                          generatePoints: generateDayPoints,
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    top: -5,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                      child: Text(
                        "Total",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Stack(
              //   children: [
              //     Container(
              //       width: double.infinity,
              //       padding: const EdgeInsets.all(18),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(20),
              //         border: Border.all(
              //           color: Theme.of(context).brightness == Brightness.dark
              //               ? Colors.white
              //               : Colors.black,
              //           width: 1,
              //         ),
              //       ),
              //       child: Column(
              //         children: [
              //           Image.asset(
              //             "assets/icons/fullBody.png",
              //             height: 240,
              //             fit: BoxFit.cover,
              //           ),
              //         ],
              //       ),
              //     ),
              //     Positioned(
              //       top: -5,
              //       left: 16,
              //       child: Container(
              //         padding: const EdgeInsets.symmetric(horizontal: 10),
              //         color: Theme.of(context).brightness == Brightness.dark
              //             ? Colors.black
              //             : Colors.white,
              //         child: Text(
              //           "Body",
              //           style: TextStyle(
              //             color: Theme.of(context).brightness == Brightness.dark
              //                 ? Colors.white
              //                 : Colors.black,
              //             fontWeight: FontWeight.w500,
              //             fontSize: 14,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              "assets/trackingTab/full_body1.png",
                              height: 350,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              "assets/trackingTab/full_body2.png",
                              height: 350,
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Floating label
                  Positioned(
                    top: -5,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                      child: Text(
                        "Body",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Stack(
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
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        width: 1,
                      ),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF1E1E1E)
                          : Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// ROW 1 — Log  ↔  Current(kg)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// LEFT → LOG BUTTON
                            GestureDetector(
                              onTap: _openWeightLogDialog,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                child: Text(
                                  "Log",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black
                                        : Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),

                            /// RIGHT → Current(kg) and 2 (in next line)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showKg = !showKg;
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    showKg ? "Current(kg)" : "Current(lbs)",
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    showKg
                                        ? latestKg.toString()
                                        : latestLbs.toString(),
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

                        /// ROW 2 — November ↔ Last 30 Days
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              monthName,
                              style: TextStyle(
                                color:
                                    Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white70
                                    : Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                            const Text(
                              "▲ Last 30 days",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        CommonLineChartView(
                          xAxisLabel: "DATE",
                          yAxisLabel: showKg ? "Weight (kg)" : "Weight (lbs)",
                          values: showKg ? monthlyWeight : monthlyWeightLbs,
                          showKg: showKg,
                          generatePoints: generateMonthLineChart,
                          chartType: "Daily",
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    top: -5,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                      child: Text(
                        "My Weight",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 210,
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 18,
                      right: 18,
                      bottom: 18,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF1E1E1E)
                          : Colors.white,
                    ),
                    child: Column(
                      children: [
                        /// MAIN CONTENT (LIST OR NO DATA)
                        Expanded(
                          child: latestHistory.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icons/noWorkout.png",
                                      height: 100,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "No Workout",
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                )
                              : GridView.builder(
                                  padding: const EdgeInsets.only(top: 15),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: dynamicCrossAxisCount,
                                        mainAxisExtent: 100,
                                        mainAxisSpacing: 12,
                                        crossAxisSpacing: 12,
                                      ),
                                  itemCount: keys.length,
                                  itemBuilder: (context, index) {
                                    final dateKey = keys[index];
                                    final totalTime =
                                        latestHistory[dateKey]!["totalTime"]!;
                                    DateTime dt = DateTime.parse(dateKey);
                                    String formattedDate =
                                        "${dt.day} ${monthName1[dt.month - 1]} ${dt.year % 100}";

                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white10
                                            : Colors.black12,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color:
                                              Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          /// TIME ROW
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                totalTime.split(' ')[0],
                                                style: const TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Transform.translate(
                                                offset: const Offset(0, 6),
                                                child: Text(
                                                  "mins",
                                                  style: TextStyle(
                                                    color:
                                                        Theme.of(
                                                              context,
                                                            ).brightness ==
                                                            Brightness.dark
                                                        ? Colors.white70
                                                        : Colors.black54,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),

                                          /// DATE
                                          Text(
                                            formattedDate,
                                            style: TextStyle(
                                              color:
                                                  Theme.of(
                                                        context,
                                                      ).brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),

                        /// ALWAYS VISIBLE BUTTON
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HistoryScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: 250,
                            height: 40,
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "View All",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// HEADER TITLE
                  Positioned(
                    top: -5,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white,
                      child: Text(
                        "History",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomTrackingPage(),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Custom Tracking",
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class StatColumn extends StatelessWidget {
  final String title;
  final String value;
  final Color? titleColor;
  final Color? valueColor;

  final double? titleFontSize;
  final double? valueFontSize;

  final Widget? valueWidget;

  const StatColumn(
    this.title,
    this.value, {
    super.key,
    this.titleColor,
    this.valueColor,
    this.titleFontSize,
    this.valueFontSize,
    this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: titleFontSize ?? 12,
            color:
                titleColor ??
                (brightness == Brightness.dark ? Colors.white : Colors.black),
          ),
        ),
        const SizedBox(height: 3),

        // Text(
        //   value,
        //   style: TextStyle(
        //     fontSize: valueFontSize ?? 23,
        //     fontWeight: FontWeight.bold,
        //     color: valueColor ?? Colors.red,
        //   ),
        // ),
        valueWidget ??
            Text(
              value,
              style: TextStyle(
                fontSize: valueFontSize ?? 23,
                fontWeight: FontWeight.bold,
                color: valueColor ?? Colors.red,
              ),
            ),
      ],
    );
  }
}
