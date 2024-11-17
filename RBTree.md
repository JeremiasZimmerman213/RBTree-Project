# **Red-Black Trees**

Pre-requisite Knowledge:
- Binary Search Trees
- Rotations (conceptual). The implementation of a rotation will have accompanying exmplanation in the instructions file.

A red-black tree is a variation on binary search trees (BSTs). The variations ensures that the BST stays balanced, avoiding a worst-case BST where all the nodes get added to one side. Since the tree is balanced, the height of the tree becomes O(lg n), where n represents the number of nodes. Operations on RB-trees take O(lg n) time in worst case.

The variation that allows the BST to be balanced comes from adding an additional bit of info to each node in the tree: an attribute colour (red or black). The rest of the BST properties remain (node value, left node, right node, parent...). 

There are 5 properties that need to be satisfied in order to have an RB-tree:
1. Every node must be one of red or black (i.e. each node needs to have the attribute colour.)
2. The root of the tree is black.
3. All the leaves (called Nil) are black.
4. If a node is red, its children must be black. Therefore there can't be consecutive red nodes.
5. For each node, all paths from the node to its descendant leaves have the same number of black nodes.


The black height of a node is defined as the number of black nodes (including a leaf) on the path from the node to a descendant leaf.

The operations we would want to perform on an RB-tree are similar to those of a regular BST: insert & delete. We also want a method that will check if a tree is a valid RB-tree. 

### **Insertion:**
Inserting a node into an RB-tree should not break the RB-trees properties. In non-functional programming, this is the procedure for implementing insertion in RB-trees:
1. Use regular BST insert to a node, x, into RB-tree, T.
2. Colour x red.
3. Use re-colouring and rotations to restore the RB-tree properties.

However, in functional programming, we follow the same first 2 steps, but the third step is different. Okasaki's algorithm is an elegant solution for the insertion and balancing of a node into a red-black tree. Since we are inserting a red node, then there are some possible conflicts, and, some impossible conflicts, of the 5 properties. For instance, it is impossible for a node to have no colour, it is impossible for the black-height of any node to change, since we are adding a red node, and the leaves will always be black. However, if we inserted the root, then now the root is red, and needs to be black. If we did not insert the root, then it is possible we inserted a red node as the childe of another red node. So, this is the procedure to fix the tree properties:
1. If the parent of the inserted node is black, then we are done with insertion.
2. If the parent of the inserted node is red, then we must fix the tree. Note that it is impossible for the parent node to be the root, because the root is black, and thus we can say that the inserted node has a grandparent. Then, there are 4 cases that can arise:

```txt
           1             2             3             4

           Bz            Bz            Bx            Bx
          / \           / \           / \           / \
         Ry  d         Rx  d         a   Rz        a   Ry
        /  \          / \               /  \          /  \
     [Rx]  c         a  [Ry]          [Ry]  d        b   [Rz]
     /  \               /  \          / \                /  \
    a    b             b    c        b   c              c    d
```

In the above cases, the notation Bz indicated that there is a node z that is blac, the capital R indicates a red node, and then a, b, c, and d are all subtrees, possibly empty, meaning we do not care about the specific nodes in them. The nodes marked with [] indicate that they are the node that violates the RB-tree property. By performing one rotation on one of the above cases, we are left with a section of the tree that no longer violates the properties, as seen below. However, it is possible that we simply moved the problem up, and we will need to balance once more.

```txt
         Ry
        /  \
      Bx    Bz
     / \   / \
    a   b c   d
```




There are only 2 possible conflicts when inserting a new node and colouring it red: either it's parent is red (and we thus have consecutive red nodes, violating property 4), or we inserted the root (thus violating property 2). To fix the property, let a be the new node we just inserted, and let b be its uncle (i.e. b is the sibling of a's parent). Then, until the conflict is solved:
1. Case 1: b is red. In this case, we recolour the nodes, which brings the conflict two levels up. We change the colour of a's parent, b, and a's parent's parent. Then, a's parent's parent becomes the new a, and b becomes the new a's uncle.
2. Case 2: b is black & the conflict is not "aligned" with the grand parents (see image below). In this case, we make a rotation at the parent of a to align the nodes and we move to case 3.

![alt text](case2.png "Case 2")

3. Case 3: b is black & the conflict is "aligned" (see image below). In this case, we re-colour a's parent and grand-parent, and we make a rotation at the grand-parent to fix the conflict.

![alt text](case3.png "Case 3")

More in depth implementation explanation is given in instructions.md. 

### **Deletion:**



### **Check Validity:**
