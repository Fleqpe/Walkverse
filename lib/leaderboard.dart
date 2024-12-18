import 'package:flutter/material.dart';

class Leaderboard extends StatelessWidget {
  Leaderboard({super.key});
  
  // Statik kullanıcı verileri
  final List<Map<String, dynamic>> users = [
    {"rank": 1, "name": "CanKarahan03", "steps": 6782},
    {"rank": 2, "name": "Excalibur", "steps": 10},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // Filtre Bölümü
          Container(
            color: Colors.purple,
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFilterItem("Dünya"),
                    _buildFilterItem("Yerel"),
                    _buildFilterItem("Arkadaşlar", selected: true),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildRadioOption("Hafta", true),
                    _buildRadioOption("Ay", false),
                    _buildRadioOption("Yıl", false),
                  ],
                ),
              ],
            ),
          ),
          // Tablo Başlığı
          Container(
            color: Colors.green[400],
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("SIRA", style: _tableHeaderStyle),
                Text("KULLANICI ADI", style: _tableHeaderStyle),
                Text("ADIM", style: _tableHeaderStyle),
              ],
            ),
          ),
          // Kullanıcı Listesi
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Container(
                  color: index % 2 == 0 ? Colors.green[200] : Colors.green[100],
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "${user['rank']}.",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        user['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "${user['steps']}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Filtre Butonu
  Widget _buildFilterItem(String text, {bool selected = false}) {
    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white60,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            fontSize: 18,
          ),
        ),
        if (selected)
          const SizedBox(height: 2),
        if (selected)
          Container(
            width: 20,
            height: 3,
            color: Colors.white,
          ),
      ],
    );
  }

  // Zaman Filtre Seçenekleri
  Widget _buildRadioOption(String label, bool selected) {
    return Row(
      children: [
        Radio(
          value: selected,
          groupValue: true,
          onChanged: (_) {},
          activeColor: Colors.white,
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}

// Tablo Başlık Stili
const TextStyle _tableHeaderStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 16,
  color: Colors.white,
);