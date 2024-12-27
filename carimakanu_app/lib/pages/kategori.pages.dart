// import 'package:carimakanu_app/models/kategori.models.dart';
// import 'package:flutter/material.dart';

// class KategoriScreen extends StatefulWidget {
//   @override
//   _KategoriScreenState createState() => _KategoriScreenState();
// }

// class _KategoriScreenState extends State<KategoriScreen> {
//   final TextEditingController _nameController = TextEditingController();
//   final Kategori _kategori = Kategori();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Kategori Management')),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _kategori.fetchKategori(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }

//           final kategoriList = snapshot.data!;

//           return ListView.builder(
//             itemCount: kategoriList.length,
//             itemBuilder: (context, index) {
//               final kategori = kategoriList[index];

//               return ListTile(
//                 title: Text(kategori['name']),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.edit),
//                       onPressed: () async {
//                         _nameController.text = kategori['name'];

//                         await showDialog(
//                           context: context,
//                           builder: (context) => AlertDialog(
//                             title: Text('Edit Kategori'),
//                             content: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 TextField(
//                                   controller: _nameController,
//                                   decoration:
//                                       InputDecoration(labelText: 'Name'),
//                                 ),
//                               ],
//                             ),
//                             actions: [
//                               TextButton(
//                                 onPressed: () async {
//                                   await _kategori.updateKategori(
//                                     kategori['id'],
//                                     _nameController.text,
//                                   );
//                                   setState(() {});
//                                   Navigator.pop(context);
//                                 },
//                                 child: Text('Save'),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () async {
//                         await _kategori.deleteKategori(kategori['id']);
//                         setState(() {});
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: Text('Add Kategori'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     controller: _nameController,
//                     decoration: InputDecoration(labelText: 'Name'),
//                   ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () async {
//                     await _kategori.addKategori(_nameController.text);
//                     setState(() {});
//                     Navigator.pop(context);
//                   },
//                   child: Text('Add'),
//                 ),
//               ],
//             ),
//           );
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
