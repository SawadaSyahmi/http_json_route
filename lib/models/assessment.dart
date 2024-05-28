class GroupMember {
  int id;
  String shortName;
  String fullName;

  GroupMember({required this.id, required this.shortName, required this.fullName});

  GroupMember.copy(GroupMember from)
      : this(id: from.id, shortName: from.shortName, fullName: from.fullName);

  GroupMember.fromJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            shortName: json['shortName'],
            fullName: json['fullName']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'shortName': shortName, 'fullName': fullName};
}

class Assessment {
  int id;
  int activityId;
  GroupMember member;
  List<int> points;

  Assessment({required this.id, required this.activityId, required this.member, required this.points});
  Assessment.copy(Assessment from)
      : this(
            id: from.id,
            activityId: from.activityId,
            member: GroupMember.copy(from.member),
            points: [...from.points]);

  Assessment.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          activityId: json['activityId'],
          member: GroupMember.fromJson(
            json['member'],
          ),
          points: [...json['points']],
        );

  Map<String, dynamic> toJson() => {
        'id': id,
        'activityId': activityId,
        'member': member.toJson(),
        'points': [...points]
      };

  // The percent() method now accepts a parameter to account for different number of scales

  double percent({required double maxScore}) =>
      (points.reduce((sum, item) => sum + item) / maxScore) * 100.0;
}
