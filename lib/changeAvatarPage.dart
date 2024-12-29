import 'package:flutter/material.dart';
import 'package:walkverse/renkler.dart';

class ChangeAvatarPage extends StatefulWidget {
  const ChangeAvatarPage({Key? key}) : super(key: key);

  @override
  _ChangeAvatarPageState createState() => _ChangeAvatarPageState();
}

class _ChangeAvatarPageState extends State<ChangeAvatarPage> {
  // Kullanıcının seviyesi
  int userLevel = 1;

  // Eşya grupları
  final Map<String, Map<String, int>> categories = {
    'Outfit': {
      '1': 2,
    },
    'Heads': {
      '1': 1,
    },
    'Hairs': {
      '1': 2,
    },
    'Eyeglasses': {
      '1': 4,
    },
  };

  // Seçilen kategori ve eşya
  String selectedCategory = 'Heads';
  String selectedItem = '';

  // Seçilen kategoriye göre öğeleri almak
  Map<String, int> get selectedCategoryItems {
    return categories[selectedCategory]!;
  }

  // Kategori değiştirme fonksiyonu
  void changeCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  // Eşyayı seçme fonksiyonu
  void changeSelectedItem(String item) {
    setState(() {
      selectedItem = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Column(
        children: [
          // Üst kısımda ikonlar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.face),
                  onPressed: () => changeCategory('Heads'),
                ),
                IconButton(
                  icon: const Icon(Icons.shield),
                  onPressed: () => changeCategory('Hairs'),
                ),
                IconButton(
                  icon: const Icon(Icons.boy_rounded),
                  onPressed: () => changeCategory('Outfit'),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_red_eye),
                  onPressed: () => changeCategory('Eyeglasses'),
                ),
              ],
            ),
          ),
          // Kategoriye göre GridView
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 sütunlu grid
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: selectedCategoryItems.length,
              itemBuilder: (context, index) {
                String item = selectedCategoryItems.keys.elementAt(index);
                int requiredLevel = selectedCategoryItems[item]!;

                return GestureDetector(
                  onTap: userLevel >= requiredLevel
                      ? () => changeSelectedItem(item)
                      : null, // Seviye yeterliyse tıklanabilir
                  child: Card(
                    color: selectedItem == item
                        ? Colors.green.withOpacity(0.5)
                        : Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Örneğin her eşya için resim ekleyebilirsiniz
                        Image.asset(
                          'Images/Characters/$selectedCategory/${item}.png',
                          width: 70,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: userLevel >= requiredLevel
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                        if (userLevel >= requiredLevel)
                          const Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Kategoriler
class ItemCategory {
  final String name;
  final List<Item> items;

  ItemCategory(this.name, this.items);
}

// Eşyalar
class Item {
  final String name;
  final int level;
  final int id;

  Item(this.name, this.level) : id = DateTime.now().millisecondsSinceEpoch;
}
