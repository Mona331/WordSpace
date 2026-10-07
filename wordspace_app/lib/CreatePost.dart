import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wordspace_app/api/api_service.dart';
import 'package:wordspace_app/colors/colors.dart';

class CreatePost extends StatefulWidget {
  final int? postId;
  final String? initialTitle;
  final String? initialContent;
  final VoidCallback? onPostCreated;
  const CreatePost({
    super.key,
    this.postId,
    this.initialTitle,
    this.initialContent,
    this.onPostCreated,
  });

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final ApiService api = ApiService();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  String status = 'published';
  bool isLoading = false;

  Future<void> createPost() async {
      print('CREATE POST FUNCTION CALLED');
    if (titleController.text.trim().isEmpty ||
        contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in the title and content.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final data = await api.postAuth('posts', {
        'title': titleController.text.trim(),
        'content': contentController.text.trim(),
        'status': status,
      });

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (data['data'] != null || data['message'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Post created successfully.'),
            backgroundColor: Colors.green,
          ),
        );
        print('CALLING onPostCreated');
        widget.onPostCreated?.call();
        print('POST CREATED - refresh Home called');
        titleController.clear();
        contentController.clear();

        setState(() {
          status = 'published';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Failed to create post.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating post: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.postId != null) {
      titleController.text = widget.initialTitle ?? '';
      contentController.text = widget.initialContent ?? '';
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
          'Create Post',
          style: GoogleFonts.spaceMono(
            fontSize: 16,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share your thoughts',
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.bistre,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Write something and share it with the WordSpace community.',
              style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 28),

            Text(
              'Title',
              style: GoogleFonts.roboto(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.bistre,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(12),
                   boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    //spreadRadius: 1,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: TextField(
                controller: titleController,
                
                decoration: InputDecoration(
                  hintText: 'Enter your post title',
                  filled: true,
                  
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Content',
              style: GoogleFonts.roboto(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.bistre,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    //spreadRadius: 1,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: TextField(
                controller: contentController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: 'Write your thoughts here...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Status',
              style: GoogleFonts.roboto(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.bistre,
              ),
            ),

            RadioListTile<String>(
              value: 'published',
              groupValue: status,
              title: const Text('Published'),
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  status = value!;
                });
              },
            ),

            RadioListTile<String>(
              value: 'draft',
              groupValue: status,
              title: const Text('Draft'),
              activeColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  status = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : createPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Create Post',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        titleController.clear();
                        contentController.clear();

                        setState(() {
                          status = 'published';
                        });
                      },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
