import 'package:flutter/material.dart';

import '../models/form.dart';
import '../models/assessment.dart';

class DetailsScreen extends StatelessWidget {
  final Assessment assessment;
  final List<Criterion> criteria;
  final List<Scale> scales;

  DetailsScreen({required this.assessment, required this.criteria, required this.scales});

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(Navigator.canPop(context)),
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          title: Text(assessment.member.shortName),
          centerTitle: true,
        ),
        body: ListView.separated(
          itemCount: criteria.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(criteria[index].title),
            subtitle: Text(criteria[index].description),
            trailing: _DropdownButton(index: index, screen: this),
          ),
          separatorBuilder: (context, index) => Divider(
            color: Colors.grey,
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton.extended(
              label: const Text('Save'),
              icon: const Icon(Icons.check_circle),
              heroTag: null,
              onPressed: () => Navigator.pop(context, assessment),
            ),
            FloatingActionButton.extended(
              label: const Text('Cancel'),
              icon: const Icon(Icons.cancel),
              heroTag: null,
              onPressed: () => Navigator.pop(context, null),
            ),
          ],
        ),
      ),
    );
  }
}

class _DropdownButton extends StatefulWidget {
  final int index;
  final DetailsScreen
      screen; // A convinience reference. Pass only one variable. We still can reference assessments, scales and criteria

  _DropdownButton({required this.index, required this.screen});

  @override
  __DropdownButtonState createState() => __DropdownButtonState();
}

class __DropdownButtonState extends State<_DropdownButton> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: widget.screen.assessment.points[widget.index],
      items: widget.screen.scales
          .map(
            (scale) => DropdownMenuItem(
              value: scale.value,
              child: Text(scale.title),
            ),
          )
          .toList(),
      onChanged: (newValue) => setState(
          () => widget.screen.assessment.points[widget.index] = newValue!),
    );
  }
}
