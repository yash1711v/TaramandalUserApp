part of 'otp_cubit.dart';

sealed class OtpState extends Equatable {
  const OtpState();
}

final class Otp extends OtpState {
  final bool? isloading;

  const Otp({this.isloading});
  @override
  List<Object> get props => [];
}
