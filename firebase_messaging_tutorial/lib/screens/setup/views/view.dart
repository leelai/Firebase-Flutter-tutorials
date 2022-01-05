import 'dart:io';

import 'package:flutter/material.dart';

class SetupView extends StatefulWidget {
  @override
  _SetupViewState createState() => _SetupViewState();
}

class _SetupViewState extends State<SetupView> {
  String _content = '';
  final myController = TextEditingController();

  void _handleChange() {
    setState(() {
      _content = myController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    myController.addListener(_handleChange);
  }

  void _onChanged(String value) {
    setState(() {
      _content = value;
    });
  }

  var upperPartGroup = Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Main page:'),
          Flexible(child: TextField(onChanged: (String value) {})),
        ],
      ),
      Card(
          child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Setup'),
              ))),
    ],
  );

  Widget lowerPartGroup(BuildContext context) {
    var lowerPartGroup = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Server:'),
            Flexible(child: TextField(onChanged: (String value) {})),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10, right: 10),
          child: const Text('Notification number:'),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: TextField(onChanged: (String value) {})),
            Card(
                child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/confirm');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Setup'),
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
        title: const Text('Setup'),
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              upperPartGroup,
              Divider(),
              lowerPartGroup(context),
            ],
          ),
        ),
      ),
    );
  }
}
