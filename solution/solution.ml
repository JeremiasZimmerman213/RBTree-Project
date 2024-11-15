(* Color for nodes *)
type color = Red | Black

(* Type for tree node *)
type 'a rb_tree =
  | Nil
  | Node of color * 'a rb_tree * 'a * 'a rb_tree

(* Helper function to create a node *)
let make_node color left value right =
  Node (color, left, value, right)

(* Balancing the tree after insertion using Okasaki's method *)
let balance = function
  (* These four patterns handle double-red violations where parent is black *)
  | Node (Black, Node (Red, Node (Red, a, x, b), y, c), z, d)
  | Node (Black, Node (Red, a, x, Node (Red, b, y, c)), z, d)
  | Node (Black, a, x, Node (Red, Node (Red, b, y, c), z, d))
  | Node (Black, a, x, Node (Red, b, y, Node (Red, c, z, d))) ->
      Node (Red,
            Node (Black, a, x, b),
            y,
            Node (Black, c, z, d))
  | node -> node  (* No balancing needed *)

(* Insert a value into the Red-Black Tree *)
let insert tree value =
  let rec ins node =
    match node with
    | Nil ->
        (* Insert as a red node if empty *)
        Node (Red, Nil, value, Nil)
    | Node (color, left, x, right) ->
        if value < x then
          balance (Node (color, ins left, x, right))
        else if value > x then
          balance (Node (color, left, x, ins right))
        else
          node  (* value already exists, return node *)
  in
  match ins tree with
  | Node (_, left, x, right) ->
      (* Ensure the root is always black *)
      Node (Black, left, x, right)
  | Nil -> Nil

(* Tail-recursive insert function using the same insertion logic *)
let insert_tr tree value =
  let rec insert_aux path node =
    match node with
    | Nil ->
        List.fold_left (fun acc (color, x, dir) ->
          match dir with
          | `Left -> balance (Node (color, acc, x, Nil))
          | `Right -> balance (Node (color, Nil, x, acc))
        ) (Node (Red, Nil, value, Nil)) path
    | Node (color, left, x, right) as n ->
        if value < x then
          insert_aux ((color, x, `Left) :: path) left
        else if value > x then
          insert_aux ((color, x, `Right) :: path) right
        else
          n
  in
  match insert_aux [] tree with
  | Node (_, left, x, right) -> Node (Black, left, x, right)
  | Nil -> Nil

(* Helper function to recolor a node to black *)
let recolor node =
  match node with
  | Node (_, l, x, r) -> Node (Black, l, x, r)
  | Nil -> Nil

(* Find the minimum value node in the subtree *)
let rec min_value_node = function
  | Nil -> failwith "Empty subtree: No minimum node"
  | Node (_, Nil, x, _) -> x
  | Node (_, left, _, _) -> min_value_node left

(* Balancing the tree after deletion *)
let balance_delete node =
  match node with
  | Node (Black, Node (Red, a, x, b), y, Node (Black, c, z, d))
  | Node (Black, Node (Red, a, x, b), y, Node (Black, c, z, d)) ->
      Node (Red,
            Node (Black, a, x, b),
            y,
            Node (Black, c, z, d))
  | _ -> node

(* Delete a value from the Red-Black Tree *)
(* let delete tree value =
  let rec del node =
    match node with
    | Nil -> Nil
    | Node (color, left, x, right) ->
        if value < x then
          balance_delete (Node (color, del left, x, right))
        else if value > x then
          balance_delete (Node (color, left, x, del right))
        else
          (* Found the node to delete *)
          match left, right with
          | Nil, Nil -> Nil
          | Nil, _ -> recolor right
          | _, Nil -> recolor left
          | _ ->
              let m = min_value_node right in
              balance_delete (Node (color, left, m, delete right m))
  in
  match del tree with
  | Node (_, left, x, right) -> Node (Black, left, x, right)
  | Nil -> Nil *)

(* Check for validity of Red-Black Tree *)
let is_valid tree =
  let rec black_height = function
    | Nil -> 1
    | Node (c, l, _, r) ->
        let left_bh = black_height l in
        let right_bh = black_height r in
        if left_bh = 0 || right_bh = 0 || left_bh <> right_bh then 0
        else
          (* Add 1 to black height if the node is Black *)
          left_bh + (if c = Black then 1 else 0)
  in
  let rec no_red_with_red_child = function
    | Nil -> true
    | Node (color, left, _, right) ->
      match color with
      | Red ->
          (match left, right with
           | Node (Red, _, _, _), _ | _, Node (Red, _, _, _) -> false
           | _ -> no_red_with_red_child left && no_red_with_red_child right)
      | Black ->
          no_red_with_red_child left && no_red_with_red_child right
  in
  (black_height tree > 0) && no_red_with_red_child tree

(* Helper function to format a node's display *)
let format_node color value =
  match color with
  | Red -> Printf.sprintf "R - %d" value
  | Black -> Printf.sprintf "B - %d" value

(* Helper to print spaces for indentation *)
let print_spaces n =
  for _ = 1 to n do
    print_string " "
  done

(* Recursive helper to print the tree with indentation *)
let rec print_tree_with_indent tree indent =
  match tree with
  | Nil ->
      print_spaces indent;
      print_endline "Nil"
  | Node (color, left, value, right) ->
      (* Print right subtree first for a sideways view *)
      print_tree_with_indent right (indent + 4);
      (* Print current node with its color and value *)
      print_spaces indent;
      Printf.printf "%s\n" (format_node color value);
      (* Print left subtree *)
      print_tree_with_indent left (indent + 4)

(* Main function to print the entire tree *)
let print_tree tree =
  print_endline "Red-Black Tree Structure:";
  print_tree_with_indent tree 0

(* Test cases for Red-Black Tree *)

(* Helper function to insert a list of values into a Red-Black Tree *)
let insert_all tree values =
  List.fold_left insert tree values

(* Helper function to print a tree and a separator line *)
let print_and_separator tree =
  print_tree tree;
  Printf.printf "Is valid RBT: %b\n" (is_valid tree);
  print_endline "---------------------------------------"

(* Test 1: Inserting values in ascending order *)
let test_ascending_order () =
  let tree = insert_all Nil [10; 20; 30; 40; 50] in
  print_endline "Test 1: Inserting values in ascending order";
  print_and_separator tree

(* Test 2: Inserting values in descending order *)
let test_descending_order () =
  let tree = insert_all Nil [50; 40; 30; 20; 10] in
  print_endline "Test 2: Inserting values in descending order";
  print_and_separator tree

(* Test 3: Inserting a balanced sequence of values *)
let test_balanced_sequence () =
  let tree = insert_all Nil [30; 15; 45; 10; 20; 40; 50] in
  print_endline "Test 3: Inserting a balanced sequence of values";
  print_and_separator tree

(* Test 4: Inserting values that require left rotation *)
let test_left_rotation () =
  let tree = insert_all Nil [10; 15; 20] in
  print_endline "Test 4: Inserting values that require left rotation";
  print_and_separator tree

(* Test 5: Inserting values that require right rotation *)
let test_right_rotation () =
  let tree = insert_all Nil [20; 15; 10] in
  print_endline "Test 5: Inserting values that require right rotation";
  print_and_separator tree

(* Test 6: Inserting a value that is already in the tree *)
let test_inserting_duplicate () =
  let tree = insert_all Nil [10; 20; 15; 20] in
  print_endline "Test 6: Inserting a duplicate value (20)";
  print_and_separator tree

(* Test 7: Complex sequence of inserts that requires multiple rotations *)
let test_complex_inserts () =
  let tree = insert_all Nil [50; 20; 60; 10; 30; 70; 25; 5; 15] in
  print_endline "Test 7: Complex sequence of inserts";
  print_and_separator tree

(* Test 8: Inserting a single element *)
let test_single_insert () =
  let tree = insert Nil 42 in
  print_endline "Test 8: Inserting a single element (42)";
  print_and_separator tree

(* Test 9: Inserting values to create a tree of height 3 *)
let test_height_3_tree () =
  let tree = insert_all Nil [20; 10; 30; 5; 15; 25; 35] in
  print_endline "Test 9: Creating a tree of height 3";
  print_and_separator tree

(* Test 10: Inserting a sequence that requires rebalancing *)
let test_root_color_change () =
  let tree = insert_all Nil [10; 20; 15] in
  print_endline "Test 10: Inserting values that cause root recoloring";
  print_and_separator tree

(* Test 11: Deleting a value from the tree *)
(* let test_delete_value () =
  let tree = insert_all Nil [10; 5; 1; 20; 30] in
  print_endline "Test 11: Deleting a value (5) from the tree";
  let tree_after_deletion = delete tree 5 in
  print_and_separator tree_after_deletion *)

(* Run all tests *)
let run_tests () =
  test_ascending_order ();
  test_descending_order ();
  test_balanced_sequence ();
  test_left_rotation ();
  test_right_rotation ();
  test_inserting_duplicate ();
  test_complex_inserts ();
  test_single_insert ();
  test_height_3_tree ();
  test_root_color_change ();;
  (* test_delete_value ();; *)

(* Execute the tests *)
run_tests ()