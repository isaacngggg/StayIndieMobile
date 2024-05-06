import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stay_indie/constants.dart';

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
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);
        if (image == null) return;
        final imageBytes = await image.readAsBytes();

        final imagePath =
            '/$currentUserId/$itemId/images/${DateTime.now()}.png';
        await supabase.storage
            .from(bucket)
            .uploadBinary(imagePath, imageBytes)
            .whenComplete(() async {
          final url =
              await supabase.storage.from(bucket).getPublicUrl(imagePath);
          updateNetworkImagesFunc(url);
        });
      },
      style: kSmallPrimaryButtonStyle,
    );
  }
}
