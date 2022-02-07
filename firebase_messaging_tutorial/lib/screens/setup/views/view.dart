import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:clipboard/clipboard.dart';
import 'package:wakelock/wakelock.dart';

class SetupView extends StatefulWidget {
  @override
  _SetupViewState createState() => _SetupViewState();
}

class _SetupViewState extends State<SetupView> {
  final mainPageText = TextEditingController();
  final serverUrlText = TextEditingController();
  final phoneText = TextEditingController();
  String token = '';

  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((value) {
      setState(() {
        mainPageText.text = value.getString('main_page') ?? '';
        serverUrlText.text = value.getString('server_url') ?? '';
        phoneText.text = value.getString('phone') ?? '';
      });
    });

    FirebaseMessaging.instance.getToken().then((value) {
      if (value == null) return;
      setState(() {
        token = value;
      });
    });

    Wakelock.enable();
  }

  Widget upperPartGroup() {
    var upperPartGroup = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('main_page').tr(),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: mainPageText,
                ),
              ),
            ),
          ],
        ),
        Card(
            child: InkWell(
                onTap: () async {
                  if (mainPageText.text.isEmpty) return;
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString('main_page', mainPageText.text);
                  // await prefs.setString(
                  //     'main_page',
                  //     mainPageText.text.startsWith('http://')
                  //         ? mainPageText.text
                  //         : 'http://' + mainPageText.text);
                  Navigator.pushReplacementNamed(context, '/webview');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('set_up').tr(),
                ))),
      ],
    );
    return upperPartGroup;
  }

  Widget lowerPartGroup(BuildContext context) {
    var lowerPartGroup = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('server').tr(),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: serverUrlText,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
          child: const Text('notification_number').tr(),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: TextField(
                controller: phoneText,
              ),
            ),
            Card(
                child: InkWell(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var serverUrl = serverUrlText.text;
                      await prefs.setString('server_url', serverUrl);
                      await prefs.setString('phone', phoneText.text);

                      var url = Uri.http(serverUrl, '/PushPhone.ashx',
                          {'phone': phoneText.text, 'user': 'ciot'});
                      var response = await http.get(url);
                      if (response.statusCode == 200) {
                        var jsonResponse = convert.jsonDecode(response.body)
                            as Map<String, dynamic>;
                        if (jsonResponse['state'] == 'ok') {
                          Navigator.pushNamed(context, '/confirm');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('error').tr(),
                          ));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Request failed with status: ${response.statusCode}.'),
                        ));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('setups').tr(),
                    )))
          ],
        ),
      ],
    );
    return lowerPartGroup;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('setups').tr(),
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              upperPartGroup(),
              Divider(),
              lowerPartGroup(context),
              if (kDebugMode)
                InkWell(
                    onTap: () {
                      FlutterClipboard.copy(token).then(
                          (value) => ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                  '已複製',
                                )),
                              ));
                    },
                    child: Text(
                      token,
                      style: DefaultTextStyle.of(context)
                          .style
                          .apply(fontSizeFactor: 0.2),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
