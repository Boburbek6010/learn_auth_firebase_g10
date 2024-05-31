import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learn_auth_firebase_g10/models/post_model.dart';
import 'package:learn_auth_firebase_g10/services/cfs_service.dart';

class FSPage extends StatefulWidget {
  const FSPage({super.key});

  @override
  State<FSPage> createState() => _FSPageState();
}

class _FSPageState extends State<FSPage> {
  bool isLoading = false;
  List<QueryDocumentSnapshot> itemList = [];
  List<Post> postList = [];

  // create
  Future<void> create() async {
    refresh(false);
    Post post = Post(userId: "userId", firstname: "firstname", lastname: "lastname", date: "date", content: "content");
    await CFSService.createCollection(collectionPath: "g10", data: post.toJson());
    await loadData();
  }

  // refresh
  void refresh(bool value) {
    isLoading = value;
    setState(() {});
  }

  // load
  Future<void> loadData() async {
    postList = [];
    refresh(false);
    itemList = await CFSService.read(collectionPath: "g10");
    refresh(true);
    for (var element in itemList) {
      postList.add(Post.fromJson(element.data() as Map<String, dynamic>));
    }
  }

  // remove
  Future<void>remove(String id)async{
    refresh(false);
    await CFSService.delete(collectionPath: "g10", id: id);
    await loadData();
  }

  // update
  Future<void>update(String id, Post post)async{
    refresh(false);
    await CFSService.update(collectionPath: "g10", id: id, data: post.toJson());
    await loadData();
  }


  @override
  void didChangeDependencies() async{
    await loadData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: ListView.builder(
                itemCount: postList.length,
                itemBuilder: (_, __) {
                  return Card(
                    child: ListTile(
                      onTap: () async {
                        log(itemList[__].id);
                        Post post = Post(userId: "New", firstname: "New", lastname: "New", date:"New", content: "New");
                        await update(itemList[__].id, post);
                      },
                      onLongPress: () async {
                        await remove(itemList[__].id);
                      },
                      title: Text(postList[__].firstname),
                      subtitle: Text(postList[__].content),
                      trailing: Text(postList[__].date),
                      leading: Text(postList[__].userId),
                    ),
                  );
                },
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await create();
        },
      ),
    );
  }
}
