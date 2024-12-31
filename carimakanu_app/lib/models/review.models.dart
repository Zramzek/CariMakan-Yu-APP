class ReviewModel {
  final String idUser;
  final double rating;
  final String date;
  final String rasa;
  final String kebersihan;
  final String lokasi;
  final String reviewText;

  ReviewModel({
    required this.idUser,
    required this.rating,
    required this.date,
    required this.reviewText,
    required this.kebersihan,
    required this.lokasi,
    required this.rasa
  });

  // Mapping dari Firestore
  factory ReviewModel.fromMap(Map<String, dynamic> data) {
    return ReviewModel(
      idUser: data['idUser'],
      rating: data['rating'].toDouble(),
      date: data['date'],
      reviewText: data['reviewText'],
      kebersihan: data['kebersihan'] ,
      lokasi: data['lokasi'],
      rasa: data['rasa']
    );
  }
}
