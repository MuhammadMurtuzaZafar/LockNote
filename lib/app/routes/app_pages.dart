import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/app/features/home/bloc/home_bloc.dart';

import '../features/home/ui/home_Screen.dart';
import '../features/splash/bloc/splash_bloc.dart';
import '../features/splash/ui/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final Map<String, Widget Function(BuildContext)> routes = {
    Routes.Splash_Screen: (context) =>
        BlocProvider(
          create: (context) => SplashBloc(),
          child: const SplashScreen(),
        ),
    Routes.Home_Screen: (context) => BlocProvider(
      create: (context)=>HomeBloc(),
      child:   HomeScreen(),),
  };
}