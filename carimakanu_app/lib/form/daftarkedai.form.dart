import 'package:carimakanu_app/services/person.services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:carimakanu_app/services/kedai.services.dart';

class daftarKedaiForm extends StatefulWidget {
  const daftarKedaiForm({super.key});

  @override
  _daftarKedaiFormState createState() => _daftarKedaiFormState();
}

class _daftarKedaiFormState extends State<daftarKedaiForm> {
  final _formKey = GlobalKey<FormState>();
  final _kedaiServices = KedaiServices();
  final _personServices = PersonServices();
  final TextEditingController _namaKedaiController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _informasiController = TextEditingController();
  final firebaseStorage = FirebaseStorage.instance;

  String? _selectedSubkategori;
  List<String> _subkategoriList = [];
  bool _isLoadingSubkategori = true;
  String? idUser = '';
  String? _selectedKategori;
  File? imageFile = null;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSubkategori();
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

  Future<void> _loadSubkategori() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(
              'SubKategori') // Note the capital K to match your structure
          .get();

      if (snapshot.docs.isEmpty) {
        print('No subkategori documents found');
        setState(() {
          _subkategoriList = [];
          _isLoadingSubkategori = false;
        });
        return;
      }

      final List<String> subkategoriItems = [];
      for (var doc in snapshot.docs) {
        String subkategori = doc.id;
        if (subkategori.isNotEmpty) {
          subkategoriItems.add(subkategori);
        }
      }

      print('Loaded subkategori: $subkategoriItems');

      setState(() {
        _subkategoriList = subkategoriItems;
        _isLoadingSubkategori = false;
      });
    } catch (e) {
      print('Error loading subkategori: $e');
      setState(() {
        _subkategoriList = [];
        _isLoadingSubkategori = false;
      });
    }
  }

  Widget _buildKategoriRadio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Kategori',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const Text(
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
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Makanan'),
                value: 'Makanan',
                groupValue: _selectedKategori,
                onChanged: (String? value) {
                  setState(() {
                    _selectedKategori = value;
                  });
                },
                activeColor: Colors.red,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Minuman'),
                value: 'Minuman',
                groupValue: _selectedKategori,
                onChanged: (String? value) {
                  setState(() {
                    _selectedKategori = value;
                  });
                },
                activeColor: Colors.red,
              ),
            ),
          ],
        ),
        if (_selectedKategori == null) ...[
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text(
              'Please select a category',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        ],
        const Divider(),
      ],
    );
  }

  Widget _buildSubkategoriDropdown() {
    if (_isLoadingSubkategori) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_subkategoriList.isEmpty) {
      return const Text('No subkategori available');
    }

    return DropdownButtonFormField<String>(
      value: _selectedSubkategori,
      decoration: const InputDecoration(
        labelText: 'Subkategori',
        border: OutlineInputBorder(),
      ),
      items: _subkategoriList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        print('Selected value: $newValue'); // Debug print
        setState(() {
          _selectedSubkategori = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a subkategori';
        }
        return null;
      },
    );
  }

  Future<String?> fetchIdUser(String email) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Person')
          .doc(email)
          .get();

      print('Email: $email');

      if (userDoc.exists) {
        print('ID user: $userDoc["idUser"]');
        return userDoc['idUser'];
      } else {
        throw Exception('User document does not exist');
      }
    } catch (e) {
      print('Error fetching User ID : $e');
      return null;
    }
  }

  void _deleteImage() {
    setState(() {
      imageFile = File('');
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    // Check all required fields
    if (_selectedKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    if (_selectedSubkategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a subcategory')),
      );
      return;
    }

    if (imageFile == File('')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final imageUrl = await _uploadImage() ?? '';
      String? emailFromJWT = await _personServices.getEmailFromJWT();
      var email = emailFromJWT ?? '';
      String? idUser = await fetchIdUser(email);

      if (idUser == null) {
        throw Exception('User ID not found');
      }
      await _kedaiServices.addKedaitoFirestore(
        idUser,
        _namaKedaiController.text,
        _informasiController.text,
        _selectedKategori!,
        _selectedSubkategori!,
        imageUrl,
        _alamatController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kedai successfully added!')),
      );

      Navigator.pop(context);

      _namaKedaiController.clear();
      _alamatController.clear();
      _informasiController.clear();
      setState(() {
        _selectedKategori = null;
        _selectedSubkategori = null;
        imageFile = File('');
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70.0,
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: SvgPicture.asset(
                    'assets/icons/tombol back.svg',
                    width: 55,
                    height: 54,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Tambah Kedai',
                style: TextStyle(
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _namaKedaiController,
                decoration: const InputDecoration(
                  labelText: 'Nama Kedai *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter kedai name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(
                  labelText: 'Alamat *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _informasiController,
                decoration: const InputDecoration(
                  labelText: 'Informasi *',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter information';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildKategoriRadio(),
              const SizedBox(height: 16),
              _buildSubkategoriDropdown(),
              const SizedBox(height: 16),
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
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Submit',
                        style: TextStyle(
                          color: Colors.white,
                        )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
