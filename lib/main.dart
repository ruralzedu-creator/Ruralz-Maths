import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://bpyhfufefpjraefcovrw.supabase.co');
const supabasePublishableKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'sb_publishable_F1KtKcCl_MdJtrAMPLjiuA_uYxqKxmo');
const _logoBase64 = '__LOGO__';
const _developerPhotoBase64 = '__PHOTO__';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabasePublishableKey);
  runApp(const RuralzMathsApp());
}

final supabase = Supabase.instance.client;
final logoImage = MemoryImage(base64Decode(_logoBase64));
final developerImage = MemoryImage(base64Decode(_developerPhotoBase64));

class RuralzMathsApp extends StatelessWidget {
  const RuralzMathsApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Ruralz - Maths',
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: const Color(0xFF2E7D5B), scaffoldBackgroundColor: const Color(0xFFF3FBF6)),
    home: const SplashScreen(),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override void initState() { super.initState(); Future.delayed(const Duration(seconds: 10), () { if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen())); }); }
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(28), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Image(image: logoImage, width: 240, height: 190, fit: BoxFit.contain),
    const SizedBox(height: 16),
    ClipOval(child: Image(image: developerImage, width: 120, height: 120, fit: BoxFit.cover)),
    const SizedBox(height: 14),
    const Text('Ruralz - Maths', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
    const SizedBox(height: 8), const Text('Enriching Hopes', style: TextStyle(letterSpacing: 3, color: Color(0xFF68766F))),
    const SizedBox(height: 18), const Text('Developed by D. K. Chavan sir', style: TextStyle(fontWeight: FontWeight.w600)),
    const SizedBox(height: 8), const Text('MHT-CET Mathematics • Offline Test Series', textAlign: TextAlign.center),
  ]))));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Ruralz - Maths', style: TextStyle(fontWeight: FontWeight.bold))),
    body: FutureBuilder<List<dynamic>>(
      future: supabase.from('topics').select('id,name,sort_order').order('sort_order'),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return Center(child: Padding(padding: const EdgeInsets.all(24), child: Text('Unable to load topics: ${snapshot.error}')));
        final topics = snapshot.data ?? <dynamic>[];
        return ListView(padding: const EdgeInsets.all(16), children: [
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFE4F5E9), borderRadius: BorderRadius.circular(22)), child: Row(children: [Image(image: logoImage, width: 82, height: 82, fit: BoxFit.cover), const SizedBox(width: 14), const Expanded(child: Text('MHT-CET Mathematics\nOffline Test Series', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)))])),
          const SizedBox(height: 18), const Text('Topics', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...topics.asMap().entries.map((entry) { final topic = entry.value; return Card(elevation: 0, child: ListTile(leading: CircleAvatar(backgroundColor: const Color(0xFF2E9468), foregroundColor: Colors.white, child: Text('${entry.key + 1}')), title: Text(topic['name'].toString(), style: const TextStyle(fontWeight: FontWeight.w600)), subtitle: const Text('20 tests • 50 questions per test'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TestListScreen(topicId: topic['id'].toString(), topicName: topic['name'].toString()))))); }),
        ]);
      },
    ),
  );
}

class TestListScreen extends StatelessWidget {
  final String topicId; final String topicName;
  const TestListScreen({super.key, required this.topicId, required this.topicName});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(topicName)), body: FutureBuilder<List<dynamic>>(
    future: supabase.from('tests').select('id,test_number,title,question_count,duration_minutes').eq('topic_id', topicId).order('test_number'),
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
      if (snapshot.hasError) return Center(child: Text('Unable to load tests: ${snapshot.error}'));
      final tests = snapshot.data ?? <dynamic>[];
      return ListView.builder(padding: const EdgeInsets.all(16), itemCount: tests.length, itemBuilder: (context, index) { final test = tests[index]; final title = test['title']?.toString() ?? 'Test ${test['test_number']}'; return Card(child: ListTile(title: Text(title), subtitle: Text('${test['question_count']} questions • ${test['duration_minutes']} minutes'), trailing: const Icon(Icons.play_arrow), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuestionScreen(testId: test['id'].toString(), title: title))))); });
    },
  ));
}

class QuestionScreen extends StatelessWidget {
  final String testId; final String title;
  const QuestionScreen({super.key, required this.testId, required this.title});
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)), body: FutureBuilder<List<dynamic>>(
    future: supabase.from('questions').select('question_text,option_a,option_b,option_c,option_d,correct_option,explanation,sort_order').eq('test_id', testId).order('sort_order'),
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
      if (snapshot.hasError) return Center(child: Text('Unable to load questions: ${snapshot.error}'));
      final questions = snapshot.data ?? <dynamic>[];
      return ListView.builder(padding: const EdgeInsets.all(16), itemCount: questions.length, itemBuilder: (context, index) { final q = questions[index]; return Card(margin: const EdgeInsets.only(bottom: 14), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Q${index + 1}. ${q['question_text']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 12), Text('A. ${q['option_a']}'), Text('B. ${q['option_b']}'), Text('C. ${q['option_c']}'), Text('D. ${q['option_d']}'), const SizedBox(height: 10), Text('Answer: ${q['correct_option']}', style: const TextStyle(fontWeight: FontWeight.bold)), if (q['explanation'] != null) Text('Explanation: ${q['explanation']}')]))); });
    },
  ));
}
