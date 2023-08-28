import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:note_helper/view/addScreen/add.task.screen.dart';
import 'package:note_helper/view/loginAuth/login.screen.dart';
import 'package:note_helper/view/widget/flutter.toast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _firebaseAuthentication = FirebaseAuth.instance;

  //** To Create Fetch The Data Form RealTime Data Base We Gonna Create A Reference
  final refRTDBase = FirebaseDatabase.instance.ref('Post');
  final TextEditingController searchController = TextEditingController();
  final TextEditingController editController = TextEditingController();
  FocusNode? myFocusNode;

  @override
  void dispose() {
    searchController.dispose();
    editController.dispose();
    myFocusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                //**** Firebase Authentication Sign out
                _firebaseAuthentication.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }).onError((error, stackTrace) {
                  FlutterToast().toastMessage(error.toString());
                });
              },
              icon: const Icon(Icons.logout))
        ],
        title: const Center(
          child: Text("T A S K  S C R E E N"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddPTaskScreen()));
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(builder: (context, BoxConstraints constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //**** Search TextField
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: searchController,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: const InputDecoration(
                  label: Text("Search...."),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              //*** Task Shown Here

              Text("DAILY TASK"),
              Expanded(
                // flex: 1,
                child: StreamBuilder(
                  stream: refRTDBase.onValue,
                  builder: (BuildContext context,
                      AsyncSnapshot<DatabaseEvent> snapshot) {
                    if (!snapshot.hasData) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(child: CircularProgressIndicator()),
                        ],
                      );
                    } else {
                      Map<Object?, dynamic> map =
                          snapshot.data!.snapshot.value as dynamic;
                      List<dynamic> list = [];
                      list.clear();
                      list = map.values.toList();
                      return ListView.builder(
                          itemCount: map.length,
                          itemBuilder: (context, index) {
                            //** To Filter/Search We Gonna Create The This Function
                            final title = list[index]['title'];
                            //** If Search Field Is Empty
                            if (searchController.text.isEmpty) {
                              return ListTile(
                                title: Text(
                                  list[index]['title'],
                                ),
                                subtitle: Text(
                                  list[index]['id'],
                                ),
                                trailing: PopupMenuButton(
                                  icon: const Icon(Icons.more_horiz_rounded),
                                  itemBuilder: (BuildContext context) => [
                                    //*** Edit Section
                                    PopupMenuItem(
                                        value: 1,
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.pop(context);
                                            showMyDialog(
                                              title,
                                              list[index]['id'],
                                            );
                                          },
                                          leading: const Icon(Icons.edit),
                                          title: const Text("Edit"),
                                        )),
                                    //*** Delete Section
                                    PopupMenuItem(
                                        value: 1,
                                        child: ListTile(
                                          onTap: () {
                                            Navigator.pop(context);
                                            refRTDBase
                                                .child(list[index]['id'])
                                                .remove();
                                          },
                                          leading: const Icon(
                                              Icons.delete_forever_outlined),
                                          title: const Text("DELETE"),
                                        )),
                                  ],
                                ),
                              );
                            } else if (title.toLowerCase().contains(
                                searchController.text
                                    .toLowerCase()
                                    .toLowerCase()
                                    .toString())) {
                              return ListTile(
                                title: Text(
                                  list[index]['title'],
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          });
                    }
                  },
                ),
              )
              //*** With Firebase Custom Animated List
              // Expanded(
              //   child: FirebaseAnimatedList(
              //       query: refRTDBase,
              //       itemBuilder:
              //           (context, DataSnapshot snapshot, animation, index) {
              //         return ListTile(
              //           title: Text(snapshot.child('id').value.toString()),
              //           subtitle: Text(snapshot.child('title').value.toString()),
              //         );
              //       }),
              // ),
            ],
          );
        }),
      ),
    );
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
              focusNode: myFocusNode,
              controller: editController,
              decoration: const InputDecoration(
                label: Text("Edit"),
                hintText: "Edit",
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("CANCEL"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  refRTDBase.child(id).update(
                    {
                      'title': editController.text.toString(),
                    },
                  ).then((value) {
                    FlutterToast().toastMessage("UPDATE CHANGE");
                  }).onError((error, stackTrace) {
                    FlutterToast().toastMessage(error.toString());
                  });
                },
                child: const Text("UPDATE"),
              ),
            ],
          );
        });
  }
}
