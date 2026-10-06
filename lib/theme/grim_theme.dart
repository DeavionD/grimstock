import 'package:flutter/material.dart';

/// Grimstock palette: the NSG Tech "Not So Grim" look.
/// Dark only for launch: crypt charcoal, bone text, ectoplasm green accent.
abstract final class GrimColors {
  static const crypt = Color(0xFF121214); // app background
  static const tomb = Color(0xFF1C1C21); // cards, sheets
  static const slab = Color(0xFF26262D); // inputs, raised surfaces
  static const mist = Color(0xFF3A3A44); // borders, dividers
  static const bone = Color(0xFFEDE6D6); // primary text
  static const ash = Color(0xFFA49E92); // secondary text
  static const ecto = Color(0xFF8FD14F); // accent, profit
  static const blood = Color(0xFFE5484D); // loss, destructive
  static const hex = Color(0xFF9B7BD4); // secondary accent (crypt purple)
  static const pyre = Color(0xFFE8B04B); // caution
}

ThemeData buildGrimTheme() {
  const scheme = ColorScheme.dark(
    primary: GrimColors.ecto,
    onPrimary: GrimColors.crypt,
    secondary: GrimColors.hex,
    onSecondary: GrimColors.crypt,
    error: GrimColors.blood,
    onError: GrimColors.bone,
    surface: GrimColors.crypt,
    onSurface: GrimColors.bone,
    surfaceContainerLowest: GrimColors.crypt,
    surfaceContainerLow: GrimColors.tomb,
    surfaceContainer: GrimColors.tomb,
    surfaceContainerHigh: GrimColors.slab,
    surfaceContainerHighest: GrimColors.slab,
    onSurfaceVariant: GrimColors.ash,
    outline: GrimColors.mist,
    outlineVariant: GrimColors.mist,
  );

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: GrimColors.crypt,
  );

  return base.copyWith(
    appBarTheme: const AppBarTheme(
      backgroundColor: GrimColors.crypt,
      foregroundColor: GrimColors.bone,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: GrimColors.tomb,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: GrimColors.mist),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: GrimColors.tomb,
      indicatorColor: GrimColors.ecto.withValues(alpha: 0.18),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? GrimColors.ecto
              : GrimColors.ash,
        ),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: states.contains(WidgetState.selected)
              ? GrimColors.bone
              : GrimColors.ash,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: GrimColors.slab,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    dividerTheme: const DividerThemeData(color: GrimColors.mist, space: 1),
  );
}
