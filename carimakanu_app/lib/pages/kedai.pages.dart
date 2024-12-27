import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carimakanu_app/form/daftar.kedai.dart';


class KedaiPage extends StatefulWidget {
  const KedaiPage({super.key});

  @override
  State<KedaiPage> createState() => _KedaiPageState();
}

class _KedaiPageState extends State<KedaiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                // Add Kedai action
              },
              child: Container(
                height: 125,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TambahInformasiScreen()),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outline, size: 40, color: Colors.red),
                        SizedBox(height: 4),
                        Text(
                          "Add Kedai",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Lexend',
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 3, // Number of items
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Image.network(
                      'https://via.placeholder.com/100', // Replace with actual image URL
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    title: const Text(
                      "Martabak Legit",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Aneka Makanan, Jajanan, Manis, Asin"),
                        SizedBox(height: 4),
                        Text(
                          "Jl. Sukapura, No.97, Kab. Bandung Barat",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 16),
                            Text("4.9 | 700+ ratings"),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {
                        // More action
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddKedaiForm(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tambah Kedai Baru',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nama Kedai',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Lokasi Kedai',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nomor Telepon',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Logika untuk menyimpan data kedai
                    Navigator.pop(context);
                  },
                  child: Text('Simpan'),
                ),
              ],
            ),
          );
        }
    );
  }

  AppBar appbar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // Disable the default back button
      backgroundColor: Colors.white, // Background color of the AppBar
      elevation: 0, // Remove shadow
      toolbarHeight: 100.0,
      title: Stack(
        alignment: Alignment.center, // Align children to the center
        children: [
          // Back Button
          Align(
            alignment:
                Alignment.centerLeft, // Position the back button on the left
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Container(
                margin:
                    const EdgeInsets.only(left: 10), // Adjust margin if needed
                child: SvgPicture.asset(
                  'assets/icons/tombol back.svg',
                  width: 55, // Adjust size as needed
                  height: 54,
                ),
              ),
            ),
          ),
          // Centered Title
          const Text(
            'Kedai',
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
