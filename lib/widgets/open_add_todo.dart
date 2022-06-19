import 'package:flutter/material.dart';

class OpenNewPageUnderpinnedByFloatingActionButton extends StatelessWidget {
  final Function(String location, {Object? extra}) goRouterGoCall;
  final String path;
  const OpenNewPageUnderpinnedByFloatingActionButton(
      this.goRouterGoCall, this.path,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(onPressed: () {
      goRouterGoCall(path);
    });
  }
}
