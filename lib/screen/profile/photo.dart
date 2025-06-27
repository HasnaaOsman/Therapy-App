import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:therapy/constants/textstyle.dart'; // مهم

class ProfileImagePicker extends StatefulWidget {
  @override
  _ProfileImagePickerState createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? _imageFile;
  final String _defaultAvatarPath = 'images/avatar.jpg';

  String get _key {
    final email = FirebaseAuth.instance.currentUser?.email ?? 'default_user';
    return 'profile_image_path_$email';
  }

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(_key);
    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _imageFile = File(imagePath);
      });
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final directory = await getApplicationDocumentsDirectory();
      final path =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      final newImage = await File(picked.path).copy(path);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, newImage.path);

      setState(() {
        _imageFile = newImage;
      });
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Are you sure you want to delete the profile image?",
                    textAlign: TextAlign.center,
                    style: AppWidget.GoogleStyle()),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey, width: 0.5),
                            right: BorderSide(color: Colors.grey, width: 0.5),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            _deleteProfilePicture();
                            Navigator.of(context).pop();
                            Flushbar(
                              message: "Profile picture deleted successfully",
                              backgroundColor: Colors.green.shade700,
                              duration: const Duration(seconds: 2),
                              margin: const EdgeInsets.all(8),
                              icon: const Icon(Icons.check_circle_rounded,
                                  color: Colors.white),
                              borderRadius: BorderRadius.circular(8),
                              flushbarPosition: FlushbarPosition.BOTTOM,
                            ).show(context);
                          },
                          child: const Text(
                            "Yes",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey, width: 0.5),
                          ),
                        ),
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "No",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteProfilePicture() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    setState(() {
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        onLongPress: _imageFile != null ? _showDeleteConfirmationDialog : null,
        child: CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: _imageFile != null
              ? FileImage(_imageFile!)
              : AssetImage(_defaultAvatarPath) as ImageProvider,
          child: _imageFile == null
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: MediaQuery.of(context).size.width * 0.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[300],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
