import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wordspace_app/CreatePost.dart';
import 'package:wordspace_app/api/api_service.dart';
import 'package:wordspace_app/colors/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordspace_app/screens/Comments.dart';
import 'package:wordspace_app/screens/EditPost.dart';
import 'package:wordspace_app/screens/PostDetails.dart';

class Home extends StatefulWidget {
  final VoidCallback? onLikeChanged;

  const Home({super.key, this.onLikeChanged});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
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

  List posts = [];
  bool isLoading = true;
  String username = '';
  int? currentUserId;
  Set<int> likedPostIds = {};
  Future<void> loadLikedPosts() async {
    for (final post in posts) {
      final postId = post['id'];

      final data = await api.getAuth('posts/$postId/likes');

      if (data['liked_by_me'] == true) {
        likedPostIds.add(postId);
      }
    }
      if (!mounted) return;

    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString('username') ?? '';
      currentUserId = prefs.getInt('id');
    });

    getPosts();
  }

  Future<void> refreshPosts() async {
    await getPosts();
  }

  Future<void> getPosts() async {
    try {
      final data = await api.getAuth('posts');
      final likes = await api.getAuth('posts/47/likes');
      print('LIKES RESPONSE: $likes');
      print('API RESPONSE: $data');
      if (!mounted) return;

      setState(() {
        posts = data['data'] ?? [];
        isLoading = false;
      });
      await loadLikedPosts();
      print('POSTS FROM API: ${data['data']}');
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
      widget.onLikeChanged?.call();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofwhite,

      appBar: AppBar(
        backgroundColor: AppColors.ofwhite,
        title: Text(
          'WordSpace',
          style: GoogleFonts.spaceMono(
            fontSize: 16,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: getPosts,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const SizedBox(height: 8),

                  Text(
                    'Welcome back, $username 👋',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    'Share your thoughts with the world.',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Recent Posts',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: AppColors.bistre,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  if (posts.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 80),
                      child: Center(
                        child: Text(
                          'No posts yet.',
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            color: AppColors.bistre,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  ...posts.map((post) {
                    final bool isMyPost = post['user_id'] == currentUserId;
                    final bool isLiked = likedPostIds.contains(post['id']);
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'By ${post['user_name'] ?? 'Unknown User'}',
                                    style: GoogleFonts.roboto(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),

                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert),
                                  onSelected: (value) async {
                                    if (value == 'edit') {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditPost(
                                            postId: post['id'],
                                            title: post['title'],
                                            content: post['content'],
                                            status: post['status'],
                                          ),
                                        ),
                                      );

                                      if (result == true) {
                                        await getPosts();
                                      }
                                    }

                                    if (value == 'delete') {
                                      deletePost(post['id']);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    if (isMyPost)
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Edit'),
                                      ),

                                    if (isMyPost)
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                  ],
                                ),
                              ],
                            ),
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}
