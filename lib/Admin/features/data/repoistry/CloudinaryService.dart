import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  final CloudinaryPublic _cloudinary;

  CloudinaryService()
      : _cloudinary = CloudinaryPublic(
    'dpifk8qun',
    'Book_preset',
    cache: false,
  );

  Future<String?> uploadImage(String filePath) async {
    try {
      final response = await _cloudinary.uploadFile(
        CloudinaryFile.fromFile(filePath, resourceType: CloudinaryResourceType.Image),
      );
      return response.secureUrl;
    } catch (e) {
      return null;
    }
  }
}