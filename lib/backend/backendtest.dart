import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'xpSystem.dart';

class UserStepsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _userStepsCollection =
      FirebaseFirestore.instance.collection('UserSteps');
  final CollectionReference _userFollowsCollection =
      FirebaseFirestore.instance.collection('UserFollows');
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('Users');

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
      QuerySnapshot querySnapshot =
          await _userStepsCollection.where('userId', isEqualTo: userId).get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error getting user steps: $e');
      return [];
    }
  }

  Future<int> getTotalStepsScaled(
      String userId, DateTime startDate, DateTime endDate) async {
    try {
      QuerySnapshot querySnapshot = await _userStepsCollection
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .get();
      int totalSteps = 0;

      for (var doc in querySnapshot.docs) {
        totalSteps += doc['stepAmount'] as int;
      }

      print(
          'Total steps for user $userId from $startDate to $endDate: $totalSteps');
      return totalSteps;
    } catch (e) {
      print(
          'Error getting total steps for user $userId from $startDate to $endDate: $e');
      return 0;
    }
  }

  Future<void> updateUserStep(
      String documentId, int stepAmount, DateTime date) async {
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
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
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
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
      print('Fetching leaderboard data...');
      QuerySnapshot querySnapshot = await _userStepsCollection.get();
      print('QuerySnapshot received: ${querySnapshot.docs.length} documents');
      Map<String, int> userSteps = {};

      for (var doc in querySnapshot.docs) {
        String userId = doc['userId'];
        int stepAmount = doc['stepAmount'];
        print('Processing document: userId=$userId, stepAmount=$stepAmount');

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

      print('Leaderboard generated: $leaderboard');
      return leaderboard;
    } catch (e) {
      print('Error getting leaderboard: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getFollowedLeaderboard(
      String userId) async {
    try {
      print('Fetching followed leaderboard data for user: $userId');
      // Get the list of users followed by the current user
      QuerySnapshot followsSnapshot = await _userFollowsCollection
          .where('follower', isEqualTo: userId)
          .get();
      print(
          'Followed users snapshot received: ${followsSnapshot.docs.length} documents');
      List<String> followedUsers =
          followsSnapshot.docs.map((doc) => doc['followed'] as String).toList();
      print('Followed users: $followedUsers');

      // Add the current user to the list
      followedUsers.add(userId);
      print('Followed users including current user: $followedUsers');

      // Get the steps for the followed users
      QuerySnapshot stepsSnapshot = await _userStepsCollection
          .where('userId', whereIn: followedUsers)
          .get();
      print('Steps snapshot received: ${stepsSnapshot.docs.length} documents');
      Map<String, int> userSteps = {};

      for (var doc in stepsSnapshot.docs) {
        String userId = doc['userId'];
        int stepAmount = doc['stepAmount'];
        print('Processing document: userId=$userId, stepAmount=$stepAmount');

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

      print('Followed leaderboard generated: $leaderboard');
      return leaderboard;
    } catch (e) {
      print('Error getting followed leaderboard: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getLeaderboardByPeriod(
      String period) async {
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

      print(
          'Fetching leaderboard data for period: $period from $startDate to $now');
      QuerySnapshot querySnapshot = await _userStepsCollection
          .where('date', isGreaterThanOrEqualTo: startDate)
          .get();
      print('QuerySnapshot received: ${querySnapshot.docs.length} documents');

      Map<String, int> userSteps = {};

      for (var doc in querySnapshot.docs) {
        String userId = doc['userId'];
        int stepAmount = doc['stepAmount'];
        print('Processing document: userId=$userId, stepAmount=$stepAmount');

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

      print('Leaderboard generated: $leaderboard');
      return leaderboard;
    } catch (e) {
      print('Error getting leaderboard by period: $e');
      return [];
    }
  }

  Future<List<String>> getFollowedUsers(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _userFollowsCollection
          .where('follower', isEqualTo: userId)
          .get();
      List<String> followedUsers =
          querySnapshot.docs.map((doc) => doc['followed'] as String).toList();
      print('Followed users for user $userId: $followedUsers');
      return followedUsers;
    } catch (e) {
      print('Error getting followed users for user $userId: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getFollowedLeaderboardByPeriod(
      String userId, String period) async {
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

      print(
          'Fetching followed leaderboard data for period: $period from $startDate to $now');
      // Get the list of users followed by the current user
      QuerySnapshot followsSnapshot = await _userFollowsCollection
          .where('follower', isEqualTo: userId)
          .get();
      print(
          'Followed users snapshot received: ${followsSnapshot.docs.length} documents');
      List<String> followedUsers =
          followsSnapshot.docs.map((doc) => doc['followed'] as String).toList();
      print('Followed users: $followedUsers');

      // Add the current user to the list
      followedUsers.add(userId);
      print('Followed users including current user: $followedUsers');

      // Get the steps for the followed users within the specified period
      QuerySnapshot stepsSnapshot = await _userStepsCollection
          .where('userId', whereIn: followedUsers)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .get();
      print('Steps snapshot received: ${stepsSnapshot.docs.length} documents');

      Map<String, int> userSteps = {};

      for (var doc in stepsSnapshot.docs) {
        String userId = doc['userId'];
        int stepAmount = doc['stepAmount'];
        print('Processing document: userId=$userId, stepAmount=$stepAmount');

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

      print('Followed leaderboard generated: $leaderboard');
      return leaderboard;
    } catch (e) {
      print('Error getting followed leaderboard by period: $e');
      return [];
    }
  }

  Future<Map<String, String>> getUsernames(List<String> userIds) async {
    try {
      print('Fetching usernames for userIds: $userIds');
      QuerySnapshot querySnapshot = await _usersCollection
          .where(FieldPath.documentId, whereIn: userIds)
          .get();
      print(
          'Usernames snapshot received: ${querySnapshot.docs.length} documents');

      Map<String, String> usernames = {};
      for (var doc in querySnapshot.docs) {
        String userId = doc.id;
        String username = doc['userName'];
        print('Processing document: userId=$userId, userName=$username');
        usernames[userId] = username;
      }

      print('Usernames fetched: $usernames');
      return usernames;
    } catch (e) {
      print('Error fetching usernames: $e');
      return {};
    }
  }

  // New function to get total steps for a user
  Future<int> getTotalSteps(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await _userStepsCollection.where('userId', isEqualTo: userId).get();
      int totalSteps = 0;

      for (var doc in querySnapshot.docs) {
        totalSteps += doc['stepAmount'] as int;
      }

      print('Total steps for user $userId: $totalSteps');
      return totalSteps;
    } catch (e) {
      print('Error getting total steps for user $userId: $e');
      return 0;
    }
  }

  Future<String> getUsername(String userId) async {
    try {
      Map<String, String> usernames = await getUsernames([userId]);
      return usernames[userId] ?? 'Unknown';
    } catch (e) {
      print('Error getting username for user $userId: $e');
      return 'Unknown';
    }
  }

  Future<void> addFriend(String followerId, String followedUsername) async {
    try {
      // Get the userId of the followed user by username
      if (followerId == followedUsername) return;
      QuerySnapshot querySnapshot = await _usersCollection
          .where('userName', isEqualTo: followedUsername)
          .get();
      if (querySnapshot.docs.isEmpty) {
        print('User with username $followedUsername not found');
        return;
      }
      String followedId = querySnapshot.docs.first.id;

      // Add the follow relationship to UserFollows collection
      await _userFollowsCollection.add({
        'follower': followerId,
        'followed': followedId,
      });

      print('User $followerId successfully followed $followedId');
    } catch (e) {
      print('Error adding friend: $e');
    }
  }

  Future<void> removeFriend(
      String followerUsername, String followedUsername) async {
    try {
      if (followerUsername == followedUsername) return;
      // Get the userId of the follower by username
      QuerySnapshot followerQuerySnapshot = await _usersCollection
          .where('userName', isEqualTo: followerUsername)
          .get();
      if (followerQuerySnapshot.docs.isEmpty) {
        print('User with username $followerUsername not found');
        return;
      }
      String followerId = followerQuerySnapshot.docs.first.id;

      // Get the userId of the followed user by username
      QuerySnapshot followedQuerySnapshot = await _usersCollection
          .where('userName', isEqualTo: followedUsername)
          .get();
      if (followedQuerySnapshot.docs.isEmpty) {
        print('User with username $followedUsername not found');
        return;
      }
      String followedId = followedQuerySnapshot.docs.first.id;

      // Find the follow relationship in UserFollows collection
      QuerySnapshot querySnapshot = await _userFollowsCollection
          .where('follower', isEqualTo: followerId)
          .where('followed', isEqualTo: followedId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print('Follow relationship not found');
        return;
      }

      // Remove the follow relationship
      await _userFollowsCollection.doc(querySnapshot.docs.first.id).delete();

      print('User $followerId successfully unfollowed $followedId');
    } catch (e) {
      print('Error removing friend: $e');
    }
  }
}

class UserSession {
  static String? userId;
  static int? totalSteps;
  static int? level = 1;
  static int? remainingXp = 0;
  static String? userName = 'sample';
  static UserStepsService _userStepsService = new UserStepsService();
  static Future<void> setUser(String id, int totalSteps) async {
    userId = id;
    totalSteps = totalSteps;
    level = XpSystem.calculateLevel(totalSteps)['level'];
    remainingXp = XpSystem.calculateLevel(totalSteps)['remainingXp'];
    userName = await _userStepsService.getUsername(userId!);
  }

  static String? getUserId() {
    return userId;
  }
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('Users');

  Future<User?> registerUser(
      {required String email,
      required String password,
      required String username}) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
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
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
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
