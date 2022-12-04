import 'package:flutter/material.dart';
import 'package:my_notes/themes/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import './screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('fa', 'IR'),
      ],
      path: 'assets/translations',
      startLocale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Note',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeClass.appTheme,
      home: const HomePage(),
    );
  }
}
