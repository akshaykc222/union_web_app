import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:union_web_app/Pages/Agents.dart';
import 'package:union_web_app/routes.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final _formKey = GlobalKey<FormState>();
  final _userName=TextEditingController();
  final _passWord=TextEditingController();
  void _submit() async{
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();
    if(_userName.text=="antony"&&_passWord.text=="123456"){
      final SharedPreferences prefs = await _prefs;
      prefs.setBool("session", true);
      Navigator.pushNamed(context, home);
    }
  }
  void checkSession() async{
    final SharedPreferences prefs = await _prefs;
    bool? session=  prefs.getBool("session");
    if(session==true){
      Navigator.pushReplacementNamed(context, home);
    }
  }
  @override
  void initState() {
    checkSession();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child:Container(
          width: width*0.3,
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                      child: Column(
                        children: [
                          Text('Login',style: TextStyle(fontSize: 25),),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(

                              validator: (value){
                                if(value!.isEmpty){
                                  return "Empty user name";
                                }
                                return null;
                              },
                              controller: _userName,
                              decoration: InputDecoration(
                                labelText: 'UserName',
                                hintText: "Enter UserName",

                                // If  you are using latest version of flutter then lable text and hint text shown like this
                                // if you r using flutter less then 1.20.* then maybe this is not working properly
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Empty Password";
                                }
                                return null;
                              },
                              controller: _passWord,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: "Enter PassWord",

                                // If  you are using latest version of flutter then lable text and hint text shown like this
                                // if you r using flutter less then 1.20.* then maybe this is not working properly
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          InkWell(
                            onTap: _submit,
                            child: Container(
                              width: width*0.2,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text('Login',style: TextStyle(color: Colors.white),),
                              ),
                            ),
                          )
                        ],
                      )
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
