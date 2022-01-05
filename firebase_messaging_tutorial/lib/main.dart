import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'screens/number_confirm/number_confirm.dart';
import 'screens/setup/setup.dart';
import 'screens/webview/webview.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
  print('background message(data.values) ${message.data.values}');
  // print(message.data.values);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(FcmPOC());
}

class FcmPOC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ciot',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: Theme.of(context)
              .textTheme
              .apply(fontSizeFactor: 1.5, fontSizeDelta: 2.0)),
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
    messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic("messaging");
    messaging.getToken().then((value) {
      print(value);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved");
      print(event.notification!.body);
      print(event.data.values);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Notification"),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/setup');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Setup"),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/webview');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Webview"),
                ),
              ),
              InkWell(
                onTap: () {
                  AssetsAudioPlayer.newPlayer().open(
                    Audio("assets/audios/alarm01.mp3"),
                    autoStart: true,
                    showNotification: true,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Play Audio"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
