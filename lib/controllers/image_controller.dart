import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:volunteer_app/services/api.dart';
import 'package:volunteer_app/services/network.dart';

class ImageController extends GetxController {
  var _image = Rx<File?>(null);
  File? get image => _image.value;
  final NetworkService networkService = NetworkService();

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      _image.value = File(pickedImage.path);
    }
  }

  Future<void> uploadImagePatch() async {
    if (_image.value == null) return;

    final url = Uri.https(apiUrl, 'user/pfp');
    try {
      final response =
          await networkService.patchImageRequest(url, _image.value!);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Image uploaded successfully');
      } else {
        Get.snackbar('Error', 'Failed to upload image');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error uploading image: $e');
    }
  }

  Future<void> uploadImagePost() async {
    if (_image.value == null) return;

    final url = Uri.https(apiUrl, 'user/pfp');
    try {
      final response =
          await networkService.postImageRequest(url, _image.value!);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Image uploaded successfully');
      } else {
        Get.snackbar('Error', 'Failed to upload image');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error uploading image: $e');
    }
  }
}
