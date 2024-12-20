import 'dart:convert';

import 'package:http/http.dart';

class ImageHandler{

  static Future<String?> uploadImage(String path) async {
      final uri = Uri.parse("https://api.cloudinary.com/v1_1/dydpgysad/upload");


      final request = MultipartRequest('POST', uri)
        ..fields['upload_preset'] = "ml_default"
        ..files.add(await MultipartFile.fromPath('file', path));


      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = json.decode(responseData);
        return data['secure_url'];
      } else {
        print("Error from uploadImage");
        print('Failed to upload image: ${response.statusCode}');
        return null;
      }

    }

}