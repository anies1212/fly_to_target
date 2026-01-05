# Contributing to fly_to_target

Thank you for your interest in contributing to fly_to_target!

## How to Contribute

### Reporting Issues

- Check if the issue already exists
- Provide a clear description of the problem
- Include steps to reproduce, expected behavior, and actual behavior
- Add Flutter/Dart version information

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests and lint checks:
   ```bash
   flutter pub get
   dart format lib test
   flutter analyze
   flutter test
   ```
5. Commit your changes (`git commit -m 'feat: add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Code Style

- Follow Dart's [Effective Dart](https://dart.dev/effective-dart) guidelines
- Use `dart format` to format code
- Ensure `flutter analyze` passes with no issues
- Add documentation comments (`///`) for public APIs
- Write tests for new features

### Commit Messages

Use conventional commits format:

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `refactor:` Code refactoring
- `test:` Adding or updating tests
- `chore:` Maintenance tasks

## Development Setup

```bash
git clone https://github.com/anies1212/fly_to_target.git
cd fly_to_target
flutter pub get
flutter test
```

## Questions?

Feel free to open an issue for any questions or discussions.
