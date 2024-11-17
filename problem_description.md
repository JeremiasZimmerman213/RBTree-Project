# Implementing Red-Black Trees in OCaml

## Introduction

Red-Black Trees are a type of self-balancing binary search tree (BST) that maintain balance through strict properties, ensuring efficient operations with a worst-case time complexity of O(log n). They are widely used in functional programming due to their efficient and elegant balancing algorithms.

In this assignment, you will implement a functional Red-Black Tree in OCaml. Your tasks include implementing insertion and deletion operations that preserve the tree's properties, as well as a validation function to ensure the tree remains balanced after modifications.

## Red-Black Tree Properties

A Red-Black Tree is a BST where each node has an additional attribute: a color, either red or black. The tree must satisfy the following properties:

1. **Every node is either red or black.**
2. **The root is black.**
3. **All leaves (Nil nodes) are black.**
4. **Red nodes cannot have red children.** (No two red nodes appear consecutively on any path.)
5. **Every path from a node to its descendant leaves contains the same number of black nodes.** (This is known as the black-height.)

These properties ensure the tree remains approximately balanced, keeping operations efficient.

## Assignment Tasks

### 1. Data Type Definitions

Begin by defining the necessary data types for colors and the Red-Black Tree nodes:

```ocaml
type color = Red | Black

type 'a rb_tree =
  | Nil
  | Node of color * 'a * 'a rb_tree * 'a rb_tree
```

- **`color`**: Represents the color of a node, either `Red` or `Black`.
- **`'a rb_tree`**: A polymorphic tree that can store values of any type `'a`.

### 2. Insertion Function

Implement an insertion function that adds a new element to the tree while maintaining Red-Black properties.

- **Function Signature**:

  ```ocaml
  val insert : 'a rb_tree -> 'a -> 'a rb_tree
  ```

- **Requirements**:
  - Insert the new node as in a standard BST, coloring it red.
  - After insertion, rebalance the tree using a helper function `balance` to fix any violations.
  - Ensure the root is black after insertion.

- **Balancing Cases**:
  The `balance` function should handle four specific cases where a red node has a red child, causing a violation of property 4. These cases involve different configurations of red and black nodes and require rotations and recoloring to fix.

- **Hints**:
  - Use pattern matching in the `balance` function to identify and correct these cases.
  - Remember that after rebalancing, the tree might still violate the properties higher up, so ensure that balancing is applied recursively as needed.

### 3. Deletion Function

Implement a deletion function that removes an element from the tree while maintaining Red-Black properties.

- **Function Signature**:

  ```ocaml
  val delete : 'a rb_tree -> 'a -> 'a rb_tree
  ```

- **Requirements**:
  - Locate the node to delete using standard BST traversal.
  - Handle cases where the node has zero, one, or two children.
  - After deletion, rebalance the tree using a helper function `balance_delete` to fix any violations.
  - Address "double black" situations that may arise when deleting black nodes.

- **Balancing Considerations**:
  - When a black node is deleted, it may cause an imbalance in black heights across paths, violating property 5.
  - The `balance_delete` function should perform rotations and recoloring to redistribute black heights and restore tree properties.

- **Hints**:
  - Implement a helper function `min_value_node` to find the in-order successor when deleting nodes with two children.
  - Carefully manage the colors during rebalancing to ensure all properties are maintained.

### 4. Validity Checking Function

Implement a function to verify that a given tree satisfies all Red-Black Tree properties.

- **Function Signature**:

  ```ocaml
  val is_valid : 'a rb_tree -> bool
  ```

- **Validation Steps**:
  - **Black-Height Consistency**: Ensure that all paths from the root to leaves have the same number of black nodes.
  - **No Consecutive Red Nodes**: Check that no red node has a red child.

- **Hints**:
  - Use recursive functions:
    - `black_height` to compute and verify the black height of subtrees.
    - `no_red_with_red_child` to traverse the tree and check for consecutive red nodes.
  - Return appropriate values when violations are detected to short-circuit further unnecessary computations.

### 5. Testing and Demonstration

- **Testing**:
  - Write test cases that cover various scenarios, including:
    - Inserting elements in ascending, descending, and random orders.
    - Deleting nodes with zero, one, or two children.
    - Validating the tree after each operation using your `is_valid` function.
  - Ensure that your tests demonstrate the correctness and robustness of your implementation.

- **Optional**:
  - Implement a function to visually print the tree structure, aiding in debugging and demonstration.
  - Include comments or explanations in your code to clarify complex parts of your implementation.

## Submission Requirements

- **Code Files**:
  - Provide all OCaml source code files containing your implementation.
  - Ensure your code is well-organized, properly indented, and includes comments where necessary.

- **Problem Description Document**:
  - Submit a 1 to 1.5-page PDF document (this document) explaining the problem and summarizing your approach.
  - Highlight any important algorithms, data structures, or design decisions.

- **Video Explanation**:
  - Create a 10-minute video summarizing the problem and the key ideas of your solution.
  - Explain how your implementation maintains the Red-Black Tree properties during insertion and deletion.

## Grading Criteria

Your project will be evaluated based on the following:

- **Correctness**: Functions correctly implement insertion, deletion, and validation while preserving Red-Black properties.
- **Algorithm Design**: Efficient use of algorithms and data structures, and appropriate handling of edge cases.
- **Understanding**: Clear demonstration of understanding Red-Black Trees and their balancing mechanisms.
- **Code Quality**: Readability, organization, commenting, and adherence to good programming practices.
- **Testing**: Comprehensive test cases that effectively demonstrate the correctness of your implementation.
- **Communication**: Clarity and depth of explanations in both the written document and the video presentation.
- **Complexity and Ambition**: The level of challenge in your implementation and any additional features or optimizations.

## Additional Resources

- **"Purely Functional Data Structures" by Chris Okasaki**: A foundational text that provides insight into functional data structures, including Red-Black Trees.
- **Red-Black Trees on Wikipedia**: [https://en.wikipedia.org/wiki/Red–black_tree](https://en.wikipedia.org/wiki/Red–black_tree)
- **OCaml Documentation**: Official documentation for OCaml can assist with language-specific questions.

---

**Note**: Be sure to test your code thoroughly and ensure that all Red-Black Tree properties are maintained after each operation. Good luck with your implementation!
