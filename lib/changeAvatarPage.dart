import 'package:flutter/material.dart';
import 'package:walkverse/container.dart';

class AvatarChangePage extends StatelessWidget {
  final AvatarItem avatarItem;

  const AvatarChangePage({Key? key, required this.avatarItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avatarını Değiştir'),
      ),
      body: Column(
        children: [
          AvatarWidget(avatarItem: avatarItem, width: 100, height: 100),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Logic to change avatar properties (e.g., open a dialog or another page)
            },
            child: const Text('Kıyafeti Değiştir'),
          ),
          ElevatedButton(
            onPressed: () {
              // Logic to change avatar properties
            },
            child: const Text('Saçları Değiştir'),
          ),
          ElevatedButton(
            onPressed: () {
              // Logic to change avatar properties
            },
            child: const Text('Gözlükleri Değiştir'),
          ),
        ],
      ),
    );
  }
}
