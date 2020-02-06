import 'dart:async';
import 'dart:convert';
import 'dart:io';

import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import "package:convert/convert.dart";
import 'package:crypto/crypto.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class NcDocumentReader {
  static const MethodChannel _channel =
      const MethodChannel('nc_document_reader');

  static Future openFile(BuildContext context,
      {docUrl, docMimeType, docName}) async {
    File savePath = File(await _createSavePath(docUrl, docMimeType));
    if (await savePath.exists()) {
      if (Platform.isIOS) {
        _push(context,
            docUrl: 'file://${savePath.path}',
            docMimeType: docMimeType,
            docName: docName,
            isHttp: false);
      } else {
        _openDocNative(docName, savePath.path);
      }
    } else {
      _push(context,
          docUrl: docUrl,
          docMimeType: docMimeType,
          docName: docName,
          isHttp: true);
    }
  }

  static Future _push(BuildContext context,
      {docUrl, docMimeType, docName, isHttp}) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DocumentDisplayPage(
            docUrl: docUrl,
            docMimeType: docMimeType,
            docName: docName,
            isHttp: isHttp)));
  }

  static Future _openDocNative(String fileName, String filePath) async {
    var arguments = {"filePath": filePath, "fileName": fileName};
    return await _channel.invokeMethod("openFile", arguments);
  }

  static Future<String> _createSavePath(String docUrl, String mimeType) async {
    //本地文件
    if(!docUrl.contains('http')) {
      File docFile = new File(docUrl);
      if(await docFile.exists()) {
        return Future.value(docUrl);
      }
    }
    Directory rootPath = (await getTemporaryDirectory());
    Directory saveDir = new Directory(rootPath.path + "/document/");
    if (!await saveDir.exists()) await saveDir.create(recursive: true);
    String fileName = _generateMd5(docUrl) + '.' + mimeType;
    return Future.value(saveDir.path + fileName);
  }

  static String _generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }
}

class DocumentDisplayPage extends StatefulWidget {
  final String docUrl;
  final String docMimeType;
  final String docName;
  final bool isHttp;

  const DocumentDisplayPage(
      {Key key,
      this.docUrl,
      this.docMimeType,
      this.docName,
      this.isHttp = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DocumentDisplayState();
  }
}

class _DocumentDisplayState extends State<DocumentDisplayPage> {
  bool _downloaded = false;
  String _savePath = "";

  @override
  void initState() {
    _savePath = widget.docUrl;
    print("savePath=$_savePath");
    _downloaded = !widget.isHttp;
    super.initState();
  }

  void _onDownload(bool download, String savePath) {
    if (Platform.isIOS) {
      this._savePath = 'file://$savePath';
      setState(() {
        _downloaded = download;
      });
    } else {
      this._savePath = savePath;
      NcDocumentReader._openDocNative(widget.docName, savePath).then((value) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.docName)),
      body: !_downloaded
          ? _DowningPage(
              docMime: widget.docMimeType,
              docUrl: widget.docUrl,
              onDownload: _onDownload,
            )
          : WebviewScaffold(
              url: _savePath,
              allowFileURLs: true,
            ),
    );
  }
}

class _DowningPage extends StatefulWidget {
  final String docUrl;
  final String docMime;
  final void Function(bool download, String savePath) onDownload;

  const _DowningPage({Key key, this.docUrl, this.docMime, this.onDownload})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DowningState();
  }
}

class _DowningState extends State<_DowningPage> {
  bool _downloading = false;
  double progress = 0.0;
  String progressPercent = "";

  @override
  void initState() {
    super.initState();
    print("download....");
    _download();
  }

  Future _download() async {
    var dio = new Dio();
    try {
      String savePath =
          await NcDocumentReader._createSavePath(widget.docUrl, widget.docMime);
      //下载为临时文件
      File tempFile = File(savePath + ".tmp");
      setState(() {
        _downloading = true;
      });
      await dio.download(widget.docUrl, tempFile.path, onReceiveProgress: (count, total) {
        if (total != -1) {
          setState(() {
            progress = count / total;
            progressPercent =
                "正在下载中" + (count / total * 100).toStringAsFixed(0) + '%';
          });
          if (count == total) {
            //下载完成，变成正式文件
            tempFile.rename(savePath).then((file) {
              setState(() {
                progressPercent = "下载完成";
              });
              widget.onDownload(true, savePath);
            });
          }
        }
      });
      return Future.value();
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _downloading
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 4,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white,
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                SizedBox.fromSize(size: Size.fromHeight(2)),
                Text(progressPercent)
              ],
            )
          : SizedBox.shrink(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
