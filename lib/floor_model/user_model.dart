import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String email;
  final int point;
  final int lastTimeUpdate;

  UserModel(this.id, this.email, this.point, this.lastTimeUpdate);

  // factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
  //   Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  //   return UserModel(
  //       id: data['id'],
  //       email: data['email'],
  //       point: data['point'] ?? 0,
  //       lastTimeUpdate: data['lastTimeUpdate'] ?? 0,
  //   );
  // }
  //
  // factory UserModel.generateEmpty() {
  //   return UserModel(
  //       id: '',
  //       email: '',
  //       point: 0,
  //       lastTimeUpdate: 0,
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "email": email,
      "point": point,
      "lastTimeUpdate": lastTimeUpdate,
    };
  }
}