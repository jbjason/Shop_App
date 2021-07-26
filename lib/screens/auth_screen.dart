import '../models/http_exception.dart';
import '../providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flare_flutter/flare_actor.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Stack(children: [
            LoginDesign1(deviceSize: deviceSize),
            LoginDesign2(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: deviceSize.height * .2,
                  width: 250,
                  margin: EdgeInsets.only(bottom: 20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.deepOrange.shade900,
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/homeLogo2.jpeg',
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  height: deviceSize.height * .65 + 15.0,
                  color: Colors.transparent,
                  child: AuthCard(),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();
  final _userNameController = TextEditingController();
  FocusNode _passwordNode = FocusNode();
  FocusNode _userNameNode = FocusNode();
  String _anitmationType = 'idle';

  @override
  void initState() {
    _passwordNode.addListener(() {
      if (_passwordNode.hasFocus) {
        setState(() {
          _anitmationType = 'hands_up';
        });
      } else {
        setState(() {
          _anitmationType = 'hands_down';
        });
      }
    });
    _userNameNode.addListener(() {
      if (_userNameNode.hasFocus) {
        setState(() {
          _anitmationType = 'test';
        });
      } else {
        setState(() {
          _anitmationType = 'idle';
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _passwordNode.dispose();
    _userNameNode.dispose();
    _passwordController.dispose();
    _userNameController.dispose();

    super.dispose();
  }

  void _showErrorDialog(String msg) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 1),
    ));
    // showDialog(
    //     context: context,
    //     builder: (_) => AlertDialog(
    //           title: Text('Error Occured'),
    //           content: Text(msg),
    //           actions: [
    //             FlatButton(
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //               child: Text('okay'),
    //             )
    //           ],
    //         ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      FocusScopeNode currentFocus = FocusScope.of(context);
      currentFocus.unfocus();
      await Future.delayed(Duration(milliseconds: 300));
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email'], _authData['password']);
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email'], _authData['password']);

        setState(() {
          _anitmationType = 'success';
        });
      }
    } on HttpException catch (error) {
      setState(() {
        _anitmationType = 'fail';
      });
      // Manual error/Exception Handling
      var errorMsg = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMsg = 'This email is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMsg = 'This is not a valid email';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMsg = 'This password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMsg = 'Could not find that email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMsg = 'Invalid Password';
      }
      _showErrorDialog(errorMsg);
    } catch (error) {
      setState(() {
        _anitmationType = 'fail';
      });
      _showErrorDialog('Could not authinticate you. Please try again later');
    }
    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      width: deviceSize.width,
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              width: 300,
              child: FlareActor(
                'assets/images/Teddy.flr',
                alignment: Alignment.bottomCenter,
                fit: BoxFit.contain,
                animation: this._anitmationType,
                callback: (_) {
                  setState(() {
                    this._anitmationType = 'idle';
                  });
                },
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
              ),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    focusNode: _userNameNode,
                    decoration: InputDecoration(
                      hintText: ' E-Mail',
                      hintStyle: TextStyle(
                          color: Colors.grey, fontFamily: 'Quicksand'),
                      prefixIcon: Icon(Icons.mark_email_read,
                          size: 30.0,
                          color:
                              Color.fromRGBO(38, 50, 56, 1).withOpacity(0.8)),
                      contentPadding: EdgeInsets.all(20),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['email'] = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: ' Password',
                      hintStyle: TextStyle(
                          color: Colors.grey, fontFamily: 'Quicksand'),
                      prefixIcon:
                          Icon(Icons.lock, size: 30.0, color: Colors.green),
                      contentPadding: EdgeInsets.all(20),
                    ),
                    // password text star hishebe show korbe
                    obscureText: true,
                    controller: _passwordController,
                    focusNode: _passwordNode,
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                  ),
                  if (_authMode == AuthMode.Signup)
                    TextFormField(
                      enabled: _authMode == AuthMode.Signup,
                      decoration: InputDecoration(
                        hintText: ' Confirm Password',
                        hintStyle: TextStyle(
                            color: Colors.grey, fontFamily: 'Quicksand'),
                        prefixIcon:
                            Icon(Icons.lock, size: 30.0, color: Colors.green),
                        contentPadding: EdgeInsets.all(20),
                      ),
                      obscureText: true,
                      validator: _authMode == AuthMode.Signup
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                              return null;
                            }
                          : null,
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    RaisedButton(
                      child: Text(
                          _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                      onPressed: _submit,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
                    ),
                  FlatButton(
                    child: Text(
                        '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                    onPressed: _switchAuthMode,
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textColor: Theme.of(context).primaryColor,
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginDesign1 extends StatelessWidget {
  const LoginDesign1({
    Key key,
    @required this.deviceSize,
  }) : super(key: key);

  final Size deviceSize;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        height: 550,
        width: deviceSize.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/welcomeShop.jpg')),
        ),
      ),
    );
  }
}

class LoginDesign2 extends StatelessWidget {
  const LoginDesign2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.fill),
      ),
      child: Stack(children: [
        Positioned(
          left: 30,
          width: 80,
          height: 200,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/light1.png'))),
          ),
        ),
        Positioned(
          left: 140,
          width: 80,
          height: 150,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/light2.png'))),
          ),
        ),
        Positioned(
          right: 40,
          top: 40,
          width: 80,
          height: 150,
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/clock.png'))),
          ),
        ),
      ]),
    );
  }
}
