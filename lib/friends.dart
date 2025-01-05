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

      // Get followed users
      List<String> followedUserIds =
          await userStepsService.getFollowedUsers(userId);

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

  final TextEditingController _controller = TextEditingController();

  void removeFriend(String name,int index) {
    UserStepsService userStepsService = UserStepsService();
    userStepsService.removeFriend(name, UserSession.getUserId()!);

    setState(() {
      friends.removeAt(index);
    });
  }

  void addFriend(String name) {
    if (name.isNotEmpty) {
     UserStepsService userStepsService = UserStepsService();
      userStepsService.addFriend(UserSession.getUserId()!, name);
      setState(() {});
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return FriendCard(
                  name: friend['name']!,
                  level: friend['level']!,
                  avatar: friend['avatar']!,
                  onDelete: () => removeFriend(friend['name'],index),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(
                        color: textColor, fontFamily: font2, fontSize: 12),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelStyle: TextStyle(
                          color: textColor, fontSize: 12, fontFamily: font2),
                      labelText: "Arkadaş İsmi",
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: accent3Color),
                  onPressed: () => addFriend(_controller.text),
                  child: createText("Arkadaş Ekle", 12),
                ),
              ],
            ),
          ),
        ],
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
