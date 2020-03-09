import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PayWebView extends StatefulWidget {
  final String session;
  final String id;

  PayWebView({this.session, this.id});

  @override
  _PayWebViewState createState() => _PayWebViewState();
}

class _PayWebViewState extends State<PayWebView> {
  String _loadHTML() {
    return '<!DOCTYPE html><html><body onload="document.f.submit();"><form id="f" name="f" method="post" action="https://nbe.gateway.mastercard.com/api/page/version/43/pay"><input type="hidden" name="merchant" value="EGGATE" /><input type="hidden" name="order.amount" value="258.44" /><input type="hidden" name="order.currency" value="EGP" /><input type="hidden" name="order.description" value="Ordered items" /><input type="hidden" name="interaction.merchant.name" value="EG-GATE" /><input type="hidden" name="interaction.displayControl.customerEmail" value="HIDE" /><input type="hidden" name="interaction.displayControl.billingAddress" value="HIDE" /><input type="hidden" name="interaction.displayControl.orderSummary" value="HIDE" /><input type="hidden" name="interaction.displayControl.paymentTerms" value="HIDE" /><input type="hidden" name="interaction.displayControl.shipping" value="HIDE" /><input type="hidden" name="interaction.cancelUrl" value="urn:hostedCheckout:defaultCancelUrl" /><input type="hidden" name="session.id" value="${widget.session}" /><input type="hidden" name="session.version" value="${widget.id}" /></form></body></html>';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final flutterWebviewPlugin = new FlutterWebviewPlugin();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      print("Basem log ${url}");
    });

    print("Basem html ${_loadHTML()}");
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(),
      withJavascript: true,
      appCacheEnabled: false,
      clearCache: true,
      clearCookies: true,
      supportMultipleWindows: true,
      withZoom: false,
      displayZoomControls: false,
      enableAppScheme: true,
      url: Uri.dataFromString(_loadHTML(),
              mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
          .toString(),
    );
  }
}
