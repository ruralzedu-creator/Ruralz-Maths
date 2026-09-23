import 'package:flutter/material.dart';

void main() {
  runApp(const RuralzMathsApp());
}

class RuralzMathsApp extends StatelessWidget {
  const RuralzMathsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ruralz Maths',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7CBF8A)),
        scaffoldBackgroundColor: const Color(0xFFF2FAF3),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruralz Maths')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Developed by D. K. Chavan sir', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: const Icon(Icons.school_outlined),
                title: const Text('MHT-CET Mathematics'),
                subtitle: const Text('Practice tests and performance tracking'),
                onTap: () {},
              ),
            ),
            const SizedBox(height: 12),
            const Text('Database integration and test navigation will be connected in the next implementation stage.'),
          ],
        ),
      ),
    );
  }
}
