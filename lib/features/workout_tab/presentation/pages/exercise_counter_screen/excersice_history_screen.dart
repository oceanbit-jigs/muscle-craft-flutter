import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../local_database/database_model/workout_session_model.dart';
import '../../../../../local_database/repo/workout_session_repository.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  const WorkoutHistoryScreen({super.key});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  final WorkoutSessionRepository _repository = WorkoutSessionRepository();
  List<WorkoutSessionModel> _sessions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final sessions = await _repository.getCompletedSessions();
    setState(() {
      _sessions = sessions;
      _isLoading = false;
    });
  }

  String _formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;

    if (hours > 0) {
      return "${hours}h ${minutes}m ${secs}s";
    } else if (minutes > 0) {
      return "${minutes}m ${secs}s";
    } else {
      return "${secs}s";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Exercise History")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _sessions.isEmpty
          ? const Center(child: Text("No completed Exercise yet"))
          : ListView.builder(
              itemCount: _sessions.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final session = _sessions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(session.focusAreaName),
                    subtitle: Text(
                      "Date: ${session.date}\nDuration: ${_formatDuration(session.totalTimeSeconds)}",
                    ),
                    trailing: Icon(Icons.check_circle, color: Colors.green),
                  ),
                );
              },
            ),
    );
  }
}
