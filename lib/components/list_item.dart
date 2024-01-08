import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lapor_book/components/styles.dart';
import 'package:lapor_book/components/vars.dart';
import 'package:lapor_book/models/akun.dart';
import 'package:lapor_book/models/laporan.dart';

class ListItem extends StatefulWidget {
  final Laporan laporan;
  final Akun akun;
  final bool isLaporanku;
   ListItem(
      {super.key,
      required this.laporan,required this.akun, required this.isLaporanku});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

    void deleteLaporan() async {
      try {
        await _db.collection('laporan').doc(widget.laporan.docId).delete();

 // menghapus gambar dari storage
       if (widget.laporan.gambar != '') {
         await _storage.refFromURL(widget.laporan.gambar!).delete();
       }
       Navigator.popAndPushNamed(context, '/dashboard');
     } catch (e) {
       print(e);
     }
   }

  @override
  Widget build(BuildContext context) {
      return Container(
        decoration: BoxDecoration(
            border: Border.all(width: 2),
            borderRadius: BorderRadius.circular(10),
            ),
        child: InkWell(
          onLongPress: () {
            if(widget.isLaporanku)
            showDialog(
              context: context, 
              builder: (BuildContext BuildContext){
                return AlertDialog(
                  title: Text('Hapus ${widget.laporan.judul}?'),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.pop(BuildContext);
                    },
                    child: Text('Batal'),),
                    TextButton(onPressed: (){
                      deleteLaporan();
                      Navigator.pop(BuildContext);
                    },
                    child: Text('Hapus'),)
                  ],
                );
              });
          },
          onTap: (){
            Navigator.pushNamed(context, '/detail', arguments: {
              'akun' : widget.akun,
              'laporan' : widget.laporan
            });
          },
          child: Column(
            children: [
              widget.laporan.gambar != ''
                  ? Image.network(
                      widget.laporan.gambar!,
                      width: 130,
                      height: 130,
                    )
                  : Image.asset(
                      'assets/istock-default.jpg',
                      width: 130,
                      height: 130,
                    ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    border: Border.symmetric(horizontal: BorderSide(width: 2))),
                child: Text(
                  widget.laporan.judul,
                  style: headerStyle(level: 4),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          color: widget.laporan.status == 'Posted'
                          ? warnaStatus[0] : widget.laporan.status == 'Process' ? warnaStatus[1] : warnaStatus[2],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                          ),
                          border: const Border.symmetric(
                              vertical: BorderSide(width: 1))),
                      alignment: Alignment.center,
                      child: Text(
                        widget.laporan.status,
                        style: headerStyle(level: 5, dark: false),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(5)),
                          border: const Border.symmetric(
                              vertical: BorderSide(width: 1))),
                      alignment: Alignment.center,
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(widget.laporan.tanggal),
                        style: headerStyle(level: 5, dark: false),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    }
}