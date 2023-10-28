import 'package:pigu_seller/app/core/models/category_model.dart';

abstract class CategoryRepositoryInterface {
  Stream<List<CategoryModel>> getCategory();
}
