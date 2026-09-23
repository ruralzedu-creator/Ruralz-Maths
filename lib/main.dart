import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty) {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }
  runApp(const RuralzMathsApp());
}

bool get configured => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
SupabaseClient get db => Supabase.instance.client;

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
  @override void initState() { super.initState(); Future.delayed(const Duration(seconds: 10), () { if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen())); }); }
  @override Widget build(BuildContext context) => const Scaffold(body: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.calculate_rounded, size: 88, color: Color(0xFF2E7D5B)), SizedBox(height: 18), Text('Ruralz Maths', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)), SizedBox(height: 12), Text('Developed by D. K. Chavan sir'), Text('MHT-CET Mathematics Practice')]));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Ruralz Maths')), body: !configured ? const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('Supabase is not configured. Build with SUPABASE_URL and SUPABASE_ANON_KEY.', textAlign: TextAlign.center))) : FutureBuilder<List<dynamic>>(future: db.from('topics').select('id,name,sort_order').order('sort_order'), builder: (context, snap) {
    if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
    if (snap.hasError) return Center(child: Text('Unable to load topics: ${snap.error}'));
    final topics = snap.data ?? [];
    return ListView(padding: const EdgeInsets.all(16), children: [const Text('MHT-CET Test Series', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 8), const Text('Choose a topic. Each test contains 50 questions and 90 minutes.'), const SizedBox(height: 16), ...topics.map((t) => Card(child: ListTile(leading: const Icon(Icons.menu_book_rounded), title: Text(t['name'].toString()), subtitle: const Text('20 tests • 50 questions • 90 minutes'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TestListScreen(topicId: t['id'].toString(), topicName: t['name'].toString()))))) ]);
  }));
}

class TestListScreen extends StatelessWidget {
  final String topicId; final String topicName;
  const TestListScreen({super.key, required this.topicId, required this.topicName});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(topicName)), body: FutureBuilder<List<dynamic>>(future: db.from('tests').select('id,test_number,title,question_count,duration_minutes').eq('topic_id', topicId).order('test_number'), builder: (context, snap) {
    if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
    if (snap.hasError) return Center(child: Text('Unable to load tests: ${snap.error}'));
    final tests = snap.data ?? [];
    return ListView.builder(padding: const EdgeInsets.all(16), itemCount: tests.length, itemBuilder: (_, i) { final t = tests[i]; return Card(child: ListTile(title: Text(t['title']?.toString() ?? 'Test ${t['test_number']}'), subtitle: Text('${t['question_count']} questions • ${t['duration_minutes']} minutes'), trailing: const Icon(Icons.play_arrow), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuestionScreen(testId: t['id'].toString(), title: t['title']?.toString() ?? 'Test ${t['test_number']}')))); });
  }));
}

class QuestionScreen extends StatelessWidget {
  final String testId; final String title;
  const QuestionScreen({super.key, required this.testId, required this.title});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)), body: FutureBuilder<List<dynamic>>(future: db.from('questions').select('question_text,option_a,option_b,option_c,option_d,correct_option,explanation,sort_order').eq('test_id', testId).order('sort_order'), builder: (context, snap) {
    if (snap.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
    if (snap.hasError) return Center(child: Text('Unable to load questions: ${snap.error}'));
    final questions = snap.data ?? [];
    return ListView.builder(padding: const EdgeInsets.all(16), itemCount: questions.length, itemBuilder: (_, i) { final q = questions[i]; return Card(margin: const EdgeInsets.only(bottom: 16), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Q${i + 1}. ${q['question_text']}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)), const SizedBox(height: 12), Text('A. ${q['option_a']}'), Text('B. ${q['option_b']}'), Text('C. ${q['option_c']}'), Text('D. ${q['option_d']}'), const SizedBox(height: 10), Text('Answer: ${q['correct_option']}', style: const TextStyle(fontWeight: FontWeight.bold)), if (q['explanation'] != null) Text('Explanation: ${q['explanation']}')]))); });
  }));
}
