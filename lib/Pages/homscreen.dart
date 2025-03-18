import 'package:api_app/service/api_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> futurePosts;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futurePosts = apiService.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'ListView',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: futurePosts,
        builder: (context, content) {
          if (content.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (content.hasError) {
            return Center(child: Text('Error: ${content.error}'));
          } else if (!content.hasData || content.data!.isEmpty) {
            return Center(child: Text('No posts found.'));
          } else {
            return ListView.builder(
              itemCount: content.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(
                    content.data![index]['id'].toString(),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  title: Text(
                    content.data![index]['title'],
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    content.data![index]['body'],
                    style: TextStyle(fontSize: 12),
                  ),
                  shape: Border(bottom: BorderSide(color: Colors.blue)),
                );
              },
            );
          }
        },
      ),
    );
  }
}
