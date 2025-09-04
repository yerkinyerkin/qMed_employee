import 'package:dio/dio.dart';
import 'package:qmed_employee/features/profile/logic/data/datasources/profile_datasource.dart';
import 'package:qmed_employee/features/profile/logic/data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getProfile();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource profileDataSource;

  ProfileRepositoryImpl(this.profileDataSource);

  @override
  Future<ProfileModel> getProfile() async {
    Response response = await profileDataSource.getProfile();
    return ProfileModel.fromJson(response.data);
  }
}
