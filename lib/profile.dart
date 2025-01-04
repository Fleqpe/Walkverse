import 'package:flutter/material.dart';
import 'package:walkverse/changeAvatarPage.dart';
import 'package:walkverse/container.dart';
import 'package:walkverse/friends.dart';
import 'package:walkverse/renkler.dart';
import 'backend/backendtest.dart';
import 'backend/xpSystem.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = 'Loading...';
  int level = 0;
  int remainingXp = 121;
  int xpToNextLevel = 500;
  int weeklyCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    String? userId = UserSession.getUserId();
    if (userId != null) {
      UserStepsService userStepsService = UserStepsService();

      // Fetch username
      userName = await userStepsService.getUsername(userId);

      // Fetch total steps
      int totalSteps = await userStepsService.getTotalSteps(userId);

      // Calculate level and remaining XP
      Map<String, int> levelInfo = XpSystem.calculateLevel(totalSteps);
      level = levelInfo['level']!;
      remainingXp = levelInfo['remainingXp']!;
      xpToNextLevel = levelInfo['xpForNextLevel']!;
      // Calculate weekly steps
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      weeklyCount = await userStepsService.getTotalStepsScaled(userId, startOfWeek, now);

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                AvatarWidget(
                  avatarItem: avatarItem,
                  width: 100,
                  height: 100,
                ),
                const SizedBox(height: 5), // Yüksekliği biraz azaltıyoruz
                createText("$userName - Lv. $level", 16),
                const SizedBox(height: 5), // Yüksekliği biraz azaltıyoruz
                createProgressBar(remainingXp,xpToNextLevel),
                const SizedBox(height: 5), // Yüksekliği biraz azaltıyoruz
                createText("BU HAFTA ATILAN ADIM SAYISI", 20),
                createText("$weeklyCount", 20),
              ],
            ),
          ),
          const SizedBox(height: 10), // Araya boşluk ekliyoruz
          ProfileOption(
            title: "Avatarını Değiştir",
            onTap: () {
              // Avatar değiştirme işlemi
            },
          ),
          ProfileOption(
            title: "Ayarlar",
            onTap: () {
              // Ayarlar sayfasına yönlendirme
            },
          ),
        ],
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const ProfileOption({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: accentColor,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: createText(title, 18),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

Widget createProgressBar(int remainingXp, int xpToNextLevel) {
  return Stack(
    children: [
      // Outline ve arka plan rengi için Container
      Container(
        width: 200 * (remainingXp / (xpToNextLevel+1)), // İlerleme çubuğunun genişliği
        height: 28, // Yükseklik
        decoration: BoxDecoration(
          color: accentColor, // Progress bar'ın iç rengi
          borderRadius: BorderRadius.circular(6), // Köşe yuvarlama
        ),
      ),
      Container(
        width: 200, // İstediğiniz genişlik
        height: 28, // Yükseklik
        decoration: BoxDecoration(
          color: Colors.transparent, // Arka plan şeffaf
          borderRadius: BorderRadius.circular(6), // Köşe yuvarlama
          border: Border.all(
            color: Colors.black, // Outline rengi
            width: 3, // Outline kalınlığı
          ),
        ),
      ),
      // LinearProgressIndicator için Container
      Positioned.fill(
        child: Center(
          child: createText("$remainingXp/$xpToNextLevel", 16),
        ),
      ),
    ],
  );
}
