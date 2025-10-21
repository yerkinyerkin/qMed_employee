import 'package:hive/hive.dart';

initHiveAdapters() {}

initHiveBoxes() async {
  await Hive.openBox('token');
  await Hive.openBox('userId');
  await Hive.openBox('polyclinic');
}
