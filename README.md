# ToolMath

<div align="center">

![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![Xcode](https://img.shields.io/badge/Xcode-15.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey.svg)

**Modern, Feature-Rich Mathematical Tool Suite for iOS**

*Beautiful UI • Powerful Features • Native Performance*

[Features](#features) • [Installation](#installation) • [Architecture](#architecture) • [Contributing](#contributing)

</div>

---

## About

**ToolMath** is a premium iOS application that combines four essential mathematical tools into one elegant, unified experience. Built with modern iOS technologies and featuring a stunning dark-themed UI with glass-morphism effects, ToolMath delivers professional-grade functionality with an intuitive user interface.

### Why ToolMath?

- **Modern Design** - Beautiful gradient buttons, glass-morphism cards, and smooth animations
- **Native Performance** - Built with UIKit and Swift for optimal speed
- **All-in-One** - Calculator, Converter, Graph Plotter, and Settings in one app
- **User-Focused** - Intuitive interactions with haptic feedback
- **iOS Native** - Follows Apple's Human Interface Guidelines

---

## Features

### Calculator
> *Premium Scientific Calculator with Modern UI*

- **Dual Modes**
  - Basic mode for everyday calculations
  - Scientific mode with advanced functions (sin, cos, tan, log, etc.)
  
- **Visual Design**
  - 250pt large display with expression preview
  - Gradient buttons with depth shadows
  - Pulsating glow effect on equals button
  - Smooth mode-switching animations

- **Functionality**
  - Real-time calculation
  - Scientific notation support
  - Expression history
  - Error handling with shake animation

### Converter
> *Multi-Category Unit Converter with Animated Values*

- **8 Conversion Categories**
  - Length (meters, feet, miles, etc.)
  - Weight (kg, lbs, ounces, etc.)
  - Temperature (C, F, K)
  - Data (bytes, MB, GB, etc.)
  - Time (seconds, minutes, hours)
  - Speed (km/h, mph, m/s)
  - Area (m², ft², acres)
  - Volume (liters, gallons, cups)

- **Features**
  - Glass-morphism conversion card
  - Animated value transitions
  - Instant conversion
  - Swap functionality
  - Custom keypad
  - Conversion history

### Graph Plotter
> *Immersive Function Visualization*

- **Interactive Graphing**
  - Full-screen canvas
  - Multi-function plotting
  - Color-coded graphs
  - Grid and axes

- **Controls**
  - Floating zoom controls (glass pill)
  - Pinch-to-zoom gestures
  - Pan to explore
  - FAB (Floating Action Button) for adding functions

- **Function Management**
  - Slide-up function panel
  - Toggle function visibility
  - Delete functions
  - Function name editing
  - Expression validation

### Settings
> *Comprehensive Preferences Management*

- **8 Organized Categories**
  - Appearance (haptic, animations)
  - Calculation (angle mode, precision)
  - Graph Plotter (zoom, line thickness, grid)
  - Converter (default category, auto-convert)
  - Data Management (clear histories)
  - Advanced (developer mode, performance)
  - About (version, build info)
  - Reset (restore defaults)

- **Collapsible Sections**
  - Glass-morphism cards
  - Smooth expand/collapse animations
  - Animated chevron indicators

- **Custom Controls**
  - Animated toggle switches with glow effect
  - Segmented controls
  - Steppers for numeric values

---

## Architecture

### Design Pattern
**MVVM (Model-View-ViewModel)** with **Combine** for reactive programming

```
ToolMath/
├── App/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── MainTabBarController.swift
│
├── Core/
│   ├── Theme/
│   │   └── Theme.swift                  # Centralized design system
│   ├── Components/
│   │   ├── GlassMorphismCard.swift      # Reusable blur card
│   │   ├── AnimatedValueLabel.swift     # Number animations
│   │   ├── CardView.swift
│   │   └── KeypadButton.swift
│   ├── Extensions/
│   │   ├── UIColor+Extensions.swift
│   │   └── UIView+Extensions.swift
│   └── Utilities/
│       ├── HapticManager.swift          # Centralized haptics
│       └── Logger.swift
│
├── Features/
│   ├── Calculator/
│   │   ├── Models/
│   │   │   ├── MathExpressionEvaluator.swift
│   │   │   └── CalculationHistory.swift
│   │   ├── ViewModels/
│   │   │   └── CalculatorViewModel.swift
│   │   └── Views/
│   │       ├── CalculatorViewController.swift
│   │       ├── CalculatorDisplayView.swift
│   │       └── CalculatorButton.swift
│   │
│   ├── Converter/
│   │   ├── Models/
│   │   │   ├── ConversionCategory.swift
│   │   │   ├── Unit.swift
│   │   │   └── ConversionHistory.swift
│   │   ├── ViewModels/
│   │   │   └── ConverterViewModel.swift
│   │   └── Views/
│   │       ├── ConverterViewController.swift
│   │
│   ├── GraphPlotter/
│   │   ├── Models/
│   │   │   ├── GraphFunction.swift
│   │   │   └── ExpressionParser.swift
│   │   ├── ViewModels/
│   │   │   └── GraphViewModel.swift
│   │   └── Views/
│   │       ├── GraphViewController.swift
│   │       ├── GraphView.swift
│   │       ├── FloatingActionButton.swift
│   │       ├── FunctionCardView.swift
│   │       └── AddFunctionViewController.swift
│   │
│   └── Settings/
│       ├── Models/
│       │   ├── AppSettings.swift
│       │   └── SettingsEnums.swift
│       ├── ViewModels/
│       │   └── SettingsViewModel.swift
│       └── Views/
│           ├── SettingsViewController.swift
│           ├── SettingsSectionHeaderView.swift
│           └── AnimatedToggleSwitch.swift
│
└── Resources/
    └── Assets.xcassets/
```

### Tech Stack

| Technology | Purpose |
|-----------|---------|
| **Swift 5.9** | Primary language |
| **UIKit** | UI framework |
| **Combine** | Reactive data flow |
| **CoreGraphics** | Graph rendering |
| **Foundation** | Core utilities |
| **UserDefaults** | Settings persistence |

### Key Technologies

#### UI Components
- **Glass-morphism** - UIVisualEffectView with blur
- **Gradient Layers** - CAGradientLayer for depth
- **Custom Animations** - CABasicAnimation, UIView.animate
- **Shadow Effects** - Multi-layered shadows for depth

#### Data Flow
```
View → User Action
  ↓
ViewModel ← Combine Publishers
  ↓
Model ← Business Logic
  ↓
Persistence ← UserDefaults/Memory
```

#### Design Patterns
- **MVVM** - Separation of concerns
- **Singleton** - HapticManager, Theme
- **Observer** - Combine publishers/subscribers
- **Factory** - Button creation
- **Strategy** - Conversion algorithms

---

## Installation

### Requirements
- **Xcode** 15.0+
- **iOS** 15.0+
- **Swift** 5.9+
- **macOS** 12.0+ (for development)

### Clone & Build

```bash
# Clone the repository
git clone https://github.com/CanSagnak1/MathToolPro.git
cd ToolMath

# Open in Xcode
open ToolMath.xcodeproj

# Or use Xcode command line
xcodebuild -project ToolMath.xcodeproj -scheme ToolMath -configuration Debug
```

### Manual Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/CanSagnak1/MathToolPro.git
   ```

2. **Open project in Xcode**
   ```bash
   cd ToolMath
   open ToolMath.xcodeproj
   ```

3. **Select your device/simulator**
   - Click on the scheme selector (top-left)
   - Choose your target device or simulator

4. **Build and run**
   - Press `⌘ + R` or click the Run button
   - Wait for the build to complete

---

## Design System

### Color Palette

```swift
// Background Gradients
Primary Background: #0a0d26 → #191f3a

// Accent Colors
Primary (Cyan): #00d4ff
Secondary (Purple): #667eea → #764ba2
Error (Red): #ff465a
Success (Green): #4ade80

// Button Colors
Number Buttons: #282d45 (Navy gradient)
Operator Buttons: #00d4ff (Cyan gradient)
Equals Button: #667eea → #764ba2 (Purple gradient)
Clear Button: #ff465a (Red gradient)
Function Buttons: #3c4159 (Light navy)

// Text Colors
Primary: #FFFFFF
Secondary: rgba(255, 255, 255, 0.7)
Tertiary: rgba(255, 255, 255, 0.5)
```

### Typography

```swift
// Font System
Display: SF Pro Display (56pt bold)
Headers: SF Pro Display (24pt bold)
Body: SF Pro Display (16pt medium)
Caption: SF Pro Display (14pt regular)
Button Labels: SF Pro Display (24pt semibold)
Function Labels: SF Pro Display (16pt semibold)
```

### Spacing System

```swift
// Padding & Margins
Screen Padding: 24pt
Card Padding: 20pt
Button Spacing: 14pt
Section Spacing: 16pt

// Corner Radius
Cards: 20pt
Buttons: 16pt
Pills: 20pt

// Shadows
Depth Shadow: (0, 4pt) blur 8pt
Elevated Shadow: (0, 8pt) blur 16pt
Glow Effect: (0, 0) blur 16pt
```

### Animations

```swift
// Timing
Button Press: 0.15s
Mode Switch: 0.35s (spring damping: 0.75)
Section Toggle: 0.4s (spring damping: 0.8)
Value Transition: 0.2s

// Easing
Default: easeOut
Spring: dampingRatio 0.75-0.8
Keyframe: Custom curves
```

---

## Configuration

### AppSettings.swift
All user preferences are stored and managed through `AppSettings`:

```swift
// Appearance
hapticFeedbackEnabled: Bool
animationSpeed: AnimationSpeed (.slow, .normal, .fast)

// Calculation
angleMode: AngleMode (.degrees, .radians)
decimalPlaces: Int (0-10)
scientificNotationEnabled: Bool
thousandsSeparatorEnabled: Bool

// Graph
defaultZoomLevel: Float
graphLineThickness: LineThickness (.thin, .medium, .thick)
graphGridDensity: GridDensity (.low, .medium, .high)
showAxesLabels: Bool
graphAntialiasing: Bool

// Converter
defaultConversionCategory: ConversionCategoryDefault
autoConvert: Bool

// Advanced
developerMode: Bool
performanceMode: Bool
```

---

## Usage

### Calculator

```swift
// Basic operations
1. Tap numbers and operators
2. Press "=" to calculate
3. Use "AC" to clear
4. Tap "DEL" for backspace

// Scientific mode
1. Tap "SCI" button
2. Access sin, cos, tan, ln, log, etc.
3. Use π, e constants
4. Calculate powers (x²) and roots (√)
```

### Converter

```swift
// Convert units
1. Select category (Length, Weight, etc.)
2. Enter value in "From" field
3. Select "To" unit
4. View instant conversion
5. Tap swap icon to reverse
```

### Graph Plotter

```swift
// Plot functions
1. Tap FAB (+ button)
2. Enter function (e.g., "x^2", "sin(x)")
3. Tap "Add" to plot
4. Pinch to zoom, drag to pan
5. Use +/- zoom controls
6. Toggle function visibility
7. Delete unwanted functions
```

---

## Testing

### Unit Tests
```bash
# Run all tests
xcodebuild test -project ToolMath.xcodeproj -scheme ToolMath -destination 'platform=iOS Simulator,name=iPhone 15'

# Or in Xcode
⌘ + U
```

### Manual Testing Checklist

- [ ] Calculator operations (add, subtract, multiply, divide)
- [ ] Scientific functions (sin, cos, tan, etc.)
- [ ] Mode switching animation
- [ ] All 8 converter categories
- [ ] Unit conversion accuracy
- [ ] Graph plotting with zoom/pan
- [ ] Settings persistence
- [ ] Haptic feedback
- [ ] Error handling
- [ ] Edge cases (division by zero, invalid input)

---

## Roadmap

### Version 2.0 (Planned)
- [ ] **History Panel** - Slide-up panel for calculation history
- [ ] **Themes** - Light mode support
- [ ] **Custom Functions** - User-defined graph functions
- [ ] **Export** - Share graphs and calculations
- [ ] **Widgets** - iOS 14+ home screen widgets
- [ ] **iPad Support** - Optimized layout for tablets
- [ ] **Apple Watch** - Basic calculator on watch

### Version 2.1 (Future)
- [ ] **Cloud Sync** - iCloud synchronization
- [ ] **Siri Shortcuts** - Voice command integration
- [ ] **3D Graphing** - Three-dimensional plots
- [ ] **Equation Solver** - Solve complex equations
- [ ] **Statistics** - Statistical calculations
- [ ] **Matrix Operations** - Linear algebra tools

---

## Contributing

Contributions are welcome! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/AmazingFeature
   ```
3. **Commit your changes**
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```
4. **Push to the branch**
   ```bash
   git push origin feature/AmazingFeature
   ```
5. **Open a Pull Request**

### Code Style Guidelines

- Follow Swift API Design Guidelines
- Use meaningful variable names
- Keep functions focused and small
- Add documentation for public APIs
- Write unit tests for new features
- Remove all comments (keep code self-documenting)

---

## Requirements

### Minimum Requirements
- iOS 15.0+
- Xcode 15.0+
- Swift 5.9+

### Recommended
- iOS 17.0+ (for latest features)
- iPhone 12 or newer (for optimal performance)

### Supported Devices
- iPhone 12, 12 mini, 12 Pro, 12 Pro Max
- iPhone 13, 13 mini, 13 Pro, 13 Pro Max
- iPhone 14, 14 Plus, 14 Pro, 14 Pro Max
- iPhone 15, 15 Plus, 15 Pro, 15 Pro Max

---

## License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Celal Can Sağnak

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## Author

**Celal Can Sağnak**

- GitHub: [@cansagnak](https://github.com/cansagnak1)

---

## Acknowledgments

- **Apple** - For the amazing iOS framework and design guidelines
- **Swift Community** - For continuous support and contributions
- **Design Inspiration** - Modern iOS calculator apps and design trends

---

## Show Your Support

If you like this project, please give it a star on GitHub!

---

<div align="center">

Made with Celal Can Sağnak

**ToolMath** © 2025

[Back to Top](#toolmath)

</div>
