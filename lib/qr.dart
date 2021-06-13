import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:project_cek_undangan/model/Undangan.dart';
import 'package:project_cek_undangan/webservice/apiUndangan.dart';

class QRViewExample extends StatefulWidget {
  @override
  _QRViewExampleState createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String email='';
  Undangan? undangan;
  ApiUndangan? apiUndangan;

  @override
  void initState() { 
    super.initState();
    apiUndangan=ApiUndangan();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid){
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }
  @override
  Widget build(BuildContext context) {
    if (result!=null)
      email=result!.code;
    return Scaffold(
      body: Column(
        children: <Widget>[
          if(result==null)
            Expanded(flex: 4, child: _buildQrView(context),)
          else
            FutureBuilder<Undangan?>(
              future: apiUndangan!.cekUndangan(email),
                builder: (BuildContext context, AsyncSnapshot<Undangan?> snapshot){
                  if (snapshot.hasData){
                    print(snapshot.data!.nama);
                    apiUndangan!.updateKehadiran(snapshot.data!);
                    return _profil(snapshot.data!);
                  }else if (snapshot.hasError){
                    print("Error Snapshot ${snapshot.error}");
                    return Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 100),
                      child: Text("Data tidak ditemukan",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                        ),
                      ),
                    );
                  }else
                    return CircularProgressIndicator();
                }
            ),
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    if(result != null)
                      Text('Barcode Type: ${describeEnum(result!.format)} Data: ${result!.code}')
                    else
                      Text('Scan a code'),
                    Container(
                      child: ElevatedButton(
                        onPressed: (){
                          setState(() {
                           result = null; 
                          });
                        },
                        child: Text("Coba Lagi"),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: () async{
                              await controller?.toggleFlash();
                              setState(() {
                                
                              });
                            },
                            child: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot){
                                return Text('Flash: ${snapshot.data}');
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: () async{
                              await controller?.flipCamera();
                              setState(() {
                                
                              });
                            },
                            child: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot){
                                if(snapshot.data != null){
                                  return Text('Camera facing ${describeEnum(snapshot.data!)}');
                                }else
                                  return Text('Loading');
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: () async{
                              await controller?.pauseCamera();
                            },
                            child: Text('resume', style: TextStyle(fontSize: 20)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context){
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
      MediaQuery.of(context).size.height < 400)
      ? 400.0
      : 400.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onORViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea
      ),
    );
  }

  Widget _profil(Undangan undangan){
    return Container(
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      margin: EdgeInsets.fromLTRB(10, 50, 10, 50),
      color: Colors.purple.withOpacity(0.5),
      child: Column(
        children: [
          Text("${undangan.nama}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.white
            ),
          ),
          SizedBox(height: 20,),
          Container(
            child: Image.network("http://10.63.115.224:8080/api_undangan/${undangan.foto}")
          ),
          SizedBox(height: 20,),
          Text("Terima kasih sudah hadir",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.amber
            ),
          )
        ],
      ),
    );
  }
  void _onORViewCreated(QRViewController controller){
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData){
      setState(() {
       result = scanData; 
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
