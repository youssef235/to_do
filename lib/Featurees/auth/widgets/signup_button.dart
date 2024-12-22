import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';

class SignUpButton extends StatelessWidget {
  final String name;
  final String phone;
  final String password;
  final int experienceYears;
  final String address;
  final String level;

  const SignUpButton({
    Key? key,
    required this.name,
    required this.phone,
    required this.password,
    required this.experienceYears,
    required this.address,
    required this.level,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          context.read<AuthCubit>().register(
            phone: phone,
            password: password,
            displayName: name,
            experienceYears: experienceYears,
            address: address,
            level: level,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
