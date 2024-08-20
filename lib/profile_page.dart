import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

      // SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', imagePath);

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
  void initState() {
    super.initState();
    _loadSavedImage();
  }

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image');
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profie',
          style: TextStyle(
            fontSize: 29,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 90,
                  backgroundImage: _image == null
                      ? const AssetImage('assets/image.png')
                      : FileImage(_image!),
                ),
              ),
              const SizedBox(height: 50),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Ilham',
                  labelStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  hintText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(200)),
                  ),
                  prefixIcon: Icon(Icons.person_outlined),
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  labelText: '26',
                  labelStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  hintText: "Age",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(200)),
                  ),
                  prefixIcon: Icon(Icons.numbers),
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Trincomalee',
                  labelStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  hintText: 'Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(200)),
                  ),
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Admin',
                  labelStyle: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  hintText: 'Roll',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(200)),
                  ),
                  prefixIcon: Icon(Icons.people_outline_outlined),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
