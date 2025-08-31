import gleam/int
import gleam/list
import gleam/regexp
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  // simplifile.read("src/day_3/test_memory")
  // simplifile.read("src/day_3/memory")
  // |> result.map(break_into_muls)
  // |> result.map(fn(l) { list.filter_map(l, find_parentheses) })
  // |> result.map(fn(l) { list.filter_map(l, check_if_numbers) })
  // // |> echo
  // |> result.map(fn(l) { list.map(l, multiply) })
  // |> result.map(fn(l) { list.fold(l, 0, fn(i, acc) { i + acc }) })
  let assert Ok(re) =
    // simplifile.read("src/day_3/test_memory")
    Ok("mul(2,3)")
    |> echo
    |> result.map(regexp.from_string)
    |> echo
    |> result.map(regexp.scan("mul([0-9]{1,3},[0-9]{1,3})"))
}

fn break_into_muls(s: String) -> List(String) {
  string.split(s, "mul")
}

fn find_parentheses(s: String) -> Result(String, String) {
  string.split_once(s, "(")
  |> result.map(fn(x) {
    let #(_, second) = x
    string.split_once(second, ")")
  })
  |> result.flatten
  |> result.map(fn(x) {
    let #(first, _) = x
    first
  })
  |> result.map_error(fn(_) { "Could not find parentheses" })
}

fn check_if_numbers(s: String) -> Result(#(Int, Int), String) {
  string.split_once(s, ",")
  |> result.map_error(fn(_) { "No comma found" })
  |> result.map(fn(x) {
    let #(first, second) = x
    case int.parse(first), int.parse(second) {
      Ok(i), Ok(j) if i < 1000 && j < 1000 -> Ok(#(i, j))
      _, _ -> Error("Invalid integer")
    }
  })
  |> result.flatten
}

fn multiply(pair: #(Int, Int)) -> Int {
  let #(a, b) = pair
  a * b
}
