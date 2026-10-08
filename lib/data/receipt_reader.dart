import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Reads the text on a receipt photo. Runs on the phone with Google's ML
/// Kit, so it's free, works offline and the photo never leaves the device.
abstract class ReceiptReader {
  /// The text, one printed row per line. Null if it couldn't be read.
  Future<String?> read(String imagePath);
}

class MlKitReceiptReader implements ReceiptReader {
  @override
  Future<String?> read(String imagePath) async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final result = await recognizer.processImage(
        InputImage.fromFilePath(imagePath),
      );
      return rowsFrom(result);
    } on Exception {
      return null;
    } finally {
      await recognizer.close();
    }
  }

  /// ML Kit reads a receipt's left column (items) and right column (prices)
  /// as separate blocks. Joining text lines that sit at the same height puts
  /// each price back next to its item.
  static String rowsFrom(RecognizedText result) {
    final lines = [for (final block in result.blocks) ...block.lines]
      ..sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));
    final rows = <List<TextLine>>[];
    for (final line in lines) {
      final box = line.boundingBox;
      final row = rows.where((r) {
        final first = r.first.boundingBox;
        final overlap =
            (box.bottom < first.bottom ? box.bottom : first.bottom) -
            (box.top > first.top ? box.top : first.top);
        return overlap > box.height / 2;
      }).firstOrNull;
      if (row == null) {
        rows.add([line]);
      } else {
        row.add(line);
      }
    }
    return rows
        .map(
          (row) =>
              (row..sort(
                    (a, b) => a.boundingBox.left.compareTo(b.boundingBox.left),
                  ))
                  .map((l) => l.text)
                  .join(' '),
        )
        .join('\n');
  }
}
