import 'package:flutter/material.dart';
import 'package:carimakanu_app/models/review.models.dart';
import 'package:carimakanu_app/services/review_services.dart';
import 'package:flutter_svg/svg.dart';


class ReviewPage extends StatefulWidget {
  final String kedaiId;

  ReviewPage({required this.kedaiId});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late Future<List<ReviewModel>> _reviews;

  @override
  void initState() {
    super.initState();
    _reviews = ReviewService(widget.kedaiId).fetchReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: FutureBuilder<List<ReviewModel>>(
        future: _reviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading reviews'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Reviews Available'));
          }

          final reviews = snapshot.data!;

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              var review = reviews[index];
              return ReviewCard(review: review);
            },
          );
        },
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final ReviewModel review;

  ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${review.idUser}',
                style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Lexend'),
              ),
              Spacer(),
              Row(
                children: [
                  Text(
                    review.rating.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.star, color: Colors.orange, size: 20),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(review.reviewText),
          SizedBox(height: 8),
          Text(
            'Direview pada ${review.date}',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

AppBar appBar(BuildContext context) {
  return AppBar(
    automaticallyImplyLeading: false,
    backgroundColor: Colors.white,
    elevation: 0, // Remove shadow
    toolbarHeight: 70.0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start, // Align items to the start
      children: [
        // Custom Back Button Icon
        GestureDetector(
          onTap: () {
            Navigator.pop(context); // Go back to the previous screen
          },
          child: Container(
            margin: EdgeInsets.only(right: 10), // Add some margin to separate it from the text
            child: SvgPicture.asset(
              'assets/icons/tombol back.svg',
              width: 55, // Adjust size as needed
              height: 54,
            ),
          ),
        ),
        Text(
          'Detail Information',
          style: TextStyle(
            fontFamily: 'Lexend',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ],
    ),
  );

}

