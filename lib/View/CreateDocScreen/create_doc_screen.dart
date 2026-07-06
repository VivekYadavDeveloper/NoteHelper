import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:note_helper/Utils/Helper/document_export_helper.dart';

import '../../Bloc/NoteBloc/create_note_bloc.dart';
import '../../Core/Model/post_model.dart';
import '../../Core/Utils/Constant/app_color.dart';
import '../../Utils/widget/custom_button.dart';
import '../../Utils/widget/flutter_toast.dart';

class CreateDocScreen extends StatefulWidget {
  final PostModel? post;
  const CreateDocScreen({super.key, this.post});

  @override
  State<CreateDocScreen> createState() => _CreateDocScreenState();
}

class _CreateDocScreenState extends State<CreateDocScreen> {
  late QuillController titleController;
  late QuillController taskController;
  late FocusNode titleFocusNode;
  late FocusNode taskFocusNode;

  bool loading = false;

  bool get isEditMode => widget.post != null;

  QuillController _buildController(String? text) {
    if (text == null || text.isEmpty) {
      return QuillController.basic();
    }
    try {
      final decoded = jsonDecode(text);
      // ✅ List check — valid Delta JSON
      if (decoded is List) {
        final doc = Document.fromJson(decoded);
        return QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
      }
      throw Exception('Not a List');
    } catch (e) {
      // ✅ Plain text fallback
      final doc = Document()..insert(0, text);
      return QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    titleController = _buildController(widget.post?.title);
    taskController = _buildController(widget.post?.taskName);
    titleFocusNode = FocusNode();
    taskFocusNode = FocusNode();
  }

  @override
  void dispose() {
    titleController.dispose();
    taskController.dispose();
    titleFocusNode.dispose();
    taskFocusNode.dispose();
    super.dispose();
  }

  String _extractText(QuillController controller) {
    return controller.document.toPlainText().trim();
  }

  String _extractJson(QuillController controller) {
    final delta = controller.document.toDelta().toJson();
    final json = jsonEncode(delta);
    debugPrint('Saving JSON: $json');
    return json;
  }

  bool _validate() {
    if (_extractText(titleController).isEmpty) {
      FlutterToast().toastMessage('Enter the title');
      return false;
    }
    if (_extractText(taskController).isEmpty) {
      FlutterToast().toastMessage('Add description for task');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(isEditMode ? "Edit Doc" : "New Doc"),
        actions: [
          PopupMenuButton<ExportFormat>(
              icon: Icon(Icons.download),
              onSelected: (formate) {
                /*    pehle validate karo ki title/body khali na ho*/
                if (!_validate()) return;

                final title = _extractText(titleController);
                final body = _extractText(taskController);
                DocumentExportHelper.exportAndShare(
                    title: title, bodyPlainText: body, format: formate);
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                      value: ExportFormat.docx,
                      child: Text('Export as DOCX'),
                    ),
                    PopupMenuItem(
                      value: ExportFormat.pdf,
                      child: Text('Export as PDF'),
                    ),
                  ])
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),

            /*──---------- TITLE EDITOR ────────*/
            SizedBox(
              height: 55,
              child: QuillEditor(
                controller: titleController,
                scrollController: ScrollController(),
                config: const QuillEditorConfig(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  maxHeight: 55,
                  minHeight: 55,
                  placeholder: 'Doc title here',
                ),
                focusNode: titleFocusNode,
              ),
            ),
            const SizedBox(height: 8),
            /*──------------------ TASK TOOLBAR ─────────────────────────────────*/
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: QuillSimpleToolbar(
                  controller: taskController,
                  config: QuillSimpleToolbarConfig(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.primaryColor,
                        border: Border.all(color: AppColors.secondaryColor)),
                    multiRowsDisplay: false,
                    toolbarSize: 45,
                    toolbarSectionSpacing: 1.0,
                    showBoldButton: true,
                    showItalicButton: true,
                    showUnderLineButton: true,
                    showStrikeThrough: true,
                    showColorButton: true,
                    showBackgroundColorButton: true,
                    showHeaderStyle: true,
                    showListNumbers: true,
                    showListBullets: true,
                    showLink: true,
                    showCodeBlock: true,
                    showQuote: true,
                    showDividers: true,
                    showAlignmentButtons: false,
                    showDirection: false,
                    showSearchButton: false,
                    showFontSize: true,
                    showSubscript: false,
                    showSuperscript: false,
                    showSmallButton: false,
                    showInlineCode: false,
                    showIndent: true,
                    showClearFormat: true,
                    showFontFamily: true,
                  )),
            ),
            const SizedBox(height: 4),
            /*──---------- TASK EDITOR (multi-line, no border) ──────────*/
            Expanded(
              child: QuillEditor(
                controller: taskController,
                scrollController: ScrollController(),
                config: const QuillEditorConfig(
                  padding: EdgeInsets.all(12),
                  placeholder: 'Here...',
                  autoFocus: true,
                ),
                focusNode: taskFocusNode,
              ),
            ),

            /* ──-------------- SUBMIT BUTTON ────────────────────────────────*/
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: BlocListener<CreateNoteBloc, CreateNoteState>(
                listener: (context, state) {
                  if (state is CreateNoteLoading) {
                    const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is CreateNoteFailure) {
                    FlutterToast().toastMessage(state.errorMessage);
                  } else if (state is CreateNoteSuccess) {
                    FlutterToast().toastMessage(
                      isEditMode
                          ? "Task Updated Successfully"
                          : "Project Created Successfully",
                    );
                    Navigator.popUntilWithResult(
                        context, (route) => route.isFirst, true);
                  }
                },
                child: CustomButton(
                  color: AppColors.secondaryColor,
                  isLoading: loading,
                  title: isEditMode ? "U P D A T E  T A S K" : "A D D  T A S K",
                  onTap: () {
                    if (_validate()) {
                      final title = _extractText(titleController);
                      final description = _extractJson(taskController);

                      if (isEditMode) {
                        context.read<CreateNoteBloc>().add(
                            UpdateNoteButtonEvent(
                                taskId: widget.post!.taskID,
                                title: title,
                                description: description));
                      } else {
                        context.read<CreateNoteBloc>().add(
                              CreateNoteButtonEvent(
                                title: title,
                                description: description,
                              ),
                            );
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
