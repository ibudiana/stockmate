# 📦 Inventory Management App (StockMate)

A modern, efficient, and clean inventory management application built with **Flutter**. Designed to help small businesses track stock levels, manage product details, and monitor inventory status in real-time.

![Flutter](https://img.shields.io/badge/Flutter-3.7.2-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0-blue?logo=dart)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-green)
![License](https://img.shields.io/badge/License-MIT-purple)

## 📱 Screenshots

|            Dashboard List            |          Search Mode           |         Add/Edit Item          |
| :----------------------------------: | :----------------------------: | :----------------------------: |
| ![Dashboard](./assets/dashboard.png) | ![Search](./assets/search.png) | ![Form](./assets/add-edit.png) |

## ✨ Key Features

- **Real-time Inventory Tracking**: Monitor stock levels with visual cues (Low stock indicators).
- **Smart Search**: Instantly find products using a dynamic search bar integrated into the AppBar.
- **CRUD Operations**: Create, Read, Update, and Delete items seamlessly using a local SQLite database.
- **Clean UI/UX**:
  - Modern card layouts with color-coded indicators.
  - Custom global widgets for consistency.
  - Interactive dialogs for adding/editing data.
- **Safe Deletion**: Confirmation dialogs to prevent accidental data loss.

## 🛠 Tech Stack

- **Framework**: Flutter SDK ^3.7.2
- **Language**: Dart
- **State Management**: `provider` (MVVM Pattern)
- **Local Database**: `sqflite` (SQLite)
- **Environment Config**: `flutter_dotenv`
- **Path Utils**: `path`

## 📂 Project Architecture (MVVM)

This project follows the **Model-View-ViewModel (MVVM)** architectural pattern to ensure separation of concerns and testability.

## Pattern Used

- **Repository Pattern**
  - Abstraction: lib/repository/base_repository.dart (Kontrak/Interface).
  - Implementation: lib/repository/item_repository.dart.
- **DAO (Data Access Object) Pattern**
  - Separating SQL queries (SELECT \* FROM ...) from the Repository logic: lib/data/local/item_dao.dart
- **Observer Pattern**
  - ChangeNotifier ( in ViewModel). context.watch<ItemViewModel>() or Consumer (in View). notifyListeners().
- **Strategy Pattern**
  - Implementation: abstract class BaseRepository<T>.
- **Singleton Pattern**
  - Implementation: DatabaseService (lib/data/local/database_service.dart).
- **Factory Method Pattern**
  - Implementation: DataResponse.success(...) / DataResponse.error(...): Factory constructors
- **Dependency Injection**
  - Implementation: Provider (main.dart atau MultiProvider) and performing dependency injection of the ItemViewModel instance
- **Barrel File Pattern**
  - Implementation: files like widgets.dart, pages.dart, repository.dart to simplify import in one file
- **Composite Pattern**
  - Implementation: Widget CustomAppBar and CustomTextField

### Key Components:

- **Repository Pattern with DAO**:
  - **DAO (`item_dao.dart`)**: Handles raw SQL queries, keeping database logic isolated.
  - **Repository (`base_repository.dart`)**: Defines the contract for data operations, making the app loosely coupled.
- **Generic Response Wrapper**:
  - Uses `DataResponse<T>` (`data_response.dart`) to standardize API/DB responses, encapsulating Data, Status, and Messages in a single object.
- **Centralized Error Handling**:
  - Custom exceptions (`app_exception.dart`) ensure errors are caught and transformed into user-friendly messages.
- **Modular Widgets**:
  - UI components are broken down into reusable widgets (`CustomAppBar`, `CustomTextField`) found in `view/widgets/`.

### Unit Test

This repository contains unit and widget tests for the Inventory App developed in Flutter. The purpose of these tests is to ensure that core functionalities, database operations, and widget behavior work as expected.

The tests follow the Arrange-Act-Assert (AAA) pattern to clearly separate setup, execution, and verification steps.

## 1. validator_test.dart

- **Purpose**:
  Test input validation logic for user forms.

- **Functionality Tested**:
  Required fields (requiredField)
  Numeric input (number)
  Letters only input (lettersOnly)
  Email format (email)
  Minimum and maximum length (minLength, maxLength)
  Combined validators (combine)

- **Test Coverage**:
  Checks that empty, invalid, and valid input return the correct error messages or null.
  Ensures validation functions handle edge cases.

## 2. item_dao_test.dart

- **Purpose**:
Test database access object (ItemDao) CRUD operations.

- **Functionality Tested**:
Insert item
Retrieve items
Update item
Delete item

- **Test Coverage**:
Verifies all CRUD operations and ensures correct return values.
Handles empty database and non-existing item updates/deletes.

## 3. database_test.dart

- **Purpose**:
Ensure database connection and raw SQLite operations work.

- **Functionality Tested**:
Database creation
Table items exists
Insert, update, delete using raw queries

- **Test Coverage**:
Validates DatabaseService initialization and in-memory database behavior.
Tests raw SQL queries for correctness.

## 4. item_repo_test.dart

- **Purpose**:
Test repository layer (ItemRepository) that wraps DAO logic.

- **Functionality Tested**:
Insert, update, delete item through repository
Retrieve all items
Retrieve item by ID

- **Test Coverage**:
Confirms repository correctly delegates to DAO.
Validates proper DataResponse status for success and failure scenarios.

## 5. item_page_test.dart

- **Purpose**:
Test widget behavior of ItemPage and interaction with ItemViewModel.

- **Functionality Tested**:
Loading state shows CircularProgressIndicator
Error state displays error message
Empty state displays "No items yet."
List of items displays correct info
Tap "Tambah Barang" button opens AddOrEditItemDialog

- **Test Coverage**:
Simulates user interaction using WidgetTester.
Ensures UI responds correctly to different ItemViewModel states.

## 6. widgets_test.dart

- **Purpose**:
Test reusable custom widgets (CustomTextField, CustomActionButton, dialogs).

- **Functionality Tested**:
Rendering of labels and input fields
Validator integration in CustomTextField
Button actions call correct functions
Dialog displays correct title and buttons

- **Test Coverage**:
Ensures reusable widgets work as intended.
Verifies interaction logic such as button taps and text input.

## 🚀 Getting Started

Follow these steps to run the project locally.

### Prerequisites

- Flutter SDK installed
- Android Studio / VS Code
- Android Emulator or Physical Device

### Installation

1.  **Clone the repository**

    ```bash
    git clone [https://github.com/ibudiana/stockmate.git](https://github.com/ibudiana/stockmate.git)
    cd stockmate
    ```

2.  **Install dependencies**

    ```bash
    flutter pub get
    ```

3.  **Environment Configuration**
    This project uses `flutter_dotenv` to manage environment variables.

    - Create a file named `.env` inside the `assets/` folder.
    - _(Optional)_ Add your specific configuration keys if needed. For now, you can leave it empty or add a dummy key:
      ```env
      DB_NAME=inventory.db
      ```

4.  **Run the App**
    ```bash
    flutter run
    ```

## ⚠️ Database Note

The app uses `sqflite` which stores data locally on the device.

- **Android/iOS**: Data persists between app restarts.
- **Uninstalling**: Uninstalling the app will clear the database.

## Reflection on Building StockMate

Working on the StockMate inventory application taught me a lot about building scalable Flutter apps. I learned how to implement the MVVM (Model-View-ViewModel) architecture properly. By separating the UI from the business logic, my code became much cleaner and easier to manage. I also learned the importance of the Repository and DAO patterns, which help organize how the app saves and loads data from the database.

One of the biggest challenges I faced was handling the search functionality. I had to figure out how to update the list dynamically while keeping the UI responsive. Changing the CustomAppBar into a stateful widget to handle the search input was a clever solution that kept the main page code clean.

Additionally, I improved my UI skills by creating reusable global widgets like CustomActionButton and CustomTextField. This made the design consistent and reduced repetitive code. Overall, this assignment helped me understand how to structure a professional mobile application that is ready for real-world use.

## 🤝 Contributing

Contributions are welcome!

1.  Fork the project
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.
