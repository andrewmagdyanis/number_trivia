import 'package:flutter/material.dart';
import 'dependencies_injection.dart' as di;
import 'features/number_trivia_feature/presentaion/pages/number_trivia_home_screen.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.green.shade800,
        primaryColor: Colors.green.shade600,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NumberTriviaHomeScreen(),
    );
  }
}
