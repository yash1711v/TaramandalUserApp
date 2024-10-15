import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rashi_network/app.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:responsive_sizer/responsive_sizer.dart';

import 'services/notification_service/push_notification_service.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService().setupInteractedMessage();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  await checkNotificationPermission();
  await Hive.openBox('settings');
  await Firebase.initializeApp();
  runApp(ResponsiveSizer(builder: (BuildContext, Orientation, ScreenType) {
    return ProviderScope(child: App());
  }));
}

Future<void> checkNotificationPermission() async {
  var status = await Permission.notification.status;
  print(status);
  if (status.isPermanentlyDenied) {
    await Permission.notification.request();
  }else if (status.isDenied || status == PermissionStatus.denied) {
    await Permission.notification.request();
  }else if (status.isRestricted) {
    await Permission.notification.request();
  }
}
/// remove me `Just for Checking New Push 01`
