//import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:project_cek_undangan/undanganList.dart';
import 'qr.dart';

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aplikasi Kehadiran Undangan"),
        leading: Icon(Icons.people_alt),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => UndanganList()
                    )
                  );
                },
                child: Text("Daftar Undangan",
                  style: TextStyle(fontSize: 48, color: Colors.cyanAccent),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => QRViewExample()
                    )
                  );
                },
                child: Text("Cek QR",
                  style: TextStyle(fontSize: 48, color: Colors.amber),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.people),
                      title: Text("Total Undangan : 10"),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.star,
                        color: Colors.blue,
                      ),
                      title: Text("Hadir : 0"),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.star,
                        color: Colors.black12,
                      ),
                      title: Text("Belum Hadir : 0"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
