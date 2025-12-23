abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}
class VerifyOtpLoading extends OtpState {}

class OtpSent extends OtpState {}

class OtpVerified extends OtpState {
  final String message;
  OtpVerified(this.message);
}

class OtpError extends OtpState {
  final String message;
  OtpError(this.message);
}
class VerifyOtpError extends OtpState {
  final String message;
  VerifyOtpError(this.message);
}
