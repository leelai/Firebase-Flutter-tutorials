import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Util {
  static checking(BuildContext context) {
    // var prefs = await SharedPreferences.getInstance();

    // if ((prefs.getString('main_page') ?? "").isEmpty) {
    //   Navigator.pushReplacementNamed(context, '/setup');
    // }

    SharedPreferences.getInstance().then((prefs) {
      if ((prefs.getString('main_page') ?? "").isEmpty) {
        // Navigator.pushReplacementNamed(context, '/setup');
        Navigator.pushNamedAndRemoveUntil(context, "/setup", (r) => false);
      }
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    print("Handling a background message: ${message.messageId}");
  }

  static void initFirebase(BuildContext context) {
    var messaging = FirebaseMessaging.instance;

    messaging.getToken().then((value) {
      //debug
      print(value);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      var sound = event.notification?.android?.sound ?? "alarm01";
      print("message recieved:$sound");
      AssetsAudioPlayer.newPlayer().open(
        Audio("assets/audios/" + sound + '.mp3'),
        autoStart: true,
        showNotification: false,
      );

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("notification").tr(),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: Text("ok").tr(),
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
}
