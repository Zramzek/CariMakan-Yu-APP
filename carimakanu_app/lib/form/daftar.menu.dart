import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_storage/firebase_storage.dart';


class AddMenuScreen extends StatefulWidget {
  final String? kedaiId;


  const AddMenuScreen({Key? key, required this.kedaiId}) : super(key: key);

  @override
  State<AddMenuScreen> createState() => _AddMenuScreenState();
}

class _AddMenuScreenState extends State<AddMenuScreen> {
  File? imageFile = null;
  File? _image;
  final firebaseStorage = FirebaseStorage.instance;

  final picker = ImagePicker();
  final TextEditingController _idMenuController = TextEditingController(); // Tambah Controller untuk idMenu
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // Fungsi pilih gambar dari galeri
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  // Fungsi ambil gambar dari kamera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  // Fungsi simpan data ke Firestore
  Future<void> saveMenu() async {
    String idMenu = _idMenuController.text.trim(); // Ambil nilai idMenu
    String description = _descriptionController.text.trim();
    String priceText = _priceController.text.trim();

    if (idMenu.isEmpty || description.isEmpty || priceText.isEmpty || imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom dan gambar harus diisi!')),
      );
      return;
    }

    double? price = double.tryParse(priceText);
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harga harus berupa angka!')),
      );
      return;
    }

    // Upload gambar ke Firebase Storage
    String? imageUrl = await _uploadImage(); // Fungsi upload gambar

    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengupload gambar!')),
      );
      return;
    }

    // Simpan data menu di Firestore
    await FirebaseFirestore.instance
        .collection('Kedai')
        .doc(widget.kedaiId)
        .collection('Menu')
        .add({
      'idMenu': idMenu,
      'desk': description,
      'harga': price,
      'imageUrl': imageUrl, // Simpan URL gambar di Firestore
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Menu berhasil disimpan!')),
    );

    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text(
                        'Image',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        ' *',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Select Image',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: _deleteImage,
                      ),
                    ],
                  ),
                  if (imageFile != null) ...[
                    const SizedBox(height: 8),
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.file(
                          imageFile!,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ],
                  if (imageFile == null) ...[
                    const Padding(
                      padding: EdgeInsets.only(left: 12, top: 8),
                      child: Text(
                        'Please select an image',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),

              const SizedBox(height: 16),
              const Text('Nama Menu',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _idMenuController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Edit Deskripsi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Harga',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: saveMenu,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  child: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
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
            'Tambahkan Menu',
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
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      String extension = image.path.split('.').last.toLowerCase();

      final allowedFormats = ['jpg', 'jpeg', 'png'];

      if (allowedFormats.contains(extension)) {
        setState(() {
          imageFile = File(image.path);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a JPG, JPEG or PNG file'),
          ),
        );
      }
    }
  }

  Future<String?> _uploadImage() async {
    try {
      String filePath =
          'kedai_images/${DateTime.now().millisecondsSinceEpoch}.png';

      await firebaseStorage.ref(filePath).putFile(imageFile!);

      String donwloadURL = await firebaseStorage.ref(filePath).getDownloadURL();
      return donwloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
  void _deleteImage() {
    setState(() {
      imageFile = File('');
    });
  }

}
