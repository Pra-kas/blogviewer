part of 'blog_bloc.dart';

@immutable
abstract class BlogState {}

class BlogInitial extends BlogState {}

class BlogEventSuccessState extends BlogState {
  final List<Blog> data;
  BlogEventSuccessState({required this.data});
}

class BlogEventFailureState extends BlogState {
  final String message;
  BlogEventFailureState({required this.message});
}

class FavoriteClickedState extends BlogState {
  final bool click;
  FavoriteClickedState({required this.click});
}

class BlogLoadingState extends BlogState {}

class FavoriteNotClickedState extends BlogState {}


class FavoritePageCliked extends BlogState {}