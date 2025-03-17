import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late Client client;
  late Storage storage;

  @override
  void initState() {
    super.initState();
    client = Client()
      .setEndpoint('http://cloud.appwrite.io/v1')
      .setProject(''); // Your project ID
    storage = Storage(client);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      
    );
  }
}