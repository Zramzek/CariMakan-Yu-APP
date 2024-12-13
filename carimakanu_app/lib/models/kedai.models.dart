import 'package:flutter/material.dart';

class KedaiModel {
  String name;
  String iconPath;
  Color boxColor;
  String alamat;
  double rating;
  String Kategori;
  int jumlah;
  String informasi;

  KedaiModel({
    required this.name,
    required this.iconPath,
    required this.boxColor,
    required this.alamat,
    required this.Kategori,
    required this.rating,
    required this.jumlah,
    required this.informasi,
  });

  static List<KedaiModel> getKategori() {
    List<KedaiModel> kategori = [];

    kategori.add(KedaiModel(
        name: "Martabak Legit",
        iconPath: 'assets/icons/image 7.png',
        boxColor: Color(0xFFFFFFFF),
        alamat: 'Jl. Sukapura, No.97, Kab.Bandung Barat',
        Kategori: 'Aneka Makanan, Jajanan, Manis, Asin',
        rating: 4.7,
        jumlah: 300,
        informasi: 'Lorem '
            'ipsum dolor sit amet, '
            'consectetur adipiscing elit. Curabitur ipsum '
            'quam, bibendum eget auctor eu, aliquam quis '
            'diam. Nunc felis magna, cursus sit amet '
            'justo id, malesuada egestas erat. Nunc a '
            'velit sit amet neque efficitur commodo. '
            ' potenti. Donec sed velit dolor. '
            'Donec imperdiet lacinia mi euismod euismod. '
            'Praesent suscipit viverra sollicitudin. '));
    kategori.add(KedaiModel(
        name: "Nasi Goreng Special",
        iconPath: 'assets/icons/image 5.png',
        Kategori: 'Aneka Makanan, Nasi Goreng',
        boxColor: Color(0xFFFFFFFF),
        alamat: 'Jl. Sukabirus, No.9, Kab.Bandung Barat',
        rating: 4.8,
        jumlah: 500,
        informasi: 'Lorem '
            'ipsum dolor sit amet, '
            'consectetur adipiscing elit. Curabitur ipsum '
            'quam, bibendum eget auctor eu, aliquam quis '
            'diam. Nunc felis magna, cursus sit amet '
            'justo id, malesuada egestas erat. Nunc a '
            'velit sit amet neque efficitur commodo. '
            ' potenti. Donec sed velit dolor. '
            'Donec imperdiet lacinia mi euismod euismod. '
            'Praesent suscipit viverra sollicitudin. '));
    kategori.add(KedaiModel(
        name: "Mie Aceh Komplit",
        iconPath: 'assets/icons/image 6.png',
        Kategori: 'Aneka Makanan, Mie Kuah, Khas',
        boxColor: Color(0xFFFFFFFF),
        alamat: 'Jl. Sukabirus, No.37, Kab.Bandung Barat',
        rating: 4.9,
        jumlah: 1200,
        informasi: 'Lorem '
            'ipsum dolor sit amet, '
            'consectetur adipiscing elit. Curabitur ipsum '
            'quam, bibendum eget auctor eu, aliquam quis '
            'diam. Nunc felis magna, cursus sit amet '
            'justo id, malesuada egestas erat. Nunc a '
            'velit sit amet neque efficitur commodo. '
            ' potenti. Donec sed velit dolor. '
            'Donec imperdiet lacinia mi euismod euismod. '
            'Praesent suscipit viverra sollicitudin. '));
    kategori.add(KedaiModel(
        name: "Coffee",
        iconPath: 'assets/icons/Coffee Bean.svg',
        boxColor: Color(0xFFFFFFFF),
        alamat: 'Jl. Sukabirus, No.37, Kab.Bandung Barat',
        rating: 4.9,
        jumlah: 1200,
        Kategori: 'Aneka Makanan, Mie Kuah, Khas',
        informasi: 'Lorem '
            'ipsum dolor sit amet, '
            'consectetur adipiscing elit. Curabitur ipsum '
            'quam, bibendum eget auctor eu, aliquam quis '
            'diam. Nunc felis magna, cursus sit amet '
            'justo id, malesuada egestas erat. Nunc a '
            'velit sit amet neque efficitur commodo. '
            ' potenti. Donec sed velit dolor. '
            'Donec imperdiet lacinia mi euismod euismod. '
            'Praesent suscipit viverra sollicitudin. '));

    return kategori;
  }
}
