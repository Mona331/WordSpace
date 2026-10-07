import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wordspace_app/colors/colors.dart';
import 'package:wordspace_app/login.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  
  PageController pageController = PageController();
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofwhite,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              children: [
                buildPage(
                  imgpath: 'assets/images/splash1..png',
                  title: "Think It. Feel It.",
                  description: "Every great post starts with an idea.",
                  color: AppColors.ofwhite,

                  //icon: Icons.home,
                ),
                buildPage(
                  imgpath: 'assets/images/splash2..png',
                  title: "Put It Into Words",
                  description: "Turn your thoughts into meaningful words.",
                  color: AppColors.ofwhite,

                  //icon: Icons.touch_app,
                ),
                buildPage(
                  imgpath: 'assets/images/splash3..png',
                  title: "Write. Share. Connect.",
                  description: "Share your words and connect with others.",
                  color: AppColors.ofwhite,

                  // icon: Icons.speed,
                ),
                // buildPage(
                //   imgpath: 'assets/images/splashpng',
                //   title: "Start Your Journey",
                //   description: "Take the test and unlock your level",
                //   color: AppColors.ofwhite,

                //   // icon: Icons.rocket_launch,
                // ),
              ],
            ),
          ),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: List.generate(3, (index) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.ofwhite,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(12),
                    right: Radius.circular(12),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: 10,
                  height: 10,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentPage == index
                        ? AppColors.primary
                        : Colors.grey,
                  ),
                ),
              );
            }),
          ),

          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                currentPage == 2
                    ? SizedBox()
                    : TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          pageController.jumpToPage(3);
                        },
                        child: Text("Skip"),
                      ),

                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (currentPage == 2) {
                      // final prefs = await SharedPreferences.getInstance();
                      // prefs.setBool('onboarding', true);
                      Navigator.pushReplacement(
                        context,
                      MaterialPageRoute(builder: (context) => Login()),
                      );
                      // Home لاحقًا
                    } else {
                      pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                  child: Text(currentPage == 2 ? "Get Started" : "Next"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
Widget buildPage({
  required String title,
  required String description,
  required Color color,
  // required IconData icon,
  required String imgpath,
}) {
  // return Container(
  //   color: color,
  //   child: Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Image.asset(imgpath, height: 100, width: 100),
  //       // Icon(icon, size: 100, color: Colors.white),
  //       SizedBox(height: 20),
  //       Text(
  //         title,
  //         style: TextStyle(
  //           fontSize: 28,
  //           color: Colors.white,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       SizedBox(height: 10),
  //       Text(
  //         description,
  //         style: TextStyle(fontSize: 16, color: Colors.white70),
  //         textAlign: TextAlign.center,
  //       ),
  //     ],
  //   ),
  // );
  return Container(
    color: color,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imgpath, height: 300, width: 300),
        // Icon(icon, size: 100, color: Colors.white),
        SizedBox(height: 20),
        Text(
          title,
          style: GoogleFonts.lora(
            fontSize: 28,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Text(
          description,
          style: GoogleFonts.lora(fontSize: 16, color: AppColors.primary),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
