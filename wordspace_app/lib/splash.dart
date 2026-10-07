import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wordspace_app/colors/colors.dart';
import 'package:wordspace_app/onboardingScreen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash>  with SingleTickerProviderStateMixin  {
   PageController pageController = PageController();

  int currentPage = 0;
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = Tween<double>(
      begin: 0.5,
      end: 2.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: AppColors.ofwhite,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Text('WordSpace',style: GoogleFonts.spaceMono(
            fontSize: 28,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),)
        ),
      ),
    );
  }
}