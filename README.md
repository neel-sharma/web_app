# web_app
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)

![Qoder Logo](qoder_logo.jpeg)

(https://www.qoder.in)

## Overview

Qoder's Mason brick streamlines the process of creating a fully functional Flutter web application with minimal user input. By simply answering a few questions, users can:

- **Generate a New Flutter Project:** Automatically set up a new Flutter project, complete with necessary dependencies and a configured web environment.
- **Customize Native Splash and Launcher Icon:** Users can provide a PNG logo, which will be used to set up a native splash screen and launcher icon for the app, ensuring a consistent brand presence.
- **Integrate Firebase with Remote Config:** Simplify Firebase setup within the project, including Firebase Remote Config integration. A base URL is configured and monitored for live changes, enabling dynamic updates directly from Firebase without redeploying the app.

This Mason brick is designed to save developers time and effort, allowing them to focus on building features while we handle the boilerplate setup.

## What's Included ✨

- **Flutter Project Initialization:** Create a new Flutter project with pre-configured settings tailored to your needs.
- **Dependency Management:** Add essential dependencies to ensure your project is ready to go, with support for web and mobile platforms.
- **Native Splash and Launcher Icon:** Automatically generate and apply a splash screen and launcher icon using your provided PNG logo.
- **Firebase Integration:** Set up Firebase in your project and integrate Firebase Remote Config with a default `base_url` key that listens for live changes.

## Project Structure 📦

```sh
├── .dart_tool/
├── .idea/
├── android/
│   ├── google1_android/
├── assets/
│   ├── loading.json
│   └── logo.png
├── build/
├── ios/
├── lib/
│   ├── core/
│   │   ├── app_constants.dart
│   ├── presentation.screens/
│   │   └── web_view_screen.dart
│   ├── main.dart
├── linux/
├── macos/
├── test/
│   ├── widget_test.dart
├── web/
├── windows/
├── .flutter-plugins
├── .flutter-plugins-dependencies
├── .gitignore
├── .metadata
├── analysis_options.yaml
├── google1.iml
├── pubspec.lock
├── pubspec.yaml
└── README.md
