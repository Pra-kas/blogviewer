import 'package:blog/model/api_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteBlog extends StatefulWidget {
  @override
  State<FavouriteBlog> createState() => _FavouriteBlogState();
}

class _FavouriteBlogState extends State<FavouriteBlog> {
  List<Blog> favBlogs = [];

  @override
  void initState() {
    super.initState();
    loadFavoriteBlogs();
  }

  Future<void> loadFavoriteBlogs() async {
    List<Blog> blogs = await getFavoriteBlogs();
    setState(() {
      favBlogs = blogs;
    });
  }

  Future<void> removeFavoriteBlog(Blog blog) async {
    await deleteFavoriteBlog(blog);
    loadFavoriteBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Favourites", style: TextStyle(color: Colors.white)),
        forceMaterialTransparency: true,
      ),
      body: favBlogs.isEmpty
          ? const Center(
              child: Text(
                'No favorites yet',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: favBlogs.length,
              itemBuilder: (context, index) {
                final blog = favBlogs[index];
                return BlogCard(
                  blog: blog,
                  onRemove: () {
                    removeFavoriteBlog(blog);
                  }, // Pass the removal function
                );
              },
            ),
    );
  }
}

class BlogCard extends StatefulWidget {
  final Blog blog;
  final VoidCallback onRemove;

  const BlogCard({Key? key, required this.blog, required this.onRemove})
      : super(key: key);

  @override
  _BlogCardState createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15.0),
                ),
                child: Image.network(
                  widget.blog.imageUrl,
                  width: double.infinity,
                  height: 180.0,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10.0,
                right: 10.0,
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: widget.onRemove,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              widget.blog.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}

Future<void> deleteFavoriteBlog(Blog blog) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? favBlogs = prefs.getStringList('favoriteBlogs') ?? [];
  favBlogs.remove(blog.toJson());
  await prefs.setStringList('favoriteBlogs', favBlogs);
}

Future<List<Blog>> getFavoriteBlogs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? favBlogs = prefs.getStringList('favoriteBlogs') ?? [];
  return favBlogs
      .map((json) => Blog.fromJson(json))
      .toList(); // Assuming `Blog` class has `fromJson` method
}
