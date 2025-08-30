import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let result =
    simplifile.read("src/day_1/lists")
    |> result.map_error(fn(_) { "Error reading file!" })
    |> result.map(read_columns_to_lists)
    |> result.flatten

  case result {
    Ok(#(a, b)) -> Ok(distance(a, b))
    Error(e) -> Error(e)
  }
  |> echo
}

fn distance(list_a: List(Int), list_b: List(Int)) -> Int {
  distance_loop(
    list.sort(list_a, int.compare),
    list.sort(list_b, int.compare),
    0,
  )
}

fn distance_loop(list_a: List(Int), list_b: List(Int), accumulator) -> Int {
  case list_a, list_b {
    [], [] -> accumulator
    [first_a, ..rest_a], [first_b, ..rest_b] ->
      distance_loop(
        rest_a,
        rest_b,
        accumulator + int.absolute_value(first_a - first_b),
      )
    _, _ -> panic as "Different length lists?"
  }
}

fn read_columns_to_lists(s: String) -> Result(#(List(Int), List(Int)), String) {
  string.split(s, on: "\n")
  |> read_rows_as_lists(#([], []))
}

fn read_rows_as_lists(
  list: List(String),
  accumulator: #(List(Int), List(Int)),
) -> Result(#(List(Int), List(Int)), String) {
  case list {
    [] -> Ok(accumulator)
    [first, ..rest] -> {
      row_to_ints(first)
      |> result.map(add_ints_to_accumulator(accumulator, _))
      |> result.map(read_rows_as_lists(rest, _))
      |> result.flatten
    }
  }
}

fn row_to_ints(row: String) -> Result(#(Int, Int), String) {
  let list =
    row
    |> string.split(on: " ")
    |> list.filter(fn(s) { s != "" })
  case list {
    [first, second] -> {
      use first_int <- result.try(
        int.parse(first)
        |> result.map_error(fn(_) { "Error parsing first number in row!" }),
      )
      use second_int <- result.try(
        int.parse(second)
        |> result.map_error(fn(_) { "Error parsing second number in row!" }),
      )
      Ok(#(first_int, second_int))
    }
    _ -> Error("Row must have exactly 2 numbers!")
  }
}

fn add_ints_to_accumulator(
  accumulator: #(List(Int), List(Int)),
  ints: #(Int, Int),
) -> #(List(Int), List(Int)) {
  let #(first_int, second_int) = ints
  let #(first_list, second_list) = accumulator
  #([first_int, ..first_list], [second_int, ..second_list])
}
