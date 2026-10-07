import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordspace_app/api/api_service.dart';
import 'package:wordspace_app/colors/colors.dart';
import 'package:wordspace_app/screens/edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token');

    if (token == null) {
      return;
    }

    try {
      final api = ApiService();

      final data = await api.postAuth('logout', {});

      print('LOGOUT RESPONSE: $data');
      await prefs.clear();

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging out: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

 Future<void> loadUserData() async {
    try {
      final api = ApiService();

      final data = await api.getAuth('profile');

      if (!mounted) return;

      setState(() {
        username = data['name'] ?? '';
        email = data['email'] ?? '';
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofwhite,

      appBar: AppBar(
        backgroundColor: AppColors.ofwhite,
        elevation: 0,
        title: Text(
          'Profile',
          style: GoogleFonts.spaceMono(
            fontSize: 16,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.person, size: 55, color: Colors.white),
            ),

            const SizedBox(height: 20),

            Text(
              username,
              style: GoogleFonts.roboto(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.bistre,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              email,
              style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.edit_outlined,
                color: AppColors.primary,
              ),
              title: const Text('Edit Profile'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
             
                onTap: () async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EditProfile(
        username: username,
        email: email,
      ),
    ),
  );
},
              
            ),

            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.primary),
              title: const Text('Logout'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
             onTap: logout,
            ),
          ],
        ),
      ),
    );
  }
}
