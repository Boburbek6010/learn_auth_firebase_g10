import 'package:cloud_firestore/cloud_firestore.dart';

class CFSService{

  static final FirebaseFirestore db = FirebaseFirestore.instance;

  /// create
  static Future<DocumentReference<Map<String, dynamic>>>createCollection({required String collectionPath, required Map<String, dynamic>data})async{
    var result = await db.collection(collectionPath).add(data);
    return result;
  }

  /// read
  static Future<List<QueryDocumentSnapshot<Object?>>>read({required String collectionPath})async{
    List<QueryDocumentSnapshot> itemList = [];
    QuerySnapshot querySnapshot = await db.collection(collectionPath).get();
    for (var element in querySnapshot.docs) {
      itemList.add(element);
    }
    return itemList;
  }


  /// update
  static Future<void>update({required String collectionPath, required String id, required Map<String, dynamic>data})async{
    await db.collection(collectionPath).doc(id).update(data);
  }


  /// delete
  static Future<void>delete({required String collectionPath, required String id})async{
    await db.collection(collectionPath).doc(id).delete();
  }


}