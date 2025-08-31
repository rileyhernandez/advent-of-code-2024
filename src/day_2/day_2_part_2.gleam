import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import simplifile

pub fn main() {
  let levels_list =
    simplifile.read("src/day_2/levels_test")
    //    simplifile.read("src/day_2/levels")
    |> result.map_error(fn(_) { "Error reading file!" })
    |> result.map(fn(s) { string.split(s, on: "\n") })
    |> result.map(fn(l) {
      list.map(l, fn(s) {
        string.split(s, on: " ")
        |> list.map(fn(x) {
          int.parse(x) |> result.map_error(fn(_) { "Error parsing int!" })
        })
        |> result.all
      })
      |> result.all
    })
    |> result.flatten

  let ascending_levels =
    levels_list
    |> result.map(fn(all) {
      list.map(all, fn(l) {
        list.fold(
          l,
          list.first(l)
            |> result.map_error(fn(_) { "Invalid list? " })
            |> result.map(fn(x) { #(x - 1, option.None) }),
          fn(acc, x) {
            case acc {
              Ok(#(a, op)) -> {
                case op {
                  // passes
                  option.Some(e) if x > a && x - a <= 3 ->
                    Ok(#(x, option.Some(e)))
                  option.None if x > a && x - a <= 3 -> Ok(#(x, option.None))
                  // tolerantly fails
                  option.None -> Ok(#(a, option.Some("Failed ascending!")))
                  // intolerantly fails
                  option.Some(e) -> Error(e)
                }
              }
              // already intolerantly failed
              Error(e) -> Error(e)
            }
          },
        )
      })
      |> echo
      |> list.filter(result.is_ok)
    })
    |> result.map(list.length)

  let descending_levels =
    levels_list
    |> result.map(fn(all) {
      list.map(all, fn(l) {
        list.fold(
          l,
          list.first(l)
            |> result.map_error(fn(_) { "Invalid list? " })
            |> result.map(fn(x) { #(x + 1, option.None) }),
          fn(acc, x) {
            case acc {
              Ok(#(a, op)) -> {
                case op {
                  // passes
                  option.Some(e) if a - x <= 3 && x < a ->
                    Ok(#(x, option.Some(e)))
                  option.None if a - x <= 3 && x < a -> Ok(#(x, option.None))
                  // tolerantly fails
                  option.None -> Ok(#(a, option.Some("Failed descending!")))
                  // intolerantly fails
                  option.Some(e) -> Error(e)
                }
              }
              // already intolerantly failed
              Error(e) -> Error(e)
            }
          },
        )
      })
      |> echo
      |> list.filter(result.is_ok)
    })
    |> result.map(list.length)

  case ascending_levels, descending_levels {
    Ok(a), Ok(b) -> Ok(a + b)
    _, _ -> Error("No valid levels")
  }
  |> echo
}
