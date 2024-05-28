import 'package:flutter/material.dart';

import 'router.dart';
import 'constants.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'flutter_http_json',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        initialRoute: homeRoute,
        onGenerateRoute: createRoute,
      ),
    );
