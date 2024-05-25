import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addUser(Map<String, dynamic> userData) async {
    await _db.collection('User').add(userData);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUser(String userID) {
    return _db
        .collection('User')
        .where('userID', isEqualTo: userID)
        .snapshots();
  }
}
