import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wordspace_app/api/api_service.dart';
import 'package:wordspace_app/colors/colors.dart';
import 'package:intl/intl.dart';
import 'package:wordspace_app/screens/AdminComments.dart';
import 'package:wordspace_app/screens/AdminPosts.dart';
import 'package:wordspace_app/screens/AdminUsers.dart';
import 'package:wordspace_app/screens/PostDetails.dart';
import 'package:wordspace_app/screens/mainScreen.dart';
//import 'package:wordspace_app/screens/AdminPosts.dart';
class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  
  int currentIndex = 0;
  bool isLoading = true;

  int totalUsers = 0;
  int totalPosts = 0;
  int totalComments = 0;
final ApiService api = ApiService();
Widget buildDashboard() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Dashboard',
            style: GoogleFonts.spaceMono(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(height: 25),

          Row(
            children: [
              Expanded(
                child: Card(
                   color: AppColors.ofwhite,
                  shadowColor: AppColors.primary,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.people_outline),
                        const SizedBox(height: 8),
                        Text(
                          '$totalUsers',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Users'),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Card(
                   color: AppColors.ofwhite,
                  shadowColor: AppColors.primary,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.article_outlined),
                        const SizedBox(height: 8),
                        Text(
                          '$totalPosts',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Posts'),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                
                child: Card(
                   color: AppColors.ofwhite,
                  shadowColor: AppColors.primary,
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.comment_outlined),
                        const SizedBox(height: 8),
                        Text(
                          '$totalComments',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Comments'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
       const SizedBox(height: 30),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'All Posts',
              style: GoogleFonts.spaceMono(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                final date = DateFormat(
                  'MMM d, yyyy · h:mm a',
                ).format(DateTime.parse(post['created_at']).toLocal());

                return Card(
                   color: Colors.white,
                  shadowColor: AppColors.primary,
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          post['content'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            color: AppColors.bistre,
                            height: 1.5,
                          ),
                        ),

                        if ((post['content'] ?? '')
                                .toString()
                                .split('\n')
                                .length >
                            2)
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PostDetails(postId: post['id']),
                                ),
                              );
                            },
                            child: Text(
                              'Read More',
                              style: GoogleFonts.merriweather(
                                fontSize: 12,
                                color: AppColors.kobich,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),

                        Text(post['user']['name'] ?? ''),

                        const SizedBox(height: 5),

                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          post['status'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  List<dynamic> posts = [];

  Future<void> getAdminDashboard() async {
    try {
      final data = await api.getAuth('admin/dashboard');
      print('ADMIN DASHBOARD: $data');
      final commentsData = await api.getAuth('admin/comments');

      print('ADMIN COMMENTS: $commentsData');
      if (!mounted) return;

     setState(() {
        final dashboard = data['data'];

        totalUsers = dashboard['users_count'] ?? 0;
        totalPosts = dashboard['posts_count'] ?? 0;
        totalComments = dashboard['comments_count'] ?? 0;
        posts = dashboard['posts'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading dashboard: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
 
  @override
  void initState() {
    super.initState();
    getAdminDashboard();
  }
  Widget _adminNavItem({
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

      // appBar: AppBar(
      //   backgroundColor: AppColors.ofwhite,
      //   elevation: 0,
      //   title: Text(
      //     'Admin Panel',
      //     style: GoogleFonts.spaceMono(
      //       fontSize: 18,
      //       color: AppColors.primary,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),

    body: currentIndex == 0
          ? buildDashboard()
       : currentIndex == 1
          ? const AdminPosts()
          : currentIndex == 2
          ? const AdminComments()
          : const AdminUsers(),

      // bottomNavigationBar: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.only(bottom: 8),
      //       child: CircleAvatar(
      //         radius: 24,
      //         backgroundColor: AppColors.primary,
      //         child: IconButton(
      //           icon: const Icon(Icons.person_outline, color: Colors.white),
      //           onPressed: () {
      //             Navigator.pushReplacement(
      //               context,
      //               MaterialPageRoute(builder: (context) => const MainScreen()),
      //             );
      //           },
      //         ),
      //       ),
      //     ),
      //     BottomNavigationBar(
      //      backgroundColor:  AppColors.ofwhite,
      //       currentIndex: currentIndex,
      //       onTap: (index) {
      //         setState(() {
      //           currentIndex = index;
      //         });
      //       },
      //       items: const [
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.dashboard_outlined, color: AppColors.primary),
      //           label: 'Dashboard',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.article_outlined, color: AppColors.primary),
      //           label: 'Posts',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.comment_outlined,color: AppColors.primary,),
      //           label: 'Comments',
      //         ),
      //         BottomNavigationBarItem(
      //           icon: Icon(Icons.people_outline, color: AppColors.primary),
      //           label: 'Users',
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
                  child: _adminNavItem(
                    icon: Icons.dashboard_outlined,
                    activeIcon: Icons.dashboard,
                    label: 'Dashboard',
                    index: 0,
                  ),
                ),

                Expanded(
                  child: _adminNavItem(
                    icon: Icons.article_outlined,
                    activeIcon: Icons.article,
                    label: 'Posts',
                    index: 1,
                  ),
                ),

                const SizedBox(width: 80),

                Expanded(
                  child: _adminNavItem(
                    icon: Icons.comment_outlined,
                    activeIcon: Icons.comment,
                    label: 'Comments',
                    index: 2,
                  ),
                ),

                Expanded(
                  child: _adminNavItem(
                    icon: Icons.people_outline,
                    activeIcon: Icons.people,
                    label: 'Users',
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
                  Icons.person_outline,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
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
