// Fetching JSON data from the internet using the http package.
// For convinience, in this demo all data (i.e. assessements, criteria and scales) are consilidated in a single JSON data, so that we fetch only once
// Modification in this commit:
//      The fetching process (i.e. calling to fetchData() ) will be done in the main scree (Summary)
//      Details screen no longer reference its data (scales and criteria) from global variables. Instead, the data
//         will be passed from the main screen.

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'assessment.dart';
import 'form.dart';

// fetchData() - To fetch data from the internet using the http package
//               The fetched data are stored in global variables (Not recommended approach. This is only for demonstration purpose)

// We use a Map variable as the return value as the functio, fetchData(), will be returning
//  multiple data, i.e., evaluator, asessements, criteria and scales

Future<Map<String, dynamic>> fetchData(String url) async {
  print('Fetching data from $url');

  http.Response response = await http.get(url as Uri);

  print('Fetching has completed with status code ${response.statusCode}');

  String stringJson = response.body;
  Map<String, dynamic> _json = json.decode(stringJson);

  Map<String, dynamic> results = Map();

  results['evaluator'] = GroupMember.fromJson(_json['evaluator']);
  results['assessments'] = (_json['assessments'] as List)
      .map((item) => Assessment.fromJson(item))
      .toList();

  results['scales'] =
      (_json['scales'] as List).map((item) => Scale.fromJson(item)).toList();

  results['criteria'] = (_json['criteria'] as List)
      .map((item) => Criterion.fromJson(item))
      .toList();

  return results;
}
