# Go Notes

## Helpful Links

* <https://pkg.go.dev/std>
* <https://pkg.go.dev/>
* <https://developer.mozilla.org/en-US/docs/Web/javascript>
* <https://www.jsdelivr.com/>
* <https://cdnjs.com/>
* <https://developer.mozilla.org/en-US/docs/Web/CSS>

## Project Setup

The program must contain a main function which has no arguments or inputs and must not return anything.

Here is the minimal configuration to use go:

```go
package main // package declaration at the top

func main() {} // function that does not expect anything and does not return anything
```

## Variables

Variables can be set a few different ways.

```go
package main
import "fmt"

var packageVariable string = "This is a package level variable, not inside a specific function"

func main() {
  var varMain int // this sets the variable w/ type int and an empty value
  
  // set the value
  varMain = 5

  // now, varMain = 5

  // setting the variable equal to some content or output
  varOutput := exeFunction() // this sets the type matching the output type of the function and stores the output as a variable.
}

```

### Variable Naming

variables that start with a capital letter are exported at the package level and are "public" to other functions and packages. Variables that start with a lower case letter are non-exportable and are only available in the current code block.

### Variable Shadowing

This is an issue when using the same variable names, however, not understanding which variable is actually being used at a specific time in code.

```go

package main

var s = "Seven" // package variable

func main() {
  var s2 = "Six" // variable inside main()

  log.Println("s is: ", s) // Seven
  log.Println("s2 is: ", s2) // Six

  saySomething("xxx")
}

func saySomething(s3 string) (string, string) {
  log.Println("s from say something func is: ", s) // calls the package var s
}

// same function, just different setup...
func saySomething(s string) (string, string) {
  log.Println("s from say something func is: ", s) // calls variable from this function, "xxx"
}
```

This can also happen inside the main function, if you define or declare a variable by name which is used elsewhere, you need to make sure you're aware of the impact. For example, if we added `s := "eight"` to the main function, the value would be updated only when called in the main function, everywhere else would use the package value of "seven".

### Structs and Types

Using types can reduce the number of variables required for your application. This can also be used to group variables together for an intended purpose.

```go
type User struct {
	FirstName   string
	LastName    string
	PhoneNumber string
	Age         int
	BirthDate time.Time
}

// Calling the user type to create a variable
	user := User {
		FirstName: "Peter",
		LastName: "Griffin",
		PhoneNumber: "555-123-1234",
		Age: 44,
		// BirthDate time.Time
	}

  // call the values using user.FirstName, user.LastName, etc.
  // if value is not defined, it returns null or default value, in the case of time.Time

```

## Functions

Functions can be used to execute specific tasks. They generally take in some data, execute some code, and return some data. Since go is strict on types, the arguments coming in must match the correct type as well as the values being returned.

```go

func returnSomeData() (string, int) {
  return "someData", 10
}

// set a variable for each equal to the output. in this case, someData would be a string, count would be an int
someData, count := returnSomeData()

fmt.Println(someData, count) // someData 10
```

### Pointers

Go can reference a location in memory and update the value to a specific variable in memory vs. having to pass it back and then store it in memory after the function execution.

```go
func main()  {
var myString string // create empty string variable
myString = "Green" // set the value to green, which stores the value in memory

log.Println("myString is set to: ", myString) // print the current value = "Green"
changeUsingPointer(&myString) // call the function, see below
log.Println("After func call myString is set to: ", myString) // print the value after the function
}

func changeUsingPointer(s *string) { // expect a pointer to a string variable and reference it as s.
	newValue := "Red" // store a new value as a variable in this function, could be anything
	*s = newValue // update the pointer which was passed to the function w/ the new value
}

```

Notice with this method, we're not returning anything from the function or updating the value in main(), the `changeUsingPointer` function is updating the value in memory.

## Receivers on Functions

These are added to types to allow for additional functionality attached to the type.

```go
package main

import "log"

type myStruct struct { // create a new type of struct
	FirstName string
}


// add a reciver to a function (m *myStruct) attaching this function to the type. This does not require an argument, just uses a pointer to the current type or variable and references the data there.
func (m *myStruct) printFirstName() string { 
	return m.FirstName
}

func main() {
	var myVar myStruct // declare variable of type myStruct
	myVar.FirstName = "Peter" // set first name

	myVar2 := myStruct{ // declare a new var and set the value shorthand
		FirstName: "Lois",
	}


	log.Println("myVar is set to: ", myVar.printFirstName() ) // call the function attached to the type to print the first name
	log.Println("myVar2 is set to: ", myVar2.printFirstName() )
}
```

## Maps

Maps are objects. Used to store data. They're super fast... You never have to pass a pointer to a map, you only have to pass the map. This is different than other variable types where the value and reference are stored differently. Maps are stored unsorted. You must always lookup by key if you want a specific value.

```go
package main

import "log"

type User struct {
  FirstName string
  LastName string
}

func main() {
  // Do not create maps this way...
  // var myOtherMap map[string]string
  myMap := make(map[string]string) // define the structure of your map...
  myMap["dog"] = "Brian"
  myMap["cat"] = "Garfield"

  log.Println(myMap["dog"]) // Brian


  myOtherMap := make(map[string]int)
  myOtherMap["first"] = 1
  myOtherMap["second"] = 2

  log.Println(myMap["first"]) // 1

  users := make(map[string]User) // using a struct as a type (map of users)

// create a new user of type User
  pgriffin := User {
    FirstName: "Peter",
    LastName: "Griffin",
  }
  users["pgriffin"] = pgriffin // set the value of pgriffin in the map

  log.Println(users["pgriffin"].FirstName)

  // shorthand for creating lgriffin...
  users["lgriffin"] = User {
    FirstName: "Lois",
    LastName: "Griffin",
  }
  log.Println(users["lgriffin"].FirstName)

}
```

### Slices

These are arrays/lists

```go
package main

import "log"


func main() {
  var pets []string

  pets = append(pets, "fish")
  pets = append(pets, "dog")

  log.Println(pets[0])
}
```

### Decision Structures

These are if statements to evaluate some conditions and take action if a specific condition is met or not met. When using if statements, a max of two conditions should be use.

```go
package main

import "log"

func main() {
  isTrue := true // set value to true using a bool type

  if isTrue { // if value is true, since value is true, this is true.
    log.Println("isTrue: ", isTrue)
  } else { // execute if the value is not true... this would include anything else other than a bool of true.
    log.Println("isTrue: ", isTrue)
  }


  cat := "cat" // var of type string
  if cat == "cat" { // check string matches string
    log.Println("Cat is cat")
    } else {
      log.Println("Cat is not cat")
  }

  myNum := 100
  isFalse := false
  if myNum > 99 && !isFalse { // double condition and using math
    log.Println("myNum is greater than 99 and isTrue is true")
    } else if myNum < 100 && isFalse { // else if statement, max of two.
      log.Println("myNumber less than 100 and isFalse is true")
    } else {
      // no condition met
      log.Println("No condition met")
    }
}

```

Another use is switches:

```go
myVar := "turkey" // setting the value
switch myVar {
case "cat": // check if myVar == "cat"
  log.Println("myVar is set to cat") 
case "dog": // check if myVar == "dog"
  log.Println("myVar is set to dog")
case "fish": // check if myVar == "fish"
  log.Println("myVar is set to fish")
default: // if nothing matches, take this action
  log.Println("myVar is not matched")
}

```

### Loops and Ranging Over Data

```go
for i := 0; i <= 10; i++ {
  log.Println(i)
}

// ranging over a slice
animals := []string{"dog", "fish", "horse", "cat", "mouse"}
for i, animal := range animals { // return the index as i and the value as animal
  log.Println(i, animal)
}

for _, animal := range animals { // use the _ if you do not care about the index
  log.Println(animal)
}


// ranging over a map
critters := make(map[string]string)
critters["dog"] = "Brian"
critters["cat"] = "Garfield"

// range over a map and just return the values
for _, critter := range critters {
  log.Println(critter)
}

// if you want the key and value of a map
for key, value := range critters {
  log.Println(key, value)
}

// range over strings
firstLine := "Once upon a midnight dreary"

for i, l := range firstLine {
  log.Println(i, ":", l)
}

// range over maps of custom types
type User struct {
  FirstName string
  LastName  string
  Email     string
  Age       int
}
var users []User
users = append(users, User{"John", "Smith", "John@smith.com", 30})
users = append(users, User{"Jane", "Doe", "jane@doe.com", 84})
users = append(users, User{"Peter", "Griffin", "peter@familyguy.com", 30})
users = append(users, User{"Lois", "Griffin", "lois@familyguy.com", 30})

for _, user := range users {
  log.Println(user.FirstName, user.LastName, user.Email, user.Age)
}
```

### Interfaces

Interfaces are used to define how a specific item should look and can include specific methods which must exists for the type as well.


Here is one example of using an Interface; notice the inline comments to follow best practices

It is a best practice to pass a reference to the methods/functions using the interface thus requiring each of those methods of functions to use a receiver.

```go
package main

import "fmt"

type Animal interface {
	Says() string
	NumberOfLegs() int
}

type Dog struct {
	Name  string
	Breed string
}

func main() {
	dog := Dog{
		Name:  "Samson",
		Breed: "German Shepherd",
	}

	PrintInfo(&dog) // best practice to use a reference and pass this to the receiver

}

func PrintInfo(a Animal) {
	fmt.Println("This animal says", a.Says(), "and has", a.NumberOfLegs(), "legs")
}

func (d *Dog) Says() string { // should use a receiver
	return "Woof!"
}
func (d *Dog) NumberOfLegs() int { // should use a receiver
	return 4
}
```

In order for something to implement an interface, it must...
Implement the same functions as the interface in questions
