## Week 1, Day 1: Introduction to Swift and Xcode
**Goal**: Understand what Swift and iOS development are, set up the development environment (Xcode), learn the basics of Swift (variables, constants, data types), and write your first Swift code in a playground.  
**Duration**: ~2–3 hours (1 hour learning, 1–2 hours practice).  
**Tools**: Mac with macOS Ventura or later, Xcode 16+ (free, Mac App Store), optional Swift Playgrounds app.  
**Prerequisites**: A Mac and an Apple ID (for Xcode). No prior coding experience required.  
**Outcome**: Successfully install Xcode, run a Swift playground, and write simple Swift code to print text.

---

### Detailed Learning Topics

#### 1. Overview of Swift and iOS Development
**Objective**: Understand what Swift is, why it’s used for iOS development, and the role of iOS apps in the Apple ecosystem.  
**Why It Matters**: This provides context, motivating beginners by showing the “big picture” of building iPhone apps.

- **What is Swift?**
  - Swift is a modern, open-source programming language created by Apple in 2014.
  - Used to build apps for iOS (iPhone/iPad), macOS, watchOS, and tvOS.
  - Beginner-friendly: Clear syntax, safe by default (prevents common errors), and widely used.
  - Example: Apps like Notes, Weather, and Twitter are built with Swift.

- **What is iOS Development?**
  - Creating apps for Apple’s mobile devices (iPhone, iPad) using Swift and tools like Xcode.
  - iOS apps are distributed via the App Store, reaching millions of users.
  - SwiftUI (introduced 2019) is Apple’s modern framework for building user interfaces (UIs), which you’ll use in this bootcamp.

- **Why Learn Swift?**
  - High demand for iOS developers (jobs, freelancing, personal projects).
  - Swift is versatile: Supports mobile, desktop, and even server-side development.
  - Apple’s ecosystem is stable, with regular updates (e.g., iOS 18 in 2025).

- **Learning Task** (15 minutes):
  - Watch: CodeWithChris “What is Swift? Swift Tutorial for Beginners” (YouTube, ~10 minutes, search for the video).
  - Read: Swift.org “About Swift” (first section, ~5 minutes, swift.org/documentation).
  - Takeaway: Swift is the key to building iOS apps, and you’ll start by learning its basics.

#### 2. Setting Up Xcode
**Objective**: Install and explore Xcode, Apple’s development tool, to prepare for coding.  
**Why It Matters**: Xcode is the primary tool for iOS development, and understanding its interface is essential for writing and testing code.

- **What is Xcode?**
  - Xcode is a free integrated development environment (IDE) for building Apple apps.
  - Includes a code editor, UI designer (SwiftUI), simulator (to test apps without an iPhone), and debugger.
  - Version 16 (2025) supports Swift 5.10+ and iOS 18.

- **Installation Steps**:
  - Open the Mac App Store.
  - Search for “Xcode” and click “Get” (requires ~12GB, stable internet).
  - After installation, open Xcode (Applications folder or Launchpad).
  - Agree to the license and let Xcode install additional components (~5–10 minutes).
  - Sign in with your Apple ID (Xcode > Preferences > Accounts) for simulator and device testing.

- **Exploring Xcode**:
  - **Welcome Screen**: Options to create a new project, playground, or open existing files.
  - **Playgrounds**: A lightweight environment to test Swift code without building a full app.
  - **Interface**:
    - Navigator (left): File explorer for projects.
    - Editor (center): Where you write code.
    - Toolbar (top): Play button to run code, device selector (e.g., iPhone 16 simulator).
    - Debug Area (bottom): Shows output (e.g., `print()` results).

- **Learning Task** (30 minutes):
  - **Install Xcode**:
    - Follow the installation steps above.
    - If already installed, verify the version (Xcode > About Xcode, should be 16+).
  - **Explore Xcode**:
    - Open Xcode and click “Create Playground” (choose “Blank” template, name it “Day1”).
    - Write: `print("Hello, Xcode!")` in the playground and click the blue “Play” button (right side) to run.
    - Observe the output in the playground’s result pane (should see “Hello, Xcode!”).
  - **Resource**:
    - Watch: CodeWithChris “Xcode Tutorial for Beginners” (YouTube, ~15 minutes, focus on installation and playgrounds).
    - Reference: Apple Developer “Xcode Overview” (developer.apple.com/xcode, skim first section).

#### 3. Swift Basics: Variables, Constants, and Data Types
**Objective**: Learn how to store and manipulate data in Swift using variables, constants, and common data types.  
**Why It Matters**: Variables and constants are the building blocks of programming, and data types define what kind of data you can work with (e.g., numbers, text).

- **Variables (`var`)**:
  - A variable stores data that can change.
  - Syntax: `var name = value`
  - Example:
    ```swift
    var score = 10
    score = 15 // Changes to 15
    print(score) // Prints: 15
    ```
  - Use `var` when data needs to update (e.g., a game score).

- **Constants (`let`)**:
  - A constant stores data that cannot change.
  - Syntax: `let name = value`
  - Example:
    ```swift
    let pi = 3.14
    // pi = 3.14159 // Error: Cannot change a constant
    print(pi) // Prints: 3.14
    ```
  - Use `let` for fixed values (e.g., a birthdate).

- **Data Types**:
  - Swift is **type-safe**, meaning every variable/constant has a specific type.
  - Common types:
    - `Int`: Whole numbers (e.g., `42`, `-10`).
    - `Double`: Decimal numbers (e.g., `3.14`, `0.001`).
    - `String`: Text (e.g., `"Hello"`, `"Swift"`).
    - `Bool`: True or false (`true`, `false`).
  - Example:
    ```swift
    var age: Int = 25 // Explicit type
    let name = "Alice" // Implicit type (String)
    var price: Double = 9.99
    let isStudent: Bool = true
    ```
  - Swift infers types automatically (e.g., `let x = 5` is an `Int`), but you can specify types for clarity.

- **Naming Rules**:
  - Use descriptive names (e.g., `userName` instead of `n`).
  - CamelCase: `firstName`, `totalScore` (lowercase first letter, capitalize subsequent words).
  - No spaces, start with a letter, avoid reserved words (e.g., `var`).

- **String Interpolation**:
  - Embed values in strings using `\(variable)`.
  - Example:
    ```swift
    let name = "Bob"
    print("Hello, \(name)!") // Prints: Hello, Bob!
    ```

- **Learning Task** (45 minutes):
  - **Read**:
    - Hacking with Swift “100 Days of Swift” Day 1 (Variables and Constants, ~15 minutes, hackingwithswift.com/100).
    - Swift.org “A Swift Tour” (The Basics, variables section, ~10 minutes).
  - **Watch**:
    - CodeWithChris “Swift Basics for Beginners” (YouTube, ~10 minutes, focus on variables and types).
  - **Code**:
    - In the “Day1” playground, write:
      ```swift
      var greeting = "Hello, Swift!"
      let year = 2025
      var temperature: Double = 72.5
      let isLearning: Bool = true
      print("Greeting: \(greeting), Year: \(year)")
      ```
    - Run the code and check the output.
    - Change `greeting` to “Hello, iOS!” and run again.
    - Try changing `year` (a `let`) and observe the error.

#### 4. Writing and Running Simple Swift Code in a Playground
**Objective**: Apply variables, constants, and data types to write and test Swift code in Xcode’s playground.  
**Why It Matters**: Playgrounds provide a safe, interactive environment to experiment with code, perfect for beginners.

- **What is a Playground?**
  - A file in Xcode (`.playground`) for testing Swift code without building a full app.
  - Shows results instantly in the “Results Pane” (right side) or console (bottom).
  - Ideal for learning syntax and experimenting.

- **Creating a Playground**:
  - Open Xcode > “Get started with a playground” > Blank > Name it “Day1” > Save to Desktop.
  - Default code: `import UIKit` (ignore for now, you’ll use `print()` for output).

- **Running Code**:
  - Write code in the left editor.
  - Click the blue “Play” button (triangle) next to a line to run it.
  - View output in:
    - Results Pane (right): Shows values (e.g., `10` for `var x = 10`).
    - Console (View > Debug Area > Show Debug Area): Shows `print()` output.

- **Example Code**:
  ```swift
  var city = "New York"
  let population: Int = 8_400_000
  var temperature: Double = 68.0
  let isSunny: Bool = true
  print("Welcome to \(city)! Population: \(population), Sunny: \(isSunny)")
  // Output: Welcome to New York! Population: 8400000, Sunny: true
  ```

- **Learning Task** (45 minutes):
  - **Create a Playground**:
    - Follow the steps above to create “Day1.playground”.
  - **Write Code**:
    - Add:
      ```swift
      var name = "YourName" // Replace with your name
      let age = 30 // Replace with your age
      var height: Double = 5.8 // Replace with your height (feet)
      let isCoder: Bool = true
      print("Hi, I'm \(name), \(age) years old, \(height) feet tall, and a coder: \(isCoder)")
      ```
    - Run the code (Play button or Cmd+Shift+Return).
    - Check the console output (e.g., “Hi, I'm Alice, 30 years old, 5.8 feet tall, and a coder: true”).
  - **Experiment**:
    - Change `name` to a different value and rerun.
    - Add a new variable `var hobby = "coding"` and print it in the message.
    - Try creating an error (e.g., assign a `String` to an `Int`: `let x: Int = "10"`) and read the error message.
  - **Resource**:
    - Hacking with Swift “Getting Started with Playgrounds” (search on their site, ~10 minutes).
    - Apple Developer “Swift Playgrounds” (developer.apple.com/swift-playgrounds, skim overview).

---

### Practice Exercises (30 minutes)
To reinforce learning, complete these hands-on exercises in your “Day1” playground:
1. **Personal Info**:
   - Create variables for your `city` (String), `zipCode` (Int), and `temperature` (Double).
   - Use `print()` with string interpolation to display: “I live in [city], zip [zipCode], where it’s [temperature]°F.”
2. **Constants**:
   - Create constants (`let`) for `birthYear` (Int) and `favoriteColor` (String).
   - Print: “Born in [birthYear], my favorite color is [favoriteColor].”
   - Try changing one constant and note the error.
3. **Data Types**:
   - Create one variable and one constant for each type: `Int`, `Double`, `String`, `Bool`.
   - Print all values in a single `print()` statement.
4. **Challenge**:
   - Create a variable `steps` (Int) starting at 5000.
   - Change it to 7500 and print: “Today’s steps: 7500.”
   - Convert `steps` to a constant and observe what happens when you try to change it.

**Example Solution** (for Exercise 1):
```swift
var city = "San Francisco"
let zipCode = 94103
var temperature: Double = 65.5
print("I live in \(city), zip \(zipCode), where it’s \(temperature)°F.")
```

---

### Resources
- **Free Resources**:
  - **Hacking with Swift**: “100 Days of Swift” Day 1 (Variables, Constants, Types, hackingwithswift.com/100).
  - **CodeWithChris**: YouTube “Swift Basics for Beginners” and “Xcode Tutorial for Beginners” (search on YouTube).
  - **Swift.org**: “A Swift Tour” (The Basics, swift.org/documentation).
  - **Apple Developer**: “Xcode Overview” (developer.apple.com/xcode) and “Swift Playgrounds” (developer.apple.com/swift-playgrounds).
- **Optional**:
  - Swift Playgrounds app (Mac/iPad, free, App Store): Try “Learn to Code 1” for interactive variable exercises.
  - Udemy: Angela Yu’s “iOS & Swift Bootcamp” (first section, often ~$10 on sale).

---

### Tips for Success
- **Take Breaks**: If overwhelmed, pause after each topic (e.g., after installing Xcode).
- **Experiment**: Change values in the playground to see what happens (e.g., make `temperature` negative).
- **Save Work**: Save your playground (File > Save) and back it up to a folder or GitHub.
- **Ask Questions**: If stuck, post on X with #SwiftUI or r/Swift (e.g., “Why does my playground not show output?”).
- **Have Fun**: Personalize your code (e.g., use your name or favorite city) to stay engaged.

---

### Expected Outcome
By the end of Day 1, you should:
- Have Xcode installed and running.
- Understand Swift’s role in iOS development.
- Create and run a playground with variables (`var`), constants (`let`), and data types (`Int`, `Double`, `String`, `Bool`).
- Write `print()` statements with string interpolation to display data.
- Feel confident experimenting with simple Swift code.

---

### Next Steps for Day 2
- Preview: Learn control flow (`if`, `for`) and functions to make your code dynamic and reusable.
- Task: Keep your “Day1” playground open to add more code tomorrow.

