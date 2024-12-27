import 'package:carimakanu_app/form/review.dart';
import 'package:flutter/material.dart';
import 'package:carimakanu_app/models/kedai.models.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carimakanu_app/pages/profile.pages.dart';



class informasiKedai extends StatelessWidget {
  final Kedai kedai;

  const informasiKedai({Key? key, required this.kedai}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                kedai.name, // Display the name above the image
                style: TextStyle(
                    fontSize: 32, // Adjusted font size
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lexend'
                ),
              ),
            ),
            const SizedBox(height: 8), // Add some spacing between title and image

            // Image Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: Container(
                  width: 316,
                  height: 164,
                  decoration: BoxDecoration(
                    color: Colors.white, // White background for the container
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Subtle shadow
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Shadow position
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15), // Match border radius
                    child: Image.asset(
                      kedai.iconPath, // Use the image path from kedai
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            // Title and Rating Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16), // Add some spacing
                      Row(
                        children: [
                          // Display stars dynamically based on the rating
                          for (int i = 0; i < 5; i++)
                            Icon(
                              i < kedai.rating ? Icons.star : Icons.star_border,
                              color: Colors.orange,
                              size: 18,
                            ),
                          SizedBox(width: 4),
                          Text(kedai.rating.toString()),
                          Text(' · ${kedai.jumlahRating} ratings'),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                          MaterialPageRoute(
                          builder: (context) => ReviewFormScreen(
                        kedai: kedai, // Replace with the actual kedai object
                      )),
                      );                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Review'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                kedai.kategori, // Use the Kategori description from kedai
                style: TextStyle(
                    fontSize: 12, color: Colors.black54, fontFamily: 'Lexend', fontWeight: FontWeight.bold),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                'Informasi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lexend',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                kedai.informasi, // Use the Kategori description from kedai
                style: TextStyle(
                    fontSize: 14, color: Colors.black54, fontWeight: FontWeight.bold, fontFamily: 'Lexend'),
              ),
            ),

            const SizedBox(height: 16),

            // Map Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                'Lokasi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lexend',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300], // Placeholder for map
                child: const Center(
                  child: Text('Map Placeholder'),
                ),
              ),
            ),

            // Menu Section (Optional)
            // If you have a menu in the KategoriModel, include the menu section here.
          ],
        ),
      ),

    );
  }





  AppBar appBar(BuildContext context) {
    return AppBar(
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
}