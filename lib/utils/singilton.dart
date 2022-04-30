import 'package:cloud_firestore/cloud_firestore.dart';

class Singleton {
  static final Singleton singleton = Singleton();

  CollectionReference mainCollection = FirebaseFirestore.instance.collection("ABC");

  setCollectionName(String name) {
    mainCollection = FirebaseFirestore.instance.collection(name);
  }
}
