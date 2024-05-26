import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test/client/widgets/date_field.dart';
import 'package:test/client/widgets/snack_bar.dart';
import 'package:test/client/widgets/text_area.dart';
import 'package:test/client/widgets/text_field.dart';
import 'package:test/shared/constants/colors.dart';
import 'package:test/shared/constants/config.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key, required this.userID});
  final String userID;

  @override
  // ignore: library_private_types_in_public_api
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 30,
          tooltip: 'Volver',
        ),
        toolbarHeight: 80,
        centerTitle: true,
        title: const Text(
          'Nueva tarea',
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
      body: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 40.0),
              textField(context, "Título", _titleController, false),
              const SizedBox(height: 20.0),
              textArea(context, "Descripción", "No tomar antes de bases!",
                  _descriptionController),
              const SizedBox(height: 20.0),
              DateField(controller: _dateController),
              const SizedBox(height: 60.0),
              colorButton("Agregar"),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget colorButton(String text) {
    return Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - horizontalScreenPadding,
        height: 80,
        child: FloatingActionButton(
          onPressed: () {
            FirebaseFirestore.instance.collection('Task').add({
              'title': _titleController.text,
              'description': _descriptionController.text,
              'date': _dateController.text,
              'state': false,
              'userID': widget.userID,
            });
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
                snackBar(context, 'Has creado una nueva tarea!', false));
          },
          backgroundColor: accentPurple,
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
