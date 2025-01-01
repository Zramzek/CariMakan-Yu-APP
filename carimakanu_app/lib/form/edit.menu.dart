import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carimakanu_app/models/menu.models.dart';
import 'package:flutter_svg/flutter_svg.dart';



class EditMenuScreen extends StatefulWidget {
  final String? kedaiDocId;
  final MenuModel menu;

  const EditMenuScreen({
    Key? key,
    required this.kedaiDocId,
    required this.menu,
  }) : super(key: key);


  @override
  State<EditMenuScreen> createState() => _EditMenuScreenState();
}

class _EditMenuScreenState extends State<EditMenuScreen> {

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idMenuController;
  late TextEditingController _deskController;
  late TextEditingController _hargaController;

  @override
  void initState() {
    super.initState();
    _idMenuController = TextEditingController(text: widget.menu.idMenu);
    _deskController = TextEditingController(text: widget.menu.Desk);
    _hargaController =
        TextEditingController(text: widget.menu.Harga.toString());

  }

  @override
  void dispose() {
    _idMenuController.dispose();
    _deskController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  Future<void> updateMenu() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('Kedai')
        .doc(widget.kedaiDocId)
        .collection('Menu')
        .where('idMenu', isEqualTo: widget.menu.idMenu)
        .get();

    if (query.docs.isNotEmpty) {
      String docId = query.docs.first.id; // Dapatkan Document ID
      await FirebaseFirestore.instance
          .collection('Kedai')
          .doc(widget.kedaiDocId)
          .collection('Menu')
          .doc(docId) // Gunakan Document ID
          .update({
        'idMenu': _idMenuController.text,
        'desk': _deskController.text,
        'harga': double.parse(_hargaController.text),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menu berhasil diperbarui!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menu tidak ditemukan!')),
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
              'Edit Menu',
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Nama Menu',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _idMenuController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Menu tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Edit Deskripsi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _deskController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Harga',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
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
                  onPressed: updateMenu,
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
      ),
    );
  }
}
