# Flutter Technical Assessment

This Flutter application was developed for the Senior Flutter Developer position at Vidavo A.E. It demonstrates three main features as requested in the technical assessment.

## Assessment Questions Implemented

### Question 1: Dynamic Form Builder
- **Location**: `lib/screens/dynamic_form_screen.dart`
- **Features**:
  - Dynamic JSON-based form configuration
  - Support for multiple field types: text, date, radio, checkbox
  - SQLite database integration for form submissions
  - Form validation and data persistence
  - Display of submitted data with delete functionality

### Question 2: Vida24 Login Screen
- **Location**: `lib/screens/login_screen.dart`
- **Features**:
  - Pixel-perfect recreation of the provided Figma design
  - Custom status bar simulation
  - Vida24 logo with animated radio waves
  - Form validation for username and password
  - Password visibility toggle
  - Responsive design matching the original mockup

### Question 3: Data Entry & Display Screens
- **Locations**: 
  - `lib/screens/data_entry_screen.dart` (Entry screen)
  - `lib/screens/message_display_screen.dart` (Display screen)
- **Features**:
  - TextFormField validation for title and message
  - SharedPreferences for local data storage
  - Navigation between entry and display screens
  - CRUD operations (Create, Read, Delete)
  - Error handling and user feedback
  - Material Design UI components

## Project Structure

```
lib/
├── main.dart                          # App entry point with navigation
├── models/
│   ├── form_model.dart               # Dynamic form data models
│   └── message_data.dart             # Message data model
├── screens/
│   ├── dynamic_form_screen.dart      # Question 1: Dynamic forms
│   ├── login_screen.dart             # Question 2: Vida24 login
│   ├── data_entry_screen.dart        # Question 3: Data entry
│   └── message_display_screen.dart   # Question 3: Data display
├── services/
│   ├── database_service.dart         # SQLite database operations
│   └── message_service.dart          # SharedPreferences operations
└── widgets/
    └── dynamic_form_field.dart       # Reusable form field widget
```

## Dependencies

The project uses the following key dependencies:

- `sqflite`: SQLite database for form submissions
- `shared_preferences`: Local storage for message data
- `intl`: Date formatting and internationalization
- `path`: File path utilities

## Key Features Demonstrated

### 1. Database Configuration (Question 1)
- SQLite integration with custom schema
- Dynamic form field handling
- Data persistence and retrieval
- Support for various field types (text, date, radio, checkbox)

### 2. UI/UX Design (Question 2)
- Faithful recreation of provided design
- Custom styling and animations
- Form validation and user interactions
- Responsive layout

### 3. State Management & Navigation (Question 3)
- Proper state management across screens
- Navigation between related screens
- Data persistence between app sessions
- Error handling and user feedback

## Technical Highlights

1. **Clean Architecture**: Separated models, services, screens, and widgets
2. **Error Handling**: Comprehensive try-catch blocks with user feedback
3. **Validation**: Form validation for all user inputs
4. **Responsive Design**: Proper spacing and layout for different screen sizes
5. **Material Design**: Consistent use of Material Design principles
6. **Code Quality**: Well-documented code with meaningful variable names

## How to Run

1. Ensure Flutter SDK is installed
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

## Assessment Completion

All three questions have been successfully implemented with additional features:

- ✅ Question 1: Dynamic form system with database support
- ✅ Question 2: Vida24 login screen recreation
- ✅ Question 3: Data entry and display functionality

The application demonstrates proficiency in:
- Flutter framework and Dart programming
- Database integration (SQLite)
- Local storage (SharedPreferences)
- UI/UX design implementation
- Form validation and user interactions
- State management and navigation
- Clean code architecture

---

**Developed for**: Vidavo A.E.  
**Position**: Senior Flutter Developer  
**Date**: September 2025
