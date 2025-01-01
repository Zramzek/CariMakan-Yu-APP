import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewFormScreen extends StatefulWidget {
  final String kedaiId;
  final String username;

  ReviewFormScreen({Key? key, required this.kedaiId,required this.username}) : super(key: key);

  @override
  _ReviewFormScreenState createState() => _ReviewFormScreenState();
}

class _ReviewFormScreenState extends State<ReviewFormScreen> {
  int selectedRating = 0;
  final TextEditingController reviewController = TextEditingController();
  final TextEditingController rasaController = TextEditingController();
  final TextEditingController kebersihanController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();

  Future<void> _saveReview() async {
    if (selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silakan beri rating.')),
      );
      return;
    }

    if (reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review tidak boleh kosong.')),
      );
      return;
    }

    try {
      CollectionReference reviewCollection = FirebaseFirestore.instance
          .collection('Kedai')
          .doc(widget.kedaiId)
          .collection('Review');

      await reviewCollection.add({
        'idUser': widget.username, // Gantilah dengan ID user yang sesungguhnya
        'rating': selectedRating,
        'date': DateTime.now().toLocal().toString().split(' ')[0],
        'reviewText': reviewController.text,
        'rasa': rasaController.text,
        'kebersihan': kebersihanController.text,
        'lokasi': lokasiController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review berhasil disimpan!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan review: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70.0,
        title: Stack(
          children: [
            Center(
              child: Text(
                'Review',
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.black, // Tambahkan warna teks sesuai kebutuhan
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  child: SvgPicture.asset(
                    'assets/icons/tombol back.svg',
                    width: 50,
                    height: 50,
                  ),
                ),
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
            Text(
              'Beri Rating',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lexend',
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Container(
                width: 500, // Lebar container tetap
                height: 80, // Tambahkan tinggi tetap untuk memastikan proporsi
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.5 ),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center( // Pastikan isi container di tengah
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Pusatkan bintang di tengah Row
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < selectedRating ? Icons.star : Icons.star_border,
                          color: Colors.orange,
                          size: 35,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedRating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                ),
              ),

            ),
            SizedBox(height: 16),
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
              height: 500,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('Rasa:', rasaController),

                  _buildTextField('Kebersihan:', kebersihanController),

                  _buildTextField('Lokasi:', lokasiController),
                  Divider(color: Colors.black, thickness: 1),
                  _buildTextField('', reviewController)
                ],
              ),
            ),
            SizedBox(height: 16),
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
                onPressed: _saveReview,
                child: Text(
                  'Simpan',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
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

  Widget _buildTextField(String hintText, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: InputBorder.none,
      ),
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'Lexend',
      ),
    );
  }

}
