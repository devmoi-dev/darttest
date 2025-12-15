import 'package:my_app/my_app.dart' as my_app;
import 'dart:convert';
import 'package:http/http.dart' as http;
void main(List<String> arguments) {
  print('Hello world: ${my_app.calculate()}!');
  testLogin();
}



void testLogin() async {
  final result = await login(username: 'a', password: '123');
  if (result['success']) {
    print('Login successful! Token: ${result['token']}');
  } else {
    print('Login failed: ${result['message']}');
  }
}
  String? _token;

    String? get token => _token;
    bool get isAuthenticated => _token != null;


  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {

 

    final url = Uri.parse("http://127.0.0.1:8000/api-token-auth/");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print(response.body);
        // Django REST Framework authtoken returns 'token' or 'auth_token'
        _token = data['token'];

        return {
          'success': true,
          'token': _token,
          'message': 'Login successful',
        };
      } else {
        // Handle Django validation errors
        final error = jsonDecode(response.body);
        String errorMessage = 'Login failed';

        if (error is Map) {
          if (error.containsKey('non_field_errors')) {
            errorMessage = error['non_field_errors'][0];
          } else if (error.containsKey('detail')) {
            errorMessage = error['detail'];
          } else if (error.containsKey('error')) {
            errorMessage = error['error'];
          }
        }

        return {
          'success': false,
          'message': errorMessage,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection error: $e',
      };
    }
  }