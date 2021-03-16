import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen(this.currUser, this.payee, this.amount, this.groupID);
  final currUser;
  final payee;
  final amount;
  final groupID;
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _loadHTML() {
    return '''
      <html>
        <body onload="document.f.submit();">
          <form id="f" name="f" method="post" action="https://slashwise-backend-live.herokuapp.com/pay?price=${widget.amount}&email=${widget.currUser.email}&targetEmail=${widget.payee.email}&currUserID=${widget.currUser.id}&targetID=${widget.payee.id}&groupID=${widget.groupID}">
          </form>
        </body>
      </html>
    ''';
    // return '''
    //   <html>
    //     <body onload="document.f.submit();">
    //       <form id="f" name="f" method="post" action="https://slashwise-backend.herokuapp.com/pay">
    //         <input type="hidden" name="price" value="${widget.price}" />
    //       </form>
    //     </body>
    //   </html>
    // ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WebView(
      onPageFinished: (page) {
        if (page.contains('/success')) {
          Navigator.pop(context);
        }
      },
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl:
          new Uri.dataFromString(_loadHTML(), mimeType: 'text/html').toString(),
    ));
  }
}
