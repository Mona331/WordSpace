import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class PostService {
  Future<List<Post>> getPosts() async {
    final response = await http.get(
      Uri.parse('http://localhost:8000/api/posts'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List postsJson = data['data'];

      return postsJson.map((postJson) => Post.fromJson(postJson)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
