import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserStepsService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference _userStepsCollection = FirebaseFirestore.instance.collection('UserSteps');
  

  Future<void> addUserStep(String userId, int stepAmount, DateTime date) async {
    try {
      await _userStepsCollection.add({
        'userId': userId,
        'stepAmount': stepAmount,
        'date': date,
      });
    } catch (e) {
      print('Error adding user step: $e');
    }
  }

  Future<void> deleteUserStep(String documentId) async {
    try {
      await _userStepsCollection.doc(documentId).delete();
    } catch (e) {
      print('Error deleting user step: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getUserSteps(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _userStepsCollection.where('userId', isEqualTo: userId).get();
      return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error getting user steps: $e');
      return [];
    }
  }

  Future<void> updateUserStep(String documentId, int stepAmount, DateTime date) async {
    try {
      await _userStepsCollection.doc(documentId).update({
        'stepAmount': stepAmount,
        'date': date,
      });
    } catch (e) {
      print('Error updating user step: $e');
    }
  }

}

class UserSession {
    static String? userId; // Kullanıcı ID'sini saklamak için
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('Users');

  Future<User?> registerUser({required String email, required String password, required String username}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      UserSession.userId = userCredential.user!.uid;

      await _usersCollection.doc(UserSession.userId).set({
        'experience': 1,
        'level': 0,
        'userName': username,
      });
      print("Kullanıcı Oluşturuldu: ${userCredential.user?.email}");
      return userCredential.user; 
    } catch (e) {
      print("Hata: $e");
      return null;
    }

  }

  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserSession.userId = userCredential.user!.uid;
      print(UserSession.userId);
     
      return userCredential.user;
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }
  
  
}