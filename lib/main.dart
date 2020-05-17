import 'dart:io';
import 'dart:async';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

main() {
  runApp(MaterialApp(
    title: 'Text Recognition',
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File _image;
  String _text = "";

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });

    analyze(image);
  }

  Future<void> analyze(File imageFile) {
    FirebaseVisionImage image = FirebaseVisionImage.fromFile(imageFile);
    TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    var result = textRecognizer.processImage(image);

    Future.sync(() async  {
      await textRecognizer.close();
      var text = (await result).text;
      debugPrint(text);
      setState(() {
        _text = text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: _image == null
                  ? Text('No image selected.')
                  : Image.file(_image),
            ),
            Center(
              child: Text(
                '$_text',
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
