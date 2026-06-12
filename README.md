# User Directory Application

An iOS application that fetches and displays user data from the [JSONPlaceholder Users API](https://jsonplaceholder.typicode.com/users). Built with SwiftUI and MVVM architecture.

## Features

- **User List** — Displays name, email, and city for each user
- **User Details** — Shows full name, email, phone, company, and website on selection
- **Search** — Filter users by name, email, or city
- **Pull-to-Refresh** — Refresh the user list from the API
- **Local Caching** — Cached users shown instantly while fetching fresh data
- **Loading & Error States** — Proper feedback for all network states
- **Dark Mode** — Automatic support via system semantic colors

## Tech Stack

| Layer | Technology |
|-------|------------|
| Language | Swift 5 |
| UI | SwiftUI |
| Architecture | MVVM |
| Networking | URLSession (async/await) |
| State Management | Observation (`@Observable`) |
| Testing | Swift Testing |

## Project Structure

```
FourteenZoneTask/
├── Models/              # Data models (User)
├── Views/               # SwiftUI views
│   └── Components/      # Reusable UI components
├── ViewModels/          # View models (UserListViewModel)
├── Services/            # API & cache services
├── Utilities/           # Constants, errors
└── FourteenZoneTaskApp.swift
FourteenZoneTaskTests/     # Unit tests
Scripts/                   # IPA build script
```

## Architecture

The app follows **MVVM** with dependency injection via protocols:

```
View (UserListView)
    ↕
ViewModel (UserListViewModel)
    ↕
Service (UserServiceProtocol → UserService)
    ↕
Cache (UserCacheService) + URLSession
```

- **Views** are responsible only for UI rendering and user interaction.
- **ViewModels** hold presentation state and coordinate data loading.
- **Services** handle networking and caching, injected through protocols for testability.

## Setup Instructions

### Requirements

- iOS 17.0+ deployment target
- Xcode 15.0+ recommended (tested with Xcode 26.3)
- Active internet connection for API calls

### Run in Simulator

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd FourteenZoneTask
   ```

2. Open the project in Xcode:
   ```bash
   open FourteenZoneTask.xcodeproj
   ```

3. Select an iOS Simulator target and press **⌘R** to build and run.

### Run Unit Tests

1. Open the project in Xcode.
2. Press **⌘U** to run all tests, or use:
   ```bash
   xcodebuild test \
     -project FourteenZoneTask.xcodeproj \
     -scheme FourteenZoneTask \
     -destination 'platform=iOS Simulator,name=iPhone 16'
   ```

### Build IPA

For submission, generate an IPA using the included script:

```bash
chmod +x Scripts/build-ipa.sh
./Scripts/build-ipa.sh
```

The IPA will be exported to `build/ipa/FourteenZoneTask.ipa`.

> **Note:** For App Store or device distribution, update `Scripts/ExportOptions.plist` with your signing certificate and provisioning profile, and enable code signing in the build script.

## API

- **Endpoint:** `GET https://jsonplaceholder.typicode.com/users`
- **Response:** JSON array of user objects

## Assumptions & Limitations

- Requires network connectivity for initial load; cached data is used as a fallback when available.
- Website URLs from the API omit the `https://` prefix; the detail screen displays them with the prefix prepended for readability.
- The IPA build script uses manual/ad-hoc export settings suitable for development builds. Production signing requires your Apple Developer credentials.
- Search is performed locally on the loaded user list (no server-side search).
- Unit tests use mock networking and do not hit the live API.

## Demo

Record a screen capture while running the app in the Simulator to demonstrate:

1. Loading state on launch
2. User list with name, email, and city
3. Search filtering
4. Pull-to-refresh
5. Navigation to user detail screen
