import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double genislik = 0;
  double yukseklik = 0;
  bool tarama = false;
  String cikti = '';
  File? imageFile;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    genislik = ekranBilgisi.size.width;
    yukseklik = ekranBilgisi.size.height;
    return Scaffold(
        appBar: AppBar(
          title: const Text("SANALOGİ"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              imageFile == null
                  ? Container(
                      width: genislik,
                      height: yukseklik / 2,
                      color: Colors.grey,
                      child: const Icon(Icons.add_photo_alternate_outlined),
                    )
                  : Container(
                      width: genislik,
                      height: yukseklik / 2,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(imageFile!),
                              fit: BoxFit.fitHeight)),
                    ),
              Wrap(
                spacing: 50,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    child: const Text(
                      'Fotograf Ekle',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    onPressed: () async {
                      await chooseImage();
                    },
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    child: const Text(
                      'Text Göster',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    onPressed: () async {
                      setState(() {
                        tarama = true;
                      });
                      await findText();
                      setState(() {
                        tarama = false;
                      });
                    },
                  ),
                ],
              ),
              tarama
                  ? Column(
                      children: const [
                        SizedBox(
                          height: 10,
                        ),
                        Text("Yazılar Bulunuyor"),
                      ],
                    )
                  : Text(
                      cikti,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
            ],
          ),
        ));
  }

  Future chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(pickedFile!.path);
    });
  }

  Future findText() async {
    cikti = await FlutterTesseractOcr.extractText(
      imageFile!.path,
      language: 'tur',
    );
    if (kDebugMode) {
      print("çıktı:$cikti");
    }
  }
}
