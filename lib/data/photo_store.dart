import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'database.dart';

/// Picks item photos and keeps copies in the app's own storage, so they
/// survive the user cleaning up their camera roll.
class PhotoStore {
  PhotoStore({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// Opens the camera or photo library and returns the saved copy's path,
  /// or null if the user cancelled. Photos are resized and compressed to
  /// keep storage (and later cloud sync) small.
  /// [maxSize] is the longest side in pixels; receipts use more so small
  /// print stays readable.
  Future<String?> pick({
    required bool fromCamera,
    double maxSize = 1600,
    int quality = 80,
  }) async {
    final picked = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: maxSize,
      maxHeight: maxSize,
      imageQuality: quality,
    );
    if (picked == null) return null;
    final dir = Directory(
      p.join((await getApplicationDocumentsDirectory()).path, 'photos'),
    );
    await dir.create(recursive: true);
    final target = p.join(dir.path, '${newSyncId()}.jpg');
    await File(picked.path).copy(target);
    return target;
  }

  Future<void> delete(Iterable<String> paths) async {
    for (final path in paths) {
      final file = File(path);
      if (await file.exists()) await file.delete();
    }
  }
}
