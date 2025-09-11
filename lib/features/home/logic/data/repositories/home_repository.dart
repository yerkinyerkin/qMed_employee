import 'package:qmed_employee/features/home/logic/data/datasources/home_datasource.dart';
import 'package:qmed_employee/features/home/logic/data/models/home_model.dart';

abstract class HomeRepository {
  Future<HomeModel> getPatients({
    required String search,
    required int page,
    required int size,
  });
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource homeDataSource;
  HomeRepositoryImpl(this.homeDataSource);

  @override
  Future<HomeModel> getPatients({
    required String search,
    required int page,
    required int size,
  }) async {
    final response = await homeDataSource.getPatients(
      search: search,
      page: page,
      size: size,
    );
    return HomeModel.fromJson(response.data);
  }
}
