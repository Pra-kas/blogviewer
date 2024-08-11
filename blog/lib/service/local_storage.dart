import 'package:blog/model/api_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveFavoriteBlog(Blog blog) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? favBlogs = prefs.getStringList('favoriteBlogs') ?? [];  
  favBlogs.add(blog.toJson());
  await prefs.setStringList('favoriteBlogs', favBlogs);
}

Future<List<Blog>> getFavoriteBlogs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? favBlogs = prefs.getStringList('favoriteBlogs') ?? [];
  
  return favBlogs.map((json) => Blog.fromJson(json)).toList();
}
