import 'dart:async';
import 'package:bloc/bloc.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<StartTimerEvent>((event, emit) async {
      await Future.delayed( Duration(seconds: 1));
      return emit(SplashFinishedState());
    });
    add(StartTimerEvent());
  }
}
