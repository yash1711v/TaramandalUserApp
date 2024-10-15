part of 'login_cubit.dart';

sealed class LoginState extends Equatable {
  const LoginState();
}

final class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

final class Logining extends LoginState {
  final bool? isLoading;

  const Logining({this.isLoading = false});

  @override
  List<Object?> get props => [isLoading];

}