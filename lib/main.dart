import 'package:flutter/material.dart';
import './my_app.dart';
import './locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const MyApp());
}
