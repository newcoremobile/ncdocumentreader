import 'package:flutter/material.dart';
import 'package:nc_document_reader/nc_document_reader.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Builder(builder: (context) {
            return Center(
              child: FlatButton(
                  child: Text("打开文件"),
                  onPressed: () => {
                        NcDocumentReader.openFile(context,
                            docMimeType: 'pdf',
                            docName: '文件名称',
                            docUrl:
                                'https://alicliimg.clewm.net/448/663/5663448/15637846995181d22986efd87ba2ba7ed14399d9c336e1563784695.pdf')
                      }),
            );
          })),
    );
  }
}
