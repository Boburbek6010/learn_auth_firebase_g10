import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

@immutable
final class StorageService{
  static final storage = FirebaseStorage.instance;

  static Future<String>upload({required String path, required File file})async{
    Reference reference = storage.ref(path).child("${DateTime.now().toLocal().toIso8601String()}${file.path.substring(file.path.lastIndexOf("."))}");
    log(file.path.substring(file.path.lastIndexOf(".")).toString());
    log("${DateTime.now().toIso8601String()}_${file.path.substring(file.path.lastIndexOf("."))}");
    UploadTask task = reference.putFile(file);
    await task.whenComplete((){});
    return reference.getDownloadURL();
  }

  static Future<(List<String>, List<String>)> getData(String path)async{
    List<String> linkList = [];
    List<String> nameList = [];
    final Reference reference = storage.ref(path);
    final ListResult list = await reference.listAll();
    for (var e in list.items) {
      linkList.add(await e.getDownloadURL());
      nameList.add(e.name);
    }
    return (linkList, nameList);
  }


  static Future<void> delete(String url)async{
    final Reference reference = storage.refFromURL(url);
    await reference.delete();
  }

}