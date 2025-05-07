import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/api_provider.dart';
import '../providers/audio_provider.dart';
import '../widgets/record_button.dart';
import '../widgets/response_display.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _processTextCommand(BuildContext context) async {
    if (_textController.text.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final apiProvider = Provider.of<ApiProvider>(context, listen: false);
      await apiProvider.processCommand(_textController.text);
      _textController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _processAudioCommand(BuildContext context) async {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);

    try {
      final filePath = await audioProvider.stopRecording();
      if (filePath.isEmpty) return;

      await apiProvider.transcribeAudio(
        await File(filePath),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      await audioProvider.deleteRecording();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Claris Assistant'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Claris Assistant',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                ).then((_) {
                  // Refresh API provider when returning from settings
                  Provider.of<ApiProvider>(context, listen: false)
                      .updateServerConfig();
                });
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ResponseDisplay(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type a command...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _processTextCommand(context),
                  ),
                ),
                const SizedBox(width: 16),
                if (_isProcessing)
                  const CircularProgressIndicator()
                else
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => _processTextCommand(context),
                  ),
                const SizedBox(width: 16),
                const RecordButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
