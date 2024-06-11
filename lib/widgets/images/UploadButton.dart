import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stay_indie/constants.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class UploadButton extends StatelessWidget {
  const UploadButton({
    super.key,
    required this.itemId,
    required this.updateNetworkImagesFunc,
    required this.bucket,
  });

  final String bucket;
  final String itemId;
  final void Function(String url) updateNetworkImagesFunc;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('Upload Images'),
      onPressed: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? pickedImage =
            await picker.pickImage(source: ImageSource.gallery);
        if (pickedImage == null) return;

        // Compression Step
        File imageFile = File(pickedImage.path); // Convert XFile to File
        Uint8List compressedImageBytes = await compressFile(imageFile);

        final imagePath =
            '/$currentUserId/$itemId/images/${DateTime.now()}.png';
        await supabase.storage
            .from(bucket)
            .uploadBinary(imagePath, compressedImageBytes)
            .whenComplete(() async {
          final url =
              await supabase.storage.from(bucket).getPublicUrl(imagePath);
          updateNetworkImagesFunc(url);
        });
      },
      style: kSmallPrimaryButtonStyle,
    );
  }

  Future<Uint8List> compressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 85, // Adjust quality as needed
    );
    return result!;
  }
}
