/// HTTP middleware and pipeline framework designed to work with Dart's
/// built-in HttpServer from `dart:io`.
library corsac_middleware;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

part 'src/middleware.dart';
part 'src/pipeline.dart';
