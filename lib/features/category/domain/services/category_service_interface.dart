import 'package:get/get.dart';
import 'package:liwas_user/common/enums/data_source_enum.dart';
import 'package:liwas_user/features/category/domain/models/category_model.dart';
import 'package:liwas_user/features/item/domain/models/item_model.dart';
import 'package:liwas_user/features/store/domain/models/store_model.dart';

abstract class CategoryServiceInterface {
  Future<List<CategoryModel>?> getCategoryList(bool allCategory, {DataSourceEnum? source});
  Future<List<CategoryModel>?> getSubCategoryList(String? parentID);
  Future<ItemModel?> getCategoryItemList(String? categoryID, int offset, String type);
  Future<StoreModel?> getCategoryStoreList(String? categoryID, int offset, String type);
  Future<Response> getSearchData(String? query, String? categoryID, bool isStore, String type);
  Future<bool> saveUserInterests(List<int?> interests);
}
