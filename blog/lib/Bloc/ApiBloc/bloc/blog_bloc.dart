import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:blog/model/api_model.dart';
import 'package:blog/service/blogApiservice.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

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
      final value = await fetchBlogs(); 
      print(value['status']);
      if (value['status']) {
        emit(BlogEventSuccessState(data: value['data']));
      } else {
      print("Error state");
        emit(BlogEventFailureState(message: "Failed to fetch blogs"));
      }
    } catch (e) {
      print("Error state");
        emit(BlogEventFailureState(message: e.toString()));
    }
  }

  FutureOr<void> favouriteclicked(FavoriteClicked event, Emitter<BlogState> emit) {
    print("Button clicked");
    emit(FavoriteClickedState(click: !event.click));
  }

  FutureOr<void> favouritePageClicked(FavoritePageClikedEvent event, Emitter<BlogState> emit) {
    print("Working");
    emit(FavoritePageCliked());
  }
}
