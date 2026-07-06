import 'dart:io';
import 'dart:typed_data';
import 'package:docs_gee/docs_gee.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

enum ExportFormat { docx, pdf }

class DocumentExportHelper {
  /// Common logic — bytes + filename banata hai, dono save methods reuse karte hain
  static ({Uint8List bytes, String fileName}) _generate({
    required String title,
    required String bodyPlainText,
    required ExportFormat format,
  }) {
    final doc = Document(title: title, author: 'Docly');
    doc.addParagraph(Paragraph.heading(title, level: 1));

    final lines = bodyPlainText.split('\n');
    for (final line in lines) {
      if (line.trim().isEmpty) continue;
      doc.addParagraph(Paragraph.text(line));
    }

    final bytes = format == ExportFormat.docx
        ? DocxGenerator().generate(doc)
        : PdfGenerator().generate(doc);

    final extension = format == ExportFormat.docx ? 'docx' : 'pdf';
    final safeTitle = title.trim().isEmpty ? 'Untitled' : title.trim();

    return (bytes: bytes, fileName: '$safeTitle.$extension');
  }

  /// OPTION 1 — "This Device": native Save-As dialog, user apni location choose karta hai
  static Future<bool> saveToDevice({
    required String title,
    required String bodyPlainText,
    required ExportFormat format,
  }) async {
    final result = _generate(
      title: title,
      bodyPlainText: bodyPlainText,
      format: format,
    );

    // v11 mein API static hai: FilePicker.saveFile (FilePicker.platform.saveFile NAHI)
    final outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Save document',
      fileName: result.fileName,
      bytes: result.bytes,
    );

    return outputFile != null; // null matlab user ne cancel kiya
  }

  /// OPTION 2 — "Share / Google Drive": native share sheet
  static Future<void> shareViaSheet({
    required String title,
    required String bodyPlainText,
    required ExportFormat format,
  }) async {
    final result = _generate(
      title: title,
      bodyPlainText: bodyPlainText,
      format: format,
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${result.fileName}');
    await file.writeAsBytes(result.bytes);

    await Share.shareXFiles([XFile(file.path)]);
  }
}
