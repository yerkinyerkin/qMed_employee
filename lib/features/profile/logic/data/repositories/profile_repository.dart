import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:qmed_employee/features/profile/logic/data/datasources/profile_datasource.dart';
import 'package:qmed_employee/features/profile/logic/data/models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getProfile();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource profileDataSource;
  Box polyclinicBox = Hive.box('polyclinic');

  ProfileRepositoryImpl(this.profileDataSource);

  @override
  Future<ProfileModel> getProfile() async {
    Response response = await profileDataSource.getProfile();
    ProfileModel profile = ProfileModel.fromJson(response.data);
    
    // Сохраняем данные поликлиники в Hive storage
    if (profile.polyclinic != null) {
      polyclinicBox.put('polyclinic_id', profile.polyclinic!.polyclinicId);
      polyclinicBox.put('polyclinic_name', profile.polyclinic!.name);
      print('Сохранены данные поликлиники: ID=${profile.polyclinic!.polyclinicId}, Name=${profile.polyclinic!.name}');
    }
    
    return profile;
  }
}
