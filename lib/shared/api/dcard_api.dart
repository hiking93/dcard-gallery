import 'dart:convert';

import 'package:dcard_gallery/shared/model/forum.dart';
import 'package:dcard_gallery/shared/model/post.dart';
import 'package:http/http.dart' as http;

class DcardApiHelper {
  static const String _BASE_URL = 'www.dcard.tw';

  static Future<List<Post>> fetchPosts(
      {String forum, int before, int limit}) async {
    Map<String, String> queryParameters = {};
    if (before != null) queryParameters["before"] = before.toString();
    if (limit != null) queryParameters["limit"] = limit.toString();
    String path = forum == null ? '/_api/posts' : '/_api/forums/$forum/posts';
    Uri uri = new Uri.https(_BASE_URL, path, queryParameters);

    final response = await http.get(uri);
    var statusCode = response.statusCode;
    if (statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson.map((jsonElement) {
        return Post.fromJson(jsonElement);
      }).toList();
    } else {
      throw Exception('Failed to load posts: $statusCode, ${response.body}');
    }
  }

  static Future<List<Forum>> fetchForums() async {
    Map<String, String> queryParameters = {};
    String path = '/_api/forums';
    Uri uri = new Uri.https(_BASE_URL, path, queryParameters);

    final response = await http.get(uri);
    var statusCode = response.statusCode;
    if (statusCode == 200) {
      List responseJson = json.decode(response.body);
      return responseJson.map((jsonElement) {
        return Forum.fromJson(jsonElement);
      }).toList();
    } else {
      throw Exception('Failed to load forums: $statusCode, ${response.body}');
    }
  }
}
