part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

class BlogGetEvent extends BlogEvent {}

class FavoriteClicked extends BlogEvent {
  final bool click;
  FavoriteClicked({required this.click});
}

class FavoritePageClikedEvent extends BlogEvent {}