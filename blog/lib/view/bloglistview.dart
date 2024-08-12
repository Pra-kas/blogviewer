import 'package:blog/Bloc/ApiBloc/bloc/blog_bloc.dart';
import 'package:blog/model/api_model.dart';
import 'package:blog/view/blogdetailview.dart';
import 'package:blog/view/favorite_blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlogListView extends StatefulWidget {
  const BlogListView({super.key});

  @override
  State<BlogListView> createState() => _BlogListViewState();
}

class _BlogListViewState extends State<BlogListView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlogBloc()..add(BlogGetEvent()),
      child: BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          if (state is BlogEventSuccessState) {
            return BlogView(blogs: state.data);
          } else if (state is BlogLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: SizedBox(
                width: 400,
                height: 400,
                child: Card(
                  color: Colors.black,
                  child: Center(
                    child: Text(
                      "Error getting API response",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BlogView extends StatefulWidget {
  final List<Blog> blogs;
  const BlogView({super.key, required this.blogs});

  @override
  State<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Blogs and Articles',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget.blogs.length,
        itemBuilder: (context, index) {
          final blog = widget.blogs[index];
          return BlogCard(blog: blog);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FavouriteBlog()),
          );
          setState(() {
          });
        },
        child: const Icon(Icons.star),
      ),
    );
  }
}

class BlogCard extends StatefulWidget {
  final Blog blog;

  const BlogCard({Key? key, required this.blog}) : super(key: key);

  @override
  _BlogCardState createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favBlogs = prefs.getStringList('favoriteBlogs') ?? [];
    setState(() {
      isFavorite = favBlogs.contains(widget.blog.toJson());
    });
  }

  Future<void> _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favBlogs = prefs.getStringList('favoriteBlogs') ?? [];

    if (isFavorite) {
      favBlogs?.remove(widget.blog.toJson());
    } else {
      favBlogs?.add(widget.blog.toJson());
    }

    await prefs.setStringList('favoriteBlogs', favBlogs);

    setState(() {
      widget.blog.isFavorite = !widget.blog.isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlogDetailView(blog: widget.blog),
          ),
        );
      },
      child: Card(
        color: Colors.black,
        margin: const EdgeInsets.all(10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
            Positioned(
              top: 10.0,
              right: 10.0,
              child: IconButton(
                icon: Icon(
                  widget.blog.isFavorite ? Icons.star : Icons.star_border,
                  color: widget.blog.isFavorite ? Colors.yellow : const Color.fromARGB(255, 126, 100, 100),
                ),
                onPressed: _toggleFavorite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
