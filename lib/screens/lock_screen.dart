// ignore_for_file: unused_import, depend_on_referenced_packages, prefer_final_fields, library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unused_field, unused_element

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LockScreen extends StatefulWidget {
  final String password;

  LockScreen({required this.password});

  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isUnlocked = false;
  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];
  static const String _imagesKey = 'images_key';

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePathList = prefs.getStringList(_imagesKey) ?? [];
    setState(() {
      _images = imagePathList.map((path) => File(path)).toList();
    });
  }

  void _unlockAlbum() {
    if (_passwordController.text == widget.password) {
      setState(() {
        _isUnlocked = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Incorrect password'),
      ));
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
      await _saveImages();
    }
  }

  Future<void> _saveImages() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePathList = _images.map((file) => file.path).toList();
    await prefs.setStringList(_imagesKey, imagePathList);
  }

  void _removeImage(int index) async {
    setState(() {
      _images.removeAt(index);
    });
    await _saveImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Snapsafe")),
      body: _isUnlocked
          ? Column(
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text("Pick an image"),
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Stack(
                          children: [
                            Image.file(_images[index], fit: BoxFit.cover),
                            const Positioned(
                              right: 5,
                              top: 5,
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Enter password'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _unlockAlbum,
                    child: const Text('Unlock Album'),
                  ),
                ],
              ),
            ),
    );
  }
}