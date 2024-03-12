import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:homework_five/floor_model/user_model.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    DocumentReference documentReference = _firestore.collection('leaderboard').doc(user.id);
    Map<String, dynamic> object = {
      "id": user.id,
      "email": user.email,
      "point": user.point,
      "lastTimeUpdate": user.lastTimeUpdate,
    };
    await documentReference.set(object);
  }

  // Future<List<UserModel>> getUsers() async {
  //   QuerySnapshot querySnapshot = await _firestore.collection("leaderboard").get();
  //   List<UserModel> userList = [];
  //   for (var document in querySnapshot.docs) {
  //     userList.add(UserModel.fromSnapshot(document));
  //   }
  //   return userList;
  // }

  Stream<List<UserModel>> getAll() {
    final querySnapshot = _firestore.collection("leaderboard").snapshots();
    return querySnapshot.map(
            (snapshot) => _snapshotsToUserModel((snapshot.docs))
    );
  }

  List<UserModel> _snapshotsToUserModel(List<QueryDocumentSnapshot<Map<String, dynamic>>> snapshots) {
    return snapshots.map(_snapshotToUserModel).toList();
  }

  UserModel _snapshotToUserModel(QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    return UserModel(snapshot['id'], snapshot['email'], snapshot['point'], snapshot['lastTimeUpdate']);
  }

  // this function can do the point update as well
  Future<void> updateUserProfile() async {
    String id = getCurrentUid();
    // these are the fields that will get updated in firebase
    DateTime curTime = DateTime.now();
    int newPoint = 0;

    DocumentReference documentReference = _firestore.collection('leaderboard').doc(id);

    DocumentSnapshot snapshot = await documentReference.get();
    if (snapshot.exists) {
      // Access the data in the document
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      // Print or use the data as needed
      print('Document data: $data');

      int lastTimeUpdate = data['lastTimeUpdate']; // this is in mili since epoc
      int prevPoint = data['point'];

      // do calculation on point
      if (lastTimeUpdate == 0) {
        // give 1 point if this is the first time this user add a record to DB
        newPoint = 1;
      } else {
        // do proper calculation
        newPoint = prevPoint + computePointEarn(curTime, DateTime.fromMillisecondsSinceEpoch(lastTimeUpdate));
      }
    }
    
    // update point and lasttimeupdate
    await documentReference.update({
      'point': newPoint,
      'lastTimeUpdate': curTime.millisecondsSinceEpoch,
    });
  }

  Future<void> deleteData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print('trying to delete');
      try {
        // Get a reference to the document
        DocumentReference documentReference = FirebaseFirestore.instance.collection('leaderboard').doc(user.uid);
        // Delete the document
        await documentReference.delete();
        // delete the user
        await user.delete();
      } catch (e) {
        print('error during deletion process: $e');
      }
    }
  }

  String getCurrentUid() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      return user.uid;
    }
    return '';
  }

  String? getCurrentUserEmail() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      return user.email;
    }
    return '';
  }

  int computePointEarn(DateTime curTime, DateTime lastTimeUpdate) {
    int diff = curTime.difference(lastTimeUpdate).inSeconds;
    //int diff = curTime - lastTimeUpdate;
    int point = 0;
    if (diff < 10) {
      point = 1;
    } else if (10 <= diff && diff <= 20) {
      point = 5;
    } else {
      point = 10;
    }
    return point;
  }
}
