import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:raven/pages/authenticate/signupemail.dart';
import 'package:raven/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:raven/shared/loading.dart';




class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();

  
  final _formkey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  String error = "";
  bool loading = false;




  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  } //email verification


  TapGestureRecognizer _signUp;

  @override
  void initState() {
    super.initState();
    _signUp = TapGestureRecognizer()..onTap = () {
      widget.toggleView();

      /*Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));*/
    };
  }

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText =!_obscureText;
      print("inside toggle");
    });
  }

  @override
  
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return  loading ? Loading() : Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: true,

      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: queryData.size.height,
          width: queryData.size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background1.jpg'),
              fit: BoxFit.fitHeight,
              alignment: Alignment.topLeft,
              colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.35), BlendMode.dstATop)
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: queryData.size.height/2.5,
                    color: Colors.transparent,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          right: 40,
                          top: 18,
                          width: 330,
                          height: queryData.size.height/2.67,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/organic_red.png'),
                                )
                            ),
                          ),
                        ),
                        Positioned(
                            left: 20,
                            top: 20,
                            width: 400,
                            height: queryData.size.height/2.67,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/organic_blue.png'),
                                  )
                              ),
                            )
                        ),
                        Positioned(
                            left: 0,
                            top: 30,
                            width: 420,
                            height: queryData.size.height/2.76,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/peacock_feather.png'),
                                  )
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 25,),
                  Container(
                    width: queryData.size.width - 68,
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            validator: (val) {
                              if(val.isEmpty)
                                return 'Empty';
                              if(validateEmail(val) == false )
                                return 'Enter a valid Email Address';
                              return null;
                            },
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black54
                            ),
                            decoration: InputDecoration(
                                hintText: "Email",
                                hintStyle: TextStyle(
                                    color: Colors.black45
                                ),
                              prefixIcon: Icon(Icons.alternate_email),
                            ),
                          ),

                          SizedBox(height: 5,),

                          TextFormField(
                              controller: passwordController,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black54
                              ),
                              validator: (val){
                                if(val.isEmpty)
                                  return 'Empty';
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: "Password",
                                hintStyle: TextStyle(
                                  color: Colors.black45,
                                ),
                                prefixIcon: Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _toggle();
                                    print("this is working");
                                  },

                                  padding: EdgeInsets.only(left: 6),
                                  icon: Icon(Icons.remove_red_eye),
                                ),
                              ),
                            obscureText: _obscureText,

                          ),
                          SizedBox(height:22),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () async {
                                  if(_formkey.currentState.validate()){
                                    setState(() {
                                      loading = true;
                                    });
                                    dynamic result = await _auth.signInWithEmailAndPassword(emailController.text, passwordController.text);
                                    if(result == null){

                                      setState(() => error = 'Wrong Email-Address or Password');
                                      print(error);
                                      loading = false;
                                    }
                                  }
                                },
                                child: Container(
                                  height: 35,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.deepPurple,
                                            Colors.blue
                                          ]
                                      )
                                  ),
                                  child: Center(
                                      child: RichText(text: TextSpan(text: "Sign In   ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                          children: [WidgetSpan(child: FaIcon(FontAwesomeIcons.locationArrow, color: Colors.white, size: 15,), alignment: PlaceholderAlignment.middle),
                                          ]), )
                                  ),
                                ),
                              ),
                              Text("Forgot Password?", textAlign: TextAlign.right, style: TextStyle(
                                  color: Colors.purple, fontSize: 15.5, decoration: TextDecoration.underline
                              ),),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(error, style: TextStyle(fontSize: 13, color: Colors.redAccent), textAlign: TextAlign.left,),
                            ],
                          )
                        ],
                      ),
                    )
                  ),


                ],
              ),
              

              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[

                  Container(
                    width: queryData.size.width - 33,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            height: 45,
                            width: queryData.size.width - 230,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.red,
                                      Colors.pink
                                    ]
                                )
                            ),
                            child: Center(
                                child: RichText(text: TextSpan(text: "Login with Google   ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                    children: [WidgetSpan(child: FaIcon(FontAwesomeIcons.google, color: Colors.white,), alignment: PlaceholderAlignment.middle),
                                    ]), )
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            height: 45,
                            width: queryData.size.width - 230,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                    colors: [
                                      Colors.red,
                                      Colors.pink
                                    ]
                                )
                            ),
                            child: Center(
                                child: RichText(text: TextSpan(text: "Login with Phone Number   ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12,),
                                    children: [WidgetSpan(child: FaIcon(FontAwesomeIcons.phone, color: Colors.white,), alignment: PlaceholderAlignment.middle),
                                    ]), )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ", style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 13,
                        ),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 13,
                                  decoration: TextDecoration.underline,
                              ),
                              recognizer: _signUp,
                          ),

                          ],

                        ),


                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
