import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pointycastle/export.dart'as pointyexport;

final TextEditingController decryptedTextController = TextEditingController();
final TextEditingController controller = TextEditingController();
final TextEditingController encryptedTextController = TextEditingController();

const storage = FlutterSecureStorage();

Future<void> generateAndStoreKeys() async {
  final rsaKeyHelper = RsaKeyHelper();
  final rsaKeyPair =
      await rsaKeyHelper.computeRSAKeyPair(rsaKeyHelper.getSecureRandom());

  final publicKey = rsaKeyPair.publicKey as pointyexport.RSAPublicKey;
  final privateKey = rsaKeyPair.privateKey as pointyexport.RSAPrivateKey;

  final publicKeyPEM = rsaKeyHelper.encodePublicKeyToPemPKCS1(publicKey);
  final privateKeyPEM = rsaKeyHelper.encodePrivateKeyToPemPKCS1(privateKey);

  await storage.write(key: 'publicKey', value: publicKeyPEM);
  await storage.write(key: 'privateKey', value: privateKeyPEM);
}
Future<pointyexport.RSAPublicKey?> getPublicKey() async {
  final publicKeyPEM = await storage.read(key: 'publicKey');
  if (publicKeyPEM != null) {
    return RsaKeyHelper().parsePublicKeyFromPem(publicKeyPEM);
  }
  return null;
}

Future<pointyexport.RSAPrivateKey?> getPrivateKey() async {
  final privateKeyPEM = await storage.read(key: 'privateKey');
  if (privateKeyPEM != null) {
    return RsaKeyHelper().parsePrivateKeyFromPem(privateKeyPEM);
  }
  return null;
}
void main(){
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encryption App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Encryption App Using RSA'),
          centerTitle: false,
          backgroundColor: Colors.teal,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextEntryWidgetEncryptMessage(),
              TextArea()
            ],
          ),
        ),
      ),
    );
  }
}

class TextEntryWidgetEncryptMessage extends StatefulWidget {
  const TextEntryWidgetEncryptMessage({super.key});

  @override
  _TextEntryWidgetEncryptMessageState createState() =>
      _TextEntryWidgetEncryptMessageState();
}


class TextArea extends StatelessWidget {
  const TextArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: decryptedTextController,
                  maxLines: 4,
                  enabled: false,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await generateAndStoreKeys();

                      // Display a toast message to indicate that keys were generated
                      Fluttertoast.showToast(
                        msg: 'Keys were generated and stored',
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.black,
                        textColor: Colors.white, //
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green),
                    child: const Text('Generate And Store Keys')
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Call the resetTextFields function to clear text fields
                    resetTextFields();
                  },
                  child: const Text('Reset'),
                ),

              ],
            ),
          ],
        )
    );
  }
  void resetTextFields(){
    controller.text = '';
    encryptedTextController.text = '';
    decryptedTextController.text = '';
  }
}

