import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const defaultSupabaseUrl = 'https://bpyhfufefpjraefcovrw.supabase.co';
const defaultSupabaseKey = 'sb_publishable_F1KtKcCl_MdJtrAMPLjiuA_uYxqKxmo';
final envSupabaseUrl = const String.fromEnvironment('SUPABASE_URL');
final envSupabaseKey = const String.fromEnvironment('SUPABASE_ANON_KEY');
final supabaseUrl = envSupabaseUrl.isEmpty ? defaultSupabaseUrl : envSupabaseUrl;
final supabaseKey = envSupabaseKey.isEmpty ? defaultSupabaseKey : envSupabaseKey;
final supabase = Supabase.instance.client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseKey);
  runApp(const RuralzMathsApp());
}

class RuralzMathsApp extends StatelessWidget {
  const RuralzMathsApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ruralz Maths',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF2E7D4F),
          scaffoldBackgroundColor: const Color(0xFFF3FBF6),
        ),
        home: const SplashScreen(),
      );
}

class RuralzLogo extends StatelessWidget {
  final double size;
  const RuralzLogo({super.key, this.size = 120});
  @override
  Widget build(BuildContext context) => CustomPaint(
        size: Size.square(size),
        painter: _RuralzLogoPainter(),
      );
}

class _RuralzLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final box = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(size.width * .2));
    canvas.drawRRect(box, Paint()..color = const Color(0xFFE8F5E9));
    canvas.drawCircle(Offset(size.width * .72, size.height * .22), size.width * .09, Paint()..color = const Color(0xFFF6B83F));
    final hill = Path()..moveTo(0, size.height * .58)..quadraticBezierTo(size.width * .35, size.height * .25, size.width * .62, size.height * .5)..quadraticBezierTo(size.width * .85, size.height * .68, size.width, size.height * .56)..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
    canvas.drawPath(hill, Paint()..color = const Color(0xFF6DBD7A));
    final ground = Path()..moveTo(0, size.height * .75)..quadraticBezierTo(size.width * .5, size.height * .48, size.width, size.height * .7)..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
    canvas.drawPath(ground, Paint()..color = const Color(0xFF2E7D4F));
    final stem = Paint()..color = const Color(0xFF2E7D4F)..strokeWidth = size.width * .045..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(size.width * .5, size.height * .72), Offset(size.width * .5, size.height * .43), stem);
    canvas.drawOval(Rect.fromCenter(center: Offset(size.width * .41, size.height * .4), width: size.width * .28, height: size.height * .14), Paint()..color = const Color(0xFF2E7D4F));
    canvas.drawOval(Rect.fromCenter(center: Offset(size.width * .59, size.height * .36), width: size.width * .28, height: size.height * .14), Paint()..color = const Color(0xFF2E7D4F));
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              RuralzLogo(size: 160),
              SizedBox(height: 18),
              Text('Ruralz', style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold)),
              Text('Enriching Hopes', style: TextStyle(fontSize: 17, letterSpacing: 4, color: Colors.grey)),
              SizedBox(height: 26),
              CircleAvatar(radius: 45, backgroundColor: Color(0xFFDCEFE0), child: Icon(Icons.person, size: 48, color: Color(0xFF2E7D4F))),
              SizedBox(height: 14),
              Text('Developed by D. K. Chavan sir', style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              Text('MHT-CET Mathematics • Test Series'),
            ],
          ),
        ),
      );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Ruralz Maths')),
        body: FutureBuilder<List<dynamic>>(
          future: supabase.from('topics').select('id,name,sort_order').order('sort_order'),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError) return _ErrorView(onRetry: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen())));
            final topics = snapshot.data ?? <dynamic>[];
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: const Color(0xFFDCEFE0), borderRadius: BorderRadius.circular(22)),
                  child: const Row(children: [RuralzLogo(size: 76), SizedBox(width: 14), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('MHT-CET Mathematics', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)), Text('Practice • Learn • Improve'), Text('20 tests • 50 questions per test')]))]),
                ),
                const SizedBox(height: 18),
                ...topics.asMap().entries.map((entry) {
                  final topic = entry.value;
                  return Card(child: ListTile(leading: CircleAvatar(backgroundColor: const Color(0xFF2E7D4F), foregroundColor: Colors.white, child: Text('${entry.key + 1}')), title: Text(topic['name'].toString()), subtitle: const Text('20 tests available'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TestListScreen(topicId: topic['id'].toString(), topicName: topic['name'].toString())))));
                }),
              ],
            );
          },
        ),
      );
}

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  const _ErrorView({required this.onRetry});
  @override
  Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.wifi_off, size: 56, color: Color(0xFF2E7D4F)), const SizedBox(height: 16), const Text('Unable to connect to Ruralz server', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 8), const Text('Check your internet connection and try again.', textAlign: TextAlign.center), const SizedBox(height: 18), FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Retry'))])));
}

class TestListScreen extends StatelessWidget {
  final String topicId;
  final String topicName;
  const TestListScreen({super.key, required this.topicId, required this.topicName});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(topicName)), body: FutureBuilder<List<dynamic>>(future: supabase.from('tests').select('id,test_number,title,question_count,duration_minutes').eq('topic_id', topicId).order('test_number'), builder: (context, snapshot) { if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator()); if (snapshot.hasError) return _ErrorView(onRetry: () => Navigator.pop(context)); final tests = snapshot.data ?? <dynamic>[]; return ListView.builder(padding: const EdgeInsets.all(16), itemCount: tests.length, itemBuilder: (context, index) { final test = tests[index]; final title = test['title']?.toString() ?? 'Test ${test['test_number']}'; return Card(child: ListTile(title: Text(title), subtitle: Text('${test['question_count']} questions • ${test['duration_minutes']} minutes'), trailing: const Icon(Icons.play_arrow), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuestionScreen(testId: test['id'].toString(), title: title)))); }); }));
}

class QuestionScreen extends StatelessWidget {
  final String testId;
  final String title;
  const QuestionScreen({super.key, required this.testId, required this.title});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)), body: FutureBuilder<List<dynamic>>(future: supabase.from('questions').select('question_text,option_a,option_b,option_c,option_d,correct_option,explanation,sort_order').eq('test_id', testId).order('sort_order'), builder: (context, snapshot) { if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator()); if (snapshot.hasError) return _ErrorView(onRetry: () => Navigator.pop(context)); final questions = snapshot.data ?? <dynamic>[]; return ListView.builder(padding: const EdgeInsets.all(16), itemCount: questions.length, itemBuilder: (context, index) { final q = questions[index]; return Card(margin: const EdgeInsets.only(bottom: 14), child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Q${index + 1}. ${q['question_text']}', style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 10), Text('A. ${q['option_a']}'), Text('B. ${q['option_b']}'), Text('C. ${q['option_c']}'), Text('D. ${q['option_d']}'), const SizedBox(height: 10), Text('Answer: ${q['correct_option']}', style: const TextStyle(fontWeight: FontWeight.bold)), if (q['explanation'] != null) Text('Explanation: ${q['explanation']}')] ))); }); }));
}
