import 'assessment.dart';
import 'form.dart';

class Activity {
  int id;
  String title;
  Form form;
  GroupMember evaluator;
  List<Assessment> assessments;

  Activity({required this.id, required this.title, required this.form, required this.evaluator, required this.assessments});

  Activity.copy(Activity from)
      : this(
            id: from.id,
            title: from.title,
            form: from.form,
            evaluator: from.evaluator,
            assessments: from.assessments);

  Activity.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            title: json['title'],
            form: Form.fromJson(json['form']),
            evaluator: GroupMember.fromJson(json['evaluator']),
            assessments: (json['assessments'] as List)
                .map((item) => Assessment.fromJson(item))
                .toList());

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'formId': form.id,
        'evaluatorId': evaluator.id,
        'assessments': assessments
      };
}
