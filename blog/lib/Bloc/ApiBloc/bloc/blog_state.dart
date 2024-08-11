part of 'blog_bloc.dart';

@immutable
abstract class BlogState {}

class BlogInitial extends BlogState {}

class BlogEventSuccessState extends BlogState {
  final List<dynamic> data;
  BlogEventSuccessState({required this.data});
}

class BlogEventFailureState extends BlogState {
  final String message;
  BlogEventFailureState({required this.message});
}
