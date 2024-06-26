import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test/client/screens/add_task_screen.dart';
import 'package:test/client/screens/edit_task_screen.dart';
import 'package:test/client/screens/login_screen.dart';
import 'package:test/client/services/google_sevice.dart';
import 'package:test/client/widgets/floating_filter_bar.dart';
import 'package:test/client/widgets/snack_bar.dart';
import 'package:test/client/widgets/task_card.dart';
import 'package:test/server/database/task_repository.dart';
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
  final ScrollController _scrollController = ScrollController();

  void updateFilter(String newFilter) {
    setState(() {
      filter = newFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            color: appBarTextColor,
            onPressed: () async {
              await GoogleService().logOut(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const LoginScreen()),
                  (route) => false);
            },
            tooltip: 'Cerrar sesión',
            iconSize: smallIconSize,
          ),
          const SizedBox(
            width: 10,
          ),
        ],
        toolbarHeight: appBarHeight,
        centerTitle: true,
        title: const Text(
          'Tareas',
          style: TextStyle(
            fontSize: appBarFontSize,
            color: appBarTextColor,
          ),
        ),
        shape: const Border(
          bottom: BorderSide(
            color: appBarLineColor,
            width: 2.0,
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: buttonIconSize, // Set the width
        height: buttonIconSize, // Set the height
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
            size: 50.0,
            color: lightPurple,
          ),
        ),
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: StreamBuilder<QuerySnapshot>(
            stream: TaskRepository().getTasks(widget.userID, filter: filter),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data!.docs.length + 1,
                  itemBuilder: (context, index) {
                    // esta condicion sirve para que el ultimo elemento sea un espacio en blanco
                    if (index == snapshot.data?.docs.length) {
                      return const SizedBox(height: 100);
                    }

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
                              .update({'state': !document['state']});
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
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return alertDialog(() {
                                          TaskRepository().deleteTask(snapshot
                                              .data?.docs[index].id as String);
                                        });
                                      });
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
        height: 40,
        color: const Color.fromARGB(255, 254, 247, 255),
        width: MediaQuery.of(context).size.width - horizontalScreenPadding,
        child: FloatingFilterBar(
          onFilterChanged: updateFilter,
        ),
      ),
    );
  }

  Widget alertDialog(Function onDelete) {
    return AlertDialog(
      title: const Text('Confirmación'),
      content: const Text('¿Estás seguro de que quieres eliminar esta tarea?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onDelete();
            Navigator.pop(context, 'OK');
            ScaffoldMessenger.of(context).showSnackBar(
                snackBar(context, 'Se ha eliminado la tarea', true));
          },
          child: const Text('Eliminar'),
        ),
      ],
    );
  }
}
