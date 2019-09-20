import 'dart:async';

import 'package:flutter/material.dart';

import 'home.dart';


Timer timer;
StreamSubscription subscription;
void main() {
  runApp(MaterialApp(
    home:Home() ,
    debugShowCheckedModeBanner: false,
  ));
}
