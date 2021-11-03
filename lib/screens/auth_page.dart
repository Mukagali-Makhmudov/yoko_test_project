import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yoko_test/models/tokens.dart';
import 'package:yoko_test/screens/activity_page.dart';

class AuthPage extends StatefulWidget {

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Widget input(String hint, TextEditingController controller){
      return Container(
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: TextField(
          style: TextStyle(color: Colors.white, fontSize: 16),
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            hintText: hint,
            hintStyle: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.5)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.5),
                width: 0.3
              )
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.5),
                width: 0.3
              )
            ),
          )
        ),
      );
    }

    Widget socialMedias(){
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text('Или войдите через:', style: TextStyle(fontSize: 16, color: Colors.white),)
          ),
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Center(
                    child: Text('G', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),)
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Center(
                    child: Text('f', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),)
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }

    Widget authButton(){
      return Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: OutlinedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          child: Text('Войти', style: TextStyle(fontSize: 16, color: Color(0xFF5E94E1))),
          onPressed: () async {
            Dio dio = Dio();
            Box tokensBox = Hive.box('tokens');
            try {
              Response response = await dio.post(
                'https://api.shymbulak-dev.com/user-service/auth/login',
                data: {
                  'email': 'test@yoko.space',
                  'password': 'qwerty123'
                }
              );

              TokensModel tokensModel = TokensModel(
                access: response.data['accessToken'],
              );

              tokensBox.put('access', tokensModel.access);

              Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityPage()));
            } on DioError catch (e) {
              showCupertinoModalPopup(
                context: context, 
                builder: (context){
                  return CupertinoAlertDialog(
                    title: Text('Ошибка'),
                    content: Text('Неправильный логин или пароль!'),
                    actions: [
                      CupertinoButton(child: Text('OK'), onPressed: () => Navigator.pop(context,))
                    ],
                  );
                }
              );
              throw e;
            }
          },
        )
      );
    }

    Widget form(){
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 54, bottom: 12),
            child: input('E-mail', emailController),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: input('Password', passwordController),
          ),
          authButton(),
          Padding(
            padding: EdgeInsets.only(top: 16, left: 24, right: 24),
            child: Container(
              child: Row(
                children: [
                  Text('Регистрация', style: TextStyle(fontSize: 16, color: Colors.white)),
                  SizedBox(width: 140,),
                  Text('Забыли пароль?', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.5)))
                ],
              ),
            ), 
          ),
        ],
      );
    }

  
    return Scaffold(
      backgroundColor: Color(0xFF5E94E1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 147, left: 24),
              child: Text('Добро пожаловать,\nАвторизуйтесь',
                style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            form(),
            Padding(
              padding: EdgeInsets.only(top: 24, left: 120, right: 120),
              child: socialMedias(),
            )
          ],
        ),
      ),
    );
  }
}