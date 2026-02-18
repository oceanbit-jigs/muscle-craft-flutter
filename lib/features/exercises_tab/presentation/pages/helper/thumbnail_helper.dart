import 'dart:io';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class VideoThumbnailHelper {
  static Future<File?> getThumbnail(String videoUrl, int id) async {
    try {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/thumb_$id.jpg';

      final file = File(path);
      if (await file.exists()) return file;

      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videoUrl,
        thumbnailPath: dir.path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 200,
        quality: 75,
      );

      return thumbnailPath != null ? File(thumbnailPath) : null;
    } catch (e) {
      return null;
    }
  }
}
