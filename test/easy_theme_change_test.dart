import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

ValueKey<String> key = const ValueKey<String>('ok');

GlobalKey<DynamicThemeState> easyThemeKey = GlobalKey<DynamicThemeState>();

void main() {
  testWidgets('change brightness', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    MaterialApp app = find.byType(MaterialApp).evaluate().first.widget;
    expect(app.themeMode, equals(ThemeMode.light));

    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle();

    app = find.byType(MaterialApp).evaluate().first.widget;
    expect(app.themeMode, equals(ThemeMode.dark));

    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle();

    app = find.byType(MaterialApp).evaluate().first.widget;
    expect(app.themeMode, equals(ThemeMode.light));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        key: easyThemeKey,
        defaultThemeMode: ThemeMode.light,
        themedWidgetBuilder: (BuildContext context, ThemeMode themeMode) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.indigo,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.indigo,
              brightness: Brightness.dark,
            ),
            themeMode: themeMode,
            home: ButtonPage(),
          );
        });
  }
}

class ButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        DynamicTheme.of(context).setThemeMode(
            Theme.of(context).brightness == Brightness.dark
                ? ThemeMode.light
                : ThemeMode.dark);
      },
      key: key,
    );
  }
}
