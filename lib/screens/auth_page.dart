import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yoko_test/constants/color_const.dart';
import 'package:yoko_test/constants/text_const.dart';
import 'package:yoko_test/service/service.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: TextField(
          style: const TextStyle(
            color: AppColors.mainAppTextColor, 
            fontSize: 16,
          ),
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.inputAuthorizationFormBackColor,
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 16, 
              color: AppColors.hintColor,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: AppColors.borderColorWithOpacity,
                width: 0.3
              )
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: AppColors.borderColorWithOpacity,
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
          const Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Text(
              AppTexts.socialMediasText, 
              style: TextStyle(
                fontSize: 16, 
                color: AppColors.mainAppTextColor
              )
            )
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.borderColor, 
                      width: 1
                    ),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: const Center(
                    child: Text(
                      AppTexts.socialMediaGoogleSymbol, 
                      style: TextStyle(
                        color: AppColors.mainAppTextColor, 
                        fontSize: 30, 
                        fontWeight: FontWeight.bold
                      )
                    )
                  )
                ),
                const SizedBox(width: 8),
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.borderColor, 
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: const Center(
                    child: Text(
                      AppTexts.socialMediaFacebookSymbol, 
                      style: TextStyle(
                        color: AppColors.mainAppTextColor, 
                        fontSize: 30, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    Widget authButton(){
      return Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: OutlinedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
              AppColors.backgroundColor,
            ),
          ),
          child: const Text(
            AppTexts.signInText, 
            style: TextStyle(
              fontSize: 16, 
              color: AppColors.mainAppColor,
            ),
          ),
          onPressed: () async {
            await authFunc(
              context, 
              emailController.text, 
              passwordController.text,
            );
          },
        ),
      );
    }

    Widget form(){
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 54, bottom: 12),
            child: input(AppTexts.emailHintText, emailController),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: input(AppTexts.passwordHintText, passwordController),
          ),
          authButton(),
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
            child: Row(
              children: [
                const Text(
                  AppTexts.registrationOptionName, 
                  style: TextStyle(
                    fontSize: 16, 
                    color: AppColors.mainAppTextColor
                  ),
                ),
                const SizedBox(width: 140,),
                Text(
                  AppTexts.passwordUpdateOptionName, 
                  style: TextStyle(
                    fontSize: 16, 
                    color: AppColors.hintColor,
                  ),
                ),
              ],
            ), 
          ),
        ],
      );
    }

  
    return Scaffold(
      backgroundColor: AppColors.mainAppColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 147, left: 24),
              child: Text(
                AppTexts.authorizationPageHeader,
                style: TextStyle(
                  fontSize: 32, 
                  color: AppColors.mainAppTextColor, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            form(),
            Padding(
              padding: const EdgeInsets.only(top: 24, left: 120, right: 120),
              child: socialMedias(),
            ),
          ],
        ),
      ),
    );
  }
}