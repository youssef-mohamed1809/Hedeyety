import 'dart:convert';

import 'package:http/http.dart';

class ImageHandler{

  static Future<String?> uploadImage(String path) async {
      final uri = Uri.parse("https://api.cloudinary.com/v1_1/dydpgysad/upload");


      final request = MultipartRequest('POST', uri)
        ..fields['upload_preset'] = "ml_default" // Upload preset
        ..files.add(await MultipartFile.fromPath('file', path));


      final response = await request.send();

      if (response.statusCode == 200) {
        print('Image uploaded successfully!');
        // If you want to get the response, you can read the response body as follows:
        final responseData = await response.stream.bytesToString();
        final data = json.decode(responseData);
        print('Uploaded image URL: ${data['secure_url']}');
        return data['secure_url'];
      } else {
        print('Failed to upload image: ${response.statusCode}');
        return null;
      }

    }

}