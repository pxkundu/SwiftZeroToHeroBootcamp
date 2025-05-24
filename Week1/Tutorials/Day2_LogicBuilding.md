For **Day 2 of Week 1** in the **Swift Zero to Hero Bootcamp**, designed for absolute beginners with no prior programming experience, the focus is on building upon Day 1’s foundation (variables, constants, data types, arithmetic, comments, and type inference). The high-level topics identified for Day 2 are **Swift control flow** (conditionals and loops) and **functions**, which introduce logic and reusable code. This detailed learning plan expands on these topics, providing in-depth explanations, examples, tasks, resources, and practice exercises to ensure beginners can grasp and apply these concepts effectively. The plan fits within the ~2–3 hour timeframe (1 hour learning, 1–2 hours practice) and prepares learners for Day 3 (arrays, dictionaries, optionals).

The goal is to enable learners to control program flow (e.g., make decisions with `if` statements, repeat tasks with loops) and write reusable code with functions, all in a beginner-friendly way.
---

## Week 1, Day 2: Swift Control Flow and Functions
**Goal**: Learn to control program flow using conditionals (`if`, `else`, `switch`) and loops (`for`, `while`), and create reusable code with functions.  
**Duration**: ~2–3 hours (1 hour learning, 1–2 hours practice).  
**Tools**: Xcode 16+ (Mac with macOS Ventura or later), optional Swift Playgrounds app.  
**Prerequisites**: Completion of Day 1 (variables, constants, data types, arithmetic, comments, type inference).  
**Outcome**: Write Swift code in a playground that uses conditionals to make decisions, loops to repeat tasks, and functions to organize code, with practical applications like checking conditions or calculating totals.  
**Date**: May 20, 2025 (aligned with current date).

---

### Detailed Learning Topics

#### 1. Conditional Statements: `if`, `else`, `switch`
**Objective**: Use conditionals to make decisions based on conditions (e.g., “if score is high, print a message”).  
**Why It Matters**: Conditionals allow programs to respond dynamically, a core feature of interactive apps (e.g., show a “Win” message if a score exceeds a threshold).  
**Time**: ~30 minutes.

- **Concepts**:
  - **If Statements**:
    - Execute code if a condition is `true`.
    - Syntax:
      ```swift
      if condition {
          // Code if true
      } else if anotherCondition {
          // Code if anotherCondition is true
      } else {
          // Code if all conditions are false
      }
      ```
    - Conditions use comparison operators: `==` (equal), `!=` (not equal), `>`, `<`, `>=`, `<=`.
    - Example:
      ```swift
      let score = 85
      if score >= 90 {
          print("Excellent!")
      } else if score >= 70 {
          print("Good job!")
      } else {
          print("Try again!")
      }
      // Prints: Good job!
      ```
  - **Logical Operators**:
    - Combine conditions with `&&` (and), `||` (or), `!` (not).
    - Example:
      ```swift
      let age = 20
      let isStudent = true
      if age < 25 && isStudent {
          print("Eligible for student discount")
      }
      // Prints: Eligible for student discount
      ```
  - **Switch Statements**:
    - Handle multiple cases efficiently.
    - Syntax:
      ```swift
      switch value {
      case value1:
          // Code
      case value2:
          // Code
      default:
          // Code if no cases match
      }
      ```
    - Example:
      ```swift
      let day = "Monday"
      switch day {
      case "Monday":
          print("Start of the week")
      case "Friday":
          print("Weekend soon!")
      default:
          print("Just another day")
      }
      // Prints: Start of the week
      ```

- **Learning Task** (15 minutes):
  - **Read**: Hacking with Swift “100 Days of Swift” Day 2 (Conditionals, ~10 minutes, hackingwithswift.com/100).
  - **Watch**: CodeWithChris “Swift Conditionals for Beginners” (YouTube, ~5 minutes, search for the video).
  - **Code** (in a new “Day2” playground):
    ```swift
    let temperature = 72
    if temperature > 80 {
        print("It’s hot!")
    } else {
        print("It’s comfortable")
    }
    ```
    - Run and change `temperature` to test different outputs.
    - Add a `switch` statement for a `grade` variable (e.g., `"A"`, `"B"`, `"C"`) to print feedback.

#### 2. Loops: `for` and `while`
**Objective**: Use loops to repeat tasks (e.g., print numbers 1 to 10 or repeat until a condition is met).  
**Why It Matters**: Loops automate repetitive tasks, essential for processing lists (e.g., displaying tasks in Week 2’s To-Do List App).  
**Time**: ~30 minutes.

- **Concepts**:
  - **For Loops**:
    - Iterate over a range or sequence.
    - Syntax:
      ```swift
      for variable in range {
          // Code to repeat
      }
      ```
    - Example:
      ```swift
      for i in 1...5 {
          print("Number: \(i)")
      }
      // Prints: Number: 1, Number: 2, ..., Number: 5
      ```
    - Use `1...5` (inclusive range) or `1..<5` (excludes 5).
  - **While Loops**:
    - Repeat while a condition is `true`.
    - Syntax:
      ```swift
      while condition {
          // Code to repeat
      }
      ```
    - Example:
      ```swift
      var count = 0
      while count < 3 {
          print("Count: \(count)")
          count += 1
      }
      // Prints: Count: 0, Count: 1, Count: 2
      ```
  - **Break and Continue**:
    - `break`: Exit a loop early.
    - `continue`: Skip to the next iteration.
    - Example:
      ```swift
      for i in 1...5 {
          if i == 3 {
              continue // Skip 3
          }
          print(i)
      }
      // Prints: 1, 2, 4, 5
      ```

- **Learning Task** (15 minutes):
  - **Read**: Hacking with Swift “100 Days of Swift” Day 2 (Loops, ~10 minutes).
  - **Code**:
    ```swift
    for i in 1...10 {
        print("Number \(i)")
    }
    var timer = 5
    while timer > 0 {
        print("Countdown: \(timer)")
        timer -= 1
    }
    ```
    - Run and observe outputs.
    - Modify the `for` loop to print only even numbers (hint: use `if i % 2 == 0`).

#### 3. Functions
**Objective**: Write reusable code blocks with functions to perform tasks (e.g., calculate a value or print a message).  
**Why It Matters**: Functions organize code, reduce repetition, and are foundational for building apps (e.g., handling button taps).  
**Time**: ~30 minutes.

- **Concepts**:
  - **Defining a Function**:
    - Syntax:
      ```swift
      func functionName(parameter: Type) -> ReturnType {
          // Code
          return value
      }
      ```
    - Example:
      ```swift
      func sayHello(name: String) {
          print("Hello, \(name)!")
      }
      sayHello(name: "Alice") // Prints: Hello, Alice!
      ```
  - **Parameters**:
    - Inputs to a function (e.g., `name: String`).
    - Can have multiple parameters or none.
    - Example:
      ```swift
      func add(a: Int, b: Int) -> Int {
          return a + b
      }
      let result = add(a: 5, b: 3)
      print("Sum: \(result)") // Prints: Sum: 8
      ```
  - **Return Types**:
    - Use `-> Type` to specify what the function returns (e.g., `Int`, `String`).
    - Use `Void` (or omit `->`) for no return.
  - **Calling Functions**:
    - Use the function name with arguments (e.g., `add(a: 5, b: 3)`).
  - **Argument Labels**:
    - Parameters can have external labels for clarity.
    - Example:
      ```swift
      func greet(to person: String) {
          print("Hi, \(person)!")
      }
      greet(to: "Bob") // Prints: Hi, Bob!
      ```

- **Learning Task** (15 minutes):
  - **Read**: Hacking with Swift “100 Days of Swift” Day 2 (Functions, ~10 minutes).
  - **Watch**: Sean Allen “Swift Functions for Beginners” (YouTube, ~5 minutes, search for the video).
  - **Code**:
    ```swift
    func square(number: Int) -> Int {
        return number * number
    }
    let result = square(number: 4)
    print("Square of 4 is \(result)") // Prints: Square of 4 is 16
    ```
    - Write a function to calculate the double of a number and test it.

---

### Practice Exercises (30 minutes)
To reinforce Day 2 topics, complete these exercises in the “Day2” playground:
1. **Conditional Check**:
   - Create a variable `temperature` (Int) and use `if-else` to print “Hot” (above 80), “Comfortable” (60–80), or “Cold” (below 60).
   - Example: `let temperature = 75` → “Comfortable”.
2. **Switch Statement**:
   - Create a `weather` variable (String, e.g., “sunny”, “rainy”, “cloudy”) and use `switch` to print a message for each case (default: “Unknown weather”).
3. **For Loop**:
   - Use a `for` loop to print multiples of 5 from 5 to 50 (5, 10, ..., 50).
4. **While Loop**:
   - Create a `balance` variable starting at 100. Use a `while` loop to subtract 20 until `balance` is 0 or negative, printing each step.
5. **Function**:
   - Write a function `isEven(number: Int) -> Bool` that returns `true` if a number is even (use `% 2 == 0`).
   - Test with `print(isEven(number: 6))` and `print(isEven(number: 7))`.
6. **Challenge**:
   - Write a function `calculateTotal(price: Double, quantity: Int) -> Double` to compute price * quantity.
   - Test with `calculateTotal(price: 9.99, quantity: 3)`.

**Example Solution** (for Exercise 1):
```swift
let temperature = 75
if temperature > 80 {
    print("Hot")
} else if temperature >= 60 {
    print("Comfortable")
} else {
    print("Cold")
}
// Prints: Comfortable
```

---

### Resources
- **Free Resources**:
  - **Hacking with Swift**: “100 Days of Swift” Day 2 (Conditionals, Loops, Functions, hackingwithswift.com/100).
  - **CodeWithChris**: YouTube “Swift Conditionals for Beginners” and “Swift Functions for Beginners” (search on YouTube).
  - **Sean Allen**: YouTube “Swift Functions for Beginners” (search for the video).
  - **Swift.org**: “A Swift Tour” (Control Flow and Functions, swift.org/documentation).
  - **Apple Developer**: “Swift Programming Language” (Control Flow, developer.apple.com/documentation/swift).
- **Optional**:
  - Swift Playgrounds app (Mac/iPad, free): “Learn to Code 1” (Conditionals, Loops).
  - Udemy: Angela Yu’s “iOS & Swift Bootcamp” (early sections, ~$10 on sale).

---

### Tips for Learners
- **Start Small**: Run one section at a time (e.g., `if` statements) before combining concepts.
- **Use Comments**: Add your own comments to explain each exercise (e.g., “// Checks if temperature is hot”).
- **Debug**: If a loop runs forever (e.g., `while true`), stop it (Cmd+.) and fix the condition.
- **Personalize**: Use real-world scenarios (e.g., `weather = "rainy"` for your city).
- **Ask Questions**: Post errors on X with #SwiftUI or r/Swift if stuck.

---

### Expected Outcome
By the end of Day 2, learners will:
- Use `if-else` and `switch` to make decisions (e.g., classify temperatures or days).
- Write `for` and `while` loops to repeat tasks (e.g., print numbers, countdown).
- Create and call functions with parameters and return values (e.g., `square(number:)`).
- Complete exercises combining conditionals, loops, and functions.
- Feel confident writing logical, reusable Swift code in a playground.

---
