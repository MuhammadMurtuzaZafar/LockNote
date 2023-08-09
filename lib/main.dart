import 'package:flutter/material.dart';
import 'package:notes_app/app/core/utils/theme.dart';
import 'package:notes_app/app/routes/app_pages.dart';
import 'package:notes_app/app/routes/app_routes.dart';

import 'app/core/utils/constants.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: ConstantValues.title,
      theme: Themes().lightTheme,
      darkTheme: Themes().dartTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.Home_Screen,
      routes: AppPages.routes,
    );
  }
}

