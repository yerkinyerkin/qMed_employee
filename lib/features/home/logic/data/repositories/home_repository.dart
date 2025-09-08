import 'package:dio/dio.dart';
import 'package:qmed_employee/features/home/logic/data/datasources/home_datasource.dart';
import 'package:qmed_employee/features/home/logic/data/models/home_model.dart';

abstract class HomeRepository {
  Future<List<HomeModel>> getPatients();
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource homeDataSource;

  HomeRepositoryImpl(this.homeDataSource);

  @override
  Future<List<HomeModel>> getPatients() async {
    Response response = await homeDataSource.getPatients();
    return (response.data as List).map((i) => HomeModel.fromJson(i)).toList();
  }
}
