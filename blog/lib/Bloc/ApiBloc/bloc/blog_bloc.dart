import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:blog/model/api_model.dart';
import 'package:blog/service/blogApiservice.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  BlogBloc() : super(BlogInitial()) {
    on<BlogGetEvent>(_blocGetEvent);
    on<FavoriteClicked>(favouriteclicked);
    on<FavoritePageClikedEvent>(favouritePageClicked);
  }

  FutureOr<void> _blocGetEvent(BlogGetEvent event, Emitter<BlogState> emit) async {
    print("Fetching blogs...");

    try {
      emit(BlogLoadingState());

      final blogs = await _getStoredBlogs();
      if (blogs.isNotEmpty) {
        print("Using stored blogs");
        print(blogs);
        emit(BlogEventSuccessState(data: blogs));
      } else {
        final value = await fetchBlogs();
        print(value['status']);
        if (value['status']) {
          final blogList = value['data'] as List<Blog>;
          await _storeBlogs(blogList);  
          emit(BlogEventSuccessState(data: blogList));
        } else {
          print("Error state");
          emit(BlogEventFailureState(message: "Failed to fetch blogs"));
        }
      }
    } catch (e) {
      print("Error state");
      emit(BlogEventFailureState(message: e.toString()));
    }
  }

  FutureOr<void> favouriteclicked(FavoriteClicked event, Emitter<BlogState> emit) {
    print("Button clicked");
    emit(FavoriteClickedState(isFavorite: !event.isFavorite));
  }

  FutureOr<void> favouritePageClicked(FavoritePageClikedEvent event, Emitter<BlogState> emit) {
    print("Working");
    emit(FavoritePageCliked());
  }

  Future<void> _storeBlogs(List<Blog> blogs) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> blogJsonList = blogs.map((blog) => jsonEncode(blog.toJson())).toList();
    await prefs.setStringList('storedBlogs', blogJsonList);
  }

  Future<List<Blog>> _getStoredBlogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? blogJsonList = prefs.getStringList('storedBlogs');

    if (blogJsonList != null && blogJsonList.isNotEmpty) {
      return blogJsonList.map((blogJson) => Blog.fromJson(jsonDecode(blogJson))).toList();
    } else {
      return [];
    }
  }
}
