import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://bpyhfufefpjraefcovrw.supabase.co';
const supabaseKey = 'sb_publishable_F1KtKcCl_MdJtrAMPLjiuA_uYxqKxmo';
const developerPhotoBase64 = '/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDABcQERQRDhcUEhQaGBcbIjklIh8fIkYyNSk5UkhXVVFIUE5bZoNvW2F8Yk5QcptzfIeLkpSSWG2grJ+OqoOPko3/2wBDARgaGiIeIkMlJUONXlBejY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY3/wAARCABAADADASIAAhEBAxEB/8QAGgAAAgMBAQAAAAAAAAAAAAAAAwQCBQYAAf/EACsQAAIBAwMDBAEEAwAAAAAAAAECAwAEERIhMQVBURMiYXEyFEKBsRWR0f/EABcBAAMBAAAAAAAAAAAAAAAAAAABAgP/xAAaEQEBAQEAAwAAAAAAAAAAAAAAEQECIVFh/9oADAMBAAIRAxEAPwBnqsrpEACAjbHzVHqIJCE89uauuo2r3EwTdiBnAbG1I3FvAAqoxVgMMQOPujcSq5Wdn0qS2T2712JQQulSScc0w1m4DOrLgHsdz/FTjngjQpp0sOWP7v8AfeohgSQRemytlZxuMUKznkW/jkVVZ84Gdu2KeUNo9ZbV5IV/J/x/kVWyYLs6eSRtVDG5M4AIxnzgb1XT2iyM7BypPIxz90zLKkYBJ0nv80rJeFhpyCPNaRL30o/RKRYjZtztyfFES1jimwFUyMM4pZJiGGnc0d4J/wDJQyHdSMsRwMUt+HnkzrKj3oQD5FZfqlsttdMI8hGww+M9q085uA4CEMD2xVP16IkwOyhSQQaOhid5LrlyPx7UENmvEmRE4LEjcVFpdbEgBfqikJHdRpOV1YkQZGRtmml63BHCRJIHkB5Xis/DELy6kLZK87HFT/Txw3aopJVRrbPxSu1WSLuS8a5hjuEYa0YgqBjAPH9Ut1O5aazCtu+rIA+qrbe4lVyWcuD5NGMgcF+DxvU9dQRISe/Sdx5pq2iicN60ojjAO2fc31VYj6R8/NMtchYgFHuzzilmezjkSK01iKVmVv3FKG8EsIkeZSnqYClhjI5/5U/1MYZdQ1gHJHAPxXvUOpG/kTMehE4UHNVQTAJBwM57io65AMMMr/VFVgh3XBNczLj64qKH/9k=';

final db = Supabase.instance.client;
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
  Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, title: 'Ruralz - Maths', theme: ThemeData(useMaterial3: true, colorSchemeSeed: green, scaffoldBackgroundColor: paleGreen), home: const Splash());
}

Widget logo(double size) => Container(width: size, height: size, decoration: BoxDecoration(color: const Color(0xFFE5F4E8), borderRadius: BorderRadius.circular(size * .2)), child: CustomPaint(painter: LogoPainter()));
Widget photo(double size) => ClipOval(child: Image.memory(base64Decode(developerPhotoBase64), width: size, height: size, fit: BoxFit.cover));

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) { final p = Paint(); p.color = const Color(0xFFF6B83F); c.drawCircle(Offset(s.width*.72,s.height*.22),s.width*.09,p); p.color=const Color(0xFF6DBD7A); final h=Path()..moveTo(0,s.height*.58)..quadraticBezierTo(s.width*.4,s.height*.2,s.width*.7,s.height*.5)..quadraticBezierTo(s.width*.9,s.height*.65,s.width,s.height*.55)..lineTo(s.width,s.height)..lineTo(0,s.height)..close(); c.drawPath(h,p); p.color=green; final g=Path()..moveTo(0,s.height*.75)..quadraticBezierTo(s.width*.5,s.height*.48,s.width,s.height*.7)..lineTo(s.width,s.height)..lineTo(0,s.height)..close(); c.drawPath(g,p); p.strokeWidth=s.width*.05; c.drawLine(Offset(s.width*.5,s.height*.72),Offset(s.width*.5,s.height*.43),p); }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Splash extends StatefulWidget { const Splash({super.key}); @override State<Splash> createState()=>_SplashState(); }
class _SplashState extends State<Splash> { @override void initState(){super.initState(); Future.delayed(const Duration(seconds:10),(){if(mounted)Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const Home()));});} @override Widget build(BuildContext c)=>Scaffold(body:Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[logo(150),const SizedBox(height:18),const Text('Ruralz - Maths',style:TextStyle(fontSize:30,fontWeight:FontWeight.bold)),const Text('Enriching Hopes',style:TextStyle(letterSpacing:4,color:Colors.black54)),const SizedBox(height:24),photo(118),const SizedBox(height:12),const Text('Developed by D. K. Chavan sir',style:TextStyle(fontWeight:FontWeight.bold)),const SizedBox(height:6),const Text('MHT-CET Mathematics Practice')]))); }

class Home extends StatelessWidget { const Home({super.key}); @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('Ruralz - Maths'),actions:[Padding(padding:const EdgeInsets.only(right:12),child:logo(40))]),body:FutureBuilder<List<dynamic>>(future:db.from('topics').select('id,name,sort_order').order('sort_order'),builder:(c,s){if(s.connectionState!=ConnectionState.done)return const Center(child:CircularProgressIndicator(color:green));if(s.hasError)return ConnectionView(onRetry:()=>Navigator.pushReplacement(c,MaterialPageRoute(builder:(_)=>const Home())));final topics=s.data??[];return ListView(padding:const EdgeInsets.all(16),children:[Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:const Color(0xFFE2F4E7),borderRadius:BorderRadius.circular(22)),child:Row(children:[Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:const[Text('MHT-CET Mathematics',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),Text('Offline Test Series'),Text('20 Tests • 50 Questions • 90 Minutes')])),logo(76)])),const SizedBox(height:18),const Text('Topics',style:TextStyle(fontSize:21,fontWeight:FontWeight.bold)),const SizedBox(height:8),...topics.map((t)=>Card(child:ListTile(leading:CircleAvatar(backgroundColor:green,foregroundColor:Colors.white,child:Text('${t['sort_order']}')),title:Text('${t['name']}'),subtitle:const Text('20 Tests • 50 Questions'),trailing:const Icon(Icons.chevron_right),onTap:()=>Navigator.push(c,MaterialPageRoute(builder:(_)=>Tests(topicId:'${t['id']}',name:'${t['name']}'))))))]);}})); }
}

class ConnectionView extends StatelessWidget { final VoidCallback onRetry; const ConnectionView({super.key,required this.onRetry}); @override Widget build(BuildContext c)=>Center(child:Padding(padding:const EdgeInsets.all(28),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:const[Icon(Icons.cloud_off,size:60,color:green),SizedBox(height:16),Text('Ruralz is temporarily offline',textAlign:TextAlign.center,style:TextStyle(fontSize:19,fontWeight:FontWeight.bold)),SizedBox(height:8),Text('Please check your internet connection and try again.',textAlign:TextAlign.center),SizedBox(height:18)]).withRetry(onRetry))); }

extension RetryWidget on Column { Widget withRetry(VoidCallback retry)=>Column(mainAxisAlignment:mainAxisAlignment,crossAxisAlignment:crossAxisAlignment,children:[...children,FilledButton.icon(onPressed:retry,icon:const Icon(Icons.refresh),label:const Text('Retry'))]); }

class Tests extends StatelessWidget { final String topicId,name; const Tests({super.key,required this.topicId,required this.name}); @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:Text(name)),body:FutureBuilder<List<dynamic>>(future:db.from('tests').select('id,test_number,title,question_count,duration_minutes').eq('topic_id',topicId).order('test_number'),builder:(c,s){if(s.connectionState!=ConnectionState.done)return const Center(child:CircularProgressIndicator());if(s.hasError)return ConnectionView(onRetry:()=>Navigator.pop(c));final tests=s.data??[];return ListView.builder(padding:const EdgeInsets.all(16),itemCount:tests.length,itemBuilder:(c,i){final t=tests[i];return Card(child:ListTile(title:Text('${t['title']??'Test ${t['test_number']}'}'),subtitle:Text('${t['question_count']} Questions • ${t['duration_minutes']} Minutes')));});})); }
}
