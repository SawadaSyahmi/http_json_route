import 'package:flutter/material.dart';

import 'constants.dart';
import 'screens/details.dart';
import 'screens/summary.dart';

Route<dynamic>? createRoute(settings) {
  switch (settings.name) {
    case homeRoute:
    case summaryRoute:
      return MaterialPageRoute(
        builder: (context) => SummaryScreen(),
      );

    case detailsRoute:
      return MaterialPageRoute(
        builder: (context) => DetailsScreen(
            assessment: settings.arguments['assessment'],
            scales: settings.arguments['scales'],
            criteria: settings.arguments['criteria']),
      );
  }
  return null;
}
