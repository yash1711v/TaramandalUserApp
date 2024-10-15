part of 'splash_screen_cubit.dart';

sealed class SplashScreenState extends Equatable {
  const SplashScreenState();
}

final class SplashScreenInitial extends SplashScreenState {
  @override
  List<Object?> get props => [];
}

final class SplashScreenCheckUserLoggedIn extends SplashScreenState {
  final bool? isUserLoggedIn;
  const SplashScreenCheckUserLoggedIn({this.isUserLoggedIn = false});

  @override
  List<Object?> get props => [isUserLoggedIn];
}
