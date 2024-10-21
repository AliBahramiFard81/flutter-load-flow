import 'dart:io';

class CreateFolder {
  Future<String> createFolderInAppDocDir(String folderName) async {
    //Get this App Document Directory
    final appDocDir = Directory.current.path;
    //App Document Directory + folder name
    final Directory appDocDirFolder =
        Directory('$appDocDir/matlib/$folderName/');

    if (await appDocDirFolder.exists()) {
      //if folder already exists return path
      return appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      // ignore: no_leading_underscores_for_local_identifiers
      final Directory _appDocDirNewFolder =
          await appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }
}
