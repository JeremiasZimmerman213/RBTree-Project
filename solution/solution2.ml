(* define the colours red and black to be used in tree data type *)
type color = Red | Black

(* define the recursive data type for a tree *)
(* either Nil (Leaf) or a recursvie Node with a colour, a value, a left sub tree and right sub tree*)
type 'a rbtree = 
  | Nil 
  | Node of color * 'a * 'a rbtree * 'a rbtree


(* balance helper function needed to Okasaki's insert algorithm *)
let balance = function
  | Black, z, Node (Red, y, Node (Red, x, a, b), c), d
  | Black, z, Node (Red, x, a, Node (Red, y, b, c)), d
  | Black, x, a, Node (Red, z, Node (Red, y, b, c), d)
  | Black, x, a, Node (Red, y, b, Node (Red, z, c, d)) ->
    Node (Red, y, Node (Black, x, a, b), Node (Black, z, c, d))
  | a, b, c, d -> Node (a, b, c, d)

  let insert x s =
    let rec ins = function
      | Nil -> Node (Red, x, Nil, Nil)
      | Node (color, y, a, b) as s ->
        if x < y then balance (color, y, ins a, b)
        else if x > y then balance (color, y, a, ins b)
        else s
    in
    match ins s with
    | Node (_, y, a, b) -> Node (Black, y, a, b)
    | Nil -> failwith "failed"