import 'package:flutter/material.dart';
import 'presentation/screens/web_view_screen.dart';

{{#enableRemoteConfig}}
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
{{/enableRemoteConfig}}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  {{#enableRemoteConfig}}
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  {{/enableRemoteConfig}}
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebViewScreen(),
    );
  }
}

