import 'package:equatable/equatable.dart';
import '../../../data/models/login_response.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginResponse response;
  LoginSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class LoginFailure extends LoginState {
  final String message;
  LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}
