class MenuModel {
  final String idMenu;
  final double Harga;
  final String Desk;
  final String imageUrl;

  MenuModel({
    required this.idMenu,
    required this.Harga,
    required this.Desk,
    this.imageUrl = ''
  });

  // Mapping dari Firestore
  factory MenuModel.fromMap(Map<String, dynamic> data) {
    return MenuModel(
      idMenu: data['idMenu'],
      Harga: data['harga'].toDouble(),
      Desk: data['desk'],
      imageUrl: data['imageUrl']
    );
  }
}