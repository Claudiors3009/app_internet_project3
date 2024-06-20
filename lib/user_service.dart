import 'dart:convert';
import 'package:http/http.dart' as http;

class Images {
  final String id;
  final String name;
  final String url;

  const Images({
    required this.id,
    required this.name,
    required this.url,
  });

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      id: json['id'],  // Key to match the API response
      name: json['name'],
      url: json['url'],
    );
  }
}

class UserService {
  Future<List<Images>> getImage() async {
    try {
      final response = await http.get(
        Uri.parse("https://api.imgflip.com/get_memes"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<Images> imageList = [];

        // Corrected key to match the API response
        for (var entry in data['data']['memes']) {
          imageList.add(Images.fromJson(entry));
        }

        return imageList;
      } else {
        throw Exception('Failed to load images. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server. Error: $e');
    }
  }
}
