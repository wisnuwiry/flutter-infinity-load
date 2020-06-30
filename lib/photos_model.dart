import 'dart:convert';

List<PhotosModel> photosModelFromJson(String str) => List<PhotosModel>.from(
    json.decode(str).map((x) => PhotosModel.fromJson(x)));

String photosModelToJson(List<PhotosModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PhotosModel {
  PhotosModel({
    this.albumId,
    this.id,
    this.title,
    this.url,
    this.thumbnailUrl,
  });

  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  factory PhotosModel.fromJson(Map<String, dynamic> json) => PhotosModel(
        albumId: json["albumId"],
        id: json["id"],
        title: json["title"],
        url: json["url"],
        thumbnailUrl: json["thumbnailUrl"],
      );

  Map<String, dynamic> toJson() => {
        "albumId": albumId,
        "id": id,
        "title": title,
        "url": url,
        "thumbnailUrl": thumbnailUrl,
      };
}
