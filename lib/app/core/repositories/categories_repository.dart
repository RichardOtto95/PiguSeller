import 'package:pigu_seller/app/core/models/category_model.dart';
import 'package:pigu_seller/app/core/repositories/categories_repository_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryRepository implements CategoryRepositoryInterface {
  final Firestore firestore;

  CategoryRepository(this.firestore);

  @override
  Stream<List<CategoryModel>> getCategory() {
    //Retornando future, faz uma busca e pronto, retornando snapshot, toda atualização no banco é retornada em seguida para cá.
    return firestore.collection('categories').snapshots().map((query) {
      return query.documents.map((doc) {
        return CategoryModel.fromDocument(doc);
      }).toList();
    });
  }

  // Future getUser(OrderModel model) async {
  //   if (model.uid == null) {
  //     print('sem uid: ${model.uid}');
  //     return firestore.collection('orders').add(OrderModel().toJson(model));
  //   }
  // }
}
