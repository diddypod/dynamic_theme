import 'package:flutter/material.dart';

class BrightnessSwitcherDialog extends StatelessWidget {
  const BrightnessSwitcherDialog({Key key, this.onSelectedTheme})
      : super(key: key);

  final ValueChanged<ThemeMode> onSelectedTheme;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select Theme'),
      children: <Widget>[
        ListTile(
          onTap: () {
            onSelectedTheme(ThemeMode.light);
          },
          title: const Text('Light'),
        ),
        ListTile(
          onTap: () {
            onSelectedTheme(ThemeMode.dark);
          },
          title: const Text('Dark'),
        ),
        ListTile(
          onTap: () {
            onSelectedTheme(ThemeMode.system);
          },
          title: const Text('System'),
        ),
      ],
    );
  }
}
