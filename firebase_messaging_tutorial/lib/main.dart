import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/number_confirm/number_confirm.dart';
import 'screens/setup/setup.dart';
import 'screens/webview/webview.dart';
import 'package:package_info/package_info.dart';

Future<void> _init() async {
  //notification channel
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'alarm01.mp3', // id
    'High Importance Notifications', // title
    playSound: true,
    sound: RawResourceAndroidNotificationSound('alarm01'),
    importance: Importance.max,
  );
  const AndroidNotificationChannel channel2 = AndroidNotificationChannel(
    'alarm02.mp3', // id
    'High Importance Notifications 2', // title
    playSound: true,
    sound: RawResourceAndroidNotificationSound('alarm02'),
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel2);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  _init();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  var isSiot = packageInfo.packageName.contains('siot');

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(EasyLocalization(
            supportedLocales: [
              Locale('en'),
              Locale('zh'),
            ],
            path: 'assets/translations',
            fallbackLocale: Locale('en'),
            child: FcmPOC(),
            startLocale: isSiot ? Locale('zh') : Locale('en'),
          )));
}

class FcmPOC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'ciot',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: Theme.of(context)
              .textTheme
              .apply(fontSizeFactor: 1, fontSizeDelta: 2.0)),
      routes: {
        '/': (context) => MyHomePage(title: 'ciot'),
        '/webview': (context) => MyWebView(),
        '/setup': (context) => SetupView(),
        '/confirm': (context) => NumberConfirmView(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;
  String? notificationText;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      if ((prefs.getString('main_page') ?? "").isEmpty) {
        Navigator.pushNamedAndRemoveUntil(context, "/setup", (r) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyWebView();
  }
}
