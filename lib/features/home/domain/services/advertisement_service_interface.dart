import 'package:liwas_user/common/enums/data_source_enum.dart';
import 'package:liwas_user/features/home/domain/models/advertisement_model.dart';

abstract class AdvertisementServiceInterface {
  Future<List<AdvertisementModel>?> getAdvertisementList(DataSourceEnum source);
}
