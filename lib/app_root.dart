import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopingapp/screen/Splash_Screen.dart';
import 'widget/theme_provider.dart';


class MyApp extends StatelessWidget {

  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    final themeProvider =
    Provider.of<ThemeProvider>(context);


    return MaterialApp(

      debugShowCheckedModeBanner: false,

      themeMode: themeProvider.themeMode,


      theme: ThemeData(

        brightness: Brightness.light,

        primarySwatch: Colors.green,

      ),


      darkTheme: ThemeData(

        brightness: Brightness.dark,

        primarySwatch: Colors.green,

      ),


      home: const SplashScreen(),

    );
  }
}
