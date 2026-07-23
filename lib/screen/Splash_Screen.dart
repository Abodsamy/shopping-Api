import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shopingapp/widget/bottonnavegationpar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;


  @override
  void initState() {
    super.initState();


    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );


    scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
    );


    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn,
      ),
    );


    animationController.forward();


    Timer(
      const Duration(seconds: 4),
          () {

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const BottomNavBar(),
            ),
          );
        }

      },
    );
  }


  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            colors: [
              Colors.green,
              Color(0xff8BC34A),
            ],

            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

          ),

        ),


        child: Center(

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,


            children: [


              FadeTransition(

                opacity: fadeAnimation,


                child: ScaleTransition(

                  scale: scaleAnimation,


                  child: Container(

                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(

                      color: Colors.white,

                      borderRadius: BorderRadius.circular(30),

                      boxShadow: [

                        BoxShadow(

                          color: Colors.black.withOpacity(0.2),

                          blurRadius: 15,

                          offset: const Offset(0, 8),

                        ),

                      ],

                    ),


                    child: Image.asset(

                      "assets/images/تنزيل.webp",

                      width: 180,

                      height: 180,

                      fit: BoxFit.contain,


                      errorBuilder: (context, error, stackTrace) {

                        return const Icon(

                          Icons.shopping_bag,

                          size: 100,

                          color: Colors.green,

                        );

                      },

                    ),

                  ),

                ),

              ),


              const SizedBox(height: 40),



              const Text(

                "Go To Shopping",

                style: TextStyle(

                  color: Colors.white,

                  fontWeight: FontWeight.bold,

                  fontSize: 30,

                  letterSpacing: 1,

                ),

              ),


              const SizedBox(height: 10),



              const Text(

                "Everything you need in one place",

                style: TextStyle(

                  color: Colors.white70,

                  fontSize: 16,

                ),

              ),


            ],

          ),

        ),

      ),

    );
  }
}