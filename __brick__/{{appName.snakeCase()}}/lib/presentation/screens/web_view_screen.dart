import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../core/app_constants.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

{{#enableRemoteConfig}}
import 'package:firebase_remote_config/firebase_remote_config.dart';
{{/enableRemoteConfig}}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  double progress = 0;
  String? baseUrl;

  StreamSubscription<void>? onConfigListener;
  InAppWebViewController? _controller;

  {{#enableRemoteConfig}}
  final FirebaseRemoteConfig firebaseRemoteConfig =
      FirebaseRemoteConfig.instance;
  {{/enableRemoteConfig}}

  @override
  void initState() {
    super.initState();

    {{#enableRemoteConfig}}
    _fetchAndListenToBaseUrlChanges();
    {{/enableRemoteConfig}}

    {{^enableRemoteConfig}}
    baseUrl = AppConstants.baseUrl;
    {{/enableRemoteConfig}}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: baseUrl != null
                  ? InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(baseUrl!)),
                {{#enableRemoteConfig}}
                onWebViewCreated: (InAppWebViewController controller) {
                  _controller = controller;
                  _onUrlChange();
                },
                 {{/enableRemoteConfig}}
                onReceivedServerTrustAuthRequest:
                    (controller, challenge) async {
                  return ServerTrustAuthResponse(
                      action: ServerTrustAuthResponseAction.PROCEED);
                },
                onProgressChanged:
                    (InAppWebViewController controller, int progress) {
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
              )
                  : const SizedBox(),
            ),
            Align(
              alignment: Alignment.center,
              child: progress != 1.0
                  ? Container(
                color: Colors.white,
                child: Center(
                  child: Lottie.asset(
                    AppConstants.loaderPath,
                    width: 100,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  {{#enableRemoteConfig}}
  Future<void> _fetchAndListenToBaseUrlChanges() async {
    final RemoteConfigSettings settings = RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 60),
    );
    await firebaseRemoteConfig.setConfigSettings(settings);
    await firebaseRemoteConfig.fetchAndActivate();

    await onConfigListener?.cancel();

    Future.delayed(const Duration(seconds: 1), () {
      _onUrlChange();
      if (onConfigListener == null) {
        final Stream<RemoteConfigUpdate> onConfigUpdated =
            firebaseRemoteConfig.onConfigUpdated;
        onConfigListener = onConfigUpdated.listen(
              (final RemoteConfigUpdate event) async {
            log(event.updatedKeys.toString());
            if (event.updatedKeys.contains(AppConstants.baseUrlKey)) {
              await firebaseRemoteConfig.fetchAndActivate();
              _onUrlChange();
            }
          },
        );
      }
    });
  }

  void _onUrlChange() {
    baseUrl = firebaseRemoteConfig.getString(AppConstants.baseUrlKey);
    if (_controller != null) {
      _controller!.loadUrl(
          urlRequest: URLRequest(url: WebUri(baseUrl ?? AppConstants.baseUrl)));
    }

    setState(() {});
  }
  {{/enableRemoteConfig}}
}
