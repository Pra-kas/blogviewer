import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:blog/servive/blogApiservice.dart';
import 'package:meta/meta.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  BlogBloc() : super(BlogInitial()) {
    on<BlogGetEvent>(_blocGetEvent);
  }

  FutureOr<void> _blocGetEvent(BlogGetEvent event, Emitter<BlogState> emit) async {
    print("Fetching blogs...");

    try {
      final value = await fetchBlogs(); // Wait for the fetchBlogs function to complete

      if (value['status']) {
        emit(BlogEventSuccessState(data: value['data']));
      } else {
        emit(BlogEventFailureState(message: "Failed to fetch blogs"));
      }
    } catch (e) {
      emit(BlogEventFailureState(message: e.toString()));
    }
  }
}
