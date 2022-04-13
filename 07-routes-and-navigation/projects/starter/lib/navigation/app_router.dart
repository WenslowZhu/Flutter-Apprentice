import 'package:flutter/material.dart';
import 'package:fooderlich/screens/screens.dart';
import '../models/models.dart';

class AppRouter extends RouterDelegate 
  with ChangeNotifier, PopNavigatorRouterDelegateMixin {

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final AppStateManager appStateManager;
  final GroceryManager groceryManager;
  final ProfileManager profileManager;

  AppRouter({
    required this.appStateManager,
    required this.groceryManager,
    required this.profileManager
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    groceryManager.addListener(notifyListeners);
    profileManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    groceryManager.removeListener(notifyListeners);
    profileManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
        if (!appStateManager.isInitialized) SplashScreen.page(),

        if (appStateManager.isInitialized && !appStateManager.isLoggedIn) 
          LoginScreen.page(),

        if (appStateManager.isLoggedIn 
          && !appStateManager.isOnboardingCompleted)
          OnboardingScreen.page(),

        if (appStateManager.isOnboardingCompleted) 
          Home.page(appStateManager.getSelectedTab),
        // TODO: Add Home
        // TODO: Create new item
        // TODO: Select GroceryItemScreen
        // TODO: Add Profile Screen
        // TODO: Add WebView Screen”
      ]
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async => null;

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }
    if (route.settings.name == FooderlichPages.onboardingPath) {
      appStateManager.logout();
    }
  // TODO: Handle state when user closes grocery item screen
  // TODO: Handle state when user closes profile screen
  // TODO: Handle state when user closes WebView screen”

    return true;
  }
}