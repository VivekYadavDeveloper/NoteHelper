import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_helper/core/model/post.model.dart';
import 'package:note_helper/view/AddScreen/add.task.screen.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen(
      {super.key,
      required this.title,
      required this.date,
      required this.subData, required this.post});

  final String title;
  final String subData;
  final int date;
  final PostModel post;

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
          return ListTile(
            title: Text(
              widget.subData,
            ),
            subtitle: Text(getHumanReadableDate(widget.date)),
            trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // ✅ post diya — edit mode
                      builder: (_) => AddPTaskScreen(post: widget.post),
                    ), 
                  );
                },
                child: const Text('Edit')),
          );
        },
      ),
    );
  }

  String getHumanReadableDate(int dt) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt);
    return DateFormat('dd MM yyyy').format(dateTime);
  }
}
