import 'package:flutter/material.dart';
import 'package:arcgis_maps/arcgis_maps.dart';

import 'login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

 
  ArcGISEnvironment.apiKey = 'AAPTafzAr0EfCb8SEsd3l9bgszw..Ye9hTWzGq-1pOJ37-UjSB9RLDwnnVcbj-69hQzHiINSCHdeLov8weVVwYtIRMWHcKCsUYGDTel3fLqoVtcGZKf_2YEWKzlcbsGA0pIARB-OK1w8odwRVUfJTdliFPuJI1etIxZcMJ7ttnfdbPsx1TnjmmM-dvc5QIV-oQh804FE6mBDS4yLbGrP1YWtHY5P4BnRX1hTl-rdetwSEk1TeKn85NrJdhYxfZIsgLgNojF_W4LgDsHapAT1_Zki67CiY';

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Pahad Alert System',

    

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1769E0),
          brightness: Brightness.light,
        ),

        scaffoldBackgroundColor: const Color(0xFFF6F8FC),

        fontFamily: 'Roboto',

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF172033),
          elevation: 0,
          centerTitle: false,
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFE1E5EC),
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFFE1E5EC),
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF1769E0),
              width: 1.5,
            ),
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1769E0),
            foregroundColor: Colors.white,

            minimumSize: const Size(
              double.infinity,
              52,
            ),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),

            elevation: 0,
          ),
        ),
      ),

     

      home: const LoginScreen(),
    );
  }
}