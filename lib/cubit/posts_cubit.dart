import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pagination_app/data/models/post_model.dart';
import 'package:pagination_app/data/repositories/posts_respository.dart';
part 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  PostsCubit(this.repository) : super(PostsInitial()) {
    loadPosts();
  }

  int page = 1;
  final PostsRepository repository;

  Future<void> loadPosts() async {
    if (state is PostsLoading) return;

    final currentState = state;

    List<Post> oldPosts = [];
    if (currentState is PostsLoaded) {
      oldPosts = currentState.posts;
    }

    emit(PostsLoading(oldPosts, isFirstFetch: page == 1));

    final posts = (state as PostsLoading).oldPosts;
    posts.addAll(await repository.fetchPosts(page));
    page++;

    emit(PostsLoaded(posts));
  }
}
