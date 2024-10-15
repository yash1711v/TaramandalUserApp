import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rashi_network/api/api.dart';
import 'package:rashi_network/features/Authentication/Login/controler/login_cubit.dart';
import 'package:rashi_network/features/Authentication/OtpScreen/controller/otp_cubit.dart';
import 'package:rashi_network/features/SplashScreen/controler/splash_screen_cubit.dart';
import 'package:rashi_network/features/SplashScreen/view/splash_screen.dart';
import 'package:rashi_network/routes.dart';
import 'package:rashi_network/theme.dart';
import 'package:rashi_network/ui/theme/text.dart';
import 'package:get/get.dart';
import 'package:rashi_network/views/connect/chat/controller/chatReq_controller.dart';
import 'package:rashi_network/views/connect/chat/new_chat/chat_screen_one.dart';
import 'package:rashi_network/views/home_controller.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  late SnackBar noInternetSnackBar;
  @override
  void initState() {
    super.initState();
    noInternetSnackBar = SnackBar(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.info,
            color: Colors.white,
          ),
          SizedBox(width: 6),
          DesignText(
            'No Internet Connection',
            fontSize: 12,
            fontWeight: 700,
            color: Colors.white,
          )
        ],
      ),
      duration: const Duration(seconds: 30),
      backgroundColor: Colors.black.withOpacity(0.85),
      behavior: SnackBarBehavior.floating,
    );
    Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        scaffoldMessengerKey.currentState!.showSnackBar(noInternetSnackBar);
      } else {
        scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
      }
    });

    WidgetsBinding.instance.addObserver(AppLifecycleObserver());
  }
  dispose() {
    WidgetsBinding.instance.removeObserver(AppLifecycleObserver());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashScreenCubit>(
          create: (context) => SplashScreenCubit(SplashScreenInitial())..checkUserLoggedIn(),
        ),
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(),
        ),
        BlocProvider<OtpCubit>(
          create: (context) => OtpCubit(),
        ),

      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: scaffoldMessengerKey,
        title: 'The Taramandal',
        // routes: appRoutes,
        themeMode: ThemeMode.light, //darkMode.isDark ? ThemeMode.dark :
        theme: theme,
        darkTheme: darkTheme, home: const SplashScreen(),
      ),
    );
  }
}

class AppLifecycleObserver extends WidgetsBindingObserver {
  ChatController timerController = Get.put(ChatController());
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state)
    {
      case AppLifecycleState.resumed:

      ///call Online Astrologer APi
      if(senderNumber.isNotEmpty){
        Api.getChatDataSingle(currentNumber, senderNumber).then((value) {
          Map<String, dynamic> data = value.data() as Map<String, dynamic>;
          log("getChatDataSingle: ${data["chattingOngoing"]} $state");
        });
      }

        log('${state.name}');
        // App is in the foreground
        break;
        case AppLifecycleState.inactive:
          // if(senderNumber.isNotEmpty && chatreqid.isNotEmpty){
          //   Api.getChatDataSingle(currentNumber, senderNumber).then((value) {
          //     Map<String, dynamic> data = value.data() as Map<String, dynamic>;
          //     log("getChatDataSingle: ${data["chattingOngoing"]} $state");
          //     if(data["chattingOngoing"]){
          //       timerController.endChatApi(data: {
          //         "chatreqid": chatreqid,
          //       });
          //       Api.endChat(
          //         currentUserUid: currentNumber,
          //         otherUserUid: senderNumber,
          //       );
          //       timerController.chatEnd.value = false;
          //       chatreqid = "";
          //       Get.offAll(() => const HomeController());
          //     }
          //   });
          // }

        ///call OFFLINE Astrologer APi

          log('${state.name}');

        // App is transitioning between states (e.g., going to/from background)
        // You can make an API call here if needed
        break;
        case AppLifecycleState.paused:
        if(senderNumber.isNotEmpty && chatreqid.isNotEmpty){
          Api.getChatDataSingle(currentNumber, senderNumber).then((value) {
            Map<String, dynamic> data = value.data() as Map<String, dynamic>;
            log("getChatDataSingle: ${data["chattingOngoing"]} $state");
            if(data["chattingOngoing"]){
              timerController.endChatApi(data: {
                "chatreqid": chatreqid,
              });
              Api.endChat(
                currentUserUid: currentNumber,
                otherUserUid: senderNumber,
              );
              timerController.chatEnd.value = false;
              chatreqid = "";
              Get.offAll(() => const HomeController());
            }
          });
        }
        log('${state.name}');

        // App is in the background
        break;

        case AppLifecycleState.detached:
          if(senderNumber.isNotEmpty && chatreqid.isNotEmpty){
            Api.getChatDataSingle(currentNumber, senderNumber).then((value) {
              Map<String, dynamic> data = value.data() as Map<String, dynamic>;
              log("getChatDataSingle: ${data["chattingOngoing"]} $state");
              if(data["chattingOngoing"]){
                timerController.endChatApi(data: {
                  "chatreqid": chatreqid,
                });
                Api.endChat(
                  currentUserUid: currentNumber,
                  otherUserUid: senderNumber,
                );
                timerController.chatEnd.value = false;
                chatreqid = "";
                Get.offAll(() => const HomeController());
              }
            });
          }
          break;
          case AppLifecycleState.hidden:
            log('${state.name}');
    }
  }
}
