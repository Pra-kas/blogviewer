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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlogBloc()..add(BlogGetEvent()),
      child: BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          const CircularProgressIndicator();
          if (state is BlogEventSuccessState) {
            return blogView(context, state.data);
          }
          else if(state is BlogLoadingState){
            return const Center(child: CircularProgressIndicator());
          }
          return const Scaffold(
            body: Center(
              child: SizedBox(
                width: 400,
                height: 400,
                child: Card(
                  child: Center(child: Text("Error getting API response"))),
              )),
          );
        },
      ),
    );
  }
}

Widget blogView(BuildContext context, List<Blog> blogs) {
  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.black,
      title: const Text(
        'Blogs and Articles',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => FavouriteBlog()));
          }, icon: const Icon(Icons.star_outlined))
      ],
    ),
    body: ListView.builder(
      itemCount: blogs.length,
      itemBuilder: (context, index) {
        final blog = blogs[index];
        return BlogCard(blog: blog);
      },
    ),
  );
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
    isFavorite = widget.blog.isFavorite;
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });

    widget.blog.isFavorite = isFavorite;
    if (isFavorite) {
      await saveFavoriteBlog(widget.blog);
    } else {
      await removeFavoriteBlog(widget.blog);
    }
  }

  Future<void> saveFavoriteBlog(Blog blog) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favBlogs = prefs.getStringList('favoriteBlogs') ?? [];
    favBlogs.add(blog.toJson());
    await prefs.setStringList('favoriteBlogs', favBlogs);
  }

  Future<void> removeFavoriteBlog(Blog blog) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favBlogs = prefs.getStringList('favoriteBlogs') ?? [];
    favBlogs.remove(blog.toJson());
    await prefs.setStringList('favoriteBlogs', favBlogs);
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
                  isFavorite ? Icons.star : Icons.star_border,
                  color: isFavorite ? Colors.yellow : Colors.white,
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
