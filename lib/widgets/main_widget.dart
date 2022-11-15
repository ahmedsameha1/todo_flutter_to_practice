import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_flutter_to_practice/widgets/main_screen.dart';

class MainWidget extends StatelessWidget {
  const MainWidget({Key? key}) : super(key: key);
  static const String title = "Todos List";

  static Widget rootPathBuilder(BuildContext context, GoRouterState state) {
    return const MainScreen();
  }

  GoRouter createGoRouter() {
    return GoRouter(
        routes: <GoRoute>[GoRoute(path: '/', builder: rootPathBuilder)]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: createGoRouter(),
      title: title,
    );
  }
}
