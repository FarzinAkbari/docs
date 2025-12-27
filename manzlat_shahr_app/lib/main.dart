import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'services/storage/boxes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(Boxes.employees);
  await Hive.openBox(Boxes.settings);
  runApp(const ManzlatShahrAppBootstrap());
}
