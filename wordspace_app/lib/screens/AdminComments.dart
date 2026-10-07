import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wordspace_app/api/api_service.dart';
import 'package:wordspace_app/colors/colors.dart';

class AdminComments extends StatefulWidget {
  const AdminComments({super.key});

  @override
  State<AdminComments> createState() => _AdminCommentsState();
}

class _AdminCommentsState extends State<AdminComments> {
  final ApiService api = ApiService();

  List comments = [];
  bool isLoading = true;

  Future<void> getComments() async {
    try {
      final data = await api.getAuth('admin/comments');

      print('ADMIN COMMENTS: $data');

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
Future<void> deleteComment(int commentId) async {
    try {
      final data = await api.deleteAuth('admin/comments/$commentId');

      if (!mounted) return;

      if (data['message'] == 'Comment deleted successfully.') {
        await getComments();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comment deleted successfully.'),
            backgroundColor: Colors.green,
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
  String formatDate(String? date) {
    if (date == null) return '';

    final parsedDate = DateTime.tryParse(date);

    if (parsedDate == null) return '';

    return DateFormat('MMM d, yyyy · h:mm a').format(parsedDate.toLocal());
  }

  @override
  void initState() {
    super.initState();
    getComments();
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
            fontSize: 18,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : comments.isEmpty
          ? const Center(child: Text('No comments yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              comment['user']['name'] ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Delete Comment'),
                                      content: const Text(
                                        'Are you sure you want to delete this comment?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirm == true) {
                                  await deleteComment(comment['id']);
                                }
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Text(
                          comment['content'] ?? '',
                          style: GoogleFonts.roboto(
                            fontSize: 15,
                            color: AppColors.bistre,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          'Post: ${comment['post']['title'] ?? ''}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          formatDate(comment['created_at']),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
