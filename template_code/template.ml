(* Prelude *)
exception NotImplemented

(* Colours used for nodes in the Red-Black Tree *)
type color = Red | Black

(* Red-Black Tree node  type*)
type 'a rb_tree =
| Empty
| Node of color * 'a rb_tree * 'a * 'a rb_tree (* colour, left sub tree, node itself, right sub-tree*)

(* Functions *)

(* Helper Functions *)

(* TODO: Implement helper function left_rotate *)
let left_rotate (tree: 'a rb_tree) (node: 'a): 'a rb_tree =
    raise NotImplemented
    
(* TODO: Implement helper function left_rotate *)
let right_rotate (tree: 'a rb_tree) (node: 'a): 'a rb_tree =
    raise NotImplemented

(* TODO: Implement helper function insert-fixup *)
let insert_fixup (tree: 'a rb_tree) (node: 'a): 'a rb_tree =
    raise NotImplemented

(* TODO: Imp    lement insert *)
let insert (tree: 'a rb_tree) (value: 'a): 'a rb_tree =
    raise NotImplemented

(* TODO: Implement delete *)
let delete (tree: 'a rb_tree) (value: 'a): 'a rb_tree =
    raise NotImplemented

(* TODO: Implement is_valid *)
let is_valid (tree: 'a rb_tree): bool =
    raise NotImplemented