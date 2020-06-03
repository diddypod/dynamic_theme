import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

typedef ThemedWidgetBuilder = Widget Function(
    BuildContext context, ThemeMode themeMode);

class DynamicTheme extends StatefulWidget {
  const DynamicTheme({
    Key key,
    this.themedWidgetBuilder,
    this.defaultThemeMode = ThemeMode.system,
    this.loadThemeModeOnStart = true,
  }) : super(key: key);

  /// Builder that gets called when the brightness or theme changes
  final ThemedWidgetBuilder themedWidgetBuilder;

  /// The default brightness on start
  ///
  /// Defaults to `ThemeMode.system`
  final ThemeMode defaultThemeMode;

  /// Whether or not to load the brightness on start
  ///
  /// Defaults to `true`
  final bool loadThemeModeOnStart;

  @override
  DynamicThemeState createState() => DynamicThemeState();

  static DynamicThemeState of(BuildContext context) {
    return context.findAncestorStateOfType<State<DynamicTheme>>();
  }
}

class DynamicThemeState extends State<DynamicTheme> {
  ThemeMode _themeMode;

  bool _shouldLoadThemeMode;

  static const String _sharedPreferencesKey = 'appTheme';

  /// Get the current `Brightness`
  ThemeMode get themeMode => _themeMode;

  @override
  void initState() {
    super.initState();
    _initVariables();
    _loadThemeMode();
  }

  /// Loads the brightness depending on the `loadBrightnessOnStart` value
  Future<void> _loadThemeMode() async {
    if (!_shouldLoadThemeMode) {
      return;
    }
    _themeMode = await _getThemeMode();
    if (mounted) {
      setState(() {});
    }
  }

  /// Initializes the variables
  void _initVariables() {
    _themeMode = widget.defaultThemeMode;
    _shouldLoadThemeMode = widget.loadThemeModeOnStart;
  }

  /// Sets the new brightness
  /// Rebuilds the tree
  Future<void> setThemeMode(ThemeMode themeMode) async {
    // Update state with new values
    setState(() {
      _themeMode = themeMode;
    });
    // Save the brightness
    await _saveThemeMode(themeMode);
  }

  /// Saves the provided brightness in `SharedPreferences`
  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    //! Shouldn't save the brightness if you don't want to load it
    if (!_shouldLoadThemeMode) {
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Saves whether or not the provided brightness is dark
    await prefs.setString(_sharedPreferencesKey, themeMode.toString());
  }

  /// Returns a boolean that gives you the latest brightness
  Future<ThemeMode> _getThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String prefThemeMode = prefs.getString(_sharedPreferencesKey) ??
        widget.defaultThemeMode.toString();
    return ThemeMode.values
        .firstWhere((ThemeMode e) => e.toString() == prefThemeMode);
  }

  @override
  Widget build(BuildContext context) {
    return widget.themedWidgetBuilder(context, _themeMode);
  }
}
