import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/api_provider.dart';

class ResponseDisplay extends StatelessWidget {
  const ResponseDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Response:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (apiProvider.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (apiProvider.lastResponse.isEmpty)
            const Text(
              'No response yet. Try giving a voice or text command.',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            )
          else
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    apiProvider.lastResponse,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}