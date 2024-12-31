import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carimakanu_app/models/review.models.dart';

class ReviewService {
  final String kedaiId;

  ReviewService(this.kedaiId);

  Future<List<ReviewModel>> fetchReviews() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Kedai')
          .doc(kedaiId)
          .collection('Review')
          .get();

      return snapshot.docs
          .map((doc) => ReviewModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching reviews: $e');
      throw e;
    }
  }

  Future<void> addReview(ReviewModel review) async {
    try {
      CollectionReference reviewCollection = FirebaseFirestore.instance
          .collection('kedai')
          .doc(kedaiId)
          .collection('review');

      // Tambahkan dokumen baru ke Firestore
      await reviewCollection.add({
        'idUser': review.idUser,
        'rating': review.rating,
        'date': review.date,
        'reviewText': review.reviewText,
      });
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }
}
