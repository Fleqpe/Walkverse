import 'package:flutter/material.dart';
import 'package:walkverse/changeAvatarPage.dart';
import 'package:walkverse/container.dart';
import 'package:walkverse/renkler.dart';

class ProfilePage extends StatelessWidget {
  final Function(Widget, String) changeCurrentWidget;

  const ProfilePage({super.key, required this.changeCurrentWidget});
  @override
  Widget build(BuildContext context) {
    final avatar = AvatarItem(
      headId: 1,
      hairId: 1,
      glassesId: 1,
      outfitId: 1,
    );
    return Scaffold(
      backgroundColor: mainColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  AvatarWidget(
                    avatarItem: avatar,
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 5), // Yüksekliği biraz azaltıyoruz
                  createText("Barış Kurt - Lv. 6", 16),
                  const SizedBox(height: 5), // Yüksekliği biraz azaltıyoruz
                  createProgressBar(),
                  const SizedBox(height: 5), // Yüksekliği biraz azaltıyoruz
                  createText("BU HAFTA ATILAN ADIM SAYISI", 20),
                  createText("36570", 20),
                ],
              ),
            ),
            const SizedBox(height: 10), // Araya boşluk ekliyoruz
            ProfileOption(
              title: "Avatarını Değiştir",
              onTap: () => {
                changeCurrentWidget(const ChangeAvatarPage(), "AVATAR DEĞİŞTİR")
              },
            ),
            ProfileOption(
              title: "Arkadaşlarım",
              onTap: () => {},
            ),
          ],
        ),
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

Widget createProgressBar() {
  return Stack(
    children: [
      // Outline ve arka plan rengi için Container
      Container(
        width: 200 * (121 / 500), // İlerleme çubuğunun genişliği
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
          child: createText("121/500", 16),
        ),
      ),
    ],
  );
}
