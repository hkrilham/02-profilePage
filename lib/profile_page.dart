import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

File? _image;

class _ProfilePageState extends State<ProfilePage> {
  Future _pickImage() async {
    try {
      final ImagePicker _pick = ImagePicker();
      final XFile? image = await _pick.pickImage(source: ImageSource.gallery);
      if (image != null) {
        File tempImage = File(image.path);
        await _saveImage(tempImage);
      }
    } catch (e) {
      print("Image pike error $e");
    }
  }

  Future _saveImage(File image) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      String imagePath =
          join(directory.path, '${DateTime.now().millisecondsSinceEpoch}.png');
      final File newImage = await image.copy(imagePath);
      setState(() {
        _image = newImage;
      });

      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        const SnackBar(content: Text('Image saved locally!')),
      );
    } catch (e) {
      print('Error saving image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: _image == null
                    ? const AssetImage('assets/image.png')
                    : FileImage(_image!),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Ilham',
                  hintText: "Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_2),
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  labelText: '26',
                  hintText: "Age",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Trincomalee',
                  hintText: 'Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on_rounded),
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Admin',
                  hintText: 'Roll',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.people),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _pickImage),
    );
  }
}
