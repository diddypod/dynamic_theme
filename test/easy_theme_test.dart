import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

ValueKey<String> key = const ValueKey<String>('ok');
DynamicThemeState state;
GlobalKey<DynamicThemeState> easyThemeKey = GlobalKey<DynamicThemeState>();

void main() {
  testWidgets('test finds state', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(state, equals(null));

    await tester.tap(find.byKey(key));
    await tester.pump();

    expect(state, isNotNull);
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        key: easyThemeKey,
        defaultThemeMode: ThemeMode.system,
        themedWidgetBuilder: (BuildContext context, ThemeMode themeMode) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData.light(),
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
        state = DynamicTheme.of(context);
      },
      key: key,
    );
  }
}
