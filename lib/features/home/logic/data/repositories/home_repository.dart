import 'package:dio/dio.dart';
import 'package:qmed_employee/features/home/logic/data/datasources/home_datasource.dart';
import 'package:qmed_employee/features/home/logic/data/models/home_model.dart';

abstract class HomeRepository {
  Future<HomeModel> getPatients(String search);
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource homeDataSource;

  HomeRepositoryImpl(this.homeDataSource);

  @override
  Future<HomeModel> getPatients(String search) async {
    Response response = await homeDataSource.getPatients(search);
    return HomeModel.fromJson(response.data);
  }
}
