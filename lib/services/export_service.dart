import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class ExportService {
  // ===================== EXPORT PDF =====================
  static Future<File> exportPdf(
      List<QueryDocumentSnapshot> docs) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Rekap Ibadah Siswa',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),
              pw.Table.fromTextArray(
                headers: const ['Nama', 'Kelas', 'Puasa'],
                data: docs.map((doc) {
                  final data =
                      doc.data() as Map<String, dynamic>;

                  return [
                    data['nama'] ?? '-',
                    data['kelas'] ?? '-',
                    data['puasa'] == true ? 'Ya' : 'Tidak',
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/rekap_ibadah.pdf');
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  // ===================== EXPORT EXCEL =====================
  static Future<File> exportExcel(
      List<QueryDocumentSnapshot> docs) async {
    final excel = Excel.createExcel();
    final sheet = excel['Rekap'];

    // ===== HEADER (WAJIB CellValue) =====
    sheet.appendRow([
      TextCellValue('Nama'),
      TextCellValue('Kelas'),
      TextCellValue('Puasa'),
    ]);

    // ===== DATA =====
    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;

      sheet.appendRow([
        TextCellValue(data['nama']?.toString() ?? '-'),
        TextCellValue(data['kelas']?.toString() ?? '-'),
        TextCellValue(
          data['puasa'] == true ? 'Ya' : 'Tidak',
        ),
      ]);
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/rekap_ibadah.xlsx');

    file.writeAsBytesSync(excel.encode()!);
    return file;
  }
}
