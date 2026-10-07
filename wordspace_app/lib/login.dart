import 'package:flutter/material.dart';
import 'package:wordspace_app/colors/colors.dart';
import 'package:wordspace_app/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordspace_app/screens/mainScreen.dart';
//import 'dart:convert';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:wordspace_app/colors/colors.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final ApiService api = ApiService();
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future<void> login() async {
    try {
      final data = await api.post('login', {
        'email': email.text.trim(),
        'password': password.text,
      });

      if (!mounted) return;

      if (data['token'] != null) {
        final user = data['user'];

        final prefs = await SharedPreferences.getInstance();

        await prefs.setInt('id', user['id']);
        await prefs.setString('username', user['name'] ?? '');
        await prefs.setString('email', user['email'] ?? '');
        await prefs.setString('token', data['token']);
        await prefs.setBool('isLogin', true);
        await prefs.setString('role', data['user']['role']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Login successful'),
            backgroundColor: Colors.green,
          ),
        );
        if (data['user']['role'] == 'admin') {
          Navigator.pushReplacementNamed(context, '/admin');
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        }
        
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Login failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login error: $e'), backgroundColor: Colors.red),
      );
    }
  }
  // Future<void> googleLogin() async {
  //   try {
  //     final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  //     // تهيئة Google Sign-In
  //     // await googleSignIn.initialize();
  //     //239711374260-4ej1esi51mqm913dj27q6j7v8deg4j62.apps.googleusercontent.com
  //     await googleSignIn.initialize(
  //       serverClientId:
  //           '239711374260-4ej1esi51mqm913dj27q6j7v8deg4j62.apps.googleusercontent.com',
  //     );
  //     // فتح نافذة اختيار حساب Google
  //     final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

  //     // بيانات المستخدم من Google
  //     final String name = googleUser.displayName ?? "";
  //     final String email = googleUser.email;
  //     final String googleId = googleUser.id;
  //     final String photo = googleUser.photoUrl ?? "";

  //     print("========== GOOGLE USER ==========");
  //     print("Name: $name");
  //     print("Email: $email");
  //     print("Google ID: $googleId");
  //     print("Photo: $photo");

  //     // إرسال البيانات إلى PHP
  //     Map<String, dynamic> data = await api.postData('google_login.php', {
  //       'name': name,
  //       'email': email,
  //       'google_id': googleId,
  //       'photo': photo,
  //     });

  //     print("========== GOOGLE API RESPONSE ==========");
  //     print(data);

  //     // إظهار رسالة الـ API
  //     if (!mounted) return;

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(data['message'] ?? ''),
  //         backgroundColor: data['status'] == true ? Colors.green : Colors.red,
  //       ),
  //     );

  //     // إذا نجح تسجيل الدخول
  //     if (data['status'] == true) {
  //       SharedPreferences prefs = await SharedPreferences.getInstance();

  //       await prefs.setInt("id", data["id"]);
  //       await prefs.setString("username", data["username"] ?? "");
  //       await prefs.setString("role", data["role"] ?? "");
  //       await prefs.setString("email", data["email"] ?? email);
  //       await prefs.setBool("isLogin", true);

  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => MainNavigation()),
  //       );
  //     }
  //   } catch (e, s) {
  //     print("========== GOOGLE LOGIN ERROR ==========");
  //     print(e);
  //     print(s);

  //     if (!mounted) return;

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text("Google Login Error: $e"),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final keyfrm = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ofwhite,
      body: SafeArea(
        child: Container(
          color: AppColors.ofwhite,
          padding: EdgeInsets.all(20),
          child: Form(
            key: keyfrm,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          //color: Colors.amber,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Icon(Icons.list, color: AppColors.ofwhite),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                              color: AppColors.bistre
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Welcome Back! Login to continue using the app.',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 12,
                            //fontWeight:
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Email ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.bistre
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value == "" || value == null) {
                            return "email must fill";
                          } else if (!value.contains("@")) {
                            return "username must contain @";
                          }

                          return null;
                        },
                        controller: email,
                        style: TextStyle(color: AppColors.primary),
                        //obscureText: true,//to hide the text as dots
                        keyboardType: TextInputType
                            .emailAddress, //in the emulater will be appeared
                        //maxLength: 10,
                        maxLines: 1,
                        //minLines: 1,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                             color: AppColors.bistre.withOpacity(0.7),
                          ),
                          hintText: "Enter Your Email",
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.6),
                          ),
                          //label: Text("Employee me"),
                          filled: true,
                          fillColor: AppColors.ofwhite,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.15),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color.fromARGB(
                                255,
                                0,
                                0,
                                0,
                              ).withOpacity(0.10),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color.fromARGB(
                                255,
                                0,
                                0,
                                0,
                              ).withOpacity(0.10),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Password ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                                color: AppColors.bistre
                            ),
                          ),
                          Text(
                            'Forget password?',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: password,
                        style: TextStyle(color: AppColors.primary),
                        obscureText: true,

                        //obscureText: true,//to hide the text as dots
                        //in the emulater will be appeared
                        //maxLength: 10,
                        //maxLines: 3,
                        //minLines: 1,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: AppColors.bistre.withOpacity(0.7),
                          ),
                          hintText: "Enter Your Password",
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.6),
                          ),
                          //label: Text("Employee me"),
                          filled: true,
                          fillColor: AppColors.ofwhite,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                               color: const Color.fromARGB(
                                255,
                                0,
                                0,
                                0,
                              ).withOpacity(0.10),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                             color: Colors.black.withOpacity(0.5),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                               color: Colors.black.withOpacity(0.5),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, "/home");
                          if (keyfrm.currentState!.validate()) {
                            login();
                          }
                          // if (keyfrm.currentState!.validate()) print('done');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.ofwhite,
                          minimumSize: Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: 15),
                      // Center(child: Text(' Or continue with')),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     GestureDetector(
                      //       onTap: (){},
                      //       child: Image.asset(
                      //         'assets/icons/google.png',
                      //         width: 70,
                      //       ),
                      //     ),

                      //     const Text('Or'),

                      //     Image.asset('assets/icons/facebook.png', width: 70),
                      //   ],
                      // ),
                    ],
                  ),
                  // Text.rich(
                  //   TextSpan(
                  //     children: [
                  //       TextSpan(text: 'Have An Account ? '),
                  //       TextSpan(
                  //         text: 'Login',
                  //         style: TextStyle(
                  //           color: Colors.amber,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Didn\'t have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/register");
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return Login();
                          //     },
                          //   ),
                          // );
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return Login();
                          //     },
                          //   ),
                          // );
                        },
                        child: Text(
                          ' Register',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// import 'dart:convert';

// //import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:monix/api_service.dart';
// import 'package:monix/screens/home.dart';
// import 'package:monix/colors/colors.dart';
// import 'package:monix/screens/main_navigation.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Login extends StatefulWidget {
//   const Login({super.key});

//   @override
//   State<Login> createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   Api_service api = Api_service();
//  // FirebaseMessaging messaging = FirebaseMessaging.instance;
//   Future<void> login() async {
//     try {
//    // String? token = await messaging.getToken();
//       Map<String, dynamic> data = await api.postData('login.php', {
        
//         'email': email.text,
//         'password': password.text,
        
       
//       });
//       // var url = Uri.parse('${api.baseUrl}login.php');

//       // var res = await http.post(
//       //   url,
//       //   body: {'email': email.text, 'password': password.text},
//       // );
//       // print(res.body);
//       // print("STATUS CODE: ${res.statusCode}");
//       // print("BODY: ${res.body}");
//       //var data = jsonDecode(res.body);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(data['message']),
//           backgroundColor: data['status'] ? Colors.green : Colors.red,
//         ),
//       );

//       if (data['status'] == true) {
//         //as a setion to save the data in the local storage
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         //String? token = await messaging.getToken();
//         await prefs.setInt("id", data["id"]);
//         await prefs.setString("username", data["username"] ?? "");
//         await prefs.setString("role", data["role"] ?? "");
//         await prefs.setString("email", data["email"]);
//         await prefs.setBool("isLogin", true);
//         // await api.postData('save_fcm_token.php', {
//         //   'id': data["id"].toString(),
//         //   'fcm_token': token ?? "",
//         // });

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => MainNavigation()),
//         );
//       }
//     } catch (e, s) {
//       print("========== ERROR ==========");
//       print(e);
//       print(s);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
//       );
//     }
//   }

//   final TextEditingController email = TextEditingController();
//   final TextEditingController password = TextEditingController();
//   final keyfrm = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     email.dispose();
//     password.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.ofwhite,
//       body: SafeArea(
//         child: Container(
//           color: AppColors.ofwhite,
//           padding: EdgeInsets.all(20),
//           child: Form(
//             key: keyfrm,
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Center(
//                     child: Column(
//                       children: [
//                         Container(
//                           height: 40,
//                           width: 40,
//                           //color: Colors.amber,
//                           decoration: BoxDecoration(
//                             color: AppColors.primary,
//                             borderRadius: BorderRadius.circular(40),
//                           ),
//                           child: Icon(
//                             Icons.list,
//                             color: AppColors.ofwhite,
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         Text(
//                           'Sign up',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Text(
//                           'Welcome Back! Login to continue using the app.',
//                           style: TextStyle(
//                             color: Colors.black.withOpacity(0.5),
//                             fontSize: 12,
//                             //fontWeight:
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
        
//                   SizedBox(height: 10),
        
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Email ',
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
                         
//                         ],
//                       ),
//                       SizedBox(height: 10),
//                       TextFormField(
//                         validator: (value) {
//                           if (value == "" || value == null) {
//                             return "email must fill";
//                           } else if (!value.contains("@")) {
//                             return "username must contain @";
//                           }
        
//                           return null;
//                         },
//                         controller: email,
//                         style: TextStyle(color: AppColors.primary),
//                         //obscureText: true,//to hide the text as dots
//                         keyboardType: TextInputType
//                             .emailAddress, //in the emulater will be appeared
//                         //maxLength: 10,
//                         maxLines: 1,
//                         //minLines: 1,
//                         decoration: InputDecoration(
//                           prefixIcon: Icon(Icons.email, color: AppColors.primary),
//                           hintText: "Enter Your Email",
//                           hintStyle: TextStyle(
//                             fontSize: 14,
//                             color: const Color.fromARGB(
//                               255,
//                               0,
//                               0,
//                               0,
//                             ).withOpacity(0.8),
//                           ),
//                           //label: Text("Employee me"),
//                           filled: true,
//                           fillColor:  AppColors.ofwhite,
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: const Color.fromARGB(255, 0, 0, 0),
//                               width: 1,
//                             ),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: const Color.fromARGB(255, 0, 0, 0),
//                               width: 1,
//                             ),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: const Color.fromARGB(255, 0, 0, 0),
//                               width: 1,
//                             ),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             'Password ',
//                             style: TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text(
//                             'Forget password?',
//                             style: TextStyle(
//                               color: AppColors.primary,
//                               fontSize: 12,
//                               //fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10),
//                       TextFormField(
//                         controller: password,
//                         style: TextStyle(color: AppColors.primary),
//                         obscureText: true,
        
//                         //obscureText: true,//to hide the text as dots
//                         //in the emulater will be appeared
//                         //maxLength: 10,
//                         //maxLines: 3,
//                         //minLines: 1,
//                         decoration: InputDecoration(
//                           prefixIcon: Icon(Icons.lock, color: AppColors.primary),
//                           hintText: "Enter Your Password",
//                           hintStyle: TextStyle(
//                             fontSize: 14,
//                             color: const Color.fromARGB(
//                               255,
//                               0,
//                               0,
//                               0,
//                             ).withOpacity(0.8),
//                           ),
//                           //label: Text("Employee me"),
//                           filled: true,
//                           fillColor:  AppColors.ofwhite,
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: const Color.fromARGB(255, 0, 0, 0),
//                               width: 1,
//                             ),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: const Color.fromARGB(255, 0, 0, 0),
//                               width: 1,
//                             ),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           errorBorder: OutlineInputBorder(
//                             borderSide: BorderSide(
//                               color: const Color.fromARGB(255, 0, 0, 0),
//                               width: 1,
//                             ),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: () {
//                           // Navigator.pushNamed(context, "/home");
//                           if (keyfrm.currentState!.validate()) {
//                             login();
//                           }
//                           // if (keyfrm.currentState!.validate()) print('done');
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primary,
//                           foregroundColor:  AppColors.ofwhite,
//                           minimumSize: Size(double.infinity, 55),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                         child: Text(
//                           'Log In',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
        
//                       SizedBox(height: 15),
//                       Center(child: Text(' Or continue with')),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Image.asset('assets/icons/google.png', width: 70),
//                           //SizedBox(width: 100),
//                           Text('Or'),
//                           Image.asset('assets/icons/facebook.png', width: 70),
//                         ],
//                       ),
//                     ],
//                   ),
//                   // Text.rich(
//                   //   TextSpan(
//                   //     children: [
//                   //       TextSpan(text: 'Have An Account ? '),
//                   //       TextSpan(
//                   //         text: 'Login',
//                   //         style: TextStyle(
//                   //           color: Colors.amber,
//                   //           fontWeight: FontWeight.bold,
//                   //         ),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('Didn\'t have an account?'),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, "/register");
//                           // Navigator.of(context).push(
//                           //   MaterialPageRoute(
//                           //     builder: (context) {
//                           //       return Login();
//                           //     },
//                           //   ),
//                           // );
//                           // Navigator.push(
//                           //   context,
//                           //   MaterialPageRoute(
//                           //     builder: (context) {
//                           //       return Login();
//                           //     },
//                           //   ),
//                           // );
//                         },
//                         child: Text(
//                           ' Register',
//                           style: TextStyle(color: AppColors.primary),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
