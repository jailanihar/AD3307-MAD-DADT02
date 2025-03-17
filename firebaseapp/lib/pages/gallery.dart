import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'dart:io';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late Client client;
  late Storage storage;
  Uint8List? _imageBytes;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    client = Client()
      .setEndpoint('http://cloud.appwrite.io/v1')
      .setProject('67d76af60020ab7cd9b7'); // Your project ID
    storage = Storage(client);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: Column(
        children: [
          kIsWeb ?
            (_imageBytes != null ? 
              Image.memory(_imageBytes!, fit: BoxFit.cover, width: 200, height: 200)
              : Text('No image selected'))
            :
            (_imagePath != null ? 
              Image.file(File(_imagePath!), fit: BoxFit.cover, width: 200, height: 200)
              : Text('No image selected')),
        ],
      ),
    );
  }
}