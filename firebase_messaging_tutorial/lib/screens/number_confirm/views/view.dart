import 'dart:io';

import 'package:flutter/material.dart';

class NumberConfirmView extends StatefulWidget {
  @override
  _NumberConfirmViewState createState() => _NumberConfirmViewState();
}

class _NumberConfirmViewState extends State<NumberConfirmView> {
  final myController = TextEditingController();

  var upperPartGroup = Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
          'A confimation code has been sent to your phone.\nPlease enter the confimation code within 55sec...'),
      SizedBox(height: 20),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Please enter confimation code:'),
          Flexible(child: TextField(onChanged: (String value) {})),
        ],
      ),
      Card(
          child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Enter'),
              ))),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification number string'),
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Container(
        padding: const EdgeInsets.all(20),
        child: upperPartGroup,
      ),
    );
  }
}
