import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wordspace_app/api/api_service.dart';
import 'package:wordspace_app/colors/colors.dart';

class PostDetails extends StatefulWidget {
  final int postId;

  const PostDetails({super.key, required this.postId});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final ApiService api = ApiService();

  Map<String, dynamic>? post;
  bool isLoading = true;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    getPost();
     
  }

  Future<void> getPost() async {
    try {
      final data = await api.get('posts/${widget.postId}');

      if (!mounted) return;

      setState(() {
        post = data['data'];
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading post: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

 
  String formatDate(String? date) {
    if (date == null) return '';

    final parsedDate = DateTime.tryParse(date);

    if (parsedDate == null) return '';

    return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofwhite,

      appBar: AppBar(
        backgroundColor: AppColors.ofwhite,
        elevation: 0,
        title: Text(
          'Post',
          style: GoogleFonts.spaceMono(
            fontSize: 16,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : post == null
          ? const Center(child: Text('Post not found.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'By ${post!['user_name'] ?? 'Unknown User'}',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    post!['title'] ?? '',
                   style: GoogleFonts.merriweather(
                      fontSize: 22,
                      color: AppColors.bistre,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    formatDate(post!['created_at']),
                    style: GoogleFonts.roboto(fontSize: 13, color: Colors.grey),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    post!['content'] ?? '',
                    style: GoogleFonts.roboto(
                      fontSize: 17,
                      color: AppColors.bistre,
                      height: 1.7,
                    ),
                  ),

                  const SizedBox(height: 30),

                  
                ],
              ),
            ),
    );
  }
}
