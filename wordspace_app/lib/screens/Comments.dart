import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordspace_app/api/api_service.dart';
import 'package:wordspace_app/colors/colors.dart';

class Comments extends StatefulWidget {
  final int postId;

  const Comments({super.key, required this.postId});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final ApiService api = ApiService();
  final TextEditingController commentController = TextEditingController();
int? currentUserId;
  List comments = [];
  bool isLoading = true;
  bool isSending = false;

 @override
  void initState() {
    super.initState();
    loadUser();
  }
Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      currentUserId = prefs.getInt('id');
    });

    getComments();
  }
 Future<void> getComments() async {
    try {
      final data = await api.getAuth('posts/${widget.postId}/comments');

      if (!mounted) return;

      setState(() {
        comments = data['data'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading comments: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
Future<void> addComment() async {
    if (commentController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      isSending = true;
    });

    try {
      final data = await api.postAuth('posts/${widget.postId}/comments', {
        'content': commentController.text.trim(),
      });

      if (!mounted) return;

      if (data['data'] != null) {
        commentController.clear();

        // جلب التعليقات من جديد
        await getComments();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Failed to add comment.'),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (!mounted) return;

      setState(() {
        isSending = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSending = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding comment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
Future<void> deleteComment(int commentId) async {
    try {
      final data = await api.deleteAuth('comments/$commentId');

      if (!mounted) return;

      if (data['message'] == 'Comment deleted successfully.') {
        await getComments();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Failed to delete comment.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting comment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofwhite,

      appBar: AppBar(
        backgroundColor: AppColors.ofwhite,
        elevation: 0,
        title: Text(
          'Comments',
          style: GoogleFonts.spaceMono(
            fontSize: 16,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : comments.isEmpty
                ? const Center(child: Text('No comments yet.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                    final isMyComment = comment['user_id'] == currentUserId;
                      return Card(
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    comment['user_name'] ?? 'Unknown User',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),

                                  if (isMyComment)
                                    IconButton(
                                      onPressed: () {
                                        deleteComment(comment['id']);
                                      },
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              Text(
                                comment['content'] ?? '',
                                style: GoogleFonts.roboto(
                                  fontSize: 15,
                                  color: AppColors.bistre,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          Container(
            padding: const EdgeInsets.all(12),
            color: AppColors.ofwhite,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                IconButton(
                  onPressed: isSending ? null : addComment,
                  icon: isSending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
