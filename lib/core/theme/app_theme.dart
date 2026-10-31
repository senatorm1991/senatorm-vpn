import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hiddify/core/theme/app_theme_mode.dart';
import 'package:hiddify/core/theme/theme_extensions.dart';

/// senatorm vpn: a strict black & white look. The system's dynamic colours are
/// deliberately ignored so the app keeps one identity on every device.
class AppTheme {
  AppTheme(this.mode, this.fontFamily);
  final AppThemeMode mode;
  final String fontFamily;

  static const ColorScheme _light = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF000000),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFEDEDED),
    onPrimaryContainer: Color(0xFF000000),
    secondary: Color(0xFF3A3A3A),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFE8E8E8),
    onSecondaryContainer: Color(0xFF111111),
    tertiary: Color(0xFF5C5C5C),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFF1F1F1),
    onTertiaryContainer: Color(0xFF111111),
    error: Color(0xFFB3261E),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF0A0A0A),
    onSurfaceVariant: Color(0xFF5A5A5A),
    surfaceDim: Color(0xFFE6E6E6),
    surfaceBright: Color(0xFFFFFFFF),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF7F7F7),
    surfaceContainer: Color(0xFFF2F2F2),
    surfaceContainerHigh: Color(0xFFECECEC),
    surfaceContainerHighest: Color(0xFFE6E6E6),
    outline: Color(0xFF8A8A8A),
    outlineVariant: Color(0xFFD9D9D9),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFF0A0A0A),
    onInverseSurface: Color(0xFFFFFFFF),
    inversePrimary: Color(0xFFFFFFFF),
    surfaceTint: Color(0x00000000),
  );

  static const ColorScheme _dark = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFFFFF),
    onPrimary: Color(0xFF000000),
    primaryContainer: Color(0xFF242424),
    onPrimaryContainer: Color(0xFFFFFFFF),
    secondary: Color(0xFFD0D0D0),
    onSecondary: Color(0xFF000000),
    secondaryContainer: Color(0xFF2A2A2A),
    onSecondaryContainer: Color(0xFFF2F2F2),
    tertiary: Color(0xFFB5B5B5),
    onTertiary: Color(0xFF000000),
    tertiaryContainer: Color(0xFF1E1E1E),
    onTertiaryContainer: Color(0xFFF2F2F2),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    errorContainer: Color(0xFF8C1D18),
    onErrorContainer: Color(0xFFF9DEDC),
    surface: Color(0xFF0A0A0A),
    onSurface: Color(0xFFF5F5F5),
    onSurfaceVariant: Color(0xFFA8A8A8),
    surfaceDim: Color(0xFF050505),
    surfaceBright: Color(0xFF2A2A2A),
    surfaceContainerLowest: Color(0xFF000000),
    surfaceContainerLow: Color(0xFF111111),
    surfaceContainer: Color(0xFF161616),
    surfaceContainerHigh: Color(0xFF1D1D1D),
    surfaceContainerHighest: Color(0xFF242424),
    outline: Color(0xFF6E6E6E),
    outlineVariant: Color(0xFF2E2E2E),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    inverseSurface: Color(0xFFF5F5F5),
    onInverseSurface: Color(0xFF0A0A0A),
    inversePrimary: Color(0xFF000000),
    surfaceTint: Color(0x00000000),
  );

  ThemeData _build(ColorScheme scheme, {required bool trueBlack}) {
    final bg = trueBlack ? Colors.black : scheme.surface;
    final radius24 = RoundedRectangleBorder(borderRadius: BorderRadius.circular(24));
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: bg,
      canvasColor: bg,
      dividerColor: scheme.outlineVariant,
      extensions: const <ThemeExtension<dynamic>>{ConnectionButtonTheme.light},
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          color: scheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: const StadiumBorder(),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          minimumSize: const Size(64, 52),
          shape: const StadiumBorder(),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 52),
          shape: const StadiumBorder(),
          side: BorderSide(color: scheme.outline),
        ),
      ),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(shape: const StadiumBorder())),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainer,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: scheme.primary,
        indicatorShape: const StadiumBorder(),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected) ? scheme.onPrimary : scheme.onSurfaceVariant,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontFamily: fontFamily,
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
            color: states.contains(WidgetState.selected) ? scheme.onSurface : scheme.onSurfaceVariant,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: bg,
        indicatorColor: scheme.primary,
        selectedIconTheme: IconThemeData(color: scheme.onPrimary),
        unselectedIconTheme: IconThemeData(color: scheme.onSurfaceVariant),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: scheme.surface,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: radius24,
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(fontFamily: fontFamily, color: scheme.onInverseSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? scheme.onPrimary : scheme.outline,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? scheme.primary : scheme.surfaceContainerHighest,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? Colors.transparent : scheme.outline,
        ),
      ),
      listTileTheme: const ListTileThemeData(contentPadding: EdgeInsetsDirectional.symmetric(horizontal: 20)),
    );
  }

  ThemeData lightTheme(ColorScheme? lightColorScheme) => _build(_light, trueBlack: false);

  ThemeData darkTheme(ColorScheme? darkColorScheme) => _build(_dark, trueBlack: mode.trueBlack);

  CupertinoThemeData cupertinoThemeData(bool sysDark, ColorScheme? lightColorScheme, ColorScheme? darkColorScheme) {
    final bool isDark = switch (mode) {
      AppThemeMode.system => sysDark,
      AppThemeMode.light => false,
      AppThemeMode.dark => true,
      AppThemeMode.black => true,
    };
    final def = CupertinoThemeData(brightness: isDark ? Brightness.dark : Brightness.light);
    final defaultMaterialTheme = isDark ? darkTheme(darkColorScheme) : lightTheme(lightColorScheme);
    return MaterialBasedCupertinoThemeData(
      materialTheme: defaultMaterialTheme.copyWith(
        cupertinoOverrideTheme: def.copyWith(
          textTheme: CupertinoTextThemeData(
            textStyle: def.textTheme.textStyle.copyWith(fontFamily: fontFamily),
            actionTextStyle: def.textTheme.actionTextStyle.copyWith(fontFamily: fontFamily),
            navActionTextStyle: def.textTheme.navActionTextStyle.copyWith(fontFamily: fontFamily),
            navTitleTextStyle: def.textTheme.navTitleTextStyle.copyWith(fontFamily: fontFamily),
            navLargeTitleTextStyle: def.textTheme.navLargeTitleTextStyle.copyWith(fontFamily: fontFamily),
            pickerTextStyle: def.textTheme.pickerTextStyle.copyWith(fontFamily: fontFamily),
            dateTimePickerTextStyle: def.textTheme.dateTimePickerTextStyle.copyWith(fontFamily: fontFamily),
            tabLabelTextStyle: def.textTheme.tabLabelTextStyle.copyWith(fontFamily: fontFamily),
          ).copyWith(),
          barBackgroundColor: def.barBackgroundColor,
          scaffoldBackgroundColor: def.scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
