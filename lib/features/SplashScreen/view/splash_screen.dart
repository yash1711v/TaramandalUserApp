import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rashi_network/features/SplashScreen/controler/splash_screen_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashScreenCubit, SplashScreenState>(
      builder: (context, state) {
        return Scaffold(
          body: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            decoration: const BoxDecoration(image: DecorationImage(
                image: AssetImage('assets/img/splash_bg.png'),
                fit: BoxFit.cover)),
            child: Center(
              child:
              Image.asset('assets/img/logo.png', height: 250, width: 250),
            ),
          ),
        );
      },
    );
  }
}
