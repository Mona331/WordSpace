import 'package:flutter/material.dart';
import 'package:wordspace_app/CreatePost.dart';
import 'package:wordspace_app/colors/colors.dart';
import 'package:wordspace_app/screens/AdminPanel.dart';
import 'package:wordspace_app/screens/Dashboard.dart';
import 'package:wordspace_app/screens/Profile.dart';
import 'package:wordspace_app/screens/home.dart';
//import 'Home.dart';
//import 'CreatePost.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

final GlobalKey<HomeState> homeKey = GlobalKey<HomeState>();
  final GlobalKey<DashboardState> dashboardKey = GlobalKey<DashboardState>();

  late final List<Widget> pages;
@override
  void initState() {
    super.initState();

    pages = [
      Home(
        key: homeKey,
        onLikeChanged: () {
          dashboardKey.currentState?.getDashboard();
        },
      ),
      const Profile(),
      CreatePost(
        onPostCreated: () {
            print('REFRESH HOME CALLED');
          homeKey.currentState?.getPosts();
          dashboardKey.currentState?.getDashboard();
        },
      ),
   Dashboard(
        key: dashboardKey,
        onLikeChanged: () {
          homeKey.currentState?.getPosts();
        },
      ),
    ];
  }
  Widget _navItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.primary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofwhite,
      body: IndexedStack(index: currentIndex, children: pages),

      // bottomNavigationBar: Column(
      //     mainAxisSize: MainAxisSize.min,
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.only(bottom: 8),
      //       child: CircleAvatar(
      //         radius: 24,
      //         backgroundColor: AppColors.primary,
      //         child: IconButton(
      //           icon: const Icon(
      //             Icons.admin_panel_settings_outlined,
      //             color: Colors.white,
      //           ),
      //           onPressed: () {
      //             Navigator.pushReplacement(
      //               context,
      //               MaterialPageRoute(builder: (context) => const AdminPanel()),
      //             );
      //           },
      //         ),
      //       ),
      //     ),
      //     BottomNavigationBar(
      //         backgroundColor: AppColors.ofwhite,
      //       currentIndex: currentIndex,
          
      //       onTap: (index) {
      //         setState(() {
      //           currentIndex = index;
      //         });
      //       },
          
      //       type: BottomNavigationBarType.fixed,
          
      //       items: const [
      //         BottomNavigationBarItem(
      //           backgroundColor: AppColors.ofwhite,
      //           label: 'Home',
      //           icon: Icon(Icons.home_outlined, color: AppColors.primary),
      //           activeIcon: Icon(Icons.home, color: AppColors.primary),
      //         ),
          
      //         BottomNavigationBarItem(
      //           label: 'Profile',
      //           icon: Icon(Icons.person_outline, color: AppColors.primary),
      //           activeIcon: Icon(Icons.person, color: AppColors.primary),
      //         ),
          
      //         BottomNavigationBarItem(
      //           label: 'Create',
      //           icon: Icon(Icons.add_circle_outline, color: AppColors.primary),
      //           activeIcon: Icon(Icons.add_circle, color: AppColors.primary),
      //         ),
          
      //         BottomNavigationBarItem(
      //           label: 'Dashboard',
      //           icon: Icon(Icons.dashboard_outlined, color: AppColors.primary),
      //           activeIcon: Icon(Icons.dashboard, color: AppColors.primary),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 75,
            decoration: BoxDecoration(
              color: AppColors.ofwhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: _navItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Home',
                    index: 0,
                  ),
                ),

                Expanded(
                  child: _navItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: 'Profile',
                    index: 1,
                  ),
                ),

                const SizedBox(width: 80),

                Expanded(
                  child: _navItem(
                    icon: Icons.add_circle_outline,
                    activeIcon: Icons.add_circle,
                    label: 'Create',
                    index: 2,
                  ),
                ),

                Expanded(
                  child: _navItem(
                    icon: Icons.dashboard_outlined,
                    activeIcon: Icons.dashboard,
                    label: 'Dashboard',
                    index: 3,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: -28,
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                border: Border.all(color: AppColors.ofwhite, width: 5),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.admin_panel_settings_outlined,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const AdminPanel()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
