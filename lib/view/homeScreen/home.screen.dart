import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_helper/core/model/post.model.dart';
import 'package:note_helper/main.dart';
import 'package:note_helper/view/addScreen/add.task.screen.dart';
import 'package:note_helper/view/homeScreen/details.screen.dart';
import 'package:note_helper/view/Auth/login.screen.dart';
import 'package:note_helper/view/profileScreen/profile.screen.dart';
import 'package:note_helper/view/widget/flutter.toast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _firebaseAuthentication = FirebaseAuth.instance;

  // To Get The User ID (We Created Reference)
  User? user;

  //** To Create Fetch The Data Form Realtime Data Base We Gonna Create A Reference
  DatabaseReference? refRTDBase;

  // final DatabaseReference refRTDBase = FirebaseDatabase.instance.ref('Post');
  final TextEditingController searchController = TextEditingController();
  final TextEditingController editController = TextEditingController();
  FocusNode? myFocusNode;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      refRTDBase =
          FirebaseDatabase.instance.ref().child('Post').child(user!.uid);
    }
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    editController.dispose();
    myFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
              icon: const Icon(Icons.person)),
          IconButton(
              onPressed: () {
                /********************** Firebase Authentication Sign out ***********************/
                _firebaseAuthentication.signOut().then((value) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                }).onError((error, stackTrace) {
                  FlutterToast().toastMessage(error.toString());
                });
              },
              icon: const Icon(Icons.logout)),
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
                  label: Text("Search"),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              //*** Task Shown Here
              const Align(
                  alignment: Alignment.topLeft, child: Text("DAILY TASK")),
              Expanded(
                child: StreamBuilder(
                  stream: refRTDBase != null ? refRTDBase!.onValue : null,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.hasData && !snapshot.hasError) {
                      //** Create The Event To Get The "Data" of EventDatabase
                      var event = snapshot.data as DatabaseEvent;
                      //** Create Variable snapShot2 To Get The Event Data Is Object
                      var snapShot2 = event.snapshot.value;
                      if (snapShot2 == null) {
                        return const Center(
                          child: Text("No Task Available"),
                        );
                      }

                      Map<String, dynamic> arguments =
                          Map<String, dynamic>.from(
                              snapShot2 as Map<Object?, dynamic>);

                      var tasks = <PostModel>[];
                      /*Create a Loop To Get The Data Dynamically*/
                      for (var taskMap in arguments.values) {
                        PostModel postModel = PostModel.fromMap(
                            Map<String, dynamic>.from(taskMap));

                        tasks.add(postModel);
                      }

                      return ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            //** To Filter/Search We Gonna Create The This Function
                            final postTitle = tasks.length
                                .toString(); /*This Is For To Find The Task Related Data*/

                            PostModel post = tasks[index];
                            //** If Search Field Is Empty
                            //*** This Condition For Search Field Area
                            if (searchController.text.isEmpty) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                            title: post.title,
                                            date: post.dt,
                                            subData: post.taskName,
                                          )));
                                },
                                child: Card(
                                  color: getRandomColor(),
                                  child: ListTile(
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            post.title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            post.taskName,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      subtitle:
                                          Text(getHumanReadableDate(post.dt)),
                                      trailing: PopupMenuButton(
                                        icon: const Icon(
                                            Icons.more_horiz_rounded),
                                        itemBuilder: (BuildContext context) => [
                                          /************************* Edit/Update Section ****************/
                                          PopupMenuItem(
                                              value: 1,
                                              child: ListTile(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  showMyDialog(
                                                    postTitle,
                                                    post.taskID,
                                                  );
                                                },
                                                leading: const Icon(Icons.edit),
                                                title: const Text("Edit"),
                                              )),
                                          /**********************************Delete Section*************************/
                                          PopupMenuItem(
                                              value: 1,
                                              child: ListTile(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  if (refRTDBase != null) {
                                                    refRTDBase!
                                                        .child(post.taskID)
                                                        .remove();
                                                  }
                                                },
                                                leading: const Icon(Icons
                                                    .delete_forever_outlined),
                                                title: const Text("DELETE"),
                                              ))
                                        ],
                                      )),
                                ),
                              );
                            } else if (post.taskName.toLowerCase().contains(
                                searchController.text
                                    .trim()
                                    .toLowerCase()
                                    .toString())) {
                              return ListTile(
                                title: Text(post.taskName),
                                subtitle: Text(getHumanReadableDate(post.dt)),
                              );
                            } else {
                              return const SizedBox();
                            }
                          });
                    } else {
                      return const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(child: CircularProgressIndicator()),
                          ]);
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

/* Function For Show Dialog Box To Update And Delete Note*/
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

                    refRTDBase!.child(id).update(
                      {
                        'taskName': editController.text.trim().toString(),
                      },
                    ).then((value) {
                      FlutterToast().toastMessage("UPDATE CHANGE");
                    }).onError((error, stackTrace) {
                      FlutterToast().toastMessage(error.toString());
                    });
                  },
                  child: const Text("UPDATE"),
                )
              ]);
        });
  }

/*Create a Function To Convert Mill Sec Date Time To Human Readable Time/Date*/

  String getHumanReadableDate(int dt) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dt);
    return DateFormat('dd MM yyyy').format(dateTime);
  }
}
