import 'package:http/http.dart' as http;

import 'photos_model.dart';

class PhotoRepository {
  Future<List<PhotosModel>> getPhotos({int start, int limit}) async {
    final response = await http.get(
        "http://jsonplaceholder.typicode.com/photos?_start=$start&_limit=${limit ?? 10}");
    if (response.statusCode == 200) {
      return photosModelFromJson(response.body);
    } else {
      return null;
    }
  }
}
