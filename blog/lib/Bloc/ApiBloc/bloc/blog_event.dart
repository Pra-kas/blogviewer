part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

class BlogGetEvent extends BlogEvent {}

class FavoriteClicked extends BlogEvent {
  final bool isFavorite;
  FavoriteClicked({required this.isFavorite});
}

class FavoritePageClikedEvent extends BlogEvent {}