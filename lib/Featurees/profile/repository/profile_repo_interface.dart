
import 'package:to_do/Featurees/profile/models/profile_model.dart';

abstract class ProfileRepoInterface {
  Future<ProfileModel> fetchProfile();
}
