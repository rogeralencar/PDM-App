import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localization/localization.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

// ignore: must_be_immutable
class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  final bool isProfile;
  File? image;

  ImageInput(
    this.onSelectImage,
    this.image, {
    this.isProfile = false,
    Key? key,
  }) : super(key: key);

  @override
  ImageInputState createState() => ImageInputState();
}

class ImageInputState extends State<ImageInput> {
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
                  label: Text('take_photo'.i18n()),
                  onPressed: _takePicture,
                ),
                TextButton.icon(
                  icon: const Icon(Icons.photo),
                  label: Text('gallery'.i18n()),
                  onPressed: pickImage,
                ),
              ],
            ),
            Container(
              width: widget.isProfile ? 100 : 180,
              height: widget.isProfile ? 100 : 150,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Theme.of(context).colorScheme.outline,
                ),
                shape: widget.isProfile ? BoxShape.circle : BoxShape.rectangle,
                borderRadius:
                    !widget.isProfile ? BorderRadius.circular(10) : null,
              ),
              child: widget.isProfile
                  ? ClipOval(
                      child: widget.image != null
                          ? Image.file(
                              widget.image!,
                              fit: BoxFit.cover,
                            )
                          : Center(
                              child: Text(
                              'no_image'.i18n(),
                              textAlign: TextAlign.center,
                            )),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: widget.image != null
                          ? Image.file(
                              widget.image!,
                              fit: BoxFit.cover,
                            )
                          : Center(child: Text('no_image'.i18n())),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
