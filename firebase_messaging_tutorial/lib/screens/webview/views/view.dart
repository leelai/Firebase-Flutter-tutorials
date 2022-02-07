// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:device_display_brightness/device_display_brightness.dart';
import 'package:firebase_messaging_tutorial/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MaterialApp(home: MyWebView()));

class MyWebView extends StatefulWidget {
  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  String url = '';

  @override
  void initState() {
    super.initState();
    WebView.platform = SurfaceAndroidWebView();

    Util.initFirebase(context);
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    DeviceDisplayBrightness.keepOn(enabled: true);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 8,
        // leading: Builder(
        //   builder: (BuildContext context) {
        //     return InkWell(
        //         onTap: () => Navigator.pushNamed(context, '/setup'),
        //         child: Center(child: Text('setupssssss').tr()));
        //   },
        // ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
                onTap: () => Navigator.pushNamed(context, '/setup'),
                child: Center(child: Text('setups').tr())),
          ],
        ),
        actions: <Widget>[
          NavigationControls(_controller.future),
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
            SharedPreferences.getInstance().then((prefs) {
              var value = prefs.getString('main_page') ?? "";
              if (value.isEmpty) return;
              webViewController.loadUrl(
                  value.startsWith('http://') ? value : 'http://' + value);
            });
          },
          javascriptChannels: <JavascriptChannel>{
            _toasterJavascriptChannel(context),
          },
          gestureNavigationEnabled: true,
          backgroundColor: const Color(0x00000000),
        );
      }),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController? controller = snapshot.data;
        return Row(
          children: <Widget>[
            // IconButton(
            //   icon: const Icon(Icons.arrow_back_ios),
            //   onPressed: !webViewReady
            //       ? null
            //       : () async {
            //           if (await controller!.canGoBack()) {
            //             await controller.goBack();
            //           }
            //         },
            // ),
            // IconButton(
            //   icon: const Icon(Icons.arrow_forward_ios),
            //   onPressed: !webViewReady
            //       ? null
            //       : () async {
            //           if (await controller!.canGoForward()) {
            //             await controller.goForward();
            //           }
            //         },
            // ),
            // IconButton(
            //   icon: const Icon(Icons.replay),
            //   onPressed: !webViewReady ? null : () => controller!.reload(),
            // ),
            InkWell(
                onTap: !webViewReady ? null : () => controller!.reload(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('refresh').tr(),
                ))
          ],
        );
      },
    );
  }
}
