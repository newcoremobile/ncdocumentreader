# ncdocumentreader

> flutter文档阅读器

## 简介

该Flutter插件在android和ios上使用了两种实现方式：

* android

  使用内置腾讯X5浏览器，腾讯浏览服务提供了打开各种文档的能力：word、ppt、excel、pdf、txt等等，**注意android上只支持armeabi-v7a**

* ios

  使用原生webview，ios的webview默认提供了打开文档功能：word、ppt、excel、pdf、txt等等

## 使用

```dart
NcDocumentReader.openFile(context,
                            docMimeType: 'pdf',
                            docName: '文件名称',
                            docUrl:
'https://alicliimg.clewm.net/448/663/5663448/15637846995181d22986efd87ba2ba7ed14399d9c336e1563784695.pdf')
```



# License

```
Licensed under the MIT License

Copyright (c) 2019 YoungChan

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

```

