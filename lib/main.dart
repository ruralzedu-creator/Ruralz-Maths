import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _defaultSupabaseUrl = 'https://bpyhfufefpjraefcovrw.supabase.co';
const _defaultSupabaseKey = 'sb_publishable_F1KtKcCl_MdJtrAMPLjiuA_uYxqKxmo';
const _envSupabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _envSupabaseKey = String.fromEnvironment('SUPABASE_ANON_KEY');
const supabaseUrl = _envSupabaseUrl.isEmpty ? _defaultSupabaseUrl : _envSupabaseUrl;
const supabaseKey = _envSupabaseKey.isEmpty ? _defaultSupabaseKey : _envSupabaseKey;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseKey);
  runApp(const RuralzMathsApp());
}

final supabase = Supabase.instance.client;

class RuralzMathsApp extends StatelessWidget {
  const RuralzMathsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ruralz - Maths',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2E7D5B),
        scaffoldBackgroundColor: const Color(0xFFF3FBF6),
      ),
      home: const SplashScreen(),
    );
  }
}

class RuralzLogo extends StatelessWidget {
  final double size;
  const RuralzLogo({super.key, this.size = 110});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFE4F5E9),
        borderRadius: BorderRadius.circular(size * 0.22),
      ),
      child: Icon(Icons.spa, size: size * 0.55, color: const Color(0xFF2E7D5B)),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const RuralzLogo(size: 180),
                const SizedBox(height: 20),
                const CircleAvatar(
                  radius: 58,
                  backgroundColor: Color(0xFFD7EEDF),
                  child: Icon(Icons.person, size: 64, color: Color(0xFF2E7D5B)),
                ),
                const SizedBox(height: 18),
                const Text('Ruralz - Maths', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                const Text('Enriching Hopes', style: TextStyle(letterSpacing: 3, color: Color(0xFF68766F))),
                const SizedBox(height: 18),
                const Text('Developed by D. K. Chavan sir', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                const Text('MHT-CET Mathematics • Offline Test Series', textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruralz - Maths', style: TextStyle(fontWeight: FontWeight.bold))),
      body: FutureBuilder<List<dynamic>>(
        future: supabase.from('topics').select('id,name,sort_order').order('sort_order'),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Padding(padding: const EdgeInsets.all(24), child: Text('Unable to load topics: ${snapshot.error}')));
          }
          final topics = snapshot.data ?? <dynamic>[];
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFE4F5E9), borderRadius: BorderRadius.circular(22)),
                child: const Row(children: [RuralzLogo(size: 78), SizedBox(width: 14), Expanded(child: Text('MHT-CET Mathematics\nOffline Test Series', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16))) ]),
              ),
              const SizedBox(height: 18),
              const Text('Topics', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...topics.asMap().entries.map((entry) {
                final topic = entry.value;
                return Card(
                  elevation: 0,
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: const Color(0xFF2E9468), foregroundColor: Colors.white, child: Text('${entry.key + 1}')),
                    title: Text(topic['name'].toString(), style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('20 tests • 50 questions per test'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TestListScreen(topicId: topic['id'].toString(), topicName: topic['name'].toString()))),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

class TestListScreen extends StatelessWidget {
  final String topicId;
  final String topicName;
  const TestListScreen({super.key, required this.topicId, required this.topicName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(topicName)),
      body: FutureBuilder<List<dynamic>>(
        future: supabase.from('tests').select('id,test_number,title,question_count,duration_minutes').eq('topic_id', topicId).order('test_number'),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Unable to load tests: ${snapshot.error}'));
          final tests = snapshot.data ?? <dynamic>[];
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tests.length,
            itemBuilder: (context, index) {
              final test = tests[index];
              final title = test['title']?.toString() ?? 'Test ${test['test_number']}';
              return Card(
                child: ListTile(
                  title: Text(title),
                  subtitle: Text('${test['question_count']} questions • ${test['duration_minutes']} minutes'),
                  trailing: const Icon(Icons.play_arrow),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuestionScreen(testId: test['id'].toString(), title: title))),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class QuestionScreen extends StatelessWidget {
  final String testId;
  final String title;
  const QuestionScreen({super.key, required this.testId, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<List<dynamic>>(
        future: supabase.from('questions').select('question_text,option_a,option_b,option_c,option_d,correct_option,explanation,sort_order').eq('test_id', testId).order('sort_order'),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Unable to load questions: ${snapshot.error}'));
          final questions = snapshot.data ?? <dynamic>[];
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Q${index + 1}. ${question['question_text']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 12),
                    Text('A. ${question['option_a']}'),
                    Text('B. ${question['option_b']}'),
                    Text('C. ${question['option_c']}'),
                    Text('D. ${question['option_d']}'),
                    const SizedBox(height: 10),
                    Text('Answer: ${question['correct_option']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (question['explanation'] != null) Text('Explanation: ${question['explanation']}'),
                  ]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
