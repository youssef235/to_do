import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/Featurees/profile/Cubit/profile_state.dart';
import '../repository/profile_repo_interface.dart';


class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepoInterface _repo;

  ProfileCubit(this._repo) : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await _repo.fetchProfile();
      emit(ProfileLoaded(profile));
    } catch (e) {
      emit(ProfileError('Error loading profile: $e'));
    }
  }
}
