import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../utils/utilities/app_utils.dart';
import '../resources/app_strings.dart';

class TakePictureWidget extends StatefulWidget {
  final Function(File? file) onPictureTaken;

  const TakePictureWidget(this.onPictureTaken);

  @override
  _TakePictureWidgetState createState() => _TakePictureWidgetState();
}

class _TakePictureWidgetState extends State<TakePictureWidget> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _buildImagePreview(),
          alignment: Alignment.center,
        ),
        SizedBox(width: 16),
        FlatButton.icon(
          icon: const Icon(Icons.camera_alt_rounded),
          textColor: Theme.of(context).primaryColor,
          label: Text(AppStrings.take_picture.toUpperCase()),
          onPressed: () => _takePicture(),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    if (_imageFile != null) {
      return Image.file(
        _imageFile!,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
    return const Text(
      AppStrings.no_image,
      textAlign: TextAlign.center,
    );
  }

  Future<void> _takePicture() async {
    // Hide keyboard
    AppUtils.removeCurrentFocus(context);

    final picker = ImagePicker();
    final pickedImageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 500,
      maxHeight: 500,
    );
    if (pickedImageFile != null) {
      setState(() {
        _imageFile = File(pickedImageFile.path);
      });
      final imagePath = await AppUtils.getFilePath(_imageFile);
      if (imagePath != null) {
        final savedImage = await _imageFile?.copy(imagePath);
        widget.onPictureTaken(savedImage);
      }
    }
  }
}
