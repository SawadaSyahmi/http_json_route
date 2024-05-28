import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/form.dart';
import '../models/assessment.dart';
import '../models/activity.dart';
import '../services/data_service.dart';

// We need to convert SummaryScreen to stateful because we need the initState() method
// to place our dataService call, i.e., the part that responsibles to fetch data from the server.

class SummaryScreen extends StatefulWidget {
  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  late Future<Activity> _futureData;

  // Now the following variables only serve as helpers or convinient variables.
  // So that we don't need to change our previous code so much.
  // They will be updated in the FutureBuilder (once the fetch process completes)

  late String activityName;
  late GroupMember evaluator;
  late List<Assessment> assessments;
  late List<Criterion> criteria;
  late List<Scale> scales;
  late double maxScore;

  @override
  void initState() {
    super.initState();
    _futureData = dataService.getActivity(2);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Activity>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            activityName = snapshot.data!.title;
            evaluator = snapshot.data!.evaluator;
            assessments = snapshot.data!.assessments;
            criteria = snapshot.data!.form.criteria;
            scales = snapshot.data!.form.scales;
            maxScore = (scales.length * scales[0].value).toDouble();
            return _buildMainScreen();
          }

          return _buildFetchingDataScreen();
        });
  }

  Scaffold _buildMainScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: <Widget>[
            Text(
              activityName,
              style: TextStyle(fontSize: 15),
            ),
            Text(
              evaluator.fullName,
              style: const TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
      body: ListView.separated(
        itemCount: assessments.length,
        itemBuilder: (context, index) => _ListTile(
          index: index,
          screen: this,
        ),
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey,
        ),
      ),
    );
  }

  Scaffold _buildFetchingDataScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 50),
            Text('Fetching data in progress'),
          ],
        ),
      ),
    );
  }
} // class _SummaryScreenState

class _ListTile extends StatefulWidget {
  final int index;
  final _SummaryScreenState
      screen; // A convinience variable to access data from the screen object, so that no need to pass multiple variables

  _ListTile({required this.index, required this.screen});

  @override
  __ListTileState createState() => __ListTileState();
}

class __ListTileState extends State<_ListTile> {
  void _navigate() async {
    final result = await Navigator.pushNamed(context, detailsRoute, arguments: {
      'assessment': Assessment.copy(widget.screen.assessments[widget.index]),
      'criteria': widget.screen.criteria,
      'scales': widget.screen.scales
    });

    if (result != null) {
      setState(() {
        widget.screen.assessments[widget.index] = result as Assessment;;
        Assessment _assessment = result;
        dataService.updateAssessmentPoints(
            id: _assessment.id, points: _assessment.points);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _percent = widget.screen.assessments[widget.index]
        .percent(maxScore: widget.screen.maxScore);
    return ListTile(
      title: Text(widget.screen.assessments[widget.index].member.shortName),
      subtitle: Text(widget.screen.assessments[widget.index].member.fullName),
      trailing: CircleAvatar(
        child: Text(
          _percent.round().toString(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: _percent < 50 ? Colors.pink : Colors.purple,
      ),
      onTap: () => _navigate(),
    );
  }
}
