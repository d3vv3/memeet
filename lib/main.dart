import 'package:flutter/material.dart';

// Local packages
import 'package:memeet/pages/root.dart';
import 'package:memeet/theme/colors.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const Memeet());
}

class Memeet extends StatelessWidget {
  const Memeet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memeet',
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: primary,
        backgroundColor: white,
        brightness: Brightness.light,
        textTheme: const TextTheme(
          headline1: TextStyle(color: black),
          headline2: TextStyle(color: black),
          headline3: TextStyle(color: black),
          headline4: TextStyle(color: black),
          headline5: TextStyle(color: black),
          headline6: TextStyle(color: grey),
          subtitle1: TextStyle(color: black),
          subtitle2: TextStyle(color: black),
          bodyText1: TextStyle(color: black),
          bodyText2: TextStyle(color: black),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.grey[900],
        textTheme: const TextTheme(
          headline1: TextStyle(color: white),
          headline2: TextStyle(color: white),
          headline3: TextStyle(color: white),
          headline4: TextStyle(color: white),
          headline5: TextStyle(color: white),
          headline6: TextStyle(color: grey),
          subtitle1: TextStyle(color: white),
          subtitle2: TextStyle(color: white),
          bodyText1: TextStyle(color: white),
          bodyText2: TextStyle(color: white),
        ),
      ),
      // themeMode: ThemeMode.dark,
      home: const Root(title: 'Memeet'),
    );
  }
}
