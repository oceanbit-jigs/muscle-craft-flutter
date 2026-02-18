class TimeFormatter {
  /// Format seconds to "Xh Xm" or "Xm Xs"
  static String formatDuration(int totalSeconds) {
    if (totalSeconds < 60) {
      return "${totalSeconds}s";
    }

    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    if (hours > 0) {
      return "${hours}h ${minutes}m";
    } else {
      return "${minutes}m ${seconds}s";
    }
  }

  /// Format seconds to "HH:MM:SS"
  static String formatDurationFull(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    if (hours > 0) {
      return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    } else {
      return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    }
  }

  /// Format seconds to readable string like "2 hours 30 minutes"
  static String formatDurationReadable(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;

    List<String> parts = [];

    if (hours > 0) {
      parts.add("$hours ${hours == 1 ? 'hour' : 'hours'}");
    }
    if (minutes > 0) {
      parts.add("$minutes ${minutes == 1 ? 'minute' : 'minutes'}");
    }

    if (parts.isEmpty) {
      return "$totalSeconds seconds";
    }

    return parts.join(" ");
  }
}
