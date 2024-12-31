import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carimakanu_app/models/menu.models.dart';

class MenuService {
  final String kedaiId;

  MenuService(this.kedaiId);

  Future<List<MenuModel>> fetchMenus() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Kedai')
          .doc(kedaiId)
          .collection('Menu')
          .get();

      return snapshot.docs
          .map((doc) => MenuModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching Menus: $e');
      throw e;
    }
  }

  Future<void> addMenu(MenuModel Menu) async {
    try {
      CollectionReference MenuCollection = FirebaseFirestore.instance
          .collection('kedai')
          .doc(kedaiId)
          .collection('Menu');

      await MenuCollection.add({
        'idMenu': Menu.idMenu,
        'harga': Menu.Harga,
        'desk': Menu.Desk,
      });
    } catch (e) {
      throw Exception('Failed to add Menu: $e');
    }
  }
}
