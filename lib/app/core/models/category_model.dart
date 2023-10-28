import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  DocumentReference uid;
  String label_ptbr;
  // String labelEnus;
  String image;

  String key;

  CategoryModel({this.uid, this.label_ptbr, this.image, this.key});

  factory CategoryModel.fromDocument(DocumentSnapshot doc) {
    return CategoryModel(
      uid: doc.reference,
      label_ptbr: doc['label_ptbr'],
      image: doc['image'],
      key: doc['key'],
    );
  }

  Map<String, dynamic> toJson(CategoryModel doc) => {
        'uid': doc.uid,
        'label_ptbr': doc.label_ptbr,
        'image': doc.image,
        'key': doc.key,
      };
}
