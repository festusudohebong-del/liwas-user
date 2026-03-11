import 'package:liwas_user/common/models/response_model.dart';
import 'package:liwas_user/interfaces/repository_interface.dart';

abstract class TaxiFavouriteRepositoryInterface extends RepositoryInterface {
  @override
  Future<ResponseModel> delete(int? id, {bool isProvider = false});
  Future<ResponseModel> addVehicleFavouriteList(int id, bool isProvider);
}
