import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_to_practice/app_runner.dart';
import 'package:todo_flutter_to_practice/firebase_options.dart';

import 'widgets/main_widget.dart';

void main() async {
  await (AppRunner(
          const ProviderScope(child: MainWidget()),
          runApp,
          WidgetsFlutterBinding.ensureInitialized,
          Firebase.initializeApp,
          (!kIsWeb && (Platform.isLinux || Platform.isWindows))
              ? const FirebaseOptions(
                  apiKey: '', appId: '', messagingSenderId: '', projectId: '')
              : DefaultFirebaseOptions.currentPlatform)
      .run());
}
