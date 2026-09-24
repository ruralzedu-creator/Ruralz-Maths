import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://bpyhfufefpjraefcovrw.supabase.co';
const supabaseKey = 'sb_publishable_F1KtKcCl_MdJtrAMPLjiuA_uYxqKxmo';
const green = Color(0xFF2E7D4F);
const pale = Color(0xFFF2FAF4);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseKey);
  runApp(const RuralzApp());
}

class RuralzApp extends StatelessWidget {
  const RuralzApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ruralz - Maths',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: green,
          scaffoldBackgroundColor: pale,
        ),
        home: const Splash(),
      );
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Home()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image.asset(
                      'ruralz-logo.jpg',
                      width: 230,
                      height: 190,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'D. K. Chavan Sir.png',
                      width: 230,
                      height: 230,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Ruralz - Maths',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF17221C)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Developed by D. K. Chavan sir',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'MHT-CET Mathematics Practice',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<dynamic>> future;

  @override
  void initState() {
    super.initState();
    future = loadTopics();
  }

  Future<List<dynamic>> loadTopics() async {
    final response = await Supabase.instance.client
        .from('topics')
        .select('id,name,sort_order')
        .order('sort_order')
        .timeout(const Duration(seconds: 15));
    return response;
  }

  void retry() => setState(() => future = loadTopics());

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Ruralz - Maths')),
        body: FutureBuilder<List<dynamic>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator(color: green));
            }
            if (snapshot.hasError) {
              return ErrorPanel(
                title: 'Unable to load topics',
                error: snapshot.error.toString(),
                onRetry: retry,
              );
            }
            final list = snapshot.data ?? [];
            if (list.isEmpty) {
              return ErrorPanel(
                title: 'No topics found',
                error: 'The request succeeded but returned zero topics.',
                onRetry: retry,
              );
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2F4E7),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('MHT-CET Mathematics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Online Test Series'),
                      Text('20 Tests • 50 Questions • 90 Minutes'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Topics', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ...list.map(
                  (topic) => Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: green,
                        foregroundColor: Colors.white,
                        child: Text('${topic['sort_order']}'),
                      ),
                      title: Text('${topic['name']}'),
                      subtitle: const Text('20 Tests • 50 Questions'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Tests(
                            topicId: '${topic['id']}',
                            name: '${topic['name']}',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
}

class Tests extends StatelessWidget {
  final String topicId;
  final String name;

  const Tests({super.key, required this.topicId, required this.name});

  Future<List<dynamic>> load() async => await Supabase.instance.client
      .from('tests')
      .select('id,test_number,title,question_count,duration_minutes')
      .eq('topic_id', topicId)
      .order('test_number')
      .timeout(const Duration(seconds: 15));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(name)),
        body: FutureBuilder<List<dynamic>>(
          future: load(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator(color: green));
            }
            if (snapshot.hasError) {
              return ErrorPanel(
                title: 'Unable to load tests',
                error: snapshot.error.toString(),
                onRetry: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Tests(topicId: topicId, name: name),
                  ),
                ),
              );
            }
            final list = snapshot.data ?? [];
            if (list.isEmpty) return const Center(child: Text('No tests found'));
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final test = list[index];
                return Card(
                  child: ListTile(
                    title: Text('${test['title'] ?? 'Test ${test['test_number']}'}'),
                    subtitle: Text('${test['question_count']} Questions • ${test['duration_minutes']} Minutes'),
                  ),
                );
              },
            );
          },
        ),
      );
}

class ErrorPanel extends StatelessWidget {
  final String title;
  final String error;
  final VoidCallback onRetry;

  const ErrorPanel({
    super.key,
    required this.title,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 58, color: green),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              SelectableText(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ),
        ),
      );
}
