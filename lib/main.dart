import 'package:flutter/material.dart';

void main() => runApp(const RuralzMathsApp());

class RuralzMathsApp extends StatelessWidget {
  const RuralzMathsApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Ruralz Maths',
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF2E7D5B), scaffoldBackgroundColor: const Color(0xFFF3FBF6)),
    home: const SplashScreen(),
  );
}

class SplashScreen extends StatefulWidget { const SplashScreen({super.key}); @override State<SplashScreen> createState() => _SplashScreenState(); }
class _SplashScreenState extends State<SplashScreen> {
  @override void initState() { super.initState(); Future.delayed(const Duration(seconds: 3), () { if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen())); }); }
  @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.calculate_rounded, size: 88, color: Color(0xFF2E7D5B)), SizedBox(height: 18), Text('Ruralz Maths', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)), SizedBox(height: 12), Text('Developed by D. K. Chavan sir'), Text('MHT-CET Mathematics Practice')]));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const topics = ['Mathematical Logic','Matrices','Trigonometric Functions','Pair of Straight Lines','Vectors & 3D','Line & Plane','Linear Programming','Differentiation','Application of Derivatives','Integration','Definite Integration','Application of Definite Integral','Differential Equation','Probability Distributions','Binomial Distribution'];
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Ruralz Maths')), body: ListView(padding: const EdgeInsets.all(16), children: [const Text('MHT-CET Test Series', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 8), const Text('Choose a topic. Each topic contains 20 planned tests.'), const SizedBox(height: 16), ...topics.map((topic) => Card(child: ListTile(leading: const Icon(Icons.menu_book_rounded), title: Text(topic), subtitle: const Text('20 tests • 50 questions • 90 minutes'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TestListScreen(topic: topic)))))]));
}

class TestListScreen extends StatelessWidget {
  final String topic; const TestListScreen({super.key, required this.topic});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(topic)), body: ListView.builder(padding: const EdgeInsets.all(16), itemCount: 20, itemBuilder: (_, i) => Card(child: ListTile(title: Text('Test ${i + 1}'), subtitle: const Text('50 questions • 90 minutes'), trailing: const Icon(Icons.play_arrow), onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Supabase question integration is pending.'))))));
}
