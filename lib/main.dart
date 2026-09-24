import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://bpyhfufefpjraefcovrw.supabase.co';
const supabaseKey = 'sb_publishable_F1KtKcCl_MdJtrAMPLjiuA_uYxqKxmo';
const developerPhotoBase64 = '/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDABcQERQRDhcUEhQaGBcbIjklIh8fIkYyNSk5UkhXVVFIUE5bZoNvW2F8Yk5QcptzfIeLkpSSWG2grJ+OqoOPko3/2wBDARgaGiIeIkMlJUONXlBejY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY3/wAARCABAADADASIAAhEBAxEB/8QAGgAAAgMBAQAAAAAAAAAAAAAAAwQCBQYAAf/EACsQAAIBAwMDBAEEAwAAAAAAAAECAwAEERIhMQVBURMiYXEyFEKBsRWR0f/EABcBAAMBAAAAAAAAAAAAAAAAAAABAgP/xAAaEQEBAQEAAwAAAAAAAAAAAAAAEQECIVFh/9oADAMBAAIRAxEAPwBnqsrpEACAjbHzVHqIJCE89uauuo2r3EwTdiBnAbG1I3FvAAqoxVgMMQOPujcSq5Wdn0qS2T2712JQQulSScc0w1m4DOrLgHsdz/FTjngjQpp0sOWP7v8AfeohgSQRemytlZxuMUKznkW/jkVVZ84Gdu2KeUNo9ZbV5IV/J/x/kVWyYLs6eSRtVDG5M4AIxnzgb1XT2iyM7BypPIxz90zLKkYBJ0nv80rJeFhpyCPNaRL30o/RKRYjZtztyfFES1jimwFUyMM4pZJiGGnc0d4J/wDJQyHdSMsRwMUt+HnkzrKj3oQD5FZfqlsttdMI8hGww+M9q085uA4CEMD2xVP16IkwOyhSQQaOhid5LrlyPx7UENmvEmRE4LEjcVFpdbEgBfqikJHdRpOV1YkQZGRtmml63BHCRJIHkB5Xis/DELy6kLZK87HFT/Txw3aopJVRrbPxSu1WSLuS8a5hjuEYa0YgqBjAPH9Ut1O5aazCtu+rIA+qrbe4lVyWcuD5NGMgcF+DxvU9dQRISe/Sdx5pq2iicN60ojjAO2fc31VYj6R8/NMtchYgFHuzzilmezjkSK01iKVmVv3FKG8EsIkeZSnqYClhjI5/5U/1MYZdQ1gHJHAPxXvUOpG/kTMehE4UHNVQTAJBwM57io65AMMMr/VFVgh3XBNczLj64qKH/9k=';

const green = Color(0xFF2E8B57);
const paleGreen = Color(0xFFF1FAF3);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseKey);
  runApp(const RuralzApp());
}

class RuralzApp extends StatelessWidget {
  const RuralzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ruralz - Maths',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: green,
        scaffoldBackgroundColor: paleGreen,
      ),
      home: const Splash(),
    );
  }
}

Widget ruralzLogo(double size) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: const Color(0xFFE5F4E8),
      borderRadius: BorderRadius.circular(size * 0.2),
    ),
    child: CustomPaint(painter: LogoPainter()),
  );
}

Widget developerPhoto(double size) {
  try {
    return ClipOval(
      child: Image.memory(
        base64Decode(developerPhotoBase64),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(Icons.person, size: size * 0.6),
      ),
    );
  } catch (_) {
    return CircleAvatar(
      radius: size / 2,
      child: Icon(Icons.person, size: size * 0.6),
    );
  }
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = const Color(0xFFF6B83F);
    canvas.drawCircle(
      Offset(size.width * 0.72, size.height * 0.22),
      size.width * 0.09,
      paint,
    );

    paint.color = const Color(0xFF6DBD7A);
    final hill = Path()
      ..moveTo(0, size.height * 0.58)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.2,
        size.width * 0.7,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.9,
        size.height * 0.65,
        size.width,
        size.height * 0.55,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hill, paint);

    paint.color = green;
    final ground = Path()
      ..moveTo(0, size.height * 0.75)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.48,
        size.width,
        size.height * 0.7,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(ground, paint);

    paint.strokeWidth = size.width * 0.05;
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.72),
      Offset(size.width * 0.5, size.height * 0.43),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ruralzLogo(150),
              const SizedBox(height: 18),
              const Text(
                'Ruralz - Maths',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Enriching Hopes',
                style: TextStyle(letterSpacing: 4, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              developerPhoto(118),
              const SizedBox(height: 12),
              const Text(
                'Developed by D. K. Chavan sir',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text('MHT-CET Mathematics Practice'),
            ],
          ),
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<dynamic>> topicsFuture;

  @override
  void initState() {
    super.initState();
    topicsFuture = loadTopics();
  }

  Future<List<dynamic>> loadTopics() async {
    try {
      final result = await Supabase.instance.client
          .from('topics')
          .select('id,name,sort_order')
          .order('sort_order')
          .timeout(const Duration(seconds: 12));
      return result;
    } catch (_) {
      return const [];
    }
  }

  void retry() {
    setState(() {
      topicsFuture = loadTopics();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ruralz - Maths'),
        actions: [Padding(padding: const EdgeInsets.only(right: 12), child: ruralzLogo(40))],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: topicsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator(color: green));
          }

          final topics = snapshot.data ?? const [];
          if (topics.isEmpty) {
            return ConnectionView(onRetry: retry);
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
                child: Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('MHT-CET Mathematics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          Text('Online Test Series'),
                          Text('20 Tests • 50 Questions • 90 Minutes'),
                        ],
                      ),
                    ),
                    ruralzLogo(76),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const Text('Topics', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...topics.map(
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Tests(
                            topicId: '${topic['id']}',
                            name: '${topic['name']}',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ConnectionView extends StatelessWidget {
  final VoidCallback onRetry;

  const ConnectionView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 60, color: green),
            const SizedBox(height: 16),
            const Text(
              'Ruralz is temporarily offline',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please check your internet connection and try again.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class Tests extends StatelessWidget {
  final String topicId;
  final String name;

  const Tests({super.key, required this.topicId, required this.name});

  Future<List<dynamic>> loadTests() async {
    try {
      final result = await Supabase.instance.client
          .from('tests')
          .select('id,test_number,title,question_count,duration_minutes')
          .eq('topic_id', topicId)
          .order('test_number')
          .timeout(const Duration(seconds: 12));
      return result;
    } catch (_) {
      return const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: FutureBuilder<List<dynamic>>(
        future: loadTests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator(color: green));
          }

          final tests = snapshot.data ?? const [];
          if (tests.isEmpty) {
            return ConnectionView(onRetry: () => Navigator.pop(context));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tests.length,
            itemBuilder: (context, index) {
              final test = tests[index];
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
}
