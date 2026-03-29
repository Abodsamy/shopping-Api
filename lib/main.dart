import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:shopingapp/app_root.dart';
import 'package:shopingapp/widget/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('cartBox');

  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MyApp(),
    ),
  );
}
