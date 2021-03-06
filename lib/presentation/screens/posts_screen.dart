import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_app/cubit/posts_cubit.dart';
import 'package:pagination_app/data/models/post_model.dart';

class PostsView extends StatelessWidget {
  final scrollController = ScrollController();

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge && scrollController.position.pixels != 0)
        BlocProvider.of<PostsCubit>(context).loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    setupScrollController(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Posts"),
      ),
      body: BlocBuilder<PostsCubit, PostsState>(builder: (context, state) {
        if (state is PostsLoading && state.isFirstFetch) {
          return _loadingIndicator();
        }

        List<Post> posts = [];
        bool isLoading = false;

        if (state is PostsLoading) {
          posts = state.oldPosts;
          isLoading = !isLoading;
        } else if (state is PostsLoaded) {
          posts = state.posts;
        }

        return ListView.separated(
          controller: scrollController,
          itemBuilder: (context, index) {
            if (index < posts.length)
              return _post(posts[index], context);
            else {
              scrollController.jumpTo(scrollController.position.maxScrollExtent + 75.0);
              return _loadingIndicator();
            }
          },
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.grey[400],
            );
          },
          itemCount: posts.length + (isLoading ? 1 : 0),
        );
      }),
    );
  }

  Padding _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Container _post(Post post, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${post.id}. ${post.title}",
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.0),
          Text(post.body)
        ],
      ),
    );
  }
}
