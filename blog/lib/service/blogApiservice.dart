import 'dart:convert';
import 'package:blog/model/api_model.dart';
import 'package:http/http.dart' as http;

Future<dynamic> fetchBlogs() async {
  const String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
  const String adminSecret = '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

  try {
    final response = await http.get(Uri.parse(url), headers: {
      'x-hasura-admin-secret': adminSecret,
    });

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data.containsKey('blogs')) {
        List<Blog> blogs = (data['blogs'] as List).map((blogData) {
          return Blog(
            id: blogData['id'],
            title: blogData['title'],
            imageUrl: blogData['image_url'],
            isFavorite: false,
          );
        }).toList();

        print("Blogs fetched successfully: $blogs");
        return {"status": true, "data": blogs};
      } else {
        return {"status": false, "data": [], "error": "'blogs' key not found in response"};
      }
    } else {
      return {"status": false, "data": [], "error": "Failed with status code ${response.statusCode}"};
    }
  } catch (e) {
    print("Exception caught: $e");
    return {"status": false, "data": [], "error": e.toString()};
  }
}
