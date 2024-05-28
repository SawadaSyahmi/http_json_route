import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/activity.dart';
import '../models/assessment.dart';

class DataService {
  // static const String baseUrl = 'http://192.168.0.3:3000';  // to use local JSON Server. Replace the IP address
  static const String baseUrl =
      'https://my-json-server.typicode.com/SawadaSyahmi/http_json_route';

  // Helper method to HTTP GET Request
  Future get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw response;
  }

  // Helper method to HTTP PATCH Request
  Future patch(String endpoint, {dynamic data}) async {
    final response = await http.patch('$baseUrl/$endpoint' as Uri,
        headers: {'Content-Type': 'application/json'}, body: jsonEncode(data));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw response;
  }

  Future<Activity> getActivity(int id) async {
    final json = await get('activities/$id');

    // Resolve evaluatorId and formId to their details data
    json['evaluator'] = await get('users/${json['evaluatorId']}');
    json['form'] = await get('forms/${json['formId']}');

    // Get the list of assessments for the activity
    json['assessments'] = await get('assessments?activityId=$id');

    // Resolve each memberId in assessments to its details
    for (int i = 0; i < json['assessments'].length; i++) {
      final memberId = json['assessments'][i]['memberId'];
      json['assessments'][i]['member'] = await get('users/$memberId');
    }

    return Activity.fromJson(json);
  }

  Future<Assessment> updateAssessmentPoints({required int id, required List<int> points}) async {
    final json = await patch('assessments/$id', data: {'points': points});
    json['member'] = await get(
        'users/${json['memberId']}'); // Resolve memberId to its details

    return Assessment.fromJson(json);
  }
}

final dataService = DataService();
