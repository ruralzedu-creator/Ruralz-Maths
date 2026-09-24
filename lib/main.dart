import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://bpyhfufefpjraefcovrw.supabase.co';
const supabaseKey = 'sb_publishable_F1KtKcCl_MdJtrAMPLjiuA_uYxqKxmo';
const photoB64 = '/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDACAWGBwYFCAcGhwkIiAmMFA0MCwsMGJGSjpQdGZ6eHJmcG6AkLicgIiuim5woNqirr7EztDOfJri8uDI8LjKzsb/2wBDASIkJDAqMF40NF7GhHCExsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsbGxsb/wAARCABgAEgDASIAAhEBAxEB/8QAGgAAAgMBAQAAAAAAAAAAAAAAAwQAAgUBBv/EADAQAAICAQMDAgMGBwAAAAAAAAECABEDBBIhMVFxE0EFImEUIzIzQpFScoGhwdHh/8QAFgEBAQEAAAAAAAAAAAAAAAAAAQAC/8QAGhEBAQEAAwEAAAAAAAAAAAAAAAEREiExcf/aAAwDAQACEQMRAD8Ad1GX0U3USPpMnOzPbkf7/aaercY8PIJB4oCZA3ZCdo5u7PEqHN5G0LxR4JlMjuCb6+8sfkJGQHcOkE9sfm5mUqMnJs3Leoo4rnvL4+gVE3N4hV09U70K5KsKuWJRNOuWtw2k8A11/aAO7TtkxsA3Ff8AY0ysTeIKgqqU8EwOowsqAtwRwwPXn38RTugzJgz2w/ECAaupILAwx5lYrdHpJLU9Bq0oKQfmJ4FQIxfZm3ZACnccTQDDtBageovFEdjNBl5CjkMyMUY8kfpgxpVyM1Oqg/hHUxhtPlGKv0XZAjGHBjT7wKLI4EMLLKjCxKBunDD/ADLfa96gvw69PEdGFsjsMi1x+mFxYceMCwCfEsTPTHn1IrBjKp13P0/pA6l8y/cagAlDx3m6GHeLfEdMNTgtaGRRwe47SsTCYGvMk61/LJAvSm7v2nAickEgyM4VabgRd8ynjnzNsj5PlHJuAB7EgQXqE+8m6QO422oxsE1AabUepm2tyG683O6ZDktmY7Rx5ldNpnx6t2P5YvaPMLK1L0abHjA61KbD7HcPM7nxKwscGUx4XU9RXe4hhahCmZkqqYyRj4hjrWuT2v8AtJMNHdW/ND35iwaX3nJQPtOHERfNgTbKXOjrKA11iWqzEZxXRalqbC6hsVYwoIBssI0+VFS9w8Tzja/LVL8v1kXJlysqlzbGZlrVkbmXOdRgybVoL73A4dUVXaeYnptSmHJ6Yysyk0VI6whIUfWNuej4r8UbcVeqJWjJA5T6xJbp5kmORHXKFFVZ7zhysepg91cNdS1AgHoI8hjoPuTEPzdR/M01MOnfUqwQ7VrliOIrj0mXT57dQQLogxlWDlQBbVQ9qien/MyZfZAa8w2oZtpvp5glG3TKP4yWPgShoKqNxIjAyMoAHMDxfacZmU2OsKjLEEAmpIv6u6r6yTOITdvN9KhlFjmLq1DtLo9Emr4jIjz58ypsOSlrjgCAYFvxMT5MDlyliByB3MhzAcDn6zSO/D9GuYu+Zd2McC/cxbWhceo9LEeFFc+0qNbnxp6ePJS9iIHexazyb6nvK3oIAbogHxLNjHHHIlbK/W+06GuYKjIAaFj6ySxfj6yRD//Z';

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
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: green, scaffoldBackgroundColor: pale),
    home: const Splash(),
  );
}

class LogoMark extends StatelessWidget {
  final double size;
  const LogoMark({super.key, this.size = 130});
  @override
  Widget build(BuildContext context) => Container(
    width: size, height: size,
    decoration: BoxDecoration(color: const Color(0xFFE5F4E8), borderRadius: BorderRadius.circular(size * .2)),
    child: CustomPaint(painter: LogoPainter()),
  );
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final p = Paint();
    p.color = const Color(0xFFF6B83F); c.drawCircle(Offset(s.width*.72, s.height*.22), s.width*.09, p);
    p.color = const Color(0xFF70BE7D);
    final h = Path()..moveTo(0,s.height*.58)..quadraticBezierTo(s.width*.4,s.height*.2,s.width*.7,s.height*.5)..quadraticBezierTo(s.width*.9,s.height*.65,s.width,s.height*.55)..lineTo(s.width,s.height)..lineTo(0,s.height)..close();
    c.drawPath(h,p);
    p.color = green;
    final g = Path()..moveTo(0,s.height*.75)..quadraticBezierTo(s.width*.5,s.height*.48,s.width,s.height*.7)..lineTo(s.width,s.height)..lineTo(0,s.height)..close();
    c.drawPath(g,p);
    p.strokeWidth = s.width*.05; c.drawLine(Offset(s.width*.5,s.height*.72),Offset(s.width*.5,s.height*.43),p);
    p.style = PaintingStyle.fill; c.drawOval(Rect.fromLTWH(s.width*.34,s.height*.35,s.width*.28,s.height*.14),p);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Splash extends StatefulWidget { const Splash({super.key}); @override State<Splash> createState()=>_SplashState(); }
class _SplashState extends State<Splash> {
  @override void initState(){super.initState(); Future.delayed(const Duration(seconds:10),(){if(mounted) Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const Home()));});}
  @override Widget build(BuildContext context)=>Scaffold(body:Center(child:SingleChildScrollView(padding:const EdgeInsets.all(24),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
    const LogoMark(size:160), const SizedBox(height:16), const Text('Ruralz - Maths',style:TextStyle(fontSize:30,fontWeight:FontWeight.bold)),
    const Text('Enriching Hopes',style:TextStyle(letterSpacing:4,color:Colors.black54)), const SizedBox(height:24),
    ClipOval(child:Image.memory(base64Decode(photoB64),width:125,height:125,fit:BoxFit.cover,errorBuilder:(_,__,___)=>const Icon(Icons.person,size:90))),
    const SizedBox(height:12), const Text('Developed by D. K. Chavan sir',style:TextStyle(fontWeight:FontWeight.bold)), const SizedBox(height:6), const Text('MHT-CET Mathematics Practice')
  ]))));
}

class Home extends StatefulWidget { const Home({super.key}); @override State<Home> createState()=>_HomeState(); }
class _HomeState extends State<Home> {
  late Future<List<dynamic>> future;
  @override void initState(){super.initState();future=loadTopics();}
  Future<List<dynamic>> loadTopics() async { try { return await Supabase.instance.client.from('topics').select('id,name,sort_order').order('sort_order').timeout(const Duration(seconds:12)); } catch(_){ return []; } }
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Ruralz - Maths'),actions:[Padding(padding:const EdgeInsets.only(right:12),child:LogoMark(size:40))]),body:FutureBuilder<List<dynamic>>(future:future,builder:(context,s){if(s.connectionState!=ConnectionState.done)return const Center(child:CircularProgressIndicator(color:green));final list=s.data??[];if(list.isEmpty)return Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[const Icon(Icons.cloud_off,size:56,color:green),const SizedBox(height:12),const Text('Unable to load topics'),const SizedBox(height:12),FilledButton(onPressed:()=>setState(()=>future=loadTopics()),child:const Text('Retry'))]));return ListView(padding:const EdgeInsets.all(16),children:[Container(padding:const EdgeInsets.all(18),decoration:BoxDecoration(color:const Color(0xFFE2F4E7),borderRadius:BorderRadius.circular(22)),child:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text('MHT-CET Mathematics',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),Text('Online Test Series'),Text('20 Tests • 50 Questions • 90 Minutes')]),),const SizedBox(height:16),const Text('Topics',style:TextStyle(fontSize:22,fontWeight:FontWeight.bold)),...list.map((t)=>Card(child:ListTile(leading:CircleAvatar(backgroundColor:green,foregroundColor:Colors.white,child:Text('${t['sort_order']}')),title:Text('${t['name']}'),subtitle:const Text('20 Tests • 50 Questions'),trailing:const Icon(Icons.chevron_right),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>Tests(topicId:'${t['id']}',name:'${t['name']}'))))))]);}));
}

class Tests extends StatelessWidget { final String topicId; final String name; const Tests({super.key,required this.topicId,required this.name});
  Future<List<dynamic>> load() async {try{return await Supabase.instance.client.from('tests').select('id,test_number,title,question_count,duration_minutes').eq('topic_id',topicId).order('test_number').timeout(const Duration(seconds:12));}catch(_){return [];}}
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:Text(name)),body:FutureBuilder<List<dynamic>>(future:load(),builder:(context,s){if(s.connectionState!=ConnectionState.done)return const Center(child:CircularProgressIndicator(color:green));final list=s.data??[];if(list.isEmpty)return const Center(child:Text('Unable to load tests'));return ListView.builder(padding:const EdgeInsets.all(16),itemCount:list.length,itemBuilder:(context,i){final t=list[i];return Card(child:ListTile(title:Text('${t['title']??'Test ${t['test_number']}'}'),subtitle:Text('${t['question_count']} Questions • ${t['duration_minutes']} Minutes')));});}));
}
