import 'dart:io';
import 'dart:isolate';

class ReadWriteResult {
  Future<void> writeToTxt(String txt) async {
    final dir = Directory.current.path;
    File f = File("$dir/result.txt");
    await f.writeAsString(txt);
  }

  Future<String> readFromTxt() async {
    final dir = Directory.current.path;
    File f = File("$dir/result.txt");
    List<String> text = await f.readAsLines();
    String firstBlockTxt = await Isolate.run(
      () {
        String x = '';
        Iterable<String> firstBlock = text.getRange(0, text.length);
        for (var i in firstBlock) {
          x = '$x$i\n';
        }
        return x;
      },
    );

    return firstBlockTxt;
  }
}
