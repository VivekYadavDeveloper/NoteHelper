import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_helper/core/model/post.model.dart';
import 'package:note_helper/core/utils/constant/app.color.dart';

import '../../Bloc/NoteBloc/create_note_bloc.dart';
import '../widget/custom_button.dart';
import '../widget/flutter.toast.dart';

class AddPTaskScreen extends StatefulWidget {
  final PostModel? post;
  const AddPTaskScreen({super.key, this.post});

  @override
  State<AddPTaskScreen> createState() => _AddPTaskScreenState();
}

class _AddPTaskScreenState extends State<AddPTaskScreen> {
  late EditorState titleEditorState;
  late EditorState taskEditorState;

  bool loading = false;

  bool get isEditMode => widget.post != null;

  EditorState _buildEditor(String? text) {
    if (text != null && text.isNotEmpty) {
      return EditorState(
        document: Document.blank()..insert([0], [paragraphNode(text: text)]),
      );
    } else {
      return EditorState.blank(withInitialText: true);
    }
  }

  @override
  void initState() {
    super.initState();

    titleEditorState = _buildEditor(widget.post?.title);
    taskEditorState = _buildEditor(widget.post?.taskName);
  }

  @override
  void dispose() {
    titleEditorState.dispose();
    taskEditorState.dispose();
    super.dispose();
  }

  String _extractText(EditorState editorState) {
    final document = editorState.document;
    final buffer = StringBuffer();
    for (final node in document.root.children) {
      final delta = node.delta;
      if (delta != null) {
        buffer.writeln(delta.toPlainText());
      }
    }
    return buffer.toString().trim();
  }

  bool _validate() {
    final title = _extractText(titleEditorState);
    final task = _extractText(taskEditorState);

    if (title.isEmpty) {
      FlutterToast().toastMessage('Enter the title');
      return false;
    }
    if (task.isEmpty) {
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
        title: Text(isEditMode ? "EDIT TASK" : "C R E A T E  T A S K"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),

            // ── TITLE LABEL ──────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "Project Title",
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 4),

            // ── TITLE EDITOR (single line, no border) ────────
            SizedBox(
              height: 55,
              child: AppFlowyEditor(
                editorState: titleEditorState,
                editorStyle: EditorStyle.mobile(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── TASK LABEL ───────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "Start Writing Your Project Details Here....",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 4),

            // ── TASK EDITOR (multi-line, no border) ──────────
            Expanded(
              child: AppFlowyEditor(
                editable: true,
                autoFocus: true,
                showMagnifier: true,
                shrinkWrap: true,
                editorState: taskEditorState,
                editorStyle: EditorStyle.mobile(),
              ),
            ),
            // ── TASK TOOLBAR ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: MobileToolbar(
                  itemHighlightColor: AppColors.primaryColor,
                  borderRadius: 10,
                  toolbarHeight: 60,
                  backgroundColor: AppColors.secondaryColor,
                  tabbarSelectedBackgroundColor:
                      AppColors.primaryGreenMintColor,
                  itemOutlineColor: AppColors.primaryColor,
                  editorState: taskEditorState,
                  toolbarItems: [
                    textDecorationMobileToolbarItem,
                    buildTextAndBackgroundColorMobileToolbarItem(
                        // textColorOptions: [
                        //   ColorOption(colorHex: 0xFFC8F469.toString(), name: "Green Mint")
                        // ],
                        // backgroundColorOptions: [],
                        ),
                    headingMobileToolbarItem,
                    listMobileToolbarItem,
                    linkMobileToolbarItem,
                    dividerMobileToolbarItem,
                    quoteMobileToolbarItem,
                    codeMobileToolbarItem,
                  ],
                ),
              ),
            ),
            // ── SUBMIT BUTTON ────────────────────────────────
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
                    Navigator.pop(context);
                    
                  }
                },
                child: CustomButton(
                  color: AppColors.secondaryColor,
                  isLoading: loading,
                  title: isEditMode ? "U P D A T E  T A S K" : "A D D  T A S K",
                  onTap: () {
                    if (_validate()) {
                      final title = _extractText(titleEditorState);
                      final description = _extractText(taskEditorState);

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
