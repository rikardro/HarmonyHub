import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';

class BreathingRepository {
  final IFirebaseStorageDataSource dataSource;
  // Create a reference to the image you want to fetch
  final FirebaseStorage storage = FirebaseStorage.instance;

  BreathingRepository(this.dataSource);

  Future<String> getBreathingAudio(String category) async {
    return await dataSource.getBreathingAudio(category);
  }
}

abstract class IFirebaseStorageDataSource {
  Future<String> getBreathingAudio(String category);
}

class FirebaseStorageDataSource implements IFirebaseStorageDataSource {
  // a method that gets the mp3 file from firebase storage
  @override
  Future<String> getBreathingAudio(String category) async {
    String downloadURL = await FirebaseStorage.instance
        .ref('meditations/$category.mp3')
        .getDownloadURL();
    return downloadURL;
  }
}
