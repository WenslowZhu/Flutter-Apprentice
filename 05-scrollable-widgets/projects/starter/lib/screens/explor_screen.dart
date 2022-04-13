import 'package:flutter/material.dart';
import '../components/components.dart';
import '../models/explore_data.dart';
import '../api/mock_fooderlich_service.dart';

class ExploreScreen extends StatefulWidget {

  const ExploreScreen({Key? key}) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final mockService = MockFooderlichService();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }


  void _scrollListener() {
    if (_scrollController.offset >= 
    _scrollController.position.maxScrollExtent &&
    !_scrollController.position.outOfRange) {
      print('reached the bottom');
    }
    if (_scrollController.offset <= 
    _scrollController.position.minScrollExtent && 
    !_scrollController.position.outOfRange) {
      print('reached the top!');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mockService.getExploreData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done 
        && snapshot.data != null ) {
          final result = snapshot.data! as ExploreData;
          final recipes = result.todayRecipes;
          final friendPosts = result.friendPosts;
          
          return ListView(
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            children: [
              TodayRecipeListView(recipes: recipes),

              const SizedBox(height: 16),

              FriendPostListView(friendPosts: friendPosts),
            ],
          );
          
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class ExploreScreenScollController extends ScrollController {

}