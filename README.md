# Optifii Flutter Assignment — Rewards / Gift Voucher Module

A Flutter implementation of the **Rewards / Gift Voucher Module** for the Optifii Flutter Round 2 assignment. The app recreates the full voucher purchase journey with static data, clean architecture, and an API-ready structure.

## Features

- **Rewards Marketplace** — Categories, trending brands, popular brands, and voucher cards with discount and starting price
- **Search & Discovery** — Search brands/categories with empty and no-results states
- **Voucher Details** — Denomination selection, custom amount (₹100–₹10,000), dynamic pricing
- **Send as Gift** — Receiver details, 200-char message, theme selection, preview
- **Order Summary & Payment** — Savings highlight, secure payment UI, success confirmation
- **Post-Purchase Voucher** — Masked card/PIN with reveal interaction, T&C, redemption steps
- **Order History** — Search, filters (All / Self / Gifted), order detail view

## Tech Stack

| Layer | Choice |
|-------|--------|
| Framework | Flutter 3.x |
| Navigation | `go_router` |
| State | `provider` |
| Typography | `google_fonts` (Inter) |
| Utilities | `intl`, `uuid` |

## Project Structure

```
lib/
├── app.dart                    # App entry & providers
├── main.dart
├── core/                       # Theme, constants, utils, router
├── data/                       # Models, static data, repository
├── features/                   # Feature-first UI (home, search, voucher, gift, order, history)
├── providers/                  # Order/checkout state
└── shared/widgets/             # Reusable UI components
```

## Getting Started

```bash
flutter pub get
flutter run
```

### Run tests

```bash
flutter test
```

### Build APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

## Design Reference

UI is built to match the [Figma design file](https://www.figma.com/design/iD5idIfcFIP3bOaBghGWzT/Flutter-Round-2) and the assignment brief. Design tokens use a professional blue/green palette with card-based layouts.

## AI Usage Disclosure

This project was developed with assistance from **Cursor AI (Claude)**:

- Architecture scaffolding (feature-first folders, repository pattern, provider setup)
- Static brand/category data and pricing logic
- Screen implementations aligned to the assignment brief
- README and test coverage for pricing calculations

All code was reviewed and structured for interview submission quality.

## Author

Fimal Jo — Optifii Flutter Round 2 Assignment
