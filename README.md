# SubPay 📱

**SubPay** is a modern, cross-platform mobile application built with **Flutter** and **Firebase**. It is designed to help users manage their digital subscriptions and shared expenses efficiently within a "Room-based" management system.

## 🚀 Key Features
* **Secure Authentication:** Supports Email/Password and Google Social Login.
* **Modular Architecture:** Clean code structure using reusable widgets for a scalable codebase.
* **Minimalist UI:** Modern, user-friendly interface designed for clarity and ease of use.
* **Subscription Tracking:** Manage and monitor recurring payments effortlessly (In Progress).
* **Cloud Integration:** Real-time data synchronization across devices via Firebase.

## 🛠 Tech Stack
* **Framework:** [Flutter](https://flutter.dev)
* **Language:** [Dart](https://dart.dev)
* **Backend:** [Firebase](https://firebase.google.com) (Authentication & Cloud Firestore)
* **State Management:** General state management patterns (Provider/BLoC style) for clean data flow.
* **Local Utilities:** Custom extensions and utilities for responsive and efficient UI building.

## 📁 Project Structure
The project follows a **Feature-Based** directory structure:
- `lib/features/auth/`: Contains all authentication logic, screens (Login/Register), and specialized widgets.
- `lib/services/`: Centralized service classes for Firebase interactions and API calls.
- `lib/widgets/`: Generic UI components used throughout the entire application.
- `lib/models/`: Data models and entity definitions (e.g., `AppUser`).