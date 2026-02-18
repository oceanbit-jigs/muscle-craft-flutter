class WorkoutSessionModel {
  final int? id;
  final int focusAreaId;
  final String focusAreaName;
  final String date; // Format: yyyy-MM-dd
  final int totalTimeSeconds;
  final bool isCompleted;
  final String createdAt;
  final String updatedAt;

  WorkoutSessionModel({
    this.id,
    required this.focusAreaId,
    required this.focusAreaName,
    required this.date,
    required this.totalTimeSeconds,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'focus_area_id': focusAreaId,
      'focus_area_name': focusAreaName,
      'date': date,
      'total_time_seconds': totalTimeSeconds,
      'is_completed': isCompleted ? 1 : 0,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory WorkoutSessionModel.fromMap(Map<String, dynamic> map) {
    return WorkoutSessionModel(
      id: map['id'],
      focusAreaId: map['focus_area_id'],
      focusAreaName: map['focus_area_name'],
      date: map['date'],
      totalTimeSeconds: map['total_time_seconds'],
      isCompleted: map['is_completed'] == 1,
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  WorkoutSessionModel copyWith({
    int? id,
    int? focusAreaId,
    String? focusAreaName,
    String? date,
    int? totalTimeSeconds,
    bool? isCompleted,
    String? createdAt,
    String? updatedAt,
  }) {
    return WorkoutSessionModel(
      id: id ?? this.id,
      focusAreaId: focusAreaId ?? this.focusAreaId,
      focusAreaName: focusAreaName ?? this.focusAreaName,
      date: date ?? this.date,
      totalTimeSeconds: totalTimeSeconds ?? this.totalTimeSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
