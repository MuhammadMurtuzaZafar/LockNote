import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/app/core/utils/constants.dart';
import 'package:notes_app/app/routes/app_routes.dart';

import '../../../core/widgets/app_bar.dart';
import '../bloc/splash_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<SplashBloc>(context);
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is SplashFinishedState) {
          Navigator.pushReplacementNamed(context, Routes.Home_Screen);
        }
      },
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              appTitle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget appTitle() {
    return const Text(
      ConstantValues.title,
      style: TextStyle(fontSize: 24,color: KColor.white),
    );
  }
}
