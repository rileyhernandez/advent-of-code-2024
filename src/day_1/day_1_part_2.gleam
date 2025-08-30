import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  echo fun()
}

fn fun() {
  simplifile.read("src/day_1/lists")
  //	simplifile.read("src/day_1/test_lists")
  |> result.map_error(fn(_) { "Error reading file!" })
  |> result.map(fn(s) { string.split(s, "\n") })
  |> result.map(fn(l) {
    list.map(l, fn(s) {
      string.split(s, " ")
      |> list.filter_map(fn(x) {
        case x {
          num if num != "" -> int.parse(num)
          _ -> Error(Nil)
        }
      })
    })
  })
  |> result.map(fn(l) { unzip(l) })
  |> result.flatten
  |> result.map(lists_to_dict)
  |> echo
  |> result.map(fn(d) { dict.fold(d, 0, fn(acc, k, v) { acc + v / k }) })
}

fn lists_to_dict(lists: #(List(Int), List(Int))) -> Dict(Int, Int) {
  let #(list_a, list_b) = lists
  list_a
  |> list.map(fn(x) { #(x, 0) })
  |> echo
  |> dict.from_list
  |> dict.map_values(fn(k, _) {
    let times_in_b =
      list_b
      |> list.filter(fn(x) { x == k })
      |> list.fold(0, fn(acc, x) { acc + x })
    list_a
    |> list.filter(fn(x) { x == k })
    |> list.fold(0, fn(acc, x) { acc + x })
    |> fn(x) { x * times_in_b }
  })
}

fn unzip(list: List(List(Int))) -> Result(#(List(Int), List(Int)), String) {
  unzip_loop(list, #([], []))
}

fn unzip_loop(
  list: List(List(Int)),
  accumulator: #(List(Int), List(Int)),
) -> Result(#(List(Int), List(Int)), String) {
  case list {
    [] -> Ok(accumulator)
    [[first, second], ..rest] ->
      unzip_loop(rest, add_to_accumulator(accumulator, first, second))
    _ -> Error("Invalid list lengths!")
  }
}

fn add_to_accumulator(
  accumulator: #(List(Int), List(Int)),
  first: Int,
  second: Int,
) -> #(List(Int), List(Int)) {
  let #(accumulator_first, accumulator_second) = accumulator
  #([first, ..accumulator_first], [second, ..accumulator_second])
}
