# Red-Black Tree Implementation Instructions

## 0. Helper

## `make_node`

### Description
The `make_node` function creates a new node in the red-black tree with a specified color, left subtree, value, and right subtree.

### Instructions
1. Use the `Node` constructor with the parameters `color`, `left`, `value`, and `right`.
2. Return the constructed node.

---

## 1. Insertion of nodes

## `balance`

### Description
The `balance` function ensures the red-black tree properties are maintained after an insertion. If an insertion disrupts the properties (such as consecutive red nodes), this function restructures the tree to restore balance.

### Instructions
1. Write pattern matches to identify cases that require balancing:
   - Identify cases where two consecutive `Red` nodes occur on the path.
   - Restructure these patterns to satisfy red-black properties using rotation and color changes.
2. In the `balance` function body, use the `make_node` helper to create balanced subtrees.
3. For cases where balancing is not required, simply return the original node structure.

---

## `insert`

### Description
The `insert` function adds a new value into the red-black tree. If the value already exists, no insertion is performed. After inserting, the tree is balanced and the root node is set to `Black`.

### Pseudocode
1. Define a helper function `insert_aux`:
   - If `Empty`, insert a new `Red` node with the value.
   - If `Node(color, left, y, right)`:
     - Traverse left or right based on `value` vs. `y`.
     - Recur with the `balance` function applied.
2. Call `insert_aux` on the initial tree.
3. Ensure the root node is recolored to `Black`.

### Instructions
1. Implement the `insert_aux` helper function with recursive calls.
2. Use `balance` to adjust the subtree structure if necessary.
3. After calling `insert_aux`, recolor the root to `Black` before returning.

---

## `insert_tr` (Tail-Recursive Insert)

### Description
The `insert_tr` function is a tail-recursive version of `insert`. It should also ensure the tree is balanced after inserting the value, and the root should be recolored to `Black`.

### Instructions
1. Define `insert_aux` to use an accumulator for holding the path as you traverse.
2. After reaching the insertion point, reconstruct the tree using `balance` on the accumulated path back to the root.
3. Ensure the root is recolored to `Black`.

---

## 2. Deletion of nodes

## `recolor`

### Description
The `recolor` function adjusts the color of a node to black, which is useful in the deletion process to maintain the red-black properties when a subtree is removed.

### Instructions
1. Use pattern matching to check if the node is `Empty` or a `Node`.
2. If it’s a `Node`, return a new node with the same structure, but with its color changed to `Black`.
3. If it’s `Empty`, return `Empty`.

---

## `balance_delete`

### Description
The `balance_delete` function restores red-black tree balance after a deletion operation. This function handles cases where the removal of a node causes an imbalance in the black-height property.

### Instructions
1. Write pattern matches to identify imbalance scenarios after deletion:
   - Identify cases where one child is `Red` and the other is `Black`, or vice versa.
   - Adjust the subtree structures to maintain the red-black properties, using rotations and color changes as needed.
2. For each balancing case, use `make_node` to reconstruct balanced subtrees.
3. Return the final balanced tree structure.

---

## `delete`

### Description
The `delete` function removes a specified value from the red-black tree. After deletion, it re-balances the tree and recolors the root to `Black` if necessary.

### Pseudocode
1. Define a helper function `delete_aux`:
   - If `Empty`, return `Empty`.
   - If `Node(color, left, y, right)`:
     - Traverse left or right based on `value` vs. `y`.
     - If `y = value`:
       - Handle cases where `left` or `right` is `Empty`.
       - For two non-empty children, find the minimum value in the right subtree and replace `y` with it.
       - Rebalance using `balance_delete`.
2. Call `delete_aux` on the initial tree.
3. Ensure the root node is recolored to `Black`.

### Instructions
1. Implement the `delete_aux` helper function using pattern matching for each case.
2. Use `balance_delete` to adjust the subtree if the removal causes an imbalance.
3. Ensure the root node is recolored to `Black` before returning.

---

## 3. Validity of tree

## `is_valid`

### Description
The `is_valid` function verifies whether the red-black tree maintains the properties of a red-black tree:
1. Root node is black.
2. No two consecutive red nodes.
3. Every path from root to leaves has the same black height.

### Instructions
1. Write a recursive function that:
   - Checks that no two consecutive nodes are `Red`.
   - Verifies that the number of `Black` nodes is consistent across all paths.
2. Return `true` if the tree satisfies all properties, otherwise `false`.