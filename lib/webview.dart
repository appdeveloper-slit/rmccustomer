import 'package:flutter/material.dart';
import 'package:rmc_customer/home.dart';
import 'package:rmc_customer/manager/static_method.dart';
import 'package:rmc_customer/values/dimens.dart';
import 'package:rmc_customer/values/styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String sUrl;
  final Widget page;

  const WebViewPage(this.sUrl, this.page, {Key? key}) : super(key: key);

  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  late BuildContext ctx;
  bool isLoading = true;
  late WebViewController webCtrl;

  @override
  void initState() {
    webCtrl = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
              if (url.contains("success_page")) {
                STM().successDialogWithAffinity(
                    ctx, "Payment successfully", Home());
              } else if (url.contains("failed_page")) {
                STM().displayToast('Payment failed');
                STM().back2Previous(ctx);
              }
            });
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.sUrl),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            if (isLoading)
              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction: Axis.vertical,
                  children: [
                    const CircularProgressIndicator(),
                    SizedBox(
                      height: Dim().d12,
                    ),
                    Text(
                      'Processing ...',
                      style: Sty().largeText,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            WebViewWidget(
              controller: webCtrl,
            ),
          ],
        ),
      ),
    );
  }
}
