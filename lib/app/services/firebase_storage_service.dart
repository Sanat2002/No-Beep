import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:neep/app/utils/utils.dart';


//TODO : check internet stream.
class FirebaseStorageService {
  Future<String?> uploadFileToFirebaseStorage(String filePath) async {
    String fileName = filePath.split('/').last;
    Reference storageRef = FirebaseStorage.instance.ref('/media_files').child(fileName);

    try {
      UploadTask uploadTask = storageRef.putFile(File(filePath));
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      if (taskSnapshot.state == TaskState.success) {
        String downloadUrl = await storageRef.getDownloadURL();
        // downloadUrls.add(downloadUrl)
        return downloadUrl;
      }
    } catch (e) {
      print('Error uploading file: $e');
      requestFailureSnackbar("Unable to upload files");
    }
    return null;
  }
}
