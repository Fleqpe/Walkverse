import 'package:flutter/material.dart';
import 'package:walkverse/container.dart';
import 'package:walkverse/renkler.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<Map<String, dynamic>> friends = [
    {
      'name': 'Barış Kurt',
      'level': 6,
      'avatar': AvatarItem(glassesId: 1, headId: 1, hairId: 1, outfitId: 2)
    },
    {
      'name': 'Can Karahan',
      'level': 7,
      'avatar': AvatarItem(glassesId: 2, headId: 1, hairId: 2, outfitId: 1)
    },
    {
      'name': 'Harun Ege Yaşar',
      'level': 5,
      'avatar': AvatarItem(glassesId: 1, headId: 1, hairId: 1, outfitId: 1)
    },
  ];

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
