import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app_todo/main.dart';

class Registration extends StatelessWidget {
  String? mailAddress;
  String? password;
  String? passwordCheck;

  Registration({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新規登録'),

      ),
      body: Column(
        children: [
          CustomTextField(
            label: 'メールアドレス',
            onChangedfunc: (newText) {
              mailAddress = newText;
            },
            isPassword: false,
          ),
          CustomTextField(
            label: 'パスワード',
            onChangedfunc: (newText) {
              password = newText;
            },
            isPassword: true,
          ),
          CustomTextField(
            label: 'パスワード確認',
            onChangedfunc: (newText) {
              passwordCheck = newText;
            },
            isPassword: true,
          ),
          ElevatedButton(
              child: Container(
                width: 200,
                height: 50,
                alignment: Alignment.center,
                child: const Text(
                  '新規登録',
                  textAlign: TextAlign.center,
                ),
              ),
              onPressed: () async {
                if (passwordCheck != password) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('エラー'),
                        content: const Text('パスワードを正しく入力してください。'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  if (mailAddress != null && password != null) {
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                        email: mailAddress!,
                        password: password!,
                      );
                      // if (!context.mounted) return;
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('登録しました'),
                            content: Text('登録完了しました。'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      // Navigator.push(MaterialPage(context) => Text('OK');)
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('エラー'),
                              content: const Text('パスワードが短すぎます。'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else if (e.code == 'email-already-in-use') {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('エラー'),
                              content: Text('入力されたメールアドレスは既につかわれています。'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } catch (e) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('エラー'),
                              content: Text(e.toString()),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'))
                              ],
                            );
                          });
                      // print(e);
                    }
                  }
                }
              }),
        ],
      ),
    );
  }
}
