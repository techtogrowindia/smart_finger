import 'package:equatable/equatable.dart';

abstract class BankState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BankInitial extends BankState {}

class BankLoading extends BankState {}

class BankSuccess extends BankState {}

class BankError extends BankState {
  final String message;
  BankError(this.message);

  @override
  List<Object?> get props => [message];
}
