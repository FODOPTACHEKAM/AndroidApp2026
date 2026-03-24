# Grade Calculator Pro

A professional Flutter application for calculating student grades from Excel files.

## Features

- 📱 Clean, modern UI with gradient design
- 📊 Upload Excel files with student grades
- ⚙️ Configurable subject count and grade scale
- 📈 Automatic grade letter assignment (A, B, C, D, F)
- 📄 Export results to PDF
- 🎯 Class average calculations
- 🔄 Modular and extensible architecture

## Architecture

The application follows SOLID principles with:
- **Factory Pattern** for grade parsing
- **Provider Pattern** for state management
- **Abstract Classes** for extensibility
- **Separation of Concerns** with clear module boundaries

## Installation

```bash
flutter pub get
flutter run