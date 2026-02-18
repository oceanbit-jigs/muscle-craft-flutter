import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../local_database/daily_weight_database.dart';
import '../../../theme/color/colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  DateTime normalize(DateTime d) {
    return DateTime(d.year, d.month, d.day);
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = normalize(DateTime.now());
    _loadDailyWorkout(_selectedDay!);
  }

  String formatDate(DateTime date) {
    return "${_monthNames[date.month - 1]} ${date.day}";
  }

  bool hasWorkout(DateTime date) {
    return dailyWorkouts.containsKey(dateKey(date));
  }

  final List<String> _monthNames = [
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

  Map<String, List<String>> dailyWorkouts = {};
  int dailyTotalSeconds = 0;
  bool isLoading = false;

  String dateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _loadDailyWorkout(DateTime date) async {
    setState(() {
      isLoading = true;
    });

    final sessions = await WeightDB.instance.getSessionsByDate(date);

    int totalSeconds = 0;
    List<String> workouts = [];

    for (final s in sessions) {
      if (s['is_completed'] == 1) {
        totalSeconds += (s['timer_seconds'] as int);
        workouts.add(s['workout_name'] as String);
      }
    }

    setState(() {
      dailyTotalSeconds = totalSeconds;
      dailyWorkouts = {dateKey(date): workouts};
      isLoading = false;
    });
  }

  Widget _buildWorkoutList() {
    DateTime date = _selectedDay ?? DateTime.now();
    String key = dateKey(date);
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (!dailyWorkouts.containsKey(key) || dailyWorkouts[key]!.isEmpty) {
      return Center(
        child: Column(
          children: [
            Image.asset("assets/icons/noWorkout.png", height: 180),
            const SizedBox(height: 10),
            Text(
              "No Workout",
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    final totalTime = "${dailyTotalSeconds ~/ 60} mins";
    final workouts = dailyWorkouts[key]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "Total Workout Time: $totalTime",
            style: TextStyle(
              color: isDark ? Colors.greenAccent : Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 15),

        /// WORKOUT ITEMS LIST
        ...workouts.map(
          (w) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              w,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
              "History",
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
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Calendar Container ----------
            Container(
              decoration: BoxDecoration(
                color: AppColors.card(context),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border(context), width: 1),
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020),
                lastDay: DateTime.utc(2035),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.month,

                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: AppColors.subText(context),
                    fontSize: 13,
                  ),
                  weekendStyle: TextStyle(
                    color: AppColors.subText(context),
                    fontSize: 13,
                  ),
                ),

                headerStyle: HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: AppColors.icon(context),
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: AppColors.icon(context),
                  ),
                ),

                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  defaultTextStyle: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 15,
                  ),
                  weekendTextStyle: TextStyle(
                    color: AppColors.text(context),
                    fontSize: 15,
                  ),
                  todayDecoration: BoxDecoration(
                    color: AppColors.primary(context).withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: AppColors.primary(context),
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(
                    color: AppColors.card(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

                onDaySelected: (selectedDay, focusedDay) {
                  final local = normalize(selectedDay);
                  debugPrint("Selected: $local");

                  setState(() {
                    _selectedDay = local;
                    _focusedDay = local;
                  });

                  _loadDailyWorkout(local);
                },

                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    if (hasWorkout(day)) {
                      return Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: AppColors.warning(
                            context,
                          ).withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${day.day}',
                          style: TextStyle(color: AppColors.text(context)),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              formatDate(_selectedDay ?? DateTime.now()),
              style: TextStyle(color: AppColors.text(context), fontSize: 16),
            ),

            Divider(color: AppColors.divider(context)),

            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _buildWorkoutList(),
            ),
          ],
        ),
      ),
    );
  }
}
