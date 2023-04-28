import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

// ignore: must_be_immutable
class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  File? image;

  ImageInput(
    this.image,
    this.onSelectImage, {
    Key? key,
  }) : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  _takePicture() async {
    final ImagePicker picker = ImagePicker();
    XFile imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    ) as XFile;

    setState(() {
      widget.image = File(imageFile.path);
    });

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    String fileName = path.basename(widget.image!.path);
    final savedImage = await widget.image!.copy(
      '${appDir.path}/$fileName',
    );
    widget.onSelectImage(savedImage);
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 150,
    );

    if (pickedImage != null) {
      setState(() {
        widget.image = File(pickedImage.path);
      });

      widget.onSelectImage(widget.image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Tirar Foto'),
                  onPressed: _takePicture,
                ),
                TextButton.icon(
                  icon: const Icon(Icons.photo),
                  label: const Text('Galeria'),
                  onPressed: pickImage,
                ),
              ],
            ),
            Container(
              width: 180,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
              ),
              alignment: Alignment.center,
              child: widget.image != null
                  ? Image.file(
                      widget.image!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : const Text('Nenhuma imagem!'),
            ),
          ],
        ),
      ],
    );
  }
}
