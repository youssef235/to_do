import '../models/profile_model.dart';
import '../services/api_services.dart';
import 'profile_repo_interface.dart';

class ProfileRepo implements ProfileRepoInterface {
  final ProfileApiServices _apiServices;

  ProfileRepo(this._apiServices);

  @override
  Future<ProfileModel> fetchProfile() async {
    try {
      return await _apiServices.fetchProfile();
    } catch (e) {
      throw Exception('Error in ProfileRepo: $e');
    }
  }
}
