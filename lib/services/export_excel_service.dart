import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class ExportExcelService {
  static Future<void> exportChecklist(
      List<Map<String, dynamic>> data) async {
    final excel = Excel.createExcel();
    final Sheet sheet = excel['Rekap Ramadhan'];

    // ===== HEADER =====
    sheet.appendRow([
      TextCellValue('Nama'),
      TextCellValue('Kelas'),
      TextCellValue('Tanggal'),
      TextCellValue('Puasa'),
      TextCellValue('Sholat'),
      TextCellValue('Tarawih'),
    ]);

    // ===== DATA =====
    for (var item in data) {
      sheet.appendRow([
        TextCellValue(item['nama'] ?? ''),
        TextCellValue(item['kelas'] ?? ''),
        TextCellValue(item['tanggal'] ?? ''),
        TextCellValue(item['puasa'] == true ? 'Ya' : 'Tidak'),
        TextCellValue(item['sholat'] == true ? 'Ya' : 'Tidak'),
        TextCellValue(item['tarawih'] == true ? 'Ya' : 'Tidak'),
      ]);
    }

    final dir = await getExternalStorageDirectory();
    final file = File('${dir!.path}/rekap_ramadhan.xlsx');

    final bytes = excel.encode();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    }
  }
}
