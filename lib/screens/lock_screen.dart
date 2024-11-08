// ignore_for_file: unused_import

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../services/auth_service.dart';
import 'home_screen.dart';

class LockScreen extends StatefulWidget {
  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];

  // Function to pick an image from gallery or take a new picture
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Save the image to local storage
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  // Function to store images locally
  Future<void> _saveImagesLocally() async {
    final directory = await getApplicationDocumentsDirectory();
    for (var image in _images) {
      final fileName = basename(image.path);
      final newImagePath = '${directory.path}/$fileName';
      await image.copy(newImagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Snapsafe")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickImage,
            child: Text("Pick an image"),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Image.file(_images[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}