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


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  

  Future<User?> registerUser({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      print("Kullanıcı Oluşturuldu: ${userCredential.user?.email}");
      return userCredential.user; 
    } catch (e) {
      print("Hata: $e");
      return null;
    }
  }

  Future<String> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return "success"; // Giriş başarılı
      }
    } on FirebaseAuthException catch (e) {
        print("HATA MESAJI: " + e.code);
        // switch (e.code) {
        //   case 'user-not-found':
        //     return "User not found. Please sign up.";
        //   case 'wrong-password':
        //     return "Incorrect password. Try again.";
        //   case 'invalid-email':
        //     return "The email address is not valid.";
        //   case 'user-disabled':
        //     return "This user account has been disabled.";
        //   case 'too-many-requests':
        //     return "Too many login attempts. Please try again later.";
        //   default:
            return "Login failed. ${e.message}";
        //}
      }
    return "Login failed. Please try again.";
  }
}