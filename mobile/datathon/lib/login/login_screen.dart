import 'package:datathon/home/home_screen.dart';
import 'package:datathon/widgets/custom_button.dart';
import 'package:datathon/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String welcome = "Hoşgeldin";
  final String description = "Verimli kaynak verimli tarım";
  final String email = "Email";
  final String password = "Şifre";

  final TextEditingController emailTec = TextEditingController();
  final TextEditingController passwordTec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                welcome,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                description,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                  textEditingController: emailTec,
                  icon: const Icon(Icons.email),
                  hint: email),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                  textEditingController: passwordTec,
                  icon: const Icon(Icons.visibility_off),
                  hint: password),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text("Şifremi unuttum",
                    style: Theme.of(context).textTheme.labelMedium),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton(
                  onClick: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ));
                  },
                  text: "Giriş yap")
            ],
          ),
        ),
      ),
    );
  }
}
