import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'logger.dart';

Future<String?> getDownloadPath() async {
  Directory? directory;
  try {
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');
      // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
      if (!await directory.exists()) {
        logger.i("No download folder");
        directory = await getExternalStorageDirectory();
      }
    }
  } catch (err, stack) {
    logger.e("Cannot get download folder path:\n$stack");
  }
  return directory?.path;
}

Future<File> writeFile(Uint8List data, String name) async {
  // storage permission ask
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  String tempPath = await getDownloadPath() ?? "";
  var filePath = '$tempPath/$name';

  var bytes = ByteData.view(data.buffer);
  final buffer = bytes.buffer;
  return File(filePath)
      .writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
}
