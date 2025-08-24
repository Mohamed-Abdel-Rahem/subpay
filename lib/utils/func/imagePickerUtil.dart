import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  static Future<Uint8List?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    return picked != null ? await picked.readAsBytes() : null;
  }
}
