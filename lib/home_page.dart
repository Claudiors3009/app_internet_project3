import 'package:flutter/material.dart';
import 'package:app_internet/user_page.dart';
import 'package:app_internet/user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Images>> imageFuture;

  @override
  void initState() {
    super.initState();
    imageFuture = UserService().getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memes Gallery')),
      body: Container(
        color: const Color.fromARGB(255, 0, 0, 0), // Set background color
        child: Center(
          child: FutureBuilder<List<Images>>(
            future: imageFuture,
            builder: (context, AsyncSnapshot<List<Images>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red), // Error text color
                );
              } else if (snapshot.hasData) {
                return ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Images image = snapshot.data![index];
                    return Card(
                      color: Colors.white, // Card background color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        title: Text(
                          image.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Text color
                          ),
                        ),
                        trailing: Image.network(
                          image.url,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        onTap: () => openPage(context, image),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                );
              } else {
                return const Text('No data available');
              }
            },
          ),
        ),
      ),
    );
  }

  void openPage(BuildContext context, Images image) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserPage(image: image)),
    );
  }
}
