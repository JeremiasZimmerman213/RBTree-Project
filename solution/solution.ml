(* color for nodes *)
type color = Red | Black

(* type for tree node *)
type 'a rb_tree =
  | Nil
  | Node of color * 'a rb_tree * 'a * 'a rb_tree

(* helper function to create node *)
let make_node color left value right =
  Node (color, left, value, right)

(* helper function to balance a tree after insertion *)
let balance = function
  (* Case 1: Red on left-left grandchild *)
  | Black, Node (Red, a, x, Node (Red, b, y, c)), z, d

  (* Case 2: Red on right-left grandchild *)
  | Black, Node (Red, Node (Red, a, x, b), y, c), z, d

  (* Case 3: Red on left-right grandchild *)
  | Black, a, x, Node (Red, Node (Red, b, y, c), z, d)

  (* Case 4: Red on right-right grandchild *)
  | Black, a, x, Node (Red, b, y, Node (Red, c, z, d)) ->
      Node (Red, make_node Black a x b, y, make_node Black c z d)

  (* Tree is already balanced; no changes needed *)
  | c, l, v, r ->
      Node (c, l, v, r)

(* insert function *)
let rec insert tree value =
  let rec insert_aux = function
    | Nil -> Node (Red, Nil, value, Nil)
    | Node (color, left, y, right) as node ->
        if value < y then balance (color, insert_aux left, y, right)
        else if value > y then balance (color, left, y, insert_aux right)
        else node
  in
  match insert_aux tree with
  | Node (_, left, y, right) -> Node (Black, left, y, right)
  | Nil -> Nil  (* this will never happen *)

(* tail-recursive insert *)
let insert_tr tree value =
  let rec insert_aux path = function
    | Nil ->
        List.fold_left (fun acc (color, y, left_or_right) ->
          match left_or_right with
          | `Left -> balance (color, acc, y, Nil)
          | `Right -> balance (color, Nil, y, acc)
        ) (Node (Red, Nil, value, Nil)) path
    | Node (color, left, y, right) as node ->
        if value < y then
          insert_aux ((color, y, `Left) :: path) left
        else if value > y then
          insert_aux ((color, y, `Right) :: path) right
        else
          node
  in
  match insert_aux [] tree with
  | Node (_, left, y, right) -> Node (Black, left, y, right)  (* make root black *)
  | Nil -> Nil  (* this will never happen *)

(* helper function to recolor nodes, used in deletion *)
let recolor = function
  | Node (_, l, x, r) -> Node (Black, l, x, r)
  | Nil -> Nil

(* balace function for deletion *)
let rec balance_delete = function
  | Black, Node (Red, a, x, b), y, Node (Black, c, z, d) ->
      Node (Red, make_node Black a x b, y, make_node Black c z d)
  | Black, Node (Black, a, x, b), y, Node (Red, c, z, d) ->
      Node (Red, make_node Black a x b, y, make_node Black c z d)
  | color, left, x, right ->
      Node (color, left, x, right)

(* delete node from tree *)
let rec delete tree value =
  let rec delete_aux = function
    | Nil -> Nil
    | Node (color, left, y, right) as node ->
        if value < y then balance_delete (color, delete_aux left, y, right)
        else if value > y then balance_delete (color, left, y, delete_aux right)
        else (* Found node to delete *)
          match left, right with
          | Nil, _ -> recolor right
          | _, Nil -> recolor left
          | _ ->
              let rec min_value_node = function
                | Node (_, Nil, x, _) -> x
                | Node (_, left, _, _) -> min_value_node left
                | Nil -> failwith "Tree invariant broken"
              in
              let min_right = min_value_node right in
              balance_delete (color, left, min_right, delete_aux right)
  in
  match delete_aux tree with
  | Node (_, left, y, right) -> Node (Black, left, y, right)
  | Nil -> Nil  (* this will never happen *)

(* check for validity *)
let rec is_valid = function
  | Nil -> true
  | Node (color, left, _, right) ->
      let check_red_children = match color with
        | Red -> (match left, right with
                  | Node (Red, _, _, _), _ | _, Node (Red, _, _, _) -> false
                  | _ -> true)
        | Black -> true
      in
      check_red_children && is_valid left && is_valid right

(* Helper function to create a node *)
let make_node color left value right =
  Node (color, left, value, right)

(* Helper function to format a node *)
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
      (* Print right subtree first for sideways view *)
      print_tree_with_indent right (indent + 6);
      
      (* Print current node with its color and value *)
      print_spaces indent;
      Printf.printf "%s\n" (format_node color value);
      
      (* Print left subtree *)
      print_tree_with_indent left (indent + 6)

(* Main function to print the entire tree *)
let print_tree tree =
  print_endline "Red-Black Tree Structure:";
  print_tree_with_indent tree 0) ->
      (* Print right subtree first (sideways representation) *)
      print_tree_with_indent right (indent + 6); (* Increase indentation for better separation *)
      
      (* Print current node with color and value *)
      print_spaces indent;
      Printf.printf "%s\n" (format_node color value);
      
      (* Print left subtree *)
      print_tree_with_indent left (indent + 6)

(* Main function to print the Red-Black Tree *)
let print_tree tree =
  print_endline "Tree:";
  print_tree_with_indent tree 0
