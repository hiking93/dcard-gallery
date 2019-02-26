import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dcard_gallery/screen/home.dart';

void main() {
  runApp(MyApp());
  updateSystemUi();
  SystemChannels.lifecycle.setMessageHandler((msg) {
    if (msg == AppLifecycleState.resumed.toString()) {
      updateSystemUi();
    }
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dcard Gallery',
      theme: ThemeData(
        primaryColor: Color(0xff006aa6),
        primaryColorDark: Color(0xff005788),
        primaryColorLight: Color(0xff3397cf),
        accentColor: Color(0xff3397cf),
      ),
      home: HomePage(),
    );
  }
}

void updateSystemUi() {
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
  }
}
