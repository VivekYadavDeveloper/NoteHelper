import 'package:flutter/material.dart';

class ReusableWidget extends StatelessWidget {
  final String title, value;
  final IconData iconData;

  const ReusableWidget(
      {super.key,
      required this.title,
      required this.value,
      required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(title),
          trailing: Text(value),
          leading: Icon(iconData),
        )
      ],
    );
  }
}
