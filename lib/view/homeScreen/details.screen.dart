import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:note_helper/core/model/post.model.dart';
import 'package:note_helper/core/utils/constant/app.color.dart';
import 'package:note_helper/view/AddScreen/add.task.screen.dart';

class DetailScreen extends StatefulWidget {
  final PostModel post;
  const DetailScreen({super.key, required this.post});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late QuillController _controller;

  @override
  void initState() {
    super.initState();
    try {
      final decoded = jsonDecode(widget.post.taskName);
      // ✅ List check — sirf tabhi Delta parse karo
      if (decoded is List) {
        final doc = Document.fromJson(decoded);
        _controller = QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
          config: const QuillControllerConfig(
          requireScriptFontFeatures: false,
        ),
        );
      } else {
        throw Exception('Not a Delta JSON');
      }
    } catch (e) {
      // ✅ Plain text fallback
      final doc = Document()..insert(0, widget.post.taskName);
      _controller = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String getHumanReadableDate(int dt) {
    return DateFormat('dd MM yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(dt));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(widget.post.title),
        actions: [
          IconButton(
            onPressed: () => _goToEditScreen(context),
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Date ─────────────────────────────────────
            Text(
              getHumanReadableDate(widget.post.dt),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),

            // ── Rich Text — Read Only ─────────────────────
            Expanded(
              child: QuillEditor(
                controller: _controller,
                scrollController: ScrollController(),
                focusNode: FocusNode(),
                config: const QuillEditorConfig(
                  padding: EdgeInsets.all(8),
            
                  showCursor: false,
                  enableInteractiveSelection: false,
                ),
              ),
            ),

            // ── Edit Button ───────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                ),
                onPressed: () => _goToEditScreen(context),
                child: const Text("E D I T  T A S K"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToEditScreen(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => AddPTaskScreen(post: widget.post),
      ),
    );

    if (result == true && context.mounted) {
      Navigator.pop(context);
    }
  }
}