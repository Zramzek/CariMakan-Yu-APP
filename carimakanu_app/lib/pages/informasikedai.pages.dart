import 'package:carimakanu_app/form/daftar.menu.dart';
import 'package:carimakanu_app/form/review.dart';
import 'package:carimakanu_app/pages/review.pages.dart';
import 'package:flutter/material.dart';
import 'package:carimakanu_app/models/kedai.models.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carimakanu_app/models/menu.models.dart';
import 'package:carimakanu_app/services/menu.services.dart  ';
import 'package:cloud_firestore/cloud_firestore.dart';


class informasiKedai extends StatefulWidget {
  final Kedai kedai;
  final String username;

  const informasiKedai({Key? key, required this.kedai, required this.username})
      : super(key: key);

  @override
  State<informasiKedai> createState() => _informasiKedaiState();
}

class _informasiKedaiState extends State<informasiKedai> {
  late MenuService menuService;
  List<MenuModel> menus = [];
  bool isLoading = true;
  String? kedaiDocId;

  @override
  void initState() {
    super.initState();
    fetchDocumentId().then((_) {
      fetchMenus(kedaiDocId);
    });

  }

  Future<void> fetchMenus(String? docId) async {
    try {
      final menuCollection = FirebaseFirestore.instance
          .collection('Kedai')
          .doc(docId)
          .collection('Menu');

      // Ambil data menu dari subkoleksi
      final querySnapshot = await menuCollection.get();
      List<MenuModel> fetchedMenus = querySnapshot.docs.map((doc) {
        return MenuModel(
          Desk: doc['desk'],
          idMenu: doc['idMenu'],
          Harga: (doc['harga'] as num).toDouble(),        );
      }).toList();

      setState(() {
        menus = fetchedMenus;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching menus: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchDocumentId() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Kedai')
          .where('name', isEqualTo: widget.kedai.name) // Match by name
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          kedaiDocId = snapshot.docs.first.id;
        });
        fetchMenus(kedaiDocId); // Ambil data setelah ID diperoleh
      }
    } catch (e) {
      print('Error fetching document ID: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),

      body: tampilanUtama(context),
      floatingActionButton: addMenu(context,kedaiDocId),
    );
  }

  SingleChildScrollView tampilanUtama(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              widget.kedai.name,
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lexend'
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Image Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Container(
                width: 316,
                height: 164,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    widget.kedai.iconPath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        if (kedaiDocId != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewPage(kedaiId: kedaiDocId!),
                            ),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          for (int i = 0; i < 5; i++)
                            Icon(
                              i < widget.kedai.rating ? Icons.star : Icons.star_border,
                              color: Colors.orange,
                              size: 18,
                            ),
                          SizedBox(width: 4),
                          Text(widget.kedai.rating.toString()),
                          Text(' · ${widget.kedai.jumlahRating} ratings'),
                        ],
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (kedaiDocId != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReviewFormScreen(
                                kedaiId: kedaiDocId!,
                                username: widget.username,
                              )));
                    }
                  },
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
              widget.kedai.kategori,
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
              widget.kedai.informasi,
              style: TextStyle(
                  fontSize: 14, color: Colors.black54, fontWeight: FontWeight.bold, fontFamily: 'Lexend'),
            ),
          ),

          const SizedBox(height: 16),

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
              color: Colors.grey[300],
              child: const Center(
                child: Text('Map Placeholder'),
              ),
            ),
          ),
          // Daftar Menu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: const Text(
              'Daftar Menu',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lexend',
              ),
            ),
          ),
          isLoading
              ? Center(child: CircularProgressIndicator()) // Loading Indicator
              : menus.isEmpty
              ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Tidak ada menu tersedia.',
              style: TextStyle(fontSize: 16, fontFamily: 'Lexend'),
            ),
          )
              : ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: menus.length,
            itemBuilder: (context, index) {
              final menu = menus[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Gambar Menu
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/martabak_sample.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Detail Menu
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            menu.idMenu,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lexend',
                            ),
                          ),
                          Text(
                            'Rp.${menu.Harga.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            menu.Desk,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

        ],
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 70.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
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

FloatingActionButton addMenu(BuildContext context, String? kedaiID) {
  return FloatingActionButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddMenuScreen(kedaiId: kedaiID)),
      );
    },
    backgroundColor: Colors.transparent,
    elevation: 0,
    child:
    SvgPicture.asset('assets/icons/Group 5.svg'),
  );
}