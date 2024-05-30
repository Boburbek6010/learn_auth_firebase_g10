import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_auth_firebase_g10/models/post_model.dart';
import 'package:learn_auth_firebase_g10/services/rtdb_service.dart';

class RTPage extends StatefulWidget {
  const RTPage({super.key});

  @override
  State<RTPage> createState() => _RTPageState();
}

class _RTPageState extends State<RTPage> {
  bool isLoading = true;
  List<Post> postList = [];

  // add
  Future<void> addNewPost() async {
    isLoading = false;
    setState(() {});
    Post post = Post(userId: "posts", firstname: "firstname", lastname: "lastname", date: "date", content: "content");
    await RTDBService.create(path: "posts", post: post);
    await loadPost();
    isLoading = true;
    setState(() {});
  }


  // load
  Future<void>loadPost()async{
    isLoading = false;
    setState(() {});
    postList = await RTDBService.read(path: "posts");
  }

  // update
  Future<void>update(Post post)async{
    isLoading = false;
    setState(() {});
    await RTDBService.update(path: "posts", post: post);
    await loadPost();
    isLoading = true;
    setState(() {});
  }

  // remove
  Future<void>remove(String key)async{
    isLoading = false;
    setState(() {});
    await RTDBService.delete(path: "posts", key: key);
    await loadPost();
    isLoading = true;
    setState(() {});
  }

  @override
  void initState() {
    loadPost().then((value) {
      isLoading = true;
      setState(() {});
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: ListView.builder(
                itemCount: postList.length,
                itemBuilder: (_, __){
                  return Card(
                    child: ListTile(
                      onTap: ()async{
                        Post post = Post(
                          postKey: postList[__].postKey,
                            userId: "Asadbek", firstname: "Asadbek", lastname: "lastname", date: "29.05.2024", content: "content");
                        await update(post);
                      },
                      onLongPress: ()async{
                        await remove(postList[__].postKey!);
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
          await addNewPost();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
