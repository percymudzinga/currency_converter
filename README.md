# Currency Converter.

Mukuru Mobile Technical Assessment.

## Getting Started

To run this project, you need to use the command
```flutter run --dart-define APP_ID=84c7db24523c4a75b8febce195d61f82```

We need this command because we are injecting our api key on run. This is to prevent it from being pushed to version control platforms.

## Packages.
- **http**: For making external http api calls.
- **flutter_bloc & bloc**: This is for state management. 
- **equatable**: This is used by flutter bloc to compare state classes so that the app knows when to update state.
- **json_annotation**: This is makes the handling of json serialization and deserialization easier.
- **hive_flutter**: This is a NoSql database where our currencies are being cached.
- **mockito**: This package mocks packages when writing tests.
- **build_runner**: I am using build runner to generate json serialization code, hive adapters and mockito mocks.
- **json_serializable**: This handles the generations of json helper class. These class are the ones with fromJson() and toJson().
- **hive_generator**: This generates hive helper classes for adapters.
