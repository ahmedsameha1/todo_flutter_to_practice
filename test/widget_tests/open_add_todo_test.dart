import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_flutter_to_practice/widgets/open_add_todo.dart';

import 'open_add_todo_test.mocks.dart';
import 'skeleton_for_widget_testing.dart';

abstract class GoRouterContextGoFunction {
  void call(String location, {Object? extra});
}

@GenerateMocks([GoRouterContextGoFunction])
void main() {
  const path = " ";
  final goRouterContextGoFunctionCall = MockGoRouterContextGoFunction();
  testWidgets("first test", (WidgetTester widgetTester) async {
    final skeleton = createWidgetInASkeleton(
        OpenNewPageUnderpinnedByFloatingActionButton(
            goRouterContextGoFunctionCall, path));
    await widgetTester.pumpWidget(skeleton);
    expect(find.byType(OpenNewPageUnderpinnedByFloatingActionButton),
        findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    await widgetTester.tap(find.byType(FloatingActionButton));
    verify(goRouterContextGoFunctionCall(path)).called(1);
  });
}
