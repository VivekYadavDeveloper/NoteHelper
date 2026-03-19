import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';
import 'package:note_helper/Bloc/HomeBloc/home_bloc.dart';

import 'package:note_helper/View/HomeScreen/details_screen.dart';
import 'package:note_helper/View/ProfileScreen/profile_screen.dart';


import '../../Core/Model/post_model.dart';
import '../../Core/Utils/Constant/app_color.dart';
import '../../Utils/widget/flutter_toast.dart';

import '../Auth/login_screen.dart';
import '../CreateDocScreen/create_doc_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController editController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    editController.dispose();
    super.dispose();
  }

  String getHumanReadableDate(int dt) {
    return DateFormat('dd MM yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(dt));
  }

  // ✅ Delta JSON se plain text extract karo
  String _getPlainText(String taskName) {
    try {
      final json = jsonDecode(taskName);
      final doc = Document.fromJson(json);
      return doc.toPlainText().trim();
    } catch (e) {
      return taskName;
    }
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("UPDATE"),
          content: TextField(
            autofocus: true,
            controller: editController,
            decoration: const InputDecoration(
              label: Text("Edit"),
              hintText: "Edit",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("CANCEL"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<HomeBloc>().add(HomeUpdateTaskEvent(
                      taskId: id,
                      newTitle: editController.text.trim(),
                    ));
                FlutterToast().toastMessage("UPDATE CHANGED");
              },
              child: const Text("UPDATE"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeLoggedOut) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
        if (state is HomeTasksError) {
          FlutterToast().toastMessage(state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryColor,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.primaryColor,
          title: const Text("T A S K  S C R E E N"),
          actions: [
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              ),
              icon: const Icon(Icons.person),
            ),
            IconButton(
              onPressed: () => context.read<HomeBloc>().add(HomeLogoutEvent()),
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryGreenMintColor,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateDocScreen()),
          ),
          child: Icon(Icons.add, color: AppColors.secondaryColor),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // ── Search ─────────────────────────────────
              TextFormField(
                controller: searchController,
                onChanged: (value) =>
                    context.read<HomeBloc>().add(HomeSearchEvent(query: value)),
                decoration: const InputDecoration(
                  label: Text("Search"),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.topLeft,
                child: Text("DAILY TASK"),
              ),

              // ── Task List ───────────────────────────────
              Expanded(
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeTasksLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is HomeTasksEmpty) {
                      return const Center(child: Text("No Task Available"));
                    }
                    if (state is HomeTasksError) {
                      return Center(child: Text(state.message));
                    }
                    if (state is HomeTasksLoaded) {
                      final tasks = state.filteredTasks;

                      if (tasks.isEmpty) {
                        return const Center(child: Text("No matching tasks"));
                      }

                      return ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          PostModel post = tasks[index];

                          return GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => DetailScreen(post: post),
                              ),
                            ),
                            child: Card(
                              color: AppColors.primaryColor,
                              child: ListTile(
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      post.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    // ✅ JSON nahi — plain text dikhao
                                    Text(
                                      _getPlainText(post.taskName),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                subtitle: Text(getHumanReadableDate(post.dt)),
                                trailing: PopupMenuButton(
                                  icon: const Icon(Icons.more_horiz_rounded),
                                  itemBuilder: (context) => [
                                    // ── Edit ─────────────────
                                    PopupMenuItem(
                                      value: 1,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  CreateDocScreen(post: post),
                                            ),
                                          );
                                        },
                                        leading: const Icon(Icons.edit),
                                        title: const Text("Edit"),
                                      ),
                                    ),
                                    // ── Delete ───────────────
                                    PopupMenuItem(
                                      value: 2,
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.pop(context);
                                          context.read<HomeBloc>().add(
                                              HomeDeleteTaskEvent(
                                                  taskId: post.taskID));
                                        },
                                        leading: const Icon(
                                            Icons.delete_forever_outlined),
                                        title: const Text("DELETE"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
