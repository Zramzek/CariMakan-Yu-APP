class ReviewModel {
  final String idUser;
  final double rating;
  final String date;
  final String reviewText;

  ReviewModel({
    required this.idUser,
    required this.rating,
    required this.date,
    required this.reviewText,
  });

  // Mapping dari Firestore
  factory ReviewModel.fromMap(Map<String, dynamic> data) {
    return ReviewModel(
      idUser: data['idUser'],
      rating: data['rating'].toDouble(),
      date: data['date'],
      reviewText: data['reviewText'],
    );
  }
}
