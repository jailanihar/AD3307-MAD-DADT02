import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List;
import 'dart:io';
import 'package:file_picker/file_picker.dart';

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
      .setEndpoint('https://cloud.appwrite.io/v1')
      .setProject('67d76af60020ab7cd9b7'); // Your project ID
    storage = Storage(client);
  }

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if(result != null) {
      setState(() {
        _imageBytes = result.files.first.bytes;
        _imagePath = result.files.first.path;
      });
    }
  }

  Future<void> uploadImage() async {
    if(kIsWeb) {
      if(_imageBytes == null) return;
    } else {
      if(_imagePath == null) return;
    }
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      String fileName = '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.png';
      final result;
      if(kIsWeb) {
        result = await storage.createFile(
          bucketId: '67d76b7600283842c636', // Appwrite bucket id
          fileId: ID.unique(),
          file: InputFile.fromBytes(bytes: _imageBytes!, filename: fileName),
        );
      } else {
        result = await storage.createFile(
          bucketId: '67d76b7600283842c636', // Appwrite bucket id
          fileId: ID.unique(),
          file: InputFile.fromPath(path: _imagePath!, filename: fileName),
        );
      }

      if(result != null) {
        setState(() {
          _imageBytes = null;
          _imagePath = null;
        });
      }
    }
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
          ElevatedButton(onPressed: pickImage, child: Text('Pick Image')),
          ElevatedButton(onPressed: uploadImage, child: Text('Upload Image')),
        ],
      ),
    );
  }
}