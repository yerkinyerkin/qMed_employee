import 'package:dio/dio.dart';
import 'package:qmed_employee/features/home/logic/data/datasources/home_datasource.dart';
import 'package:qmed_employee/features/home/logic/data/models/home_model.dart';
import 'package:qmed_employee/features/profile/logic/data/datasources/profile_datasource.dart';
import 'package:qmed_employee/features/profile/logic/data/models/profile_model.dart';

abstract class HomeRepository {
  Future<HomeModel> getPatients(int? polyclinicId,{
    required String search,
    required int page,
    required int size,
  });
  Future<ProfileModel> getProfile();
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource homeDataSource;
  final ProfileDataSource profileDataSource;
  HomeRepositoryImpl(this.homeDataSource, this.profileDataSource);

  @override
  Future<HomeModel> getPatients(int? polyclinicId,{
    required String search,
    required int page,
    required int size,
  }) async {
    final response = await homeDataSource.getPatients(
      polyclinicId,
      search: search,
      page: page,
      size: size,
    );
    return HomeModel.fromJson(response.data);
  }

  @override
  Future<ProfileModel> getProfile() async {
    Response response = await profileDataSource.getProfile();
    return ProfileModel.fromJson(response.data);
  }
}
