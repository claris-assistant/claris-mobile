import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../providers/api_provider.dart';

class RecordButton extends StatelessWidget {
  const RecordButton({super.key});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    final apiProvider = Provider.of<ApiProvider>(context);

    return GestureDetector(
      onLongPress: () async {
        try {
          await audioProvider.startRecording();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      },
      onLongPressEnd: (_) async {
        try {
          final filePath = await audioProvider.stopRecording();
          if (filePath.isNotEmpty) {
            await apiProvider.transcribeAudio(File(filePath));
            await audioProvider.deleteRecording();
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: audioProvider.isRecording ? Colors.red : Colors.blue,
          shape: BoxShape.circle,
        ),
        child: Icon(
          audioProvider.isRecording ? Icons.mic : Icons.mic_none,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}