import 'package:equatable/equatable.dart';
import 'package:smart_finger/data/models/profile_response.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final ProfileResponse response;
  ProfileSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class ProfileFailure extends ProfileState {
  final String message;
  ProfileFailure(this.message);

  @override
  List<Object?> get props => [message];
}
