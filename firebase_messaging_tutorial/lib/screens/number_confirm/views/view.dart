import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class NumberConfirmView extends StatefulWidget {
  @override
  _NumberConfirmViewState createState() => _NumberConfirmViewState();
}

class _NumberConfirmViewState extends State<NumberConfirmView> {
  final myController = TextEditingController();
  int count = 60;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (count == 0) {
        timer.cancel();
        return;
      }
      setState(() {
        count--;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('notification_number_setting').tr(),
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('nns_msg').tr(args: [count.toString()]),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('please_enter_code').tr(),
                Flexible(
                  child: TextField(
                    controller: myController,
                  ),
                ),
              ],
            ),
            Card(
                child: InkWell(
                    onTap: () async {
                      var messaging = FirebaseMessaging.instance;
                      var token = await messaging.getToken();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      var code = myController.text;
                      var serverUrl = prefs.getString('server_url') ?? '';
                      var phone = prefs.getString('phone') ?? '';

                      var url = Uri.http(serverUrl, '/pushdata.ashx', {
                        'user': 'ciot',
                        'sys': 'android',
                        'phone': phone,
                        'code': code,
                        'token': token
                      });
                      print(url);
                      var response = await http.get(url);
                      if (response.statusCode == 200) {
                        var jsonResponse = convert.jsonDecode(response.body)
                            as Map<String, dynamic>;
                        if (jsonResponse['state'] == 'ok') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('success').tr(),
                          ));
                          Navigator.pushReplacementNamed(context, '/webview');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('error').tr(),
                          ));
                          Navigator.pop(context);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('error2')
                              .tr(args: [response.statusCode.toString()]),
                        ));
                        Navigator.pop(context);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('enter').tr(),
                    ))),
          ],
        ),
      ),
    );
  }
}
