import 'package:flutter/material.dart';

class AppColors {
  // ------------------------------
  // LIGHT THEME COLORS
  // ------------------------------
  static const Color lightBackground = Colors.white;
  static const Color lightCard = Colors.white;
  static const Color lightText = Colors.black;
  static const Color lightSubText = Colors.black54;
  static const Color lightIcon = Colors.black87;

  // LIGHT
  static const Color lightWarning = Colors.yellow;
  // DARK
  static const Color darkWarning = Colors.yellow;

  // Borders
  static const Color lightBorder = Colors.black;
  static const Color lightDivider = Colors.black26;

  // Functional Colors
  static const Color lightPrimary = Colors.black;
  static const Color lightButtonText = Colors.white;

  // ------------------------------
  // DARK THEME COLORS
  // ------------------------------
  static const Color darkBackground = Color(0xFF0D0D0D);
  static const Color darkCard = Color(0xFF1A1A1A);
  static const Color darkText = Colors.white;
  static const Color darkSubText = Colors.white60;
  static const Color darkIcon = Colors.white;

  // Borders
  static const Color darkBorder = Colors.grey;
  static const Color darkDivider = Colors.grey;

  // Functional Colors
  static const Color darkPrimary = Colors.white;
  static const Color darkButtonText = Colors.black;

  //Divider video
  static const Color videoDivider = Colors.red;

  static const bmiLabelStyle = TextStyle(fontSize: 10);
  static const bmiValueStyle = TextStyle(fontSize: 10);

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color rowEven(BuildContext context) =>
      isDark(context) ? const Color(0xFF0F1A2A) : const Color(0xFFF5F5F5);

  static Color rowOdd(BuildContext context) =>
      isDark(context) ? const Color(0xFF091422) : const Color(0xFFFFFFFF);

  static Color cardDark(BuildContext context) =>
      isDark(context) ? const Color(0xFF0B1120) : const Color(0xFFEAEAEA);

  // LIGHT THEME
  static const Color lightSecondary = Color(0xFF5B8FF9); // example blue accent

  // DARK THEME
  static const Color darkSecondary = Color(0xFF366AD6); // darker blue accent

  // Getter
  static Color secondary(BuildContext context) =>
      isDark(context) ? darkSecondary : lightSecondary;

  // ------------------------------
  // GETTERS
  // ------------------------------
  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkBackground
      : lightBackground;

  static Color card(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkCard : lightCard;

  static Color text(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkText : lightText;

  static Color subText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkSubText
      : lightSubText;

  static Color icon(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? darkIcon : lightIcon;

  static Color border(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkBorder
      : lightBorder;

  static Color divider(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkDivider
      : lightDivider;

  static Color primary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkPrimary
      : lightPrimary;

  static Color buttonText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkButtonText
      : lightButtonText;

  // Getter
  static Color warning(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? darkWarning
      : lightWarning;

  // ------------------------------
  // ROW ALTERNATE COLORS
  // ------------------------------
  static Color rowAlternate(BuildContext context) =>
      isDark(context) ? const Color(0xFF1A1A1A) : const Color(0xFFF5F5F5);
}
