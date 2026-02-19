# FLUX — Readable Syntax

> The golden rule: **code reads like a technical English sentence**, no unnecessary symbols.

---

## Variables

```flux
let name = "Ana"                -- immutable, type inferred
let age: Int = 25               -- explicit type
mut counter = 0                 -- mutable
let x, y, z = 1, 2, 3          -- multiple assignment
```

---

## Types

```flux
-- Primitives
Bool  Int  Float  Str  Char  Byte  Any  Null

-- Compound
[Int]                           -- list of integers
{Str: Int}                      -- map of string to int
(Int, Str)                      -- tuple
Int?                            -- nullable
Int | Str                       -- one or the other

-- Named
type Age = Int
type Point = (Float, Float)

-- Structs
struct Person {
    name  : Str
    age   : Int
    email : Str?                -- optional field
}

-- Enums with data
enum Result {
    Ok(value: Any)
    Error(message: Str)
    Pending
}
```

---

## Functions

```flux
-- Basic
fn add(a: Int, b: Int) -> Int {
    a + b                       -- last value is returned implicitly
}

-- With default values
fn greet(name: Str, formal: Bool = false) -> Str {
    if formal { "Good day, " + name }
    else      { "Hey, " + name }
}

-- Anonymous / lambda
let double = |x| x * 2
let add    = |a, b| a + b

-- Multiple return values
fn divide(a: Int, b: Int) -> (quotient: Int, remainder: Int) {
    (a / b, a % b)
}

-- Named arguments (more readable)
greet(name: "Carlos", formal: true)
```

---

## Conditionals

```flux
-- If as expression
let label = if age >= 18 { "adult" } else { "minor" }

-- Multiline if
if temperature > 30 {
    turn_on(fan)
} else if temperature < 10 {
    turn_on(heater)
} else {
    do_nothing()
}

-- When multiple cases (instead of switch)
when color {
    "red"   => stop()
    "green" => go()
    "blue"  => turn()
    else    => wait()
}

-- Pattern matching
match result {
    Ok(value)      => show(value)
    Error(message) => log(message)
    Pending        => waiting()
}
```

---

## Loops

```flux
-- Repeat N times
repeat 10 {
    print("hello")
}

-- While condition
while playing {
    update()
    draw()
}

-- For each element
for fruit in fruits {
    print(fruit)
}

-- With index
for i, fruit in fruits {
    print(i, fruit)
}

-- Range
for n in 1..=100 {
    print(n)
}

-- Loop with exit value
let result = loop {
    let x = calculate()
    if x > 100 { break x }
}
```

---

## Error Handling

```flux
-- ? propagates the error upward
fn read_config() -> Config | Error {
    let text = read_file("config.json")?
    let data = parse_json(text)?
    data
}

-- Explicit handling
try {
    connect(server)
} catch Error(msg) {
    log("Failed: " + msg)
} finally {
    close_resources()
}

-- Default value if null
let name = user?.name ?? "Anonymous"
```

---

## Classes

```flux
class Animal {
    name       : Str
    mut energy : Int = 100

    new(name: Str) {
        self.name = name
    }

    fn eat(amount: Int) {
        self.energy += amount
    }

    fn speak() -> Str { "..." }
}

class Dog extends Animal {
    fn speak() -> Str { "Woof" }
}

let dog = Dog(name: "Rex")
dog.eat(amount: 10)
print(dog.speak())              -- "Woof"
```

---

## Modules

```flux
module Math {
    export let PI = 3.14159

    export fn sqrt(x: Float) -> Float { ... }
    export fn pow(base: Float, exp: Int) -> Float { ... }
}

import Math
import Math.{ sqrt, PI }
import Math as M
```

---

## Functional Style

```flux
-- Pipeline: pass result to the next step
let total = numbers
    |> filter(|x| x > 0)
    |> map(|x| x * 2)
    |> reduce(0, |acc, x| acc + x)

-- Collection methods (self-explanatory)
users
    .filter(|u| u.active)
    .sort(by: |u| u.name)
    .take(10)
    .map(|u| u.email)
```

---

## Concurrency

```flux
-- Async / await (reads like spoken English)
async fn fetch_user(id: Int) -> User {
    let response = await http.get("/users/" + id)
    await response.json()
}

-- Run in parallel
let (posts, friends) = await parallel {
    fetch_posts(user),
    fetch_friends(user)
}

-- Background task
spawn {
    process_in_background()
}
```

---

## Annotations

```flux
@inline
@deprecated("Use new_function()")
@derive(Debug, Eq, Hash)
struct Point { x: Float, y: Float }
```

---

## Literals

```flux
-- Text
"hello world"
`hello, ${name}!`               -- interpolation
"""
    multiline
    text here
"""

-- Numbers
1_000_000                       -- visual separator
3.14
0xFF   0b1010   0o77            -- hex, binary, octal

-- Collections
[1, 2, 3]                       -- list
{1, 2, 3}                       -- set
{"a": 1, "b": 2}                -- map
(42, "hello", true)             -- tuple

-- Ranges
1..10                           -- 1 to 9
1..=10                          -- 1 to 10 inclusive
0..100 step 5                   -- with step
```

---

## Operators

```flux
-- Math          + - * / % **
-- Comparison    == != < > <= >=
-- Logical       and  or  not
-- Null-safe     ??   ?.
-- Pipeline      |>
-- Range         ..   ..=
-- Spread        ...list
```

---

## The 5 Principles of FLUX

1. **Explicit over implicit** — if something happens, you can see it
2. **Words over symbols** — `and`, `or`, `not` instead of `&&`, `||`, `!`
3. **Immutable by default** — mutability is declared with `mut`
4. **Errors as values** — no hidden surprises
5. **One clear path** — for each problem, one obvious way to solve it