import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test/client/screens/add_task_screen.dart';
import 'package:test/client/screens/edit_task_screen.dart';
import 'package:test/client/screens/login_screen.dart';
import 'package:test/client/services/google_sevice.dart';
import 'package:test/client/widgets/floating_filter_bar.dart';
import 'package:test/client/widgets/task_card.dart';
import 'package:test/shared/constants/colors.dart';
import 'package:test/shared/constants/config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.userID});
  final String userID;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String filter = 'all';

  void updateFilter(String newFilter) {
    setState(() {
      filter = newFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await GoogleService().logOut(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const LoginScreen()),
                  (route) => false);
            },
            tooltip: 'Cerrar sesión',
            iconSize: 30,
          ),
          const SizedBox(
            width: 10,
          ),
        ],
        toolbarHeight: 80,
        centerTitle: true,
        title: const Text(
          'Tareas',
          style: TextStyle(
            fontSize: 30.0,
            color: almostBlack,
          ),
        ),
        shape: const Border(
          bottom: BorderSide(
            color: lightGray,
            width: 2.0,
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 80.0, // Set the width
        height: 80.0, // Set the height
        child: FloatingActionButton(
          backgroundColor: accentPurple,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => AddTaskScreen(userID: widget.userID)),
            );
          },
          tooltip: 'AddTask',
          child: const Icon(
            Icons.add,
            size: 60.0,
            color: lightPurple,
          ),
        ),
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(top: 52, bottom: 30),
          child: StreamBuilder<QuerySnapshot>(
            stream: filter == 'all'
                ? FirebaseFirestore.instance
                    .collection('Task')
                    .where('userID', isEqualTo: widget.userID)
                    .snapshots()
                : filter == 'pending'
                    ? FirebaseFirestore.instance
                        .collection('Task')
                        .where('userID', isEqualTo: widget.userID)
                        .where('state', isEqualTo: false)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('Task')
                        .where('userID', isEqualTo: widget.userID)
                        .where('state', isEqualTo: true)
                        .snapshots(),
            builder: (context, snapshot) {
              // for snapshot in snapshots
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> document = snapshot.data?.docs[index]
                        .data() as Map<String, dynamic>;
                    return Center(
                      child: Dismissible(
                        key: ValueKey(snapshot.data!.docs[index].id.toString() +
                            document['state'].toString()),
                        confirmDismiss: (direction) async {
                          await FirebaseFirestore.instance
                              .collection('Task')
                              .doc(snapshot.data?.docs[index].id as String)
                              .update({'state': true});
                          return false;
                        },
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width -
                              smallHorizontalScreenPadding,
                          child: Center(
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.circular(cardRadius + 4),
                              hoverColor: Colors.transparent,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditTaskScreen(
                                      task: document,
                                      id: snapshot.data?.docs[index].id
                                          as String),
                                ),
                              ),
                              child: TaskCard(
                                title: document['title'],
                                description: document['description'],
                                date: document['date'],
                                state: document['state'],
                                onDelete: () {
                                  FirebaseFirestore.instance
                                      .collection('Task')
                                      .doc(snapshot.data?.docs[index].id)
                                      .delete();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            },
          ),
        ),
        positionedFilterBar(),
      ]),
    );
  }

  Widget positionedFilterBar() {
    return Positioned(
      right: 0,
      left: 0,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        color: const Color.fromARGB(255, 254, 247, 255),
        width: MediaQuery.of(context).size.width - horizontalScreenPadding,
        child: FloatingFilterBar(
          onFilterChanged: updateFilter,
        ),
      ),
    );
  }
}
