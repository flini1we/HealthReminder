# Health Reminder

<div align="center">
  <img src="./imagesAndGifs/images/ChatGPT Image 14 июн. 2025 г., 23_48_57.png" width="200"/>
</div>

A modern iOS application for managing health-related reminders, built with UIKit, SwiftUI, and following clean architecture principles.

## Features

- 📱 Create and manage health-related reminders
- 🔔 Local notifications for timely reminders
- 🎯 Multiple reminder categories (Water, Exercise, Vitamins, Sleep, etc.)
- 🔄 Real-time updates using Combine
- 🔗 Deep linking support
- 📊 Detailed reminder information
- 🎨 Modern UI with UIKit and SwiftUI integration

<img src="./imagesAndGifs/gifs/Simulator-Screen-Recording-iPhone-16-Pro-2025-06-16-at-01.44.22.gif" alt="screencast" width="400" />

## Technical Stack

- **Architecture**: VIPER, Service Locator
- **UI**: UIKit, SwiftUI
- **Data Flow**: Combine
- **Persistence**: SwiftData
- **Testing**: XCTest, Snapshot Testing
- **Minimum iOS Version**: iOS 17.0+

## Project Structure

```
HealthReminder/
├── Application/        # App configuration and setup
├── Assembly/           # Dependency injection
├── Builders/           # Builder pattern implementations
├── Custom/             # Custom UI components
├── Extensions/         # Swift extensions
├── Factories/          # Factory pattern implementations
├── Formatters/         # Data formatting utilities
├── Managers/           # Various managers
├── Models/             # Data models
├── Modules/            # Feature modules
│   ├── RemindsModule/  # Main reminders list
│   ├── RemindDetail/   # Reminder details
│   └── CreateRemindModule/ # Create new reminder
├── Resources/          # Assets and resources
├── Services/           # Business logic services
└── Support/            # Supporting files
```

## Architecture

The project follows a hybrid architecture approach:

- **VIPER** for UIKit-based screens
- **Service Locator** for dependency management
- **Builder Pattern** for object creation
- **Factory Method** for notification generation
- **Combine** for reactive data flow

## Features Implementation

### Main Screen (UIKit)
- Displays list of reminders using UITableView
- VIPER architecture implementation
- Real-time updates via Combine
- "+" button to create new reminders

### Create Reminder Screen (SwiftUI)
- Text input and interval selection
- Category selection with custom options
- Builder pattern for Reminder creation
- Integration via UIHostingController

### Reminder Details Screen (SwiftUI)
- Deep linking support
- Opens from list or push notification

## Testing

The project includes comprehensive testing:

### Unit Tests
- ReminderService logic
- NotificationFactory functionality
- Data persistence

### Snapshot Tests
- CreateReminderView
- ReminderDetailView

### UI Tests
- Reminder creation flow
- Deep linking from notifications
- User interaction scenarios

## Requirements

- iOS 17.0+
- Xcode 14.0+
- Swift 5.0+

## GitHub Topics

```
swift
ios
swiftui
uikit
viper
combine
swiftdata
health
reminders
notifications
local-notifications
deeplink
clean-architecture
service-locator
builder-pattern
factory-pattern
```

## Author

Danil Zabinskij

## Acknowledgments

- VIPER architecture pattern
- SwiftUI and UIKit integration
- Combine framework
- Local notifications system 
