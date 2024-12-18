import 'package:flutter/material.dart';

import 'pages/create_page.dart';
import 'pages/home.dart';


void main() => runApp(MaterialApp(
      title: 'Our Calendar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/create': (context) => CreatePage(),
      },
    ));
