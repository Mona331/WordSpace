import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wordspace_app/api/api_service.dart';
import 'package:wordspace_app/colors/colors.dart';
import 'package:intl/intl.dart';
import 'package:wordspace_app/screens/Comments.dart';
import 'package:wordspace_app/screens/EditPost.dart';
import 'package:wordspace_app/screens/PostDetails.dart';

class Dashboard extends StatefulWidget {
  final VoidCallback? onLikeChanged;

  const Dashboard({super.key, this.onLikeChanged});

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  final ApiService api = ApiService();

  bool isLoading = true;

  int publishedPosts = 0;
  int draftPosts = 0;
  int totalPosts = 0;
  List<dynamic> publishedPostsList = [];
  List<dynamic> draftPostsList = [];
  Set<int> likedPosts = {};
  Future<void> loadLikedPosts() async {
    for (final post in publishedPostsList) {
      final postId = post['id'];

      final data = await api.getAuth('posts/$postId/likes');

      if (data['liked_by_me'] == true) {
        likedPosts.add(postId);
      }
    }

    if (!mounted) return;

    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    print('DASHBOARD INIT: ${identityHashCode(this)}');
    getDashboard();
  }

  Future<void> getDashboard() async {
    try {
      final data = await api.getAuth('dashboard');

      if (!mounted) return;

      setState(() {
        publishedPosts = data['published_count'] ?? 0;
        draftPosts = data['draft_count'] ?? 0;
        totalPosts = publishedPosts + draftPosts;

        publishedPostsList = data['published_posts'] ?? [];
        draftPostsList = data['draft_posts'] ?? [];

        isLoading = false;
      });
      await loadLikedPosts();
    } catch (e) {
      print('4 - ERROR: $e');

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

  Future<void> toggleLike(int postId, bool isLiked) async {
    try {
      if (isLiked) {
        await api.deleteAuth('posts/$postId/likes');
        likedPosts.remove(postId);
      } else {
        await api.postAuth('posts/$postId/likes', {});
        likedPosts.add(postId);
      }

      
      await getDashboard();
      widget.onLikeChanged?.call();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> deletePost(int postId) async {
    try {
      await api.deleteAuth('posts/$postId');

      await getDashboard();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post deleted successfully')),
      );
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
    print(
      'DASHBOARD BUILD: ${identityHashCode(this)} → $publishedPosts / $draftPosts / $totalPosts',
    );
    return Scaffold(
      backgroundColor: AppColors.ofwhite,
      appBar: AppBar(
        backgroundColor: AppColors.ofwhite,
        elevation: 0,
        title: Text(
          'Personal Space',
          style: GoogleFonts.spaceMono(
            fontSize: 18,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Card(
                            color: AppColors.ofwhite,
                            shadowColor: AppColors.primary,
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  Text(
                                    '$publishedPosts',
                                    style: GoogleFonts.spaceMono(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  const Text(
                                    'Published',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Card(
                            color: AppColors.ofwhite,
                            shadowColor: AppColors.primary,
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  Text(
                                    '$draftPosts',
                                    style: GoogleFonts.spaceMono(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  const Text(
                                    'Draft',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Expanded(
                          child: Card(
                            color: AppColors.ofwhite,
                            shadowColor: AppColors.primary,
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                children: [
                                  Text(
                                    '$totalPosts',
                                    style: GoogleFonts.spaceMono(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  const Text(
                                    'Total',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Published Posts',
                        style: GoogleFonts.spaceMono(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...publishedPostsList.map((post) {
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 9,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post['title'] ?? '',
                                style: GoogleFonts.merriweather(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                post['content'] ?? '',
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
                              const SizedBox(height: 10),

                              Text(
                                DateFormat('MMM d, yyyy · h:mm a').format(
                                  DateTime.parse(post['created_at']).toLocal(),
                                ),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      final postId = post['id'];
                                      final isLiked = likedPosts.contains(
                                        postId,
                                      );

                                      toggleLike(postId, isLiked);
                                    },
                                    icon: Icon(
                                      likedPosts.contains(post['id'])
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                    ),
                                    color: AppColors.primary,
                                  ),

                                  Text(
                                    '${post['likes_count'] ?? 0}',
                                    style: const TextStyle(fontSize: 13),
                                  ),

                                  const SizedBox(width: 12),

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
                                    color: AppColors.primary,
                                  ),

                                  Text(
                                    '${post['comments_count'] ?? 0}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  const SizedBox(width: 8),

                                  IconButton(
                                    onPressed: () {
                                      deletePost(post['id']);
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 21,
                                    ),
                                    color: Colors.red,
                                  ),
                                  IconButton(
                                    onPressed: () async {
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
                                        await getDashboard();
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 21,
                                    ),
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              Text(
                                'by ${post['user']['name']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 25),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Drafts',
                        style: GoogleFonts.spaceMono(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  ...draftPostsList.map((post) {
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 6,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post['title'] ?? '',
                                style: GoogleFonts.merriweather(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                post['content'] ?? '',
                                style: const TextStyle(fontSize: 14),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                DateFormat('MMM d, yyyy · h:mm a').format(
                                  DateTime.parse(post['created_at']).toLocal(),
                                ),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
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
                                        await getDashboard();
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 21,
                                    ),
                                    color: AppColors.primary,
                                  ),

                                  IconButton(
                                    onPressed: () {
                                      deletePost(post['id']);
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 21,
                                    ),
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ],
                          ),
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
