
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:learn_auth_firebase_g10/models/post_model.dart';

@immutable
final class RTDBService{


  static final db = FirebaseDatabase.instance.ref();

  /// create

  static Future<Stream<DatabaseEvent>>create({required String path, required Post post})async{
    String? key = db.child(path).push().key;
    post.postKey = key!;
    await db.child(path).child(post.postKey!).set(post.toJson());
    return db.onChildAdded;
  }

  /// read
  static Future<List<Post>>read({required String path})async{
    List<Post> postList = [];
    Query query = db.child(path);
    DatabaseEvent databaseEvent = await query.once();
    Iterable<DataSnapshot> result = databaseEvent.snapshot.children;
    for (DataSnapshot item in result) {
      if(item.value != null){
        postList.add(Post.fromJson(Map<String, dynamic>.from(item.value as Map)));
      }
    }
    return postList;
  }

  /// update
  static Future<Stream<DatabaseEvent>>update({required String path, required Post post})async{
    await db.child(path).child(post.postKey!).set(post.toJson());
    return db.onChildAdded;
  }


  /// delete
  static Future<void>delete({required String path, required String key})async{
    await db.child(path).child(key).remove();
  }


}