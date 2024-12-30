import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserStepsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _userStepsCollection = FirebaseFirestore.instance.collection('UserSteps');
  final CollectionReference _userFollowsCollection = FirebaseFirestore.instance.collection('UserFollows');

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

  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error logging in: $e');
      return null;
    }
  }

  Future<User?> registerUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error registering user: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    try {
      QuerySnapshot querySnapshot = await _userStepsCollection.get();
      Map<String, int> userSteps = {};

      for (var doc in querySnapshot.docs) {
        String userId = doc['userId'];
        int stepAmount = doc['stepAmount'];

        if (userSteps.containsKey(userId)) {
          userSteps[userId] = userSteps[userId]! + stepAmount;
        } else {
          userSteps[userId] = stepAmount;
        }
      }

      List<Map<String, dynamic>> leaderboard = userSteps.entries
          .map((entry) => {'userId': entry.key, 'totalSteps': entry.value})
          .toList();

      leaderboard.sort((a, b) => b['totalSteps'].compareTo(a['totalSteps']));

      return leaderboard;
    } catch (e) {
      print('Error getting leaderboard: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getFollowedLeaderboard(String userId) async {
    try {
      // Get the list of users followed by the current user
      QuerySnapshot followsSnapshot = await _userFollowsCollection.where('follower', isEqualTo: userId).get();
      List<String> followedUsers = followsSnapshot.docs.map((doc) => doc['followed'] as String).toList();

      // Add the current user to the list
      followedUsers.add(userId);

      // Get the steps for the followed users
      QuerySnapshot stepsSnapshot = await _userStepsCollection.where('userId', whereIn: followedUsers).get();
      Map<String, int> userSteps = {};

      for (var doc in stepsSnapshot.docs) {
        String userId = doc['userId'];
        int stepAmount = doc['stepAmount'];

        if (userSteps.containsKey(userId)) {
          userSteps[userId] = userSteps[userId]! + stepAmount;
        } else {
          userSteps[userId] = stepAmount;
        }
      }

      List<Map<String, dynamic>> leaderboard = userSteps.entries
          .map((entry) => {'userId': entry.key, 'totalSteps': entry.value})
          .toList();

      leaderboard.sort((a, b) => b['totalSteps'].compareTo(a['totalSteps']));

      return leaderboard;
    } catch (e) {
      print('Error getting followed leaderboard: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getLeaderboardByPeriod(String period) async {
    try {
      DateTime now = DateTime.now();
      DateTime startDate;

      if (period == 'weekly') {
        startDate = now.subtract(Duration(days: now.weekday - 1));
      } else if (period == 'monthly') {
        startDate = DateTime(now.year, now.month, 1);
      } else if (period == 'yearly') {
        startDate = DateTime(now.year, 1, 1);
      } else {
        throw ArgumentError('Invalid period: $period');
      }

      QuerySnapshot querySnapshot = await _userStepsCollection
          .where('date', isGreaterThanOrEqualTo: startDate)
          .get();

      Map<String, int> userSteps = {};

      for (var doc in querySnapshot.docs) {
        String userId = doc['userId'];
        int stepAmount = doc['stepAmount'];

        if (userSteps.containsKey(userId)) {
          userSteps[userId] = userSteps[userId]! + stepAmount;
        } else {
          userSteps[userId] = stepAmount;
        }
      }

      List<Map<String, dynamic>> leaderboard = userSteps.entries
          .map((entry) => {'userId': entry.key, 'totalSteps': entry.value})
          .toList();

      leaderboard.sort((a, b) => b['totalSteps'].compareTo(a['totalSteps']));

      return leaderboard;
    } catch (e) {
      print('Error getting leaderboard by period: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getFollowedLeaderboardByPeriod(String userId, String period) async {
    try {
      DateTime now = DateTime.now();
      DateTime startDate;

      if (period == 'weekly') {
        startDate = now.subtract(Duration(days: now.weekday - 1));
      } else if (period == 'monthly') {
        startDate = DateTime(now.year, now.month, 1);
      } else if (period == 'yearly') {
        startDate = DateTime(now.year, 1, 1);
      } else {
        throw ArgumentError('Invalid period: $period');
      }

      // Get the list of users followed by the current user
      QuerySnapshot followsSnapshot = await _userFollowsCollection.where('follower', isEqualTo: userId).get();
      List<String> followedUsers = followsSnapshot.docs.map((doc) => doc['followed'] as String).toList();

      // Add the current user to the list
      followedUsers.add(userId);

      // Get the steps for the followed users within the specified period
      QuerySnapshot stepsSnapshot = await _userStepsCollection
          .where('userId', whereIn: followedUsers)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .get();

      Map<String, int> userSteps = {};

      for (var doc in stepsSnapshot.docs) {
        String userId = doc['userId'];
        int stepAmount = doc['stepAmount'];

        if (userSteps.containsKey(userId)) {
          userSteps[userId] = userSteps[userId]! + stepAmount;
        } else {
          userSteps[userId] = stepAmount;
        }
      }

      List<Map<String, dynamic>> leaderboard = userSteps.entries
          .map((entry) => {'userId': entry.key, 'totalSteps': entry.value})
          .toList();

      leaderboard.sort((a, b) => b['totalSteps'].compareTo(a['totalSteps']));

      return leaderboard;
    } catch (e) {
      print('Error getting followed leaderboard by period: $e');
      return [];
    }
  }
}

class UserSession {
    static String? userId; // Kullanıcı ID'sini saklamak için
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
        UserSession.userId = userCredential.user!.uid;
        print(UserSession.userId);
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