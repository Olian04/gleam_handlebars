import gleam/dict
import gleam/dynamic
import gleam/list
import gleeunit/should
import handles/compiler
import handles/engine

pub fn engine_should_return_correct_when_running_hello_world_test() {
  engine.run([compiler.Constant("Hello World")], Nil |> dynamic.from)
  |> should.be_ok
  |> should.equal("Hello World")
}

pub fn engine_should_return_correct_when_running_hello_name_test() {
  engine.run(
    [compiler.Constant("Hello "), compiler.Property(["name"])],
    dict.new()
      |> dict.insert("name", "Oliver")
      |> dynamic.from,
  )
  |> should.be_ok
  |> should.equal("Hello Oliver")
}

pub fn engine_should_return_correct_when_accessing_nested_property_test() {
  engine.run(
    [compiler.Property(["foo", "bar"])],
    dict.new()
      |> dict.insert(
        "foo",
        dict.new()
          |> dict.insert("bar", 42),
      )
      |> dynamic.from,
  )
  |> should.be_ok
  |> should.equal("42")
}

pub fn engine_should_return_correct_when_using_truthy_if_test() {
  engine.run(
    [compiler.Block("if", ["bool"], [compiler.Property(["foo", "bar"])])],
    dict.new()
      |> dict.insert(
        "foo",
        dict.new()
          |> dict.insert("bar", 42)
          |> dynamic.from,
      )
      |> dict.insert(
        "bool",
        True
          |> dynamic.from,
      )
      |> dynamic.from,
  )
  |> should.be_ok
  |> should.equal("42")
}

pub fn engine_should_return_correct_when_using_falsy_if_test() {
  engine.run(
    [compiler.Block("if", ["bool"], [compiler.Property(["foo", "bar"])])],
    dict.new()
      |> dict.insert(
        "bool",
        False
          |> dynamic.from,
      )
      |> dynamic.from,
  )
  |> should.be_ok
  |> should.equal("")
}

pub fn engine_should_return_correct_when_using_truthy_unless_test() {
  engine.run(
    [compiler.Block("unless", ["bool"], [compiler.Property(["foo", "bar"])])],
    dict.new()
      |> dict.insert(
        "bool",
        True
          |> dynamic.from,
      )
      |> dynamic.from,
  )
  |> should.be_ok
  |> should.equal("")
}

pub fn engine_should_return_correct_when_using_falsy_unless_test() {
  engine.run(
    [compiler.Block("unless", ["bool"], [compiler.Property(["foo", "bar"])])],
    dict.new()
      |> dict.insert(
        "foo",
        dict.new()
          |> dict.insert("bar", 42)
          |> dynamic.from,
      )
      |> dict.insert(
        "bool",
        False
          |> dynamic.from,
      )
      |> dynamic.from,
  )
  |> should.be_ok
  |> should.equal("42")
}

pub fn engine_should_return_correct_when_using_each_test() {
  engine.run(
    [
      compiler.Block("each", ["list"], [
        compiler.Property(["name"]),
        compiler.Constant(", "),
      ]),
    ],
    dict.new()
      |> dict.insert(
        "list",
        list.new()
          |> list.append([
            dict.new()
              |> dict.insert("name", "Knatte")
              |> dynamic.from,
            dict.new()
              |> dict.insert("name", "Fnatte")
              |> dynamic.from,
            dict.new()
              |> dict.insert("name", "Tjatte")
              |> dynamic.from,
          ])
          |> dynamic.from,
      )
      |> dynamic.from,
  )
  |> should.be_ok
  |> should.equal("Knatte, Fnatte, Tjatte, ")
}

pub fn engine_should_return_correct_when_using_empty_each_test() {
  engine.run(
    [
      compiler.Block("each", ["list"], [
        compiler.Property(["name"]),
        compiler.Constant(", "),
      ]),
    ],
    dict.new()
      |> dict.insert(
        "list",
        list.new()
          |> dynamic.from,
      )
      |> dynamic.from,
  )
  |> should.be_ok
  |> should.equal("")
}