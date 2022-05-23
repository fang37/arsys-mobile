import 'package:arsys/login/view/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> formKey = GlobalKey();
  LoginViewModel _viewModel = Get.put(LoginViewModel());

  TextEditingController emailCtr = TextEditingController();
  TextEditingController passwordCtr = TextEditingController();
  FormType _formType = FormType.login;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage("assets/arches.png"),
              scale: 1.5,
              fit: BoxFit.none,
              repeat: ImageRepeat.repeat),
          gradient: LinearGradient(
              colors: [Colors.lightBlue, Colors.lightBlueAccent[100]!],
              begin: FractionalOffset.bottomLeft,
              end: FractionalOffset.topRight)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                arsysLogo(),
                loginCard(),
              ],
            )),
      ),
    );
  }

  Card loginCard() {
    return Card(
      elevation: 4.0,
      color: Colors.white,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: loginForm(),
      ),
    );
  }

  Padding arsysLogo() {
    return Padding(
      padding: EdgeInsets.only(
          top: (MediaQuery.of(context).size.height * 0.05), bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Ar",
                style: TextStyle(
                  fontFamily: "Helvetica",
                  fontWeight: FontWeight.bold,
                  fontSize: 80,
                  color: Color(0xFFFFFFFF),
                ),
              ),
              Text(
                "Sys",
                style: TextStyle(
                  fontFamily: "Helvetica",
                  fontSize: 80,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ],
          ),
          const Text(
            "Advanced Research Support System",
            style: TextStyle(
              fontFamily: "Helvetica",
              fontSize: 20,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ],
      ),
    );
  }

  Form loginForm() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextFormField(
          controller: emailCtr,
          validator: (value) {
            return (value == null || value.isEmpty)
                ? 'Please Enter Email'
                : null;
          },
          decoration: inputDecoration('E-mail', Icons.person),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          obscureText: true,
          validator: (value) {
            return (value == null || value.isEmpty)
                ? 'Please Enter Password'
                : null;
          },
          controller: passwordCtr,
          decoration: inputDecoration('Password', Icons.lock),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                await _viewModel.loginUser(emailCtr.text, passwordCtr.text);
              }
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width * 0.8, 40)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(width: 1.5, color: Colors.transparent))),
              backgroundColor:
                  MaterialStateProperty.all(Colors.lightBlueAccent[600]),
              shadowColor: MaterialStateProperty.all(Colors.transparent),
            ),
            child: Text('Login'),
          ),
        ),
        Wrap(
          children: [
            const Text(
              "For use ArSys Mobile, please do mobile activation ",
              style:
                  TextStyle(color: Color(0xff3A4856), fontFamily: "OpenSans"),
            ),
            InkWell(
                onTap: () async {
                  await openURL(
                      'http://ee.upi.edu/arsys/arsys/user/mobile-activation');
                },
                child: Text("here",
                    style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontFamily: "OpenSans",
                        fontWeight: FontWeight.bold)))
          ],
        ),
      ]),
    );
  }

  Form registerForm() {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextFormField(
          controller: emailCtr,
          validator: (value) {
            return (value == null || value.isEmpty)
                ? 'Please Enter Email'
                : null;
          },
          decoration: inputDecoration('E-mail', Icons.person),
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          validator: (value) {
            return (value == null || value.isEmpty)
                ? 'Please Enter Password'
                : null;
          },
          controller: passwordCtr,
          decoration: inputDecoration('Password', Icons.lock),
        ),
        SizedBox(
          height: 8,
        ),
        TextFormField(
          validator: (value) {
            return (value == null || value.isEmpty || value != passwordCtr.text)
                ? 'Passwords does not match'
                : null;
          },
          decoration: inputDecoration('Retype Password', Icons.lock),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _formType = FormType.login;
            });
          },
          child: Text('Login'),
        )
      ]),
    );
  }
}

InputDecoration inputDecoration(String labelText, IconData iconData,
    {String? prefix, String? helperText}) {
  return InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    helperText: helperText,
    labelText: labelText,
    prefixText: prefix,
    prefixIcon: Icon(
      iconData,
      size: 20,
    ),
    prefixIconConstraints: BoxConstraints(minWidth: 60),
    // enabledBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(30),
    //     borderSide: BorderSide(color: Colors.black)),
    // focusedBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(30),
    //     borderSide: BorderSide(color: Colors.black)),
    // errorBorder: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(30),
    //     borderSide: BorderSide(color: Colors.black)),
    // border: OutlineInputBorder(
    //     borderRadius: BorderRadius.circular(30),
    //     borderSide: BorderSide(color: Colors.black)),
  );
}

Future<void> openURL(String url,
    {bool forceWebView = false, bool enableJavaScript = true}) async {
  await launch(url,
      forceWebView: forceWebView, enableJavaScript: enableJavaScript);
}

enum FormType { login, register }
