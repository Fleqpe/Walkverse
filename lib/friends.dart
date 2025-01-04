import 'package:flutter/material.dart';
import 'package:walkverse/container.dart';
import 'package:walkverse/renkler.dart';
import 'backend/backendtest.dart';
import 'backend/xpSystem.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<Map<String, dynamic>> friends = [];

  @override
  void initState() {
    super.initState();
    _fetchFriendsData();
  }

  Future<void> _fetchFriendsData() async {
    String? userId = UserSession.getUserId();
    if (userId != null) {
      UserStepsService userStepsService = UserStepsService();
      XpSystem xpSystem = XpSystem();

      // Get followed users
      List<String> followedUserIds = await userStepsService.getFollowedUsers(userId);

      // Fetch friends data
      for (String followedUserId in followedUserIds) {
        // Get username
        String userName = await userStepsService.getUsername(followedUserId);

        // Get total steps
        int totalSteps = await userStepsService.getTotalSteps(followedUserId);

        // Calculate level
        Map<String, int> levelInfo = XpSystem.calculateLevel(totalSteps);
        int level = levelInfo['level']!;

        // Create friend data
        Map<String, dynamic> friendData = {
          'name': userName,
          'level': level,
          'avatar': AvatarItem(
            glassesId: (1 + (followedUserIds.indexOf(followedUserId) % 2)),
            headId: (1 + (followedUserIds.indexOf(followedUserId) % 2)),
            hairId: (1 + (followedUserIds.indexOf(followedUserId) % 2)),
            outfitId: (1 + (followedUserIds.indexOf(followedUserId) % 2)),
          ),
        };

        friends.add(friendData);
      }

      setState(() {});
    }
  }

  void removeFriend(int index) {
    setState(() {
      friends.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: mainColor,
        body: ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            return FriendCard(
              name: friend['name'],
              level: friend['level'],
              avatar: friend['avatar'], // Avatar kısmını değiştirebilirsin
              onDelete: () => removeFriend(index),
            );
          },
        ),
      ),
    );
  }
}

class FriendCard extends StatelessWidget {
  final String name;
  final int level;
  final AvatarItem avatar;
  final VoidCallback onDelete;

  const FriendCard({
    super.key,
    required this.name,
    required this.level,
    required this.avatar,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: accentColor,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Stack(
        children: [
          ListTile(
            leading: AvatarWidget(
              avatarItem: avatar,
              width: 60,
              height: 60,
            ),
            title: createText(name, 18),
            subtitle: createText("Lv. $level", 17),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onDelete,
              child: const Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
