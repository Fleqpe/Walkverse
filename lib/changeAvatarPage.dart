import 'package:flutter/material.dart';
import 'package:walkverse/container.dart';
import 'package:walkverse/renkler.dart';

class ChangeAvatarPage extends StatefulWidget {
  const ChangeAvatarPage({Key? key}) : super(key: key);

  @override
  _ChangeAvatarPageState createState() => _ChangeAvatarPageState();
}

class _ChangeAvatarPageState extends State<ChangeAvatarPage> {
  int userLevel = 5;
  final Map<String, Map<Item, int>> categories = {
    'Outfit': {
      Item("Cool Outfit", 1): 2,
    },
    'Heads': {
      Item("Test Head", 1): 1,
    },
    'Hairs': {
      Item("Hair 1", 1): 2,
      Item("Test Head 1", 2): 1,
    },
    'Eyeglasses': {
      Item("Eyeglasses", 1): 4,
    },
  };

  // Seçilen kategori ve eşya
  String selectedCategory = 'Heads';
  String selectedItem = '1';

  // Seçilen kategoriye göre öğeleri almak
  Map<Item, int> get selectedCategoryItems {
    return categories[selectedCategory]!;
  }

  // Kategori değiştirme fonksiyonu
  void changeCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  // Eşyayı seçme fonksiyonu
  void changeSelectedItem(Item item) {
    setState(() {
      if (selectedCategory == "Eyeglasses") {
        avatarItem.glassesId = item.id;
        selectedItem = avatarItem.glassesId.toString();
      } else if (selectedCategory == "Hairs") {
        avatarItem.hairId = item.id;
        selectedItem = avatarItem.hairId.toString();
      } else if (selectedCategory == "Heads") {
        avatarItem.headId = item.id;
        selectedItem = avatarItem.headId.toString();
      } else if (selectedCategory == "Outfit") {
        avatarItem.outfitId = item.id;
        selectedItem = avatarItem.outfitId.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Column(
        children: [
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
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: selectedCategoryItems.length,
              itemBuilder: (context, index) {
                Item item = selectedCategoryItems.keys.elementAt(index);
                int requiredLevel = selectedCategoryItems[item]!;

                return GestureDetector(
                  onTap: userLevel >= requiredLevel
                      ? () => changeSelectedItem(item)
                      : null, // Seviye yeterliyse tıklanabilir
                  child: Card(
                    color: isEquipped(selectedCategory, item)
                        ? Colors.green.withOpacity(0.5)
                        : Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'Images/Characters/$selectedCategory/${item.id}.png',
                          width: 75,
                        ),
                        createText(item.name, 16),
                        if (userLevel >= requiredLevel)
                          const Icon(
                            Icons.lock_open,
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

bool isEquipped(String selectedCategory, Item item) {
  if (selectedCategory == "Eyeglasses") {
    return avatarItem.glassesId == item.id;
  } else if (selectedCategory == "Hairs") {
    return avatarItem.hairId == item.id;
  } else if (selectedCategory == "Heads") {
    return avatarItem.headId == item.id;
  } else {
    return avatarItem.outfitId == item.id;
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
  final int id;

  Item(this.name, this.id);
}
