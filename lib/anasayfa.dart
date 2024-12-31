import 'package:flutter/material.dart';
import 'package:walkverse/chart.dart';
import 'package:walkverse/container.dart';
import 'package:walkverse/renkler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'backend/backendtest.dart';

class Anasayfa extends StatelessWidget {
  const Anasayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getUsernameFromFirestore(),
      builder: (context, snapshot) {
        // Yüklenme durumunu kontrol et
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Hata durumunu kontrol et
        if (snapshot.hasError) {
          return Center(
            child: Text("Bir hata oluştu: ${snapshot.error}"),
          );
        }

        // Veri boşsa kullanıcı bulunamadı mesajı göster
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text("Kullanıcı bulunamadı"),
          );
        }

        // Başarılı durumda UI'ı oluştur
        final username = snapshot.data!;
        return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 40)),
        Center(
          child: Container(
              width: 400,
              height: 90,
              decoration: createDecoration(accentColor),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      "Images/Character.png",
                      width: 50,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        createText(username, 16),
                        createText("Lv. 9", 16)
                      ],
                    ),
                  )
                ],
              )),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Container(
              width: 400,
              height: 90,
              decoration: createDecoration(accent3Color),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        createText("BUGÜN ATILAN ADIM SAYISI", 20),
                        createText("10/100", 18),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 40),
                    child: createText("%100", 30),
                  )
                ],
              ),
            ),
          ),
        ),
        Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 25, right: 10, left: 10),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 175,
                  height: 90,
                  decoration: createDecoration(accentColor),
                  child: Padding(
                      padding: const EdgeInsets.only(),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            createText("HAFTALIK HEDEF", 18),
                            createText("3655", 30)
                          ],
                        ),
                      )),
                ),
                Container(
                    width: 175,
                    height: 90,
                    decoration: createDecoration(accentColor),
                    child: Padding(
                        padding: const EdgeInsets.only(),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              createText("AYLIK HEDEF", 18),
                              createText("3655", 30)
                            ],
                          ),
                        )))
              ],
            ),
          ),
        )),
        Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Container(
            width: 400,
            height: 175,
            decoration: createDecoration(accentColor),
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.all(10)),
                Text(
                  "RAPOR",
                  style: TextStyle(
                      color: textColor, fontFamily: font2, fontSize: 25),
                ),
                const SizedBox(
                  height: 115,
                  child: ChartWidget(),
                )
              ],
            ),
          ),
        )),
      ],
    );
    
      },
    );
  }


  Future<String?> getUsernameFromFirestore() async {
    try {
      // Firestore'daki "Users" koleksiyonunda userId ile eşleşen dökümanı al
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(UserSession.userId)
          .get();

      if (userDoc.exists) {
      
        return userDoc['userName']; 
      } else {
        print("Kullanıcı bulunamadı.");
        return null;
      }
    } catch (e) {
      print("Hata oluştu: $e");
      return null;
    }
  }
}