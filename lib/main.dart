import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://bpyhfufefpjraefcovrw.supabase.co';
const supabaseKey = 'sb_publishable_F1KtKcCl_MdJtrAMPLjiuA_uYxqKxmo';
const green = Color(0xFF2E7D4F);
const pale = Color(0xFFF2FAF4);

const localTopics = <Map<String, dynamic>>[
  {'id': 'local-01', 'name': 'Mathematical Logic', 'sort_order': 1},
  {'id': 'local-02', 'name': 'Matrices', 'sort_order': 2},
  {'id': 'local-03', 'name': 'Trigonometric Functions', 'sort_order': 3},
  {'id': 'local-04', 'name': 'Pair of Straight Lines', 'sort_order': 4},
  {'id': 'local-05', 'name': 'Vectors and 3 Dimensional Geometry', 'sort_order': 5},
  {'id': 'local-06', 'name': 'Line and Plane', 'sort_order': 6},
  {'id': 'local-07', 'name': 'Linear Programming', 'sort_order': 7},
  {'id': 'local-08', 'name': 'Differentiation', 'sort_order': 8},
  {'id': 'local-09', 'name': 'Application of Derivatives', 'sort_order': 9},
  {'id': 'local-10', 'name': 'Integration', 'sort_order': 10},
  {'id': 'local-11', 'name': 'Definite Integration', 'sort_order': 11},
  {'id': 'local-12', 'name': 'Application of Definite Integral', 'sort_order': 12},
  {'id': 'local-13', 'name': 'Differential Equation', 'sort_order': 13},
  {'id': 'local-14', 'name': 'Probability Distributions', 'sort_order': 14},
  {'id': 'local-15', 'name': 'Binomial Distribution', 'sort_order': 15},
];

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
                    child: Image.asset('ruralz-logo.jpg', width: 230, height: 190, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset('D. K. Chavan Sir.png', width: 230, height: 230, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 18),
                  const Text('Ruralz - Maths', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF17221C))),
                  const SizedBox(height: 8),
                  const Text('Developed by D. K. Chavan sir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center),
                  const SizedBox(height: 6),
                  const Text('MHT-CET Mathematics Practice', textAlign: TextAlign.center),
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
  bool offlineMode = false;

  @override
  void initState() {
    super.initState();
    future = loadTopics();
  }

  Future<List<dynamic>> loadTopics() async {
    try {
      final response = await Supabase.instance.client
          .from('topics')
          .select('id,name,sort_order')
          .order('sort_order')
          .timeout(const Duration(seconds: 15));
      return response;
    } catch (_) {
      if (mounted) setState(() => offlineMode = true);
      return localTopics;
    }
  }

  void retry() => setState(() {
        offlineMode = false;
        future = loadTopics();
      });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Ruralz - Maths')),
        body: FutureBuilder<List<dynamic>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator(color: green));
            }
            final list = snapshot.data ?? localTopics;
            return Column(
              children: [
                if (offlineMode)
                  MaterialBanner(
                    backgroundColor: const Color(0xFFFFF3CD),
                    content: const Text('Offline mode: showing saved topic list. Connect to the internet to load tests from Supabase.'),
                    actions: [TextButton(onPressed: retry, child: const Text('Retry'))],
                  ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(color: const Color(0xFFE2F4E7), borderRadius: BorderRadius.circular(22)),
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
                      ...list.map((topic) => Card(
                            child: ListTile(
                              leading: CircleAvatar(backgroundColor: green, foregroundColor: Colors.white, child: Text('${topic['sort_order']}')),
                              title: Text('${topic['name']}'),
                              subtitle: const Text('20 Tests • 50 Questions'),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Tests(topicId: '${topic['id']}', name: '${topic['name']}'))),
                            ),
                          )),
                    ],
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

  Future<List<dynamic>> load() async {
    if (topicId.startsWith('local-')) {
      return List.generate(20, (index) => {
            'id': 'local-test-${index + 1}',
            'test_number': index + 1,
            'title': 'Test ${index + 1}',
            'question_count': 50,
            'duration_minutes': 90,
          });
    }
    try {
      return await Supabase.instance.client
          .from('tests')
          .select('id,test_number,title,question_count,duration_minutes')
          .eq('topic_id', topicId)
          .order('test_number')
          .timeout(const Duration(seconds: 15));
    } catch (_) {
      return List.generate(20, (index) => {
            'id': 'offline-test-${index + 1}',
            'test_number': index + 1,
            'title': 'Test ${index + 1} (offline)',
            'question_count': 50,
            'duration_minutes': 90,
          });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(name)),
        body: FutureBuilder<List<dynamic>>(
          future: load(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator(color: green));
            final list = snapshot.data ?? [];
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final test = list[index];
                return Card(child: ListTile(title: Text('${test['title'] ?? 'Test ${test['test_number']}'}'), subtitle: Text('${test['question_count']} Questions • ${test['duration_minutes']} Minutes')));
              },
            );
          },
        ),
      );
}
