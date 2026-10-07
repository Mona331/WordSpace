import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wordspace_app/api/api_service.dart';
import 'package:wordspace_app/colors/colors.dart';
import 'package:wordspace_app/screens/Comments.dart';
import 'package:wordspace_app/screens/PostDetails.dart';

class AdminPosts extends StatefulWidget {
  const AdminPosts({super.key});

  @override
  State<AdminPosts> createState() => _AdminPostsState();
}

class _AdminPostsState extends State<AdminPosts> {
  final ApiService api = ApiService();
  String formatDate(String? date) {
    if (date == null) return '';

    final parsedDate = DateTime.tryParse(date);

    if (parsedDate == null) return '';

    return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
  }

  String formatStatus(String? status) {
    if (status == 'published') {
      return 'Published';
    }

    return 'Draft';
  }
  Set<int> likedPostIds = {};
  List posts = [];
  bool isLoading = true;
  Future<void> getPosts() async {
    try {
      final data = await api.getAuth('posts');

      if (!mounted) return;

      setState(() {
        posts = data['data'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading posts: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
   Future<void> toggleLike(int postId, bool isLiked) async {
    try {
      if (isLiked) {
        await api.deleteAuth('posts/$postId/likes');

        setState(() {
          likedPostIds.remove(postId);
        });
      } else {
        await api.postAuth('posts/$postId/likes', {});

        setState(() {
          likedPostIds.add(postId);
        });
      }

      await getPosts();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating like: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
Future<void> deletePost(int postId) async {
    try {
      final data = await api.deleteAuth('posts/$postId');

      if (!mounted) return;

      if (data['message'] == 'Post deleted successfully.') {
        await getPosts();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post deleted successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Failed to delete post.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting post: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    getPosts();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofwhite,

      appBar: AppBar(
        backgroundColor: AppColors.ofwhite,
        elevation: 0,
        title: Text(
          'Posts',
          style: GoogleFonts.spaceMono(
            fontSize: 18,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'All Posts',
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: AppColors.bistre,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                ...posts.map((post) {
                    final bool isLiked = likedPostIds.contains(post['id']);
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        //mainAxisAlignment: ,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            post['title'] ?? '',
                            style: GoogleFonts.merriweather(
                              fontSize: 18,
                              color: AppColors.bistre,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

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
                          const SizedBox(height: 12),

                          Text(
                            formatDate(post['created_at']),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),

                          Text(
                            formatStatus(post['status']),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: post['status'] == 'published'
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  toggleLike(post['id'], isLiked);
                                },
                                icon: Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 20,
                                  color: isLiked ? Colors.red : Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text('${post['likes_count'] ?? 0}'),

                              const SizedBox(width: 20),

                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Comments(postId: post['id']),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.comment_outlined,
                                  size: 21,
                                ),
                              ),
                              // Text('${post['comments_count'] ?? 0}'),
                              const SizedBox(width: 5),
                              Text('${post['comments_count'] ?? 0}'),
                              IconButton(
                                onPressed: () {
                                  deletePost(post['id']);
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}
