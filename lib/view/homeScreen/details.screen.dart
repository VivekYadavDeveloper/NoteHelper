import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../main.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.title, required this.date, required this.subData});

  final String title;
  final String subData;
  final int date;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LayoutBuilder(
        builder: (context, BoxConstraints constraints) {
          return Card(
              color: getRandomColor(),
              child: ListTile(
                title: Text(
                  widget.subData,
                ),
                subtitle: Text(getHumanReadableDate(widget.date)),
              ));
        },
      ),
    );
  }

  String getHumanReadableDate(int dt) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt);
    return DateFormat('dd MM yyyy').format(dateTime);
  }
}
