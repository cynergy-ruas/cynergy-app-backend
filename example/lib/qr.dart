import 'package:flutter/material.dart';
import 'package:cynergy_app_backend/cynergy_app_backend.dart';

class QrExample extends StatefulWidget {
  @override
  _QrExampleState createState() => _QrExampleState();
}

class _QrExampleState extends State<QrExample> {

  String text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Example"),
      ),

      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  RaisedButton(
                    child: Text("Generate QR code"),
                    onPressed: () {
                      setState(() {
                        text = (text == "") ? "Hello world!" : "";
                      });
                    },
                  ),
                  SizedBox(width: 20,),
                  QrScanner(
                    child: RaisedButton(
                      child: Text("Scan QR code"),
                      onPressed: () async {
                        this.text = await QrScanner.scan();
                        setState(() {});
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: 40,),
              QrImage(
                data: text,
                version: QrVersions.auto,
                size: 270,
                gapless: true,
              ),
              SizedBox(height: 40,),
              Text(text)
            ],
          )
        ],
      ),
    );
  }
}