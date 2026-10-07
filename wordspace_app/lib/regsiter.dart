import 'package:flutter/material.dart';
import 'package:wordspace_app/colors/colors.dart';
import 'package:wordspace_app/api/api_service.dart';
//import 'package:monix/api_service.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Api_service api = Api_service();
  final ApiService api = ApiService();
  Future<void> register() async {
    try {
      final data = await api.post('register', {
        'name': username.text.trim(),
        'email': email.text.trim(),
        'password': password.text,
        'password_confirmation': confpassword.text,
      });

      if (!mounted) return;

      if (data['token'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Account created successfully'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacementNamed(context, "/login");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Registration failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  final TextEditingController email = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confpassword = TextEditingController();
  final keyfrm = GlobalKey<FormState>();
  @override
  void dispose() {
    email.dispose();
    username.dispose();
    password.dispose();
    confpassword.dispose();
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
                            color: AppColors.bistre,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Icon(Icons.list, color: AppColors.ofwhite),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                              color: AppColors.bistre
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Create an account to use the app',
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
                      Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                            color: AppColors.bistre
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value == "" || value == null) {
                            return "Username is required";
                          } else if (value.length < 6) {
                            return "Username must be at least 6 characters";
                          } else if (value.contains(" ")) {
                            return "Username cannot contain spaces";
                          }

                          return null;
                        },
                        controller: username,
                        style: TextStyle(color: AppColors.bistre),
                        //obscureText: true,

                        //obscureText: true,//to hide the text as dots
                        //in the emulater will be appeared
                        //maxLength: 10,
                        //maxLines: 3,
                        //minLines: 1,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                             color: AppColors.bistre.withOpacity(0.7),
                          ),
                          hintText: "  Enter username",
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
                      Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                            color: AppColors.bistre
                        ),
                      ),

                      SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value == "" || value == null) {
                            return "Email is required";
                          } else if (value.length < 6) {
                            return "Email must be at least 6 characters";
                          } else if (value.contains(" ")) {
                            return "Email cannot contain spaces";
                          } else if (!value.contains("@")) {
                            return "Email must contain @";
                          }

                          return null;
                        },
                        controller: email,
                        style: TextStyle(color: AppColors.bistre),
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
                          hintText: "Enter your email",
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
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                            color: AppColors.bistre
                        ),
                      ),
                      SizedBox(height: 10),

                      TextFormField(
                        validator: (value) {
                          if (value == "" || value == null) {
                            return "Password is required";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          } else if (value.contains(" ")) {
                            return "Password cannot contain spaces";
                          }

                          return null;
                        },
                        controller: password,
                        style: TextStyle(color: AppColors.bistre),
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
                          hintText: "Enter password",
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
                      Text(
                        'Confirm Password',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                            color: AppColors.bistre
                        ),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == "" || value == null) {
                            return "Password is required";
                          } else if (value.length < 6) {
                            return "Password must be at least 6 characters";
                          } else if (value.contains(" ")) {
                            return "Password cannot contain spaces";
                          }

                          return null;
                        },
                        controller: confpassword,
                        style: TextStyle(color: AppColors.bistre),
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
                          hintText: "Confirm Password",
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

                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          //Navigator.pushNamed(context, "/home");
                          // if (keyfrm.currentState!.validate()) print('done');
                          if (keyfrm.currentState!.validate()) {
                            register();
                          }
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
                          'Register',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: 15),
                      // Center(child: Text('or sign up with')),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     Image.asset('assets/icons/google.png', width: 70),
                      //     //SizedBox(width: 100),
                      //     Text('or'),
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
                      Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/login");
                          // Navigator.pop(context);
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
                          'Login',

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
