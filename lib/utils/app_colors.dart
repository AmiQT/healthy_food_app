import 'package:flutter/material.dart';

class AppColors {
  // Dark theme colors
  static const Color _darkBackground = Color(0xFF121714);
  static const Color _darkAccent = Color(0xFF94e0b2);
  static const Color _darkCard = Color(0xFF181D1A);
  static const Color _darkHeading = Colors.white;
  static const Color _darkBodyText = Color(0xFFA2B4A9);
  static const Color _darkBorder = Color(0xFF232A25);
  static const Color _darkError = Color(0xFFFF6B6B);
  static const Color _darkShimmerBase = Color(0xFF232A25);
  static const Color _darkShimmerHighlight = Color(0xFF2B362F);
  static const Color _darkButtonShadow = Color(0x33000000);
  static const Color _darkButtonHover = Color(0xFFB6F2D5);
  static const Color _darkCardShadow = Color(0x22000000);
  static const Color _darkInputFocus = Color(0xFF1A2A22);

  // Light theme colors
  static const Color _lightBackground = Color(0xFFF6F6F6);
  static const Color _lightAccent = Color(0xFF4CB37B);
  static const Color _lightCard = Color(0xFFFFFFFF);
  static const Color _lightHeading = Color(0xFF101311);
  static const Color _lightBodyText = Color(0xFF3A4A3F);
  static const Color _lightBorder = Color(0xFFE0E0E0);
  static const Color _lightError = Color(0xFFD32F2F);
  static const Color _lightShimmerBase = Color(0xFFE0E0E0);
  static const Color _lightShimmerHighlight = Color(0xFFF6F6F6);
  static const Color _lightButtonShadow = Color(0x22000000);
  static const Color _lightButtonHover = Color(0xFFB6F2D5);
  static const Color _lightCardShadow = Color(0x11000000);
  static const Color _lightInputFocus = Color(0xFFD0F5E8);

  final bool isDark;
  const AppColors._(this.isDark);

  static AppColors of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return AppColors._(brightness == Brightness.dark);
  }

  Color get background => isDark ? _darkBackground : _lightBackground;
  Color get accent => isDark ? _darkAccent : _lightAccent;
  Color get card => isDark ? _darkCard : _lightCard;
  Color get heading => isDark ? _darkHeading : _lightHeading;
  Color get bodyText => isDark ? _darkBodyText : _lightBodyText;
  Color get border => isDark ? _darkBorder : _lightBorder;
  Color get error => isDark ? _darkError : _lightError;
  Color get shimmerBase => isDark ? _darkShimmerBase : _lightShimmerBase;
  Color get shimmerHighlight =>
      isDark ? _darkShimmerHighlight : _lightShimmerHighlight;
  Color get buttonShadow => isDark ? _darkButtonShadow : _lightButtonShadow;
  Color get buttonHover => isDark ? _darkButtonHover : _lightButtonHover;
  Color get cardShadow => isDark ? _darkCardShadow : _lightCardShadow;
  Color get inputFocus => isDark ? _darkInputFocus : _lightInputFocus;
}
