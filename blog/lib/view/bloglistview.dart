import 'package:blog/Bloc/ApiBloc/bloc/blog_bloc.dart';
import 'package:blog/view/blogdetailview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      child: BlocConsumer<BlogBloc, BlogState>(
        builder: (context, state) {
          if (state is BlogEventSuccessState) {
            // Pass the blogs data to the blogView widget
            return blogView(context, state.data);
          }
          return const Center(child: CircularProgressIndicator()); // Show a loading indicator while fetching data
        },
        listener: (context, state) {
          if (state is BlogEventFailureState) {
            // Display error message if needed
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
      ),
    );
  }
}

Widget blogView(BuildContext context, List<dynamic> blogs) {
  return Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.black,
      title: const Text('Blogs and Articles',
      style: TextStyle(
        color: Colors.white
      ),),
      centerTitle: true,
    ),
    body: ListView.builder(
      itemCount: blogs.length,
      itemBuilder: (context, index) {
        final blog = blogs[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlogDetailView(blog: blog),
              ),
            );
          },
          child: Card(
            color: Colors.black,
            margin: const EdgeInsets.all(10.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full-width image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15.0),
                  ),
                  child: Image.network(
                    blog['image_url'],
                    width: double.infinity,
                    height: 180.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    blog['title'],
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
          ),
        );
      },
    ),
  );
}
