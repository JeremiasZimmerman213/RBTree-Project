(* define the colours red and black to be used in tree data type *)
type color = Red | Black

(* define the recursive data type for a tree *)
(* either Nil (Leaf) or a recursvie Node with a colour, a value, a left sub tree and right sub tree*)
type 'a rb_tree = 
  | Nil 
  | Node of color * 'a * 'a rb_tree * 'a rb_tree


(* balance helper function needed to Okasaki's insert algorithm *)
let balance (color, a, left, right) = match color, a, left, right with
  (* case 1 *)
  | Black, z, Node (Red, y, Node (Red, x, a, b), c), d
  (* case 2 *)
  | Black, z, Node (Red, x, a, Node (Red, y, b, c)), d
  (* case 3 *)
  | Black, x, a, Node (Red, z, Node (Red, y, b, c), d)
  (* case 4 *)
  | Black, x, a, Node (Red, y, b, Node (Red, z, c, d)) ->
    Node (Red, y, Node (Black, x, a, b), Node (Black, z, c, d))
  | a, b, c, d -> Node (a, b, c, d)


let insert s x =
  let rec insert_aux = function
    | Nil -> Node (Red, x, Nil, Nil)
    | Node (color, y, a, b) as s ->
      if x < y then balance (color, y, insert_aux a, b)
      else if x > y then balance (color, y, a, insert_aux b)
      else s
  in
  match insert_aux s with
  | Node (_, y, a, b) -> Node (Black, y, a, b)
  | Nil -> failwith "failed"


let insert_tr s x =
  let rec insert_aux path = function
    | Nil ->
        let new_node = Node (Red, x, Nil, Nil) in
        List.fold_left
          (fun acc (color, value, direction) ->
              match direction with
              | `Left -> balance (color, value, acc, Nil)
              | `Right -> balance (color, value, Nil, acc))
          new_node path
    | Node (color, y, left, right) as node ->
        if x < y then insert_aux ((color, y, `Left) :: path) left
        else if x > y then insert_aux ((color, y, `Right) :: path) right
        else
          List.fold_left
            (fun acc (color, value, direction) ->
                match direction with
                | `Left -> balance (color, value, acc, Nil)
                | `Right -> balance (color, value, Nil, acc))
            node path
  in
  match insert_aux [] s with
  | Node (_, value, left, right) -> Node (Black, value, left, right)
  | Nil -> failwith "failed"