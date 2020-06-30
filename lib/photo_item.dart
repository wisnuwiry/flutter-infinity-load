import 'package:flutter/material.dart';

import 'photos_model.dart';

class PhotoItem extends StatelessWidget {
  final PhotosModel data;

  const PhotoItem({Key key, @required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Image.network(
            '${data.thumbnailUrl}',
            fit: BoxFit.cover,
            height: 150,
          ),
          SizedBox(height: 8.0),
          Text(data.title),
        ]),
      ),
    );
  }
}
