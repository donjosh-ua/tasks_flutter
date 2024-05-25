import 'package:cloud_firestore/cloud_firestore.dart';

class TaskRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addTask(Map<String, dynamic> taskData) async {
    await _db.collection('Task').add(taskData);
  }

  Stream<QuerySnapshot> getTasks(String userID) {
    return _db
        .collection('Task')
        .where('userID', isEqualTo: userID)
        .snapshots();
  }

  Future<void> updateTaskState(String id) async {
    await _db.collection('Task').doc(id).update({'state': true});
  }

  Future<void> deleteTask(String id) async {
    await _db.collection('Task').doc(id).delete();
  }

  Future<void> updateTask(Map<String, dynamic> taskData, String id) async {
    await _db.collection('Task').doc(id).update(taskData);
  }
}
