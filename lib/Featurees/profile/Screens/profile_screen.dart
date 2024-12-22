import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Cubit/profile_cubit.dart';
import '../Cubit/profile_state.dart';
import '../widgets/profile_info_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ProfileCubit>().loadProfile();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final profile = state.profile;
            return ListView(
              children: [
                ProfileInfoCard(title: 'Name', value: profile.name),
                ProfileInfoCard(title: 'Phone', value: profile.phone),
                ProfileInfoCard(title: 'Level', value: profile.level),
                ProfileInfoCard(
                    title: 'Years of Experience',
                    value: profile.yearsOfExperience.toString()),
                ProfileInfoCard(title: 'Location', value: profile.location),
              ],
            );
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No Data Available'));
          }
        },
      ),
    );
  }
}
