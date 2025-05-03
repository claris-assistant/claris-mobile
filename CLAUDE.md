# CLAUDE.md

mobile app to integrate with claris-mcp-server. in vendor/claris-mcp-server.
push button (walkie talkie style), to send voice commands to server.
  - send voice command to Server
  - wait to receive text translation
  - display command, editable, with green button to send validated command to mcp server



## Build and Run Commands
```bash
# Flutter
flutter pub get           # Install dependencies
flutter run               # Run app in debug mode
flutter build apk         # Build Android APK
flutter build ios         # Build iOS app (Mac only)

# Testing
flutter test              # Run all tests
flutter test test/path_to_test.dart  # Run specific test
```

## Linting and Formatting
```bash
flutter analyze           # Static analysis
flutter format .          # Format code
```

## Code Style Guidelines
- Use camelCase for variables and methods
- Use PascalCase for classes and types
- Prefer final for immutable variables
- Use strong typing with Flutter widgets
- Group imports: Dart, Flutter, external packages, project imports
- Use async/await for API calls to clordor-mcp-server
- Handle API errors with try/catch and show user-friendly messages
- Add comments for complex logic only
- Each class/widget in its own file
- Use provider pattern for state management

## MCP Server Integration Notes
- Server endpoints available at http://localhost:8888/api
- Implement audio recording using flutter_sound or record package
- Send recordings to /api/transcribe endpoint
- Use http or dio package for API communication
