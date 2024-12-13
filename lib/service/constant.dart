import 'package:flutter/material.dart';

//const constserver = 'http://192.168.0.13:8098';

//const constserversocket = 'http://192.168.0.13:9000';

const constserver =
    'http://ec2-3-23-93-56.us-east-2.compute.amazonaws.com:8080';

const constserversocket =
    'http://ec2-3-23-93-56.us-east-2.compute.amazonaws.com:9000';

const loginUrl = constserver + "/api/auth/login";

const registerUrl = constserver + "/api/auth/register";

const registerUrlApoderado = constserver + "/api/user/register-apoderado";

const protegidos =
    constserver + "/api/user/protegido/"; // se le suma al final /protegidos

const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';
