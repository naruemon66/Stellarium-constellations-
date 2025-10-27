import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'provider/star_provider.dart';
import 'screens/star_list_screen.dart';
import 'screens/star_add_edit_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ConstellaApp());
}

class ConstellaApp extends StatelessWidget {
  const ConstellaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StarProvider(),
      child: MaterialApp(
        title: 'Constella',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        routes: {
          StarListScreen.routeName: (_) => const StarListScreen(),
          StarAddEditScreen.routeName: (_) => const StarAddEditScreen(),
        },
        initialRoute: StarListScreen.routeName,
      ),
    );
  }
}
