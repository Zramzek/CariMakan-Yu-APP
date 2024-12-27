import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReviewFormScreen extends StatefulWidget {
  final dynamic kedai; // Replace `dynamic` with the actual type of kedai, if known

  ReviewFormScreen({Key? key, required this.kedai}) : super(key: key);

  @override
  _ReviewFormScreenState createState() => _ReviewFormScreenState();
}

class _ReviewFormScreenState extends State<ReviewFormScreen> {
  int selectedRating = 0;
  final TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the default back button
        backgroundColor: Colors.white, // Background color of the AppBar
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
              'Review',
              style: TextStyle(
                fontFamily: 'Lexend',
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Beri Rating
            Text(
              'Beri Rating',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lexend',
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < selectedRating
                        ? Icons.star
                        : Icons.star_border, // Bintang penuh atau kosong
                    color: Colors.orange,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedRating = index + 1; // Update rating
                    });
                  },
                );
              }),
            ),
            SizedBox(height: 16),

            // Bagian Komentar
            Text(
              'Komentar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lexend',
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('Rasa:'),
                  Divider(color: Colors.red),
                  _buildTextField('Kebersihan:'),
                  Divider(color: Colors.red),
                  _buildTextField('Lokasi:'),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Large Text Box for Review
            Text(
              'Isi Review',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lexend',
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: reviewController,
                maxLines: 6, // Makes it a large text box
                decoration: InputDecoration(
                  hintText: 'Tulis review Anda di sini...',
                  border: InputBorder.none,
                ),
              ),
            ),

            Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // Handle aksi simpan
                  print("Rating: $selectedRating");
                  print("Isi Review: ${reviewController.text}");
                },
                child: Text(
                  'Simpan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lexend',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
      ),
      maxLines: 1,
    );
  }
}
