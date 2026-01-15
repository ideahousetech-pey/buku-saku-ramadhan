import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class ExportPdfService {
  static Future<void> exportChecklist(
      List<Map<String, dynamic>> data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Rekap Ramadhan',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Table.fromTextArray(
                headers: [
                  'Nama',
                  'Kelas',
                  'Tanggal',
                  'Puasa',
                  'Sholat',
                  'Tarawih'
                ],
                data: data.map((e) {
                  return [
                    e['nama'],
                    e['kelas'],
                    e['tanggal'],
                    e['puasa'] ? 'Ya' : 'Tidak',
                    e['sholat'] ? 'Ya' : 'Tidak',
                    e['tarawih'] ? 'Ya' : 'Tidak',
                  ];
                }).toList(),
              ),
            ],
          );
        },
      ),
    );

    final dir = await getExternalStorageDirectory();
    final file =
        File('${dir!.path}/rekap_ramadhan.pdf');

    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }
}
