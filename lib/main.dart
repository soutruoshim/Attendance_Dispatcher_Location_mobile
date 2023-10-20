import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:hr_dispatcher/data/source/datastore/preferences.dart';
import 'package:hr_dispatcher/model/auth.dart';
import 'package:hr_dispatcher/provider/attendancereportprovider.dart';
import 'package:hr_dispatcher/provider/dashboardprovider.dart';
import 'package:hr_dispatcher/provider/leaveprovider.dart';
import 'package:hr_dispatcher/provider/meetingprovider.dart';
import 'package:hr_dispatcher/provider/morescreenprovider.dart';
import 'package:hr_dispatcher/provider/payslipprovider.dart';
import 'package:hr_dispatcher/provider/prefprovider.dart';
import 'package:hr_dispatcher/provider/profileprovider.dart';
import 'package:hr_dispatcher/screen/auth/login_screen.dart';
import 'package:hr_dispatcher/screen/dashboard/dashboard_screen.dart';
import 'package:hr_dispatcher/screen/profile/editprofilescreen.dart';
import 'package:hr_dispatcher/screen/profile/payslipdetailscreen.dart';
import 'package:hr_dispatcher/screen/profile/profilescreen.dart';
import 'package:hr_dispatcher/screen/profile/meetingdetailscreen.dart';
import 'package:hr_dispatcher/screen/splashscreen.dart';
import 'package:hr_dispatcher/utils/navigationservice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:in_app_notification/in_app_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_messageHandler);

  // Step required to send ios push notification
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else {
    print('User declined or has not accepted permission');
  }

  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
      'resource://drawable/app_icon',
      [
        NotificationChannel(
            channelGroupKey: 'digital_hr_group',
            channelKey: 'digital_hr_channel',
            channelName: 'Digital Hr notifications',
            channelDescription: 'Digital HR Alert',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'digital_hr_group',
            channelGroupName: 'HR group')
      ],
      debug: true
  );

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });

  FirebaseMessaging.onMessage.listen((event) {
    FlutterRingtonePlayer.play(
      fromAsset: "assets/sound/beep.mp3",
    );
    try {
      InAppNotification.show(
        child: Card(
          margin: const EdgeInsets.all(15),
          child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            leading: Container(height: double.infinity,child: Icon(Icons.notifications)),
            iconColor: HexColor("#011754"),
            textColor: HexColor("#011754"),
            minVerticalPadding: 10,
            minLeadingWidth: 0,
            tileColor: Colors.white,
            title: Text(event.notification!.title!,),
            subtitle: Text(event.notification!.body!,style: TextStyle(color: Colors.grey),),
          ),
        ),
        context: NavigationService.navigatorKey.currentState!.context,
      );
    } catch (e) {
      print(e);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('Message clicked!');
  });

  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  runApp(const MyApp());
  configLoading();
}

Future<void> _messageHandler(RemoteMessage message) async {
  FlutterRingtonePlayer.play(
    fromAsset: "assets/sound/beep.mp3",
  );
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.cubeGrid
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 50.0
    ..radius = 0.0
    ..progressColor = Colors.blue
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.blue
    ..textColor = Colors.black
    ..maskType = EasyLoadingMaskType.none
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Preferences(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => LeaveProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => PrefProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => ProfileProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => AttendanceReportProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => DashboardProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => MoreScreenProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => MeetingProvider(),
          ),
          ChangeNotifierProvider(
            create: (ctx) => PaySlipProvider(),
          ),
        ],
        child: Portal(
          child: InAppNotification(
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              onVerticalDragDown: (details) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: GetMaterialApp(
                navigatorKey: NavigationService.navigatorKey,
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  canvasColor: const Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: 'GoogleSans',
                  primarySwatch: Colors.blue,
                ),
                initialRoute: '/',
                routes: {
                  '/': (_) => SplashScreen(),
                  LoginScreen.routeName: (_) => LoginScreen(),
                  DashboardScreen.routeName: (_) => DashboardScreen(),
                  ProfileScreen.routeName: (_) => ProfileScreen(),
                  EditProfileScreen.routeName: (_) => EditProfileScreen(),
                  MeetingDetailScreen.routeName: (_) => MeetingDetailScreen(),
                  PaySlipDetailScreen.routeName: (_) => PaySlipDetailScreen(),
                },
                builder: EasyLoading.init(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
