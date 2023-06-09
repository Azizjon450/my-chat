import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function getUserImage;
  const UserImagePicker(this.getUserImage, {super.key});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void _pickImage() async {
    try {
      XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 150,
      );
      if (image == null) {
        return;
      }
      final _pickedImagePath = File(image.path);
      setState(() {
        _pickedImage = _pickedImagePath;
      });
      widget.getUserImage(_pickedImage);
    } catch (error) {
      print("error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Theme.of(context).primaryColor,
          backgroundImage:
              _pickedImage == null ? null : FileImage(_pickedImage!),
        ),
        TextButton(
          onPressed: _pickImage,
          child: const Text('Set image'),
        ),
      ],
    );
  }
}
