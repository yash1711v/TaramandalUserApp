import 'package:flutter/material.dart';
import 'package:rashi_network/features/Authentication/Login/view/login_Screen.dart';
import 'package:rashi_network/services/firebase/auth_servoces.dart';
import 'package:rashi_network/services/shared_prefrence/pref_controller.dart';
import 'package:rashi_network/ui/widgets/progress_circle.dart';
import 'package:rashi_network/views/home_controller.dart';

import '../services/shared_prefrence/prefrence_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  getToken() async {
    PrefrenceDataController.to.token.value = await PreferencesHelper()
            .getPreferencesStringData(PreferencesHelper.token) ??
        '';
  }

  @override
  void initState() {
    // TODO: implement initState
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return LoginScreen();
    if (PrefrenceDataController.to.token.value != '' &&
        PrefrenceDataController.to.token.value != null) {
      return  HomeController();
    } else {
      return const  LoginScreen();
    }
    ;
  }
}

class Waiting extends StatelessWidget {
  const Waiting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
            onTap: () {
              // AuthService().signOut();
            },
            child: const DesignProgress(size: 60)),
      ),
    );
  }
}
