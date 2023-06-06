import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voxart/utils/api.dart';

import 'components/snackbar.dart';

class Settings extends StatelessWidget {
  late Future<bool> isApiWorking;

  Settings({super.key});

  final myTextFieldController = TextEditingController();
  final apiManager = ApiManager();
  final Uri _url = Uri.parse(
      'https://colab.research.google.com/github/unshDee/voxart-backend/blob/main/backend/voxart_backend.ipynb');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  Future<Text> apiStatus() async {
    return Text( await isApiWorking ? 'API is working!' : 'Unresponsive');
  }

  @override
  Widget build(BuildContext context) {
    try {
      myTextFieldController.value =
          myTextFieldController.value.copyWith(text: apiManager.apiUrl);
    } catch (Exception) {
      print(Exception);
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            'Set API',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              autofocus: false,
              keyboardType: TextInputType.url,
              controller: myTextFieldController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter the API URL here!',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    ),
                  ),
                  onPressed: _launchUrl,
                  // onPressed: () {},
                  child: const Text('Get the URL from here'),
                ),
                const Spacer(),
                FilledButton(
                  style: FilledButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    (
                    myTextFieldController.value.text.isEmpty
                        ? const VoxSnackBar(text: 'No URL found!')
                        .show(context)
                        : {
                      apiManager.apiUrl =
                          myTextFieldController.value.text
                    },
                    );
                    print(apiManager.apiUrl);
                    isApiWorking = apiManager.test();
                  },
                  child: const Text('Set URL'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
