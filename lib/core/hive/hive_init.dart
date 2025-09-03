import 'package:hive/hive.dart';

initHiveAdapters() {}

initHiveBoxes() async {
  await Hive.openBox('token');
}
