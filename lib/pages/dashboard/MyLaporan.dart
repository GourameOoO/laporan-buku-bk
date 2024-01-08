import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lapor_book/components/list_item.dart';
import 'package:lapor_book/models/akun.dart';
import 'package:lapor_book/models/laporan.dart';

class MyLaporan extends StatefulWidget {
  final Akun akun;
  const MyLaporan({super.key, required this.akun});

  @override
  State<MyLaporan> createState() => _MyLaporanState();
}

class _MyLaporanState extends State<MyLaporan> {
  final _firestoree = FirebaseFirestore.instance;
List<Laporan> listLaporan = [];

void getTransaksi() async {
  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestoree
        .collection('laporan')
        .where('uid', isEqualTo: widget.akun.uid) // kondisi untuk menccari laporan yang sesuai dengan akun yang telah login
        .get();

    setState(() {
      listLaporan.clear();
      for (var documents in querySnapshot.docs) {
        listLaporan.add(
          Laporan(
            uid: documents.data()['uid'],
            docId: documents.data()['docId'],
            judul: documents.data()['judul'],
            instansi: documents.data()['instansi'],
            deskripsi: documents.data()['deskripsi'],
            nama: documents.data()['nama'],
            status: documents.data()['status'],
            gambar: documents.data()['gambar'],
            tanggal: documents['tanggal'].toDate(),
            maps: documents.data()['maps'],
          ),
        );
      }
    });
  } catch (e) {
    print(e);
  }
}

  @override
  Widget build(BuildContext context) {
    getTransaksi();
    return SafeArea(
    child: Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1 / 1.234,
          ),
          itemCount: listLaporan.length,
          itemBuilder: (context, index) {//sampai sini
            return ListItem(
              laporan: listLaporan[index],
              akun: widget.akun,
              isLaporanku: true,
            );
          }),
    ),
  );
}
}