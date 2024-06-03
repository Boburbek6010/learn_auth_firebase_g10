import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:learn_auth_firebase_g10/services/storage_service.dart';
import 'package:learn_auth_firebase_g10/services/util_service.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({super.key});

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {

  File? file;
  List<String>linkList = [];
  (List<String>, List<String>)allList = ([], []);
  List<String>nameList = [];
  bool isLoading = false;

  Future<File?>takeFile()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file = File(result.files.single.path!);
      return file;
    } else {
      return null;
    }
  }

  // upload
  Future<void>uploadFile()async{
    file = await takeFile();
    if(file != null){
      String link = await StorageService.upload(path: "G10", file: file!);
      log(link);
      Utils.fireSnackBar("Successfully Uploaded", context);
    }
  }


  // getData
  Future<void>getItems()async{
    isLoading = false;
    allList =  await StorageService.getData("G10");
    linkList = allList.$1;
    nameList = allList.$2;
    log(linkList.toString());
    isLoading = true;
    setState(() {});
  }

  // delete
  Future<void> delete(String url)async{
    isLoading = false;
    setState(() {});
    await StorageService.delete(url);
    await getItems();
  }

  @override
  void initState() {
    getItems();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage Page'),
      ),
      body: Center(
        child: isLoading ?ListView.builder(
          itemCount: linkList.length,
          itemBuilder: (_, index){
            return Card(
              child: ListTile(
                leading: nameList[index].endsWith(".png") || nameList[index].endsWith(".jpg") ?Image.network(linkList[index]) : Image.network("https://cdn1.iconfinder.com/data/icons/social-messaging-ui-color-shapes/128/volume-circle-blue-512.png"),
                title: Text(nameList[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: (){},
                ),
                onLongPress: ()async{
                  await delete(linkList[index]);
                },
              ),
            );
          },
        ):const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await uploadFile();
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}

