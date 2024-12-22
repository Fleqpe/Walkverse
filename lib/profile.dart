import 'package:flutter/material.dart';
import 'package:walkverse/anasayfa.dart';
import 'package:walkverse/container.dart';
import 'package:walkverse/renkler.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      bottomNavigationBar: bottomNavigationBar(),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Geri butonunun ikonu
          onPressed: () {
            // Geri butonuna tıklanınca yapılacak işlemi buraya yazın
            Navigator.pop(context); // Sayfayı geri almak için kullanılır
          },
        ),
        backgroundColor: accentColor,
        title: createText("Hesabım", 26),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50, // Profil resmini biraz daha küçültüyoruz
                    backgroundImage:
                        AssetImage('Images/Character.png'), // Profil resminiz
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
            const SizedBox(height: 20), // Araya boşluk ekliyoruz
            const ProfileOption(title: "Avatarını Değiştir"),
            const ProfileOption(title: "Arkadaşlarım"),
          ],
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final String title;

  const ProfileOption({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: accentColor,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: createText(title, 18),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // İlgili işlem burada yapılacak
        },
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
