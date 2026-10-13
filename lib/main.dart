import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://bpyhfufefpjraefcovrw.supabase.co';
const supabaseKey = 'sb_publishable_F1KtKcCl_MdJtrAMPLjiuA_uYxqKxmo';
const green = Color(0xFF2E7D4F);
const pale = Color(0xFFF2FAF4);
final db = Supabase.instance.client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseKey);
  runApp(const RuralzApp());
}

class RuralzApp extends StatelessWidget {
  const RuralzApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false, title: 'Ruralz - Maths',
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: green, scaffoldBackgroundColor: pale),
    home: const Splash(),
  );
}

class Splash extends StatefulWidget {
  const Splash({super.key});
  @override State<Splash> createState() => _SplashState();
}
class _SplashState extends State<Splash> {
  @override void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AuthGate()));
    });
  }
  @override Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ClipRRect(borderRadius: BorderRadius.circular(28), child: Image.asset('ruralz-logo.jpg', width: 230, height: 190, fit: BoxFit.contain)),
        const SizedBox(height: 18),
        ClipRRect(borderRadius: BorderRadius.circular(24), child: Image.asset('D. K. Chavan Sir.png', width: 230, height: 230, fit: BoxFit.cover)),
        const SizedBox(height: 18),
        const Text('Ruralz - Maths', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Developed by D. K. Chavan sir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 6), const Text('MHT-CET Mathematics Practice'),
      ]),
    ))),
  );
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});
  @override Widget build(BuildContext context) => StreamBuilder<AuthState>(
    stream: db.auth.onAuthStateChange,
    builder: (context, snapshot) => db.auth.currentSession == null ? const LoginPage() : const Home(),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController(), password = TextEditingController();
  bool signup = false, busy = false;
  String? error, note;
  Future<void> submit() async {
    setState(() { busy = true; error = null; note = null; });
    try {
      if (signup) {
        final res = await db.auth.signUp(email: email.text.trim(), password: password.text);
        if (res.session == null) { setState(() => note = 'Check your email to confirm your account, then sign in.'); }
      } else {
        await db.auth.signInWithPassword(email: email.text.trim(), password: password.text);
      }
    } catch (e) { setState(() => error = e.toString()); }
    finally { if (mounted) setState(() => busy = false); }
  }
  @override void dispose() { email.dispose(); password.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Ruralz Maths')),
    body: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Icon(Icons.school, size: 64, color: green),
        Text(signup ? 'Create your account' : 'Sign in', textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password (minimum 6 characters)', border: OutlineInputBorder())),
        if (error != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(error!, style: const TextStyle(color: Colors.red))),
        if (note != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(note!, style: const TextStyle(color: green))),
        const SizedBox(height: 16),
        FilledButton(onPressed: busy ? null : submit, child: Text(busy ? 'Please wait…' : (signup ? 'Create account' : 'Sign in'))),
        TextButton(onPressed: () => setState(() { signup = !signup; error = null; note = null; }), child: Text(signup ? 'Already registered? Sign in' : 'New student? Create account')),
      ]),
    ))),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
  late Future<List<dynamic>> future;
  @override void initState() { super.initState(); future = loadTopics(); }
  Future<List<dynamic>> loadTopics() => db.from('topics').select('id,name,sort_order').order('sort_order').timeout(const Duration(seconds: 15));
  void retry() => setState(() => future = loadTopics());
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Ruralz - Maths'), actions: [
      IconButton(tooltip: 'Sign out', icon: const Icon(Icons.logout), onPressed: () async { await db.auth.signOut(); }),
    ]),
    body: FutureBuilder<List<dynamic>>(future: future, builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator(color: green));
      if (snapshot.hasError) return ErrorPanel(error: snapshot.error.toString(), onRetry: retry);
      final topics = snapshot.data ?? [];
      if (topics.isEmpty) return const Center(child: Text('No topics found'));
      return ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: const Color(0xFFE2F4E7), borderRadius: BorderRadius.circular(22)),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('MHT-CET Mathematics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Online Test Series'), Text('20 Tests • 50 Questions • 90 Minutes'),
          ])),
        const SizedBox(height: 16), const Text('Topics', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ...topics.map((topic) => Card(child: ListTile(
          leading: CircleAvatar(backgroundColor: green, foregroundColor: Colors.white, child: Text('${topic['sort_order']}')),
          title: Text('${topic['name']}'), subtitle: const Text('20 Tests • 50 Questions'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Tests(topicId: '${topic['id']}', name: '${topic['name']}'))),
        ))),
      ]);
    }),
  );
}

class Tests extends StatefulWidget {
  final String topicId, name;
  const Tests({super.key, required this.topicId, required this.name});
  @override State<Tests> createState() => _TestsState();
}
class _TestsState extends State<Tests> {
  late Future<List<dynamic>> future;
  @override void initState() { super.initState(); future = loadTests(); }
  Future<List<dynamic>> loadTests() => db.from('tests').select('id,test_number,title,question_count,duration_minutes').eq('topic_id', widget.topicId).order('test_number').timeout(const Duration(seconds: 15));
  void retry() => setState(() => future = loadTests());
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.name)),
    body: FutureBuilder<List<dynamic>>(future: future, builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator(color: green));
      if (snapshot.hasError) return ErrorPanel(error: snapshot.error.toString(), onRetry: retry);
      final tests = snapshot.data ?? [];
      if (tests.isEmpty) return const Center(child: Text('No tests found'));
      return ListView.builder(padding: const EdgeInsets.all(16), itemCount: tests.length, itemBuilder: (context, index) {
        final test = tests[index];
        return Card(child: ListTile(
          leading: const CircleAvatar(backgroundColor: Color(0xFFE2F4E7), child: Icon(Icons.quiz, color: green)),
          title: Text('${test['title'] ?? 'Test ${test['test_number']}'}'),
          subtitle: Text('${test['question_count']} Questions • ${test['duration_minutes']} Minutes'),
          trailing: const Icon(Icons.play_circle_outline, color: green),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuizPage(test: Map<String, dynamic>.from(test)))),
        ));
      });
    }),
  );
}

class QuizPage extends StatefulWidget {
  final Map<String, dynamic> test;
  const QuizPage({super.key, required this.test});
  @override State<QuizPage> createState() => _QuizPageState();
}
class _QuizPageState extends State<QuizPage> {
  List<Map<String, dynamic>> questions = [];
  final Map<int, String> answers = {};
  Timer? timer;
  int remaining = 0, current = 0;
  final DateTime startedAt = DateTime.now().toUtc();
  bool loading = true, submitted = false;
  String? error;
  int get correct => questions.where((q) => answers[q['id']] == q['correct_option']).length;
  @override void initState() { super.initState(); loadQuestions(); }
  Future<void> loadQuestions() async {
    try {
      final rows = await db.from('questions').select('id,question_text,option_a,option_b,option_c,option_d,correct_option,explanation,sort_order')
        .eq('test_id', widget.test['id']).order('sort_order');
      final list = rows.map((e) => Map<String, dynamic>.from(e)).toList()..shuffle(Random());
      if (!mounted) return;
      setState(() { questions = list; loading = false; remaining = ((widget.test['duration_minutes'] ?? 90) as num).toInt() * 60; });
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (!mounted || submitted) { t.cancel(); return; }
        if (remaining <= 1) { setState(() => remaining = 0); t.cancel(); submitTest(); }
        else { setState(() => remaining--); }
      });
    } catch (e) { if (mounted) setState(() { loading = false; error = e.toString(); }); }
  }
  String get clock => '${(remaining ~/ 3600).toString().padLeft(2, '0')}:${((remaining % 3600) ~/ 60).toString().padLeft(2, '0')}:${(remaining % 60).toString().padLeft(2, '0')}';
  Future<void> submitTest() async {
    if (submitted || questions.isEmpty) return;
    timer?.cancel();
    setState(() => submitted = true);
    final attempted = answers.length;
    final wrong = attempted - correct;
    final user = db.auth.currentUser;
    if (user != null) {
      try {
        final submittedAt = DateTime.now().toUtc();
        final attempt = await db.from('attempts').insert({
          'user_id': user.id, 'test_id': widget.test['id'], 'started_at': startedAt.toIso8601String(),
          'submitted_at': submittedAt.toIso8601String(), 'total_questions': questions.length,
          'attempted': attempted, 'correct': correct, 'wrong': wrong, 'unattempted': questions.length - attempted,
          'score': correct, 'percentage': questions.isEmpty ? 0 : correct * 100 / questions.length, 'status': 'submitted'
        }).select('id').single();
        final attemptId = attempt['id'];
        final answerRows = questions.map((q) {
          final selected = answers[q['id']];
          return {
            'attempt_id': attemptId,
            'question_id': q['id'],
            'selected_option': selected,
            'marked_for_review': false,
            'is_correct': selected == null ? null : selected == q['correct_option'],
            'answered_at': selected == null ? null : submittedAt.toIso8601String(),
          };
        }).toList();
        if (answerRows.isNotEmpty) {
          await db.from('attempt_answers').insert(answerRows);
        }
      } catch (_) { /* Keep the result visible even if result-saving policies need configuration. */ }
    }
  }
  @override void dispose() { timer?.cancel(); super.dispose(); }
  @override Widget build(BuildContext context) {
    if (loading) return Scaffold(appBar: AppBar(title: const Text('Loading test')), body: const Center(child: CircularProgressIndicator(color: green)));
    if (error != null) return Scaffold(appBar: AppBar(title: const Text('Test')), body: ErrorPanel(error: error!, onRetry: () => setState(() { loading = true; error = null; loadQuestions(); })));
    if (questions.isEmpty) return Scaffold(appBar: AppBar(title: const Text('Test')), body: const Center(child: Text('No questions available in this test.')));
    if (submitted) return Scaffold(appBar: AppBar(title: const Text('Test Result')), body: ListView(padding: const EdgeInsets.all(16), children: [
      Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        const Icon(Icons.emoji_events, size: 54, color: green),
        const Text('Test Submitted', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text('Score: $correct / ${questions.length}', style: const TextStyle(fontSize: 21)),
        Text('Attempted: ${answers.length} • Correct: $correct • Wrong: ${answers.length - correct} • Unattempted: ${questions.length - answers.length}'),
        Text('Percentage: ${(correct * 100 / questions.length).toStringAsFixed(1)}%'),
      ]))),
      const SizedBox(height: 8), const Text('Answer Review', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
      ...questions.asMap().entries.map((entry) {
        final i = entry.key, q = entry.value;
        final key = q['correct_option']?.toString() ?? '';
        return Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Q${i + 1}. ${q['question_text']}', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final letter in ['A','B','C','D']) Text('$letter. ${q['option_${letter.toLowerCase()}'] ?? ''}${letter == key ? '  ✓ Correct answer' : ''}'),
          Text('Your answer: ${answers[q['id']] ?? 'Not attempted'}'),
          if ((q['explanation'] ?? '').toString().isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6), child: Text('Explanation: ${q['explanation']}')),
        ])));
      }),
      FilledButton(onPressed: () => Navigator.popUntil(context, (route) => route.isFirst), child: const Text('Back to Topics')),
    ]));
    final q = questions[current];
    return Scaffold(
      appBar: AppBar(title: Text('Test ${widget.test['test_number']}'), actions: [
        Padding(padding: const EdgeInsets.all(14), child: Text(clock, style: TextStyle(fontWeight: FontWeight.bold, color: remaining < 300 ? Colors.red : green))),
      ]),
      body: Column(children: [
        LinearProgressIndicator(value: (current + 1) / questions.length, color: green, backgroundColor: const Color(0xFFDDEEE1)),
        Padding(padding: const EdgeInsets.all(16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Question ${current + 1} of ${questions.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('${answers.length} answered'),
        ])),
        Expanded(child: ListView(padding: const EdgeInsets.symmetric(horizontal: 16), children: [
          Text(q['question_text']?.toString() ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          for (final letter in ['A','B','C','D'])
            Card(child: RadioListTile<String>(
              value: letter, groupValue: answers[q['id']], activeColor: green,
              title: Text('${q['option_${letter.toLowerCase()}'] ?? ''}'),
              onChanged: submitted ? null : (v) => setState(() { if (v != null) answers[q['id'] as int] = v; }),
            )),
        ])),
        SafeArea(top: false, child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [
          OutlinedButton(onPressed: current == 0 ? null : () => setState(() => current--), child: const Text('Previous')),
          const Spacer(),
          if (current < questions.length - 1) FilledButton(onPressed: () => setState(() => current++), child: const Text('Next'))
          else FilledButton(onPressed: submitTest, child: const Text('Submit Test')),
        ]))),
      ]),
    );
  }
}

class ErrorPanel extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const ErrorPanel({super.key, required this.error, required this.onRetry});
  @override Widget build(BuildContext context) => Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
    const Icon(Icons.cloud_off, size: 58, color: Colors.redAccent),
    const SizedBox(height: 12), const Text('Unable to connect to Supabase', textAlign: TextAlign.center, style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
    const SizedBox(height: 12), SelectableText(error, textAlign: TextAlign.center),
    const SizedBox(height: 18), FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Retry')),
  ])));
}
