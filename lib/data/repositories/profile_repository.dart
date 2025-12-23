import 'package:smart_finger/data/models/profile_response.dart';
import 'package:smart_finger/data/services/profile_service.dart';

class ProfileRepository {
  final ProfileService service;

  ProfileRepository(this.service);

  Future<ProfileResponse> getProfile() {
    return service.getProfile();
  }
}
