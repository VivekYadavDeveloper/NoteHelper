import 'package:flutter/material.dart';
import '../Helper/document_export_helper.dart';
import 'flutter_toast.dart';

void showSaveAsSheet({
  required BuildContext context,
  required String title,
  required String bodyPlainText,
  required ExportFormat format,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Save As',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            ListTile(
              leading: const Icon(Icons.smartphone),
              title: const Text('This Device'),
              subtitle: const Text('Choose a folder to save the file'),
              onTap: () async {
                Navigator.pop(sheetContext);
                final saved = await DocumentExportHelper.saveToDevice(
                  title: title,
                  bodyPlainText: bodyPlainText,
                  format: format,
                );
                if (saved) {
                  FlutterToast().toastMessage('Saved to device successfully');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud_upload_outlined),
              title: const Text('Google Drive / Share'),
              subtitle:
                  const Text('Opens share sheet — pick Drive, WhatsApp, etc.'),
              onTap: () async {
                Navigator.pop(sheetContext);
                await DocumentExportHelper.shareViaSheet(
                  title: title,
                  bodyPlainText: bodyPlainText,
                  format: format,
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
