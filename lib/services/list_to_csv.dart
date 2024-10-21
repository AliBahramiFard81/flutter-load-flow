import 'package:csv/csv.dart';
import 'dart:io';

class ListToCsv {
  final List<List<dynamic>> rows;
  final String fileName;
  ListToCsv({
    required this.rows,
    required this.fileName,
  });
  Future<void> listToCsv() async {
    String csv = const ListToCsvConverter().convert(rows);
    final dir = Directory.current.path;
    File f = File("$dir/$fileName.csv");
    f.writeAsString(csv);
  }
}
