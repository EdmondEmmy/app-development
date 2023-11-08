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

void main(){

}



