class MenuModel {
  final String idMenu;
  final double Harga;
  final String Desk;

  MenuModel({
    required this.idMenu,
    required this.Harga,
    required this.Desk,
  });

  // Mapping dari Firestore
  factory MenuModel.fromMap(Map<String, dynamic> data) {
    return MenuModel(
      idMenu: data['idMenu'],
      Harga: data['harga'].toDouble(),
      Desk: data['desk'],
    );
  }
}
