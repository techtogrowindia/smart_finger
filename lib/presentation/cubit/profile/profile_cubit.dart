import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_finger/core/shared_prefs_helper.dart';
import 'package:smart_finger/data/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit(this.repository) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());

    try {
      final res = await repository.getProfile();

      if (res.statusCode == 200) {
               await SharedPrefsHelper.saveID(res.data.userId);
        emit(ProfileSuccess(res));
      } else {
        emit(ProfileFailure(res.message));
      }
    }

    on SocketException catch (_) {
      emit( ProfileFailure("NO_INTERNET"));
    }
    catch (e) {
      emit(ProfileFailure("Something went wrong"));
    }
  }
}
