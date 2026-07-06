import 'dart:io';
import 'dart:typed_data';
import 'package:docs_gee/docs_gee.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

enum ExportFormat { docx, pdf }

class DocumentExportHelper {
  /*title = note ka title (plain text)*/
  /* bodyPlainText = Quill se extract kiya hua plain text (naya line = \n)*/
  static Future<void> exportAndShare({
    required String title,
    required String bodyPlainText,
    required ExportFormat format,
  }) async {
    // 1. docs_gee ka Document object banao
    final doc = Document(title: title, author: 'Docly');

    // 2. Title ko heading ki tarah add karo
    doc.addParagraph(Paragraph.heading(title, level: 1));

    // 3. Body ko line-by-line normal paragraph ki tarah add karo
    final lines = bodyPlainText.split('\n');
    for (final line in lines) {
      if (line.trim().isEmpty) continue; // khali lines skip
      doc.addParagraph(Paragraph.text(line));
    }

    // 4. Format ke hisaab se bytes generate karo
    late Uint8List bytes;
    late String extension;
    if (format == ExportFormat.docx) {
      bytes = DocxGenerator().generate(doc);
      extension = 'docx';
    } else {
      bytes = PdfGenerator().generate(doc);
      extension = 'pdf';
    }

    // 5. Temp file mein save karo aur share karo (mobile ke liye)
    final dir = await getTemporaryDirectory();
    final safeTitle = title.trim().isEmpty ? 'Untitled' : title.trim();
    final file = File('${dir.path}/$safeTitle.$extension');
    await file.writeAsBytes(bytes);

    await Share.shareXFiles([XFile(file.path)]);
  }
}
