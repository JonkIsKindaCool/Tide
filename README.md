# TIDE

---

## Variables

```tide
let name = "Ana"                # immutable, type inferred
let age: Int = 25               # explicit type
mut counter = 0                 # mutable
```

---

## Types

```tide
# Primitives
Bool  Int  Float  Str  Any  Null

# Compound
List<Int>                         # list of integers
Map<String, Int>                      # map of string to int
Int?                            # nullable

# Named
type Age = Int
type Point = (Float, Float)

# Structs
struct Person {
    name  : Str
    age   : Int
    email : Str?                # optional field
}

# Enums with data
enum Result {
    Ok(value: Any)
    Error(message: Str)
    Pending
}
```

---

## Functions

```tide
# Basic
fn add(a: Int, b: Int) -> Int {
    a + b                       # last value is returned implicitly
}

# With default values
fn greet(name: Str, formal: Bool = false) -> Str {
    if formal { "Good day, " + name }
    else      { "Hey, " + name }
}

# Anonymous / lambda
let double = |x| x * 2
let add    = |a, b| a + b

# Multiple return values
fn divide(a: Int, b: Int) -> (quotient: Int, remainder: Int) {
    (a / b, a % b)
}
```

---

## Conditionals

```tide
# If as expression
let label = if age >= 18 { "adult" } else { "minor" }

# Multiline if
if temperature > 30 {
    turn_on(fan)
} else if temperature < 10 {
    turn_on(heater)
} else {
    do_nothing()
}

# Switch
switch color {
    "red"   => stop()
    "green" => go()
    "blue"  => turn()
    else    => wait()
}
```

---

## Loops

```tide
# While condition
while playing {
    update()
    draw()
}

# For each element
for fruit in fruits {
    print(fruit)
}

# With index
for i, fruit in fruits {
    print(i, fruit)
}

# Range
for n in 1..100 {
    print(n)
}
```

---

## Error Handling

```tide
# ? propagates the error upward
fn read_config() -> Config {
    try {
        let text = read_file("config.json")?
        let data = parse_json(text)?    
    } catch e -> Exception{
        throw e
    }
    data
}

# Explicit handling
try {
    connect(server)
} catch e -> Any {
    log("Failed: " + msg)
} finally {
    close_resources()
}

# Default value if null
let name = user?.name ?? "Anonymous"
```

---

## Classes

```tide
class Animal {
    let name : Str
    mut energy : Int = 100

    public fn new(name: Str) {
        self.name = name
    }

    public fn eat(amount: Int) {
        self.energy += amount
    }

    fn speak() -> Str { "..." }
}

class Dog extends Animal {
    public fn speak() -> Str { "Woof" }
}

let dog = Dog(name: "Rex")
dog.eat(amount: 10)
print(dog.speak())              # "Woof"
```

---

## Concurrency

```tide
# Async / await (reads like spoken English)
async fn fetch_user(id: Int) -> User {
    let response = await http.get("/users/" + id)
    await response.json()
}
```

---

## Annotations

```tide
@inline
@deprecated("Use new_function()")
struct Point { x: Float, y: Float }
```

---

## Literals

```tide
# Text
"hello world"

# Numbers
1_000_000                       # visual separator
3.14
0xFF   0b1010   0o77            # hex, binary, octal

# Collections
[1, 2, 3]                       # list
{"a": 1, "b": 2}                # map

# Ranges
1..10                           # 1 to 9
1..=10                          # 1 to 10 inclusive
0..100 step 5                   # with step
```

---

## Operators

```tide
# Math          + - * / % **
# Comparison    == != < > <= >=
# Logical       && || !
# Null-safe     ??   ?.
# Range         .. ..=
# Spread        ...list
# Bitwise       << >>
```

---