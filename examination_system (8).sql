-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 08, 2026 at 02:33 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `examination_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `admin_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`admin_id`) VALUES
(167);

-- --------------------------------------------------------

--
-- Stand-in structure for view `admin_details`
-- (See below for the actual view)
--
CREATE TABLE `admin_details` (
`admin_id` int(11)
,`admin_name` varchar(100)
,`email` varchar(100)
,`password` varchar(100)
);

-- --------------------------------------------------------

--
-- Table structure for table `attempt`
--

CREATE TABLE `attempt` (
  `attempt_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `quiz_id` int(11) NOT NULL,
  `score` int(11) DEFAULT NULL CHECK (`score` >= 0),
  `attempt_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `attempt`
--

INSERT INTO `attempt` (`attempt_id`, `student_id`, `quiz_id`, `score`, `attempt_date`) VALUES
(1, 26, 1, 4, '2026-01-16 22:36:42'),
(2, 14, 1, 1, '2026-01-16 23:25:47'),
(4, 8, 1, 1, '2026-01-16 23:32:37'),
(5, 10, 1, 3, '2026-01-16 23:43:26'),
(6, 26, 3, 1, '2026-02-06 22:00:03'),
(7, 28, 1, 1, '2026-02-06 22:06:54'),
(9, 28, 3, 5, '2026-02-06 22:07:39'),
(11, 478, 1, 5, '2026-02-07 20:42:01'),
(12, 127, 6, 1, '2026-02-08 13:45:56');

-- --------------------------------------------------------

--
-- Table structure for table `questionbank`
--

CREATE TABLE `questionbank` (
  `question_id` int(11) NOT NULL,
  `question_text` text NOT NULL,
  `option_a` varchar(100) NOT NULL,
  `option_b` varchar(100) NOT NULL,
  `option_c` varchar(100) NOT NULL,
  `option_d` varchar(100) NOT NULL,
  `correct_option` char(1) NOT NULL CHECK (`correct_option` in ('A','B','C','D')),
  `marks` int(11) NOT NULL CHECK (`marks` > 0),
  `subject_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `questionbank`
--

INSERT INTO `questionbank` (`question_id`, `question_text`, `option_a`, `option_b`, `option_c`, `option_d`, `correct_option`, `marks`, `subject_id`) VALUES
(1, 'Which data structure uses FIFO principle?', 'Stack', 'Queue', 'Tree', 'Graph', 'B', 1, 1),
(2, 'Time complexity of binary search on a sorted array?', 'O(n)', 'O(log n)', 'O(n log n)', 'O(1)', 'B', 1, 1),
(3, 'Which data structure is used for recursion?', 'Queue', 'Stack', 'Linked List', 'Hash Table', 'B', 1, 1),
(4, 'Height of a balanced binary tree with n nodes?', 'n', 'log n', 'n/2', 'sqrt(n)', 'B', 1, 1),
(5, 'Which sorting algorithm is stable?', 'Quick Sort', 'Heap Sort', 'Merge Sort', 'Selection Sort', 'C', 1, 1),
(6, 'In a max-heap, maximum element is at?', 'Leaf Node', 'Root Node', 'Any Node', 'Middle Level', 'B', 1, 1),
(7, 'Best data structure for implementing priority queue?', 'Array', 'Linked List', 'Heap', 'Stack', 'C', 1, 1),
(8, 'Worst-case insertion in hash table with chaining?', 'O(1)', 'O(n)', 'O(log n)', 'O(n log n)', 'B', 1, 1),
(9, 'Which graph traversal uses a queue?', 'DFS', 'BFS', 'Dijkstra', 'Prim', 'B', 1, 1),
(10, 'Which is NOT a linear data structure?', 'Array', 'Stack', 'Queue', 'Binary Tree', 'D', 1, 1),
(11, 'Time complexity of searching in a balanced BST?', 'O(n)', 'O(log n)', 'O(1)', 'O(n log n)', 'B', 1, 1),
(12, 'Which data structure can implement undo in software?', 'Queue', 'Stack', 'Graph', 'Tree', 'B', 1, 1),
(13, 'Which is best for adjacency representation of sparse graph?', 'Matrix', 'List', 'Tree', 'Heap', 'B', 1, 1),
(14, 'Worst-case time complexity of quicksort?', 'O(n)', 'O(n log n)', 'O(log n)', 'O(n^2)', 'D', 1, 1),
(15, 'Which data structure supports LRU cache?', 'Queue', 'Stack', 'Deque', 'Heap', 'C', 1, 1),
(16, 'Circular queue avoids?', 'Overflow', 'Underflow', 'Waste of memory', 'All of the above', 'C', 1, 1),
(17, 'Which tree has every level filled except possibly last?', 'Complete Binary Tree', 'Full Binary Tree', 'AVL Tree', 'BST', 'A', 1, 1),
(18, 'Which is a self-balancing binary search tree?', 'AVL Tree', 'BST', 'Binary Heap', 'Graph', 'A', 1, 1),
(19, 'Which algorithm finds shortest path in weighted graph?', 'DFS', 'BFS', 'Dijkstra', 'Prim', 'C', 1, 1),
(20, 'What is the purpose of hashing?', 'Searching', 'Sorting', 'Storing key-value pairs', 'Traversal', 'C', 1, 1),
(21, 'Which data structure is ideal for expression evaluation?', 'Stack', 'Queue', 'Linked List', 'Heap', 'A', 1, 1),
(22, 'Which traversal visits root, left, right?', 'Inorder', 'Preorder', 'Postorder', 'Level-order', 'B', 1, 1),
(23, 'Which traversal visits left, right, root?', 'Inorder', 'Preorder', 'Postorder', 'Level-order', 'C', 1, 1),
(24, 'Which traversal visits left, root, right?', 'Inorder', 'Preorder', 'Postorder', 'Level-order', 'A', 1, 1),
(25, 'In BFS, which data structure is used?', 'Stack', 'Queue', 'Linked List', 'Heap', 'B', 1, 1),
(26, 'In DFS, which data structure is used?', 'Stack', 'Queue', 'Linked List', 'Heap', 'A', 1, 1),
(27, 'Time complexity to insert in a linked list at beginning?', 'O(1)', 'O(n)', 'O(log n)', 'O(n log n)', 'A', 1, 1),
(28, 'Time complexity to delete in a singly linked list?', 'O(1)', 'O(n)', 'O(log n)', 'O(n log n)', 'B', 1, 1),
(29, 'Which algorithm is used for minimum spanning tree?', 'Dijkstra', 'Prim', 'KMP', 'Bellman-Ford', 'B', 1, 1),
(30, 'Kruskal’s algorithm uses which data structure?', 'Stack', 'Queue', 'Disjoint Set', 'Linked List', 'C', 1, 1),
(31, 'Which algorithm detects cycles in graph?', 'DFS', 'BFS', 'Both', 'Dijkstra', 'C', 1, 1),
(32, 'Time complexity of insertion sort best case?', 'O(n^2)', 'O(n log n)', 'O(n)', 'O(log n)', 'C', 1, 1),
(33, 'Time complexity of bubble sort worst case?', 'O(n)', 'O(n^2)', 'O(n log n)', 'O(log n)', 'B', 1, 1),
(34, 'Which data structure is used in BFS shortest path?', 'Queue', 'Stack', 'Heap', 'Linked List', 'A', 1, 1),
(35, 'Which data structure is used for priority tasks?', 'Queue', 'Stack', 'Priority Queue', 'Heap', 'C', 1, 1),
(36, 'Which is NOT a property of AVL tree?', 'Balance factor ≤ 1', 'Self-balancing', 'Binary Search Tree', 'Queue based', 'D', 1, 1),
(37, 'Which heap allows minimum element at root?', 'Max Heap', 'Min Heap', 'Binary Search Tree', 'AVL Tree', 'B', 1, 1),
(38, 'Which search is better for linked list?', 'Binary Search', 'Linear Search', 'Interpolation Search', 'Exponential Search', 'B', 1, 1),
(39, 'Time complexity of hash table search best case?', 'O(n)', 'O(log n)', 'O(1)', 'O(n log n)', 'C', 1, 1),
(40, 'Which is NOT linear search improvement?', 'Sentinel', 'Binary Search', 'Transposition', 'Move to Front', 'B', 1, 1),
(41, 'What is the worst case of quicksort?', 'O(n)', 'O(n log n)', 'O(n^2)', 'O(log n)', 'C', 1, 1),
(42, 'What is the best case of quicksort?', 'O(n)', 'O(n log n)', 'O(n^2)', 'O(log n)', 'B', 1, 1),
(43, 'Which algorithm is stable?', 'QuickSort', 'MergeSort', 'HeapSort', 'SelectionSort', 'B', 1, 1),
(44, 'Which algorithm is in-place?', 'MergeSort', 'HeapSort', 'BubbleSort', 'All', 'C', 1, 1),
(45, 'Which sort is best for nearly sorted data?', 'Insertion Sort', 'Selection Sort', 'Bubble Sort', 'QuickSort', 'A', 1, 1),
(46, 'Which algorithm finds shortest path?', 'DFS', 'BFS', 'Dijkstra', 'All', 'C', 1, 1),
(47, 'Which is NOT a graph representation?', 'Adjacency Matrix', 'Adjacency List', 'Edge List', 'Binary Tree', 'D', 1, 1),
(48, 'In adjacency matrix, memory complexity?', 'O(V)', 'O(E)', 'O(V+E)', 'O(V^2)', 'D', 1, 1),
(49, 'In adjacency list, memory complexity?', 'O(V)', 'O(E)', 'O(V+E)', 'O(V^2)', 'C', 1, 1),
(50, 'Which algorithm is used in topological sorting?', 'DFS', 'BFS', 'Dijkstra', 'Bellman-Ford', 'A', 1, 1),
(51, 'Cycle detection in directed graph?', 'DFS', 'BFS', 'Union-Find', 'All', 'A', 1, 1),
(52, 'Cycle detection in undirected graph?', 'DFS', 'BFS', 'Union-Find', 'All', 'C', 1, 1),
(53, 'Which data structure is used in recursion?', 'Stack', 'Queue', 'Linked List', 'Heap', 'A', 1, 1),
(54, 'Time complexity to search in BST worst case?', 'O(1)', 'O(n)', 'O(log n)', 'O(n log n)', 'B', 1, 1),
(55, 'Time complexity to search in AVL tree?', 'O(1)', 'O(n)', 'O(log n)', 'O(n log n)', 'C', 1, 1),
(56, 'Which sorting is not comparison-based?', 'Counting Sort', 'QuickSort', 'MergeSort', 'HeapSort', 'A', 1, 1),
(57, 'Which algorithm uses divide and conquer?', 'MergeSort', 'QuickSort', 'Binary Search', 'All', 'D', 1, 1),
(58, 'Time complexity to insert in BST average case?', 'O(n)', 'O(log n)', 'O(1)', 'O(n log n)', 'B', 1, 1),
(59, 'Which data structure is used in LRU cache?', 'Queue', 'Stack', 'HashMap + Doubly Linked List', 'Heap', 'C', 1, 1),
(60, 'Which algorithm is greedy?', 'Dijkstra', 'Prim', 'Kruskal', 'All', 'D', 1, 1),
(61, 'Which algorithm is used to find minimum spanning tree?', 'DFS', 'Kruskal', 'BFS', 'Binary Search', 'B', 1, 1),
(62, 'Which algorithm is also greedy for MST?', 'Prim', 'Dijkstra', 'Bellman-Ford', 'Floyd-Warshall', 'A', 1, 1),
(63, 'Time complexity of BFS?', 'O(V+E)', 'O(V^2)', 'O(E^2)', 'O(V)', 'A', 1, 1),
(64, 'Time complexity of DFS?', 'O(V+E)', 'O(V^2)', 'O(E^2)', 'O(V)', 'A', 1, 1),
(65, 'Which algorithm detects negative cycles?', 'DFS', 'BFS', 'Dijkstra', 'Bellman-Ford', 'D', 1, 1),
(66, 'Which is not a graph traversal algorithm?', 'DFS', 'BFS', 'Dijkstra', 'QuickSort', 'D', 1, 1),
(67, 'Which data structure for BFS?', 'Stack', 'Queue', 'Heap', 'Array', 'B', 1, 1),
(68, 'Which data structure for DFS?', 'Stack', 'Queue', 'Heap', 'Array', 'A', 1, 1),
(69, 'Time complexity of HeapSort?', 'O(n log n)', 'O(n^2)', 'O(n)', 'O(log n)', 'A', 1, 1),
(70, 'Time complexity of Insertion Sort worst case?', 'O(n^2)', 'O(n log n)', 'O(n)', 'O(log n)', 'A', 1, 1),
(71, 'Time complexity of Selection Sort?', 'O(n^2)', 'O(n log n)', 'O(n)', 'O(log n)', 'A', 1, 1),
(72, 'Which is better for large data?', 'MergeSort', 'BubbleSort', 'InsertionSort', 'SelectionSort', 'A', 1, 1),
(73, 'Which sorting is adaptive?', 'BubbleSort', 'SelectionSort', 'HeapSort', 'QuickSort', 'A', 1, 1),
(74, 'What is the height of a complete binary tree with n nodes?', 'n', 'log n', 'n-1', 'n+1', 'B', 1, 1),
(75, 'Max nodes in binary tree of height h?', '2^h -1', '2^h', 'h^2', '2h', 'A', 1, 1),
(76, 'AVL tree is?', 'Balanced BST', 'Unbalanced BST', 'Heap', 'Graph', 'A', 1, 1),
(77, 'Red-Black tree is?', 'Balanced BST', 'Unbalanced BST', 'Heap', 'Graph', 'A', 1, 1),
(78, 'Which is fastest searching for unsorted array?', 'Linear Search', 'Binary Search', 'Hash Table', 'Queue', 'C', 1, 1),
(79, 'Which structure stores key-value pairs?', 'Array', 'Linked List', 'Hash Table', 'Stack', 'C', 1, 1),
(80, 'What is complexity to search in hash table average?', 'O(1)', 'O(log n)', 'O(n)', 'O(n log n)', 'A', 1, 1),
(81, 'Which algorithm is used for shortest path in weighted graph?', 'DFS', 'BFS', 'Dijkstra', 'Prim', 'C', 1, 1),
(82, 'Which algorithm handles negative weights?', 'DFS', 'Bellman-Ford', 'Dijkstra', 'Prim', 'B', 1, 1),
(83, 'Time complexity of Dijkstra with min-heap?', 'O(V^2)', 'O(E + V log V)', 'O(E^2)', 'O(V)', 'B', 1, 1),
(84, 'Which algorithm is divide and conquer?', 'MergeSort', 'BubbleSort', 'Linear Search', 'DFS', 'A', 1, 1),
(85, 'Which sorting is in-place?', 'MergeSort', 'QuickSort', 'HeapSort', 'BubbleSort', 'C', 1, 1),
(86, 'Stable sorting algorithms?', 'QuickSort', 'HeapSort', 'BubbleSort', 'SelectionSort', 'C', 1, 1),
(87, 'Which is non-comparison sort?', 'MergeSort', 'Counting Sort', 'QuickSort', 'HeapSort', 'B', 1, 1),
(88, 'Time complexity of Counting Sort?', 'O(n)', 'O(n+k)', 'O(n^2)', 'O(log n)', 'B', 1, 1),
(89, 'Which is better for nearly sorted array?', 'InsertionSort', 'SelectionSort', 'HeapSort', 'QuickSort', 'A', 1, 1),
(90, 'Which data structure for LRU cache?', 'Stack', 'Queue', 'Hash + DLL', 'Array', 'C', 1, 1),
(91, 'Circular queue implementation uses?', 'Array', 'Stack', 'Linked List', 'Both A and C', 'D', 1, 1),
(92, 'Which structure is FIFO?', 'Stack', 'Queue', 'Heap', 'BST', 'B', 1, 1),
(93, 'Which structure is LIFO?', 'Stack', 'Queue', 'Heap', 'BST', 'A', 1, 1),
(94, 'Height of balanced BST?', 'log n', 'n', 'n/2', 'sqrt(n)', 'A', 1, 1),
(95, 'Binary Search requires?', 'Sorted array', 'Linked List', 'Queue', 'Heap', 'A', 1, 1),
(96, 'Which is self-adjusting BST?', 'AVL', 'Splay Tree', 'Red-Black', 'Heap', 'B', 1, 1),
(97, 'Which is used for priority scheduling?', 'Queue', 'Stack', 'Heap', 'Array', 'C', 1, 1),
(98, 'Which graph representation uses less space for sparse graphs?', 'Adjacency Matrix', 'Adjacency List', 'Edge List', 'Heap', 'B', 1, 1),
(99, 'DFS can be implemented using?', 'Queue', 'Stack', 'Heap', 'Array', 'B', 1, 1),
(100, 'BFS can be implemented using?', 'Stack', 'Queue', 'Heap', 'Array', 'B', 1, 1),
(101, 'Which traversal is used in expression tree evaluation?', 'Inorder', 'Preorder', 'Postorder', 'Level order', 'C', 1, 1),
(102, 'Which is a linear data structure?', 'Stack', 'BST', 'Graph', 'Heap', 'A', 1, 1),
(103, 'Which is a non-linear data structure?', 'Queue', 'Array', 'Graph', 'Stack', 'C', 1, 1),
(104, 'Time complexity of linear search?', 'O(1)', 'O(n)', 'O(log n)', 'O(n log n)', 'B', 1, 1),
(105, 'Time complexity of binary search?', 'O(n)', 'O(log n)', 'O(n log n)', 'O(1)', 'B', 1, 1),
(106, 'Which structure allows random access?', 'Array', 'Linked List', 'Queue', 'Stack', 'A', 1, 1),
(107, 'Which structure allows dynamic memory allocation?', 'Array', 'Linked List', 'Stack', 'Queue', 'B', 1, 1),
(108, 'Which is used for recursion?', 'Queue', 'Stack', 'Heap', 'Graph', 'B', 1, 1),
(109, 'AVL tree guarantees?', 'O(log n) search', 'O(n) search', 'O(n^2) search', 'O(1) search', 'A', 1, 1),
(110, 'Red-Black tree ensures?', 'Balanced height', 'Unbalanced', 'Sorted array', 'Heap', 'A', 1, 1),
(111, 'Which algorithm finds MST?', 'Dijkstra', 'Prim', 'Bellman-Ford', 'Binary Search', 'B', 1, 1),
(112, 'Kruskal algorithm uses?', 'Union-Find', 'DFS', 'BFS', 'Queue', 'A', 1, 1),
(113, 'Heap can be represented as?', 'Array', 'Linked List', 'Queue', 'Graph', 'A', 1, 1),
(114, 'Min-heap property?', 'Parent <= Children', 'Parent >= Children', 'Parent = Children', 'None', 'A', 1, 1),
(115, 'Max-heap property?', 'Parent <= Children', 'Parent >= Children', 'Parent = Children', 'None', 'B', 1, 1),
(116, 'Which is used in Huffman coding?', 'Queue', 'Stack', 'Priority Queue', 'Heap', 'C', 1, 1),
(117, 'Dynamic programming is?', 'Greedy', 'Divide & Conquer', 'Optimal substructure', 'Backtracking', 'C', 1, 1),
(118, 'Greedy algorithm chooses?', 'Local optimum', 'Global optimum', 'Random', 'None', 'A', 1, 1),
(119, 'Backtracking is used in?', 'Maze solving', 'Sorting', 'Searching', 'Heap', 'A', 1, 1),
(120, 'Which algorithm uses memoization?', 'Dynamic Programming', 'Greedy', 'Divide & Conquer', 'Backtracking', 'A', 1, 1),
(121, 'Which data structure is used for BFS?', 'Stack', 'Queue', 'Linked List', 'Heap', 'B', 1, 1),
(122, 'Which data structure is used for DFS?', 'Queue', 'Stack', 'Heap', 'Graph', 'B', 1, 1),
(123, 'Which is a stable sorting algorithm?', 'Quick Sort', 'Heap Sort', 'Merge Sort', 'Selection Sort', 'C', 1, 1),
(124, 'Which is not stable?', 'Bubble Sort', 'Insertion Sort', 'Selection Sort', 'Merge Sort', 'C', 1, 1),
(125, 'Worst case of Quick Sort?', 'O(n log n)', 'O(n^2)', 'O(log n)', 'O(n)', 'B', 1, 1),
(126, 'Best case of Quick Sort?', 'O(n log n)', 'O(n^2)', 'O(log n)', 'O(n)', 'A', 1, 1),
(127, 'Average case of Quick Sort?', 'O(n log n)', 'O(n^2)', 'O(n)', 'O(log n)', 'A', 1, 1),
(128, 'Time complexity of Bubble Sort?', 'O(n^2)', 'O(n log n)', 'O(n)', 'O(log n)', 'A', 1, 1),
(129, 'Time complexity of Insertion Sort?', 'O(n^2)', 'O(n log n)', 'O(n)', 'O(log n)', 'A', 1, 1),
(130, 'Time complexity of Merge Sort?', 'O(n)', 'O(n log n)', 'O(n^2)', 'O(log n)', 'B', 1, 1),
(131, 'Time complexity of Heap Sort?', 'O(n log n)', 'O(n^2)', 'O(n)', 'O(log n)', 'A', 1, 1),
(132, 'Which search is faster for sorted array?', 'Linear', 'Binary', 'Both same', 'None', 'B', 1, 1),
(133, 'Binary Search requires?', 'Sorted array', 'Linked List', 'Unsorted array', 'Heap', 'A', 1, 1),
(134, 'Which data structure is best for priority scheduling?', 'Stack', 'Queue', 'Heap', 'Array', 'C', 1, 1),
(135, 'Circular Queue avoids?', 'Overflow', 'Underflow', 'Wasted space', 'Stacking', 'C', 1, 1),
(136, 'Which data structure is FIFO?', 'Stack', 'Queue', 'Heap', 'BST', 'B', 1, 1),
(137, 'Which data structure is LIFO?', 'Stack', 'Queue', 'Heap', 'BST', 'A', 1, 1),
(138, 'Time complexity of accessing array element?', 'O(n)', 'O(log n)', 'O(1)', 'O(n log n)', 'C', 1, 1),
(139, 'Time complexity of inserting in array?', 'O(1)', 'O(n)', 'O(log n)', 'O(n log n)', 'B', 1, 1),
(140, 'Time complexity of deleting from array?', 'O(1)', 'O(n)', 'O(log n)', 'O(n log n)', 'B', 1, 1),
(141, 'Linked List is?', 'Linear', 'Non-linear', 'Graph', 'Tree', 'A', 1, 1),
(142, 'Singly Linked List has?', 'One pointer', 'Two pointers', 'Three pointers', 'No pointer', 'A', 1, 1),
(143, 'Doubly Linked List has?', 'One pointer', 'Two pointers', 'Three pointers', 'None', 'B', 1, 1),
(144, 'Circular Linked List connects?', 'Head to tail', 'Tail to head', 'Both', 'None', 'C', 1, 1),
(145, 'Stack operations?', 'Push & Pop', 'Enqueue & Dequeue', 'Insert & Delete', 'Add & Remove', 'A', 1, 1),
(146, 'Queue operations?', 'Push & Pop', 'Enqueue & Dequeue', 'Insert & Delete', 'Add & Remove', 'B', 1, 1),
(147, 'Which graph uses adjacency list?', 'Dense graph', 'Sparse graph', 'Binary tree', 'Heap', 'B', 1, 1),
(148, 'Which graph uses adjacency matrix?', 'Sparse graph', 'Dense graph', 'Stack', 'Queue', 'B', 1, 1),
(149, 'Dijkstra algorithm finds?', 'MST', 'Shortest path', 'Longest path', 'DFS', 'B', 1, 1),
(150, 'Bellman-Ford handles?', 'Positive edges', 'Negative edges', 'Both', 'None', 'C', 1, 1),
(239, 'Which of these is the correct syntax to declare a Java main method?', 'public static void main(String[] args)', 'public void main(String[] args)', 'static public void main(String args)', 'main(String[] args)', 'A', 1, 2),
(240, 'Which keyword is used to inherit a class in Java?', 'this', 'extends', 'implements', 'super', 'B', 1, 2),
(241, 'Which of these data types is used to create a variable that should store text?', 'myString', 'String', 'string', 'txt', 'B', 1, 2),
(242, 'Which operator is used to add together two values?', '+', '-', '*', '&', 'A', 1, 2),
(243, 'Which method can be used to find the length of a string in Java?', 'length()', 'getLength()', 'size()', 'len()', 'A', 1, 2),
(244, 'How do you insert COMMENTS in Java code?', '// This is a comment', '<!-- This is a comment -->', '# This is a comment', '/* This is a comment */', 'A', 1, 2),
(245, 'How do you create a variable with the numeric value 5?', 'num x = 5;', 'int x = 5;', 'x = 5;', 'integer x = 5;', 'B', 1, 2),
(246, 'Which of these is a correct way to declare an array in Java?', 'int[] arr = new int[5];', 'int arr = new int[5];', 'int arr[] = int[5];', 'array int arr = new int[5];', 'A', 1, 2),
(247, 'Which of the following is not a Java primitive type?', 'int', 'boolean', 'String', 'char', 'C', 1, 2),
(248, 'How do you create a method in Java?', 'public void myMethod() {}', 'method void myMethod() {}', 'void method myMethod() {}', 'create void myMethod() {}', 'A', 1, 2),
(249, 'What is the default value of a boolean variable in Java?', 'true', 'false', '0', 'null', 'B', 1, 2),
(250, 'Which of these is used to define a constant value?', 'const', 'final', 'immutable', 'static', 'B', 1, 2),
(251, 'Which of these is used to compare two strings in Java?', '==', 'equals()', 'compare()', 'match()', 'B', 1, 2),
(252, 'Which exception is thrown when dividing by zero in Java?', 'ArithmeticException', 'NullPointerException', 'ArrayIndexOutOfBoundsException', 'NumberFormatException', 'A', 1, 2),
(253, 'Which keyword is used to define an interface in Java?', 'interface', 'class', 'implements', 'abstract', 'A', 1, 2),
(254, 'What is the correct way to start a thread in Java?', 'Thread.start();', 'Thread.run();', 'start.Thread();', 'run.Thread();', 'A', 1, 2),
(255, 'Which of these loops is guaranteed to execute at least once?', 'for', 'while', 'do-while', 'foreach', 'C', 1, 2),
(256, 'Which keyword is used to stop a loop immediately?', 'break', 'stop', 'exit', 'return', 'A', 1, 2),
(257, 'Which keyword is used to refer to the current object?', 'current', 'self', 'this', 'super', 'C', 1, 2),
(258, 'Which of these is used to handle exceptions in Java?', 'try-catch', 'if-else', 'switch', 'for', 'A', 1, 2),
(259, 'Which of the following is used to create a new object?', 'class MyObj();', 'new MyObj();', 'MyObj();', 'create MyObj();', 'B', 1, 2),
(260, 'Which method is used to start a Java application?', 'main()', 'start()', 'init()', 'run()', 'A', 1, 2),
(261, 'Which of these keywords is used to inherit an interface?', 'extends', 'implements', 'inherits', 'interface', 'B', 1, 2),
(262, 'Which of these is NOT a Java access modifier?', 'public', 'private', 'protected', 'package', 'D', 1, 2),
(263, 'Which of these data types can store decimal numbers?', 'int', 'float', 'double', 'char', 'C', 1, 2),
(264, 'Which of the following is used to define a constructor?', 'public ClassName() {}', 'void ClassName() {}', 'ClassName void() {}', 'new ClassName() {}', 'A', 1, 2),
(265, 'Which keyword is used to create an object of a class?', 'object', 'new', 'create', 'instance', 'B', 1, 2),
(266, 'Which method is used to compare two numbers?', 'compare()', 'equals()', '==', 'compareTo()', 'D', 1, 2),
(267, 'Which of these keywords prevents method overriding?', 'final', 'static', 'const', 'immutable', 'A', 1, 2),
(268, 'Which of these keywords allows method overriding?', 'abstract', 'final', 'private', 'static', 'A', 1, 2),
(269, 'Which of the following is used to access superclass members?', 'this', 'super', 'parent', 'base', 'B', 1, 2),
(270, 'Which of these keywords defines an abstract class?', 'abstract', 'interface', 'final', 'public', 'A', 1, 2),
(271, 'Which of these is used to terminate the current method?', 'stop', 'break', 'return', 'exit', 'C', 1, 2),
(272, 'Which of these is used to terminate the program?', 'System.exit(0)', 'exit()', 'terminate()', 'stop()', 'A', 1, 2),
(273, 'Which of the following is NOT a Java loop?', 'for', 'while', 'do-while', 'foreach', 'D', 1, 2),
(274, 'Which keyword is used to create a subclass?', 'extends', 'implements', 'inherits', 'subclass', 'A', 1, 2),
(275, 'Which of these is a Java logical operator?', '&&', '&', '|', '^', 'A', 1, 2),
(276, 'Which of these is a bitwise operator?', '&', '&&', '||', '==', 'A', 1, 2),
(277, 'Which of these is used to compare object references?', '==', 'equals()', 'compare()', 'match()', 'A', 1, 2),
(278, 'Which of these is used to read input from the user?', 'Scanner sc = new Scanner(System.in);', 'BufferedReader br = new BufferedReader();', 'InputStreamReader isr = new InputStreamReader(System.in);', 'System.input();', 'A', 1, 2),
(279, 'Which of these is the correct way to declare a constant?', 'final int x = 5;', 'int final x = 5;', 'const int x = 5;', 'immutable int x = 5;', 'A', 1, 2),
(280, 'Which of these keywords is used to create an interface?', 'interface', 'class', 'implements', 'abstract', 'A', 1, 2),
(281, 'Which of these is NOT a Java keyword?', 'static', 'void', 'integer', 'final', 'C', 1, 2),
(282, 'Which of these is used for single-line comments?', '// comment', '/* comment */', '# comment', '<!-- comment -->', 'A', 1, 2),
(283, 'Which of these is used for multi-line comments?', '/* comment */', '// comment', '# comment', '<!-- comment -->', 'A', 1, 2),
(284, 'Which of these is used to create a new instance of a class?', 'new ClassName();', 'ClassName();', 'instance ClassName();', 'create ClassName();', 'A', 1, 2),
(285, 'Which of these is a Java primitive type?', 'String', 'int', 'Scanner', 'ArrayList', 'B', 1, 2),
(286, 'Which of these is used to read integers from the user?', 'Scanner.nextInt()', 'Scanner.readInt()', 'Scanner.getInt()', 'System.inInt()', 'A', 1, 2),
(287, 'Which keyword is used to define a method that does not return a value?', 'void', 'int', 'null', 'none', 'A', 1, 2),
(288, 'Which of these is used to compare strings?', 'equals()', '==', 'compare', 'match', 'A', 1, 2),
(289, 'Which keyword is used to inherit a class?', 'extends', 'implements', 'inherits', 'super', 'A', 1, 2),
(290, 'Which keyword is used to implement an interface?', 'implements', 'extends', 'interface', 'override', 'A', 1, 2),
(291, 'Which of these is used to create an abstract class?', 'abstract', 'interface', 'final', 'static', 'A', 1, 2),
(292, 'Which keyword is used to prevent method overriding?', 'final', 'static', 'abstract', 'private', 'A', 1, 2),
(293, 'Which of these loops is executed at least once?', 'do-while', 'while', 'for', 'foreach', 'A', 1, 2),
(294, 'Which keyword is used to exit a loop immediately?', 'break', 'continue', 'return', 'exit', 'A', 1, 2),
(295, 'Which keyword refers to the current object?', 'this', 'super', 'self', 'current', 'A', 1, 2),
(296, 'Which keyword is used to access superclass methods?', 'super', 'this', 'parent', 'base', 'A', 1, 2),
(297, 'Which of these is used to handle exceptions?', 'try-catch', 'if-else', 'switch', 'loop', 'A', 1, 2),
(298, 'Which exception occurs when dividing by zero?', 'ArithmeticException', 'NullPointerException', 'IOException', 'ArrayIndexOutOfBoundsException', 'A', 1, 2),
(299, 'Which of these keywords is used to define constants?', 'final', 'const', 'immutable', 'static', 'A', 1, 2),
(300, 'Which of these operators is used for addition?', '+', '-', '*', '&', 'A', 1, 2),
(301, 'Which operator is used for equality check?', '==', '=', 'equals', '!=', 'A', 1, 2),
(302, 'Which of these is used to find string length?', 'length()', 'size()', 'len()', 'count()', 'A', 1, 2),
(303, 'Which of these is the correct array declaration?', 'int[] arr = new int[5];', 'int arr = new int[5];', 'array int arr = new int[5];', 'int arr[] = int[5];', 'A', 1, 2),
(304, 'Which of these is not a primitive type?', 'String', 'int', 'boolean', 'char', 'A', 1, 2),
(305, 'Which keyword is used to define a subclass?', 'extends', 'implements', 'inherits', 'subclass', 'A', 1, 2),
(306, 'Which keyword is used to start a thread?', 'start()', 'run()', 'init()', 'execute()', 'A', 1, 2),
(307, 'Which keyword allows creating interfaces?', 'interface', 'abstract', 'class', 'final', 'A', 1, 2),
(308, 'Which of these is used for logical AND?', '&&', '&', '|', '^', 'A', 1, 2),
(309, 'Which of these is used for logical OR?', '||', '|', '&&', '^', 'A', 1, 2),
(310, 'Which method is used to compare strings?', 'equals()', 'compare()', '==', 'match()', 'A', 1, 2),
(311, 'Which of these reads input from user?', 'Scanner sc = new Scanner(System.in);', 'BufferedReader br = new BufferedReader();', 'InputStreamReader isr = new InputStreamReader(System.in);', 'System.input();', 'A', 1, 2),
(312, 'Which keyword prevents a class from being inherited?', 'final', 'abstract', 'static', 'const', 'A', 1, 2),
(313, 'Which keyword is used to declare packages?', 'package', 'import', 'module', 'namespace', 'A', 1, 2),
(314, 'Which keyword imports classes?', 'import', 'include', 'package', 'using', 'A', 1, 2),
(315, 'Which of these is NOT an access modifier?', 'public', 'private', 'protected', 'constant', 'D', 1, 2),
(316, 'Which of these can store decimal numbers?', 'int', 'float', 'double', 'char', 'C', 1, 2),
(317, 'Which method is used to convert string to int?', 'Integer.parseInt()', 'Integer.toInt()', 'parseInt()', 'Int.parse()', 'A', 1, 2),
(318, 'Which of these is a Java wrapper class?', 'Integer', 'int', 'Double', 'double', 'A', 1, 2),
(319, 'Which of these is used to access array elements?', 'arr[index]', 'arr.get(index)', 'arr.fetch(index)', 'arr.element(index)', 'A', 1, 2),
(320, 'Which keyword is used to define an abstract method?', 'abstract', 'final', 'static', 'private', 'A', 1, 2),
(321, 'Which keyword is used to implement method overriding?', 'abstract', 'final', 'static', 'public', 'A', 1, 2),
(322, 'Which of these loops is not guaranteed to run at least once?', 'for', 'do-while', 'while', 'none', 'A', 1, 2),
(323, 'Which keyword is used to create objects?', 'new', 'object', 'instance', 'create', 'A', 1, 2),
(324, 'Which method is used to start the execution of a thread?', 'start()', 'run()', 'execute()', 'init()', 'A', 1, 2),
(325, 'Which keyword is used to inherit multiple interfaces?', 'implements', 'extends', 'abstract', 'interface', 'A', 1, 2),
(326, 'Which method is used to stop program execution?', 'System.exit(0)', 'exit()', 'stop()', 'terminate()', 'A', 1, 2),
(327, 'Which of these is used to handle runtime exceptions?', 'try-catch', 'if-else', 'switch', 'loop', 'A', 1, 2),
(328, 'Which operator is used for modulus operation?', '%', '+', '-', '*', 'A', 1, 2),
(329, 'Which of these is a relational operator?', '==', '&&', '|', '!', 'A', 1, 2),
(330, 'Which method is used to append text to a StringBuilder?', 'append()', 'add()', 'concat()', 'insert()', 'A', 1, 2),
(331, 'Which of these is used for type casting?', '(int) value', 'cast(value)', 'convert(value)', 'toInt(value)', 'A', 1, 2),
(332, 'Which keyword is used to declare static methods?', 'static', 'final', 'abstract', 'void', 'A', 1, 2),
(333, 'Which keyword is used to define packages?', 'package', 'import', 'module', 'namespace', 'A', 1, 2),
(334, 'Which method is used to get character at a specific index?', 'charAt()', 'getChar()', 'char()', 'characterAt()', 'A', 1, 2),
(335, 'Which of these is a valid boolean expression?', 'true', '0', 'null', '1', 'A', 1, 2),
(336, 'Which of these converts int to string?', 'Integer.toString()', 'String.valueOf()', 'toString()', 'All of the above', 'D', 1, 2),
(337, 'Which of these is used to iterate over arrays?', 'for', 'while', 'do-while', 'All of the above', 'D', 1, 2),
(338, 'Which of these is used for string concatenation?', '+', '&', '*', '/', 'A', 1, 2),
(339, 'Which of these is used to check instance type?', 'instanceof', 'type()', 'typeof', 'checktype', 'A', 1, 2),
(340, 'Which of these is used to declare a variable inside class?', 'int x;', 'int x = 0;', 'both A and B', 'None', 'C', 1, 2),
(341, 'Which of these is the default value of int?', '0', 'null', 'false', 'undefined', 'A', 1, 2),
(342, 'Which of these is the default value of boolean?', 'false', '0', 'true', 'null', 'A', 1, 2),
(343, 'Which of these is used to inherit a class?', 'extends', 'implements', 'inherits', 'super', 'A', 1, 2),
(344, 'Which of these is NOT a valid identifier?', '1variable', '_variable', 'variable1', '$variable', 'A', 1, 2),
(345, 'Which of these is used to exit a method?', 'return', 'break', 'exit', 'stop', 'A', 1, 2),
(346, 'Which of these is used to compare numbers?', '==', '=', 'equals', 'compare', 'A', 1, 2),
(347, 'Which of these is used to create multi-line comments?', '/* */', '//', '#', '<!-- -->', 'A', 1, 2),
(348, 'Which of these is used to compare strings for equality?', 'equals()', '==', 'compare', 'match', 'A', 1, 2),
(349, 'Which of these is used for bitwise AND?', '&', '&&', '|', '^', 'A', 1, 2),
(350, 'Which of these is used for logical OR?', '||', '|', '&&', '^', 'A', 1, 2),
(351, 'Which of these is used to create a new thread?', 'new Thread()', 'Thread()', 'create Thread()', 'start Thread()', 'A', 1, 2),
(352, 'Which of these is used to access superclass constructor?', 'super()', 'this()', 'parent()', 'base()', 'A', 1, 2),
(353, 'Which keyword is used to define interface methods?', 'abstract', 'final', 'static', 'void', 'A', 1, 2),
(354, 'Which of these is used to handle file exceptions?', 'try-catch', 'if-else', 'switch', 'loop', 'A', 1, 2),
(355, 'Which of these is used to check array length?', 'arr.length', 'arr.size()', 'arr.count', 'arr.len()', 'A', 1, 2),
(356, 'Which of these is used to concatenate strings?', 'concat()', '+', 'append()', 'All of the above', 'D', 1, 2),
(357, 'What is the full form of OOP?', 'Object Oriented Programming', 'Open Object Programming', 'Optional Oriented Programming', 'Ordered Object Programming', 'A', 1, 3),
(358, 'Which of the following is a feature of OOP?', 'Polymorphism', 'Recursion', 'Iteration', 'Compilation', 'A', 1, 3),
(359, 'What does encapsulation mean in OOP?', 'Wrapping data and methods together', 'Splitting data and methods', 'Running multiple threads', 'Overloading functions', 'A', 1, 3),
(360, 'Which keyword is used to inherit a class in Java?', 'extends', 'implements', 'inherits', 'super', 'A', 1, 3),
(361, 'Which of these is not a valid OOP concept?', 'Inheritance', 'Polymorphism', 'Abstraction', 'Compilation', 'D', 1, 3),
(362, 'What is polymorphism in OOP?', 'Ability of objects to take multiple forms', 'Encapsulation of data', 'Hiding implementation details', 'Creating multiple classes', 'A', 1, 3),
(363, 'Which method is called when an object is created?', 'Constructor', 'Destructor', 'Main', 'Init', 'A', 1, 3),
(364, 'Which keyword is used to prevent inheritance in Java?', 'final', 'static', 'abstract', 'private', 'A', 1, 3),
(365, 'Which type of polymorphism is achieved at compile time?', 'Compile-time polymorphism', 'Runtime polymorphism', 'Dynamic polymorphism', 'Interface polymorphism', 'A', 1, 3),
(366, 'Which type of polymorphism is achieved at runtime?', 'Runtime polymorphism', 'Compile-time polymorphism', 'Static polymorphism', 'Operator overloading', 'A', 1, 3),
(367, 'Which access specifier allows access only within the same class?', 'private', 'public', 'protected', 'default', 'A', 1, 3),
(368, 'Which access specifier allows access within package and subclasses?', 'protected', 'private', 'public', 'default', 'A', 1, 3),
(369, 'Which access specifier allows access from anywhere?', 'public', 'private', 'protected', 'default', 'A', 1, 3),
(370, 'Which access specifier allows access only within the package?', 'default', 'private', 'public', 'protected', 'A', 1, 3),
(371, 'What is an abstract class?', 'A class that cannot be instantiated', 'A class with only variables', 'A class with no methods', 'A class that always runs main', 'A', 1, 3),
(372, 'Which keyword is used to define an abstract class?', 'abstract', 'final', 'static', 'private', 'A', 1, 3),
(373, 'Which keyword is used to define an interface in Java?', 'interface', 'implements', 'abstract', 'extends', 'A', 1, 3),
(374, 'A class can implement how many interfaces in Java?', 'Multiple', 'Only one', 'None', 'Two', 'A', 1, 3),
(375, 'Which keyword is used for method overriding?', 'Override', 'Overload', 'Implement', 'Extend', 'A', 1, 3),
(376, 'Method overloading occurs at which time?', 'Compile time', 'Runtime', 'Link time', 'Execution time', 'A', 1, 3),
(377, 'Method overriding occurs at which time?', 'Runtime', 'Compile time', 'Link time', 'None of these', 'A', 1, 3),
(378, 'What is the default value of an object reference in Java?', 'null', '0', 'undefined', 'empty', 'A', 1, 3),
(379, 'What is the size of int in Java?', '4 bytes', '2 bytes', '8 bytes', 'Depends on OS', 'A', 1, 3),
(380, 'Which of these is a wrapper class in Java?', 'Integer', 'int', 'char', 'boolean', 'A', 1, 3),
(381, 'Which keyword is used to inherit from an interface?', 'implements', 'extends', 'inherits', 'super', 'A', 1, 3),
(382, 'Which keyword is used to call superclass constructor?', 'super', 'this', 'base', 'parent', 'A', 1, 3),
(383, 'What is the default constructor?', 'Constructor with no parameters', 'Constructor with parameters', 'Main method', 'Destructor', 'A', 1, 3),
(384, 'Which is not a type of constructor?', 'Virtual constructor', 'Default constructor', 'Parameterized constructor', 'Copy constructor', 'A', 1, 3),
(385, 'What does the \"this\" keyword represent?', 'Current object', 'Parent object', 'Superclass', 'Static variable', 'A', 1, 3),
(386, 'Which of these is used to achieve abstraction?', 'Abstract class or Interface', 'Encapsulation', 'Polymorphism', 'Inheritance', 'A', 1, 3),
(387, 'Which operator is used for reference comparison?', '==', '=', '===', '!=', 'A', 1, 3),
(388, 'Which of these is true about final variables?', 'Value cannot change', 'Value can change', 'Value is private', 'Value is static', 'A', 1, 3),
(389, 'Can an interface have a constructor?', 'No', 'Yes', 'Sometimes', 'Depends', 'A', 1, 3),
(390, 'What is the parent class of all classes in Java?', 'Object', 'Class', 'Interface', 'System', 'A', 1, 3),
(391, 'Which of these is not a feature of OOP?', 'Goto statement', 'Encapsulation', 'Polymorphism', 'Inheritance', 'A', 1, 3),
(392, 'Which keyword is used to prevent method overriding?', 'final', 'abstract', 'static', 'private', 'A', 1, 3),
(393, 'Which of these is true about static methods?', 'Belongs to class', 'Belongs to object', 'Belongs to parent', 'None', 'A', 1, 3),
(394, 'Which of these cannot be inherited?', 'Constructors', 'Private members', 'Final methods', 'All of these', 'D', 1, 3),
(395, 'Which method is used to finalize objects before garbage collection?', 'finalize()', 'destroy()', 'cleanup()', 'delete()', 'A', 1, 3),
(396, 'Which of these is true about Java packages?', 'Group related classes', 'Group unrelated classes', 'Group objects', 'Group methods', 'A', 1, 3),
(397, 'Which of these is a marker interface?', 'Serializable', 'Runnable', 'Cloneable', 'All of these', 'D', 1, 3),
(398, 'Which of these is true about checked exceptions?', 'Must be handled or declared', 'Optional', 'Never handled', 'Runtime only', 'A', 1, 3),
(399, 'Which of these is true about unchecked exceptions?', 'Do not require handling', 'Must be declared', 'Cannot be caught', 'Always handled', 'A', 1, 3),
(400, 'Which of these is true about try-catch-finally?', 'Finally block always executes', 'Finally block never executes', 'Catch block executes first', 'Try block executes last', 'A', 1, 3),
(401, 'Which of these keywords is used to handle exceptions?', 'try', 'catch', 'throw', 'throws', 'A', 1, 3),
(402, 'Which keyword is used to manually throw an exception?', 'throw', 'throws', 'try', 'catch', 'A', 1, 3),
(403, 'Which keyword is used to declare multiple exceptions?', 'throws', 'throw', 'try', 'catch', 'A', 1, 3),
(404, 'Which of these is used to create a custom exception?', 'Extend Exception class', 'Extend Object class', 'Extend Throwable', 'Use static', 'A', 1, 3),
(405, 'Which of these is true about finally block?', 'Executes even if exception occurs', 'Executes only if exception occurs', 'Executes only if no exception', 'Executes randomly', 'A', 1, 3),
(406, 'Which of these is true about finally and return?', 'Finally executes before return', 'Finally executes after return', 'Finally does not execute', 'None', 'A', 1, 3),
(407, 'Which of these is used to declare a constant?', 'final', 'const', 'static', 'immutable', 'A', 1, 3),
(408, 'Which of these is true about constructors?', 'Called automatically', 'Called manually', 'Called by main', 'Never called', 'A', 1, 3),
(409, 'Which of these is true about object cloning?', 'Shallow copy by default', 'Deep copy by default', 'Objects cannot be cloned', 'None', 'A', 1, 3),
(410, 'Which of these is true about inheritance?', 'Child class inherits parent members', 'Child class cannot inherit', 'Parent inherits child', 'None', 'A', 1, 3),
(411, 'Which of these is true about super keyword?', 'Access superclass members', 'Access current members', 'Access child members', 'None', 'A', 1, 3),
(412, 'Which of these is true about method overriding?', 'Signature must be same', 'Signature can differ', 'Method can overload', 'Method cannot be overloaded', 'A', 1, 3),
(413, 'Which of these is true about abstract methods?', 'Declared without body', 'Declared with body', 'Cannot declare', 'Must declare body', 'A', 1, 3),
(414, 'Which of these is true about interfaces?', 'All methods are abstract by default', 'All methods have body', 'Some methods have body', 'None', 'A', 1, 3),
(415, 'Which of these is true about inner classes?', 'Defined within another class', 'Defined outside class', 'Cannot define', 'Defined in package', 'A', 1, 3),
(416, 'Which of these is true about nested classes?', 'Static or non-static', 'Abstract only', 'Interface only', 'None', 'A', 1, 3),
(417, 'Which of these is true about this keyword?', 'Refers current object', 'Refers parent object', 'Refers superclass', 'Refers child object', 'A', 1, 3),
(418, 'Which of these is true about instanceof?', 'Checks object type', 'Checks class type', 'Checks method type', 'Checks reference type', 'A', 1, 3),
(419, 'Which of these is true about static block?', 'Executes when class loads', 'Executes when object loads', 'Executes on method call', 'Never executes', 'A', 1, 3),
(420, 'Which of these is true about final class?', 'Cannot be inherited', 'Can be inherited', 'Cannot be instantiated', 'Both', 'A', 1, 3),
(421, 'Which of these is true about super()?', 'Calls superclass constructor', 'Calls main method', 'Calls child constructor', 'Calls object constructor', 'A', 1, 3),
(422, 'Which of these is true about object reference?', 'Stores memory address', 'Stores object value', 'Stores method', 'Stores class', 'A', 1, 3),
(423, 'Which of these is true about overloading?', 'Same method name, different parameters', 'Same name and same parameters', 'Different name', 'Cannot overload', 'A', 1, 3),
(424, 'Which of these is true about type casting?', 'Converting data type', 'Comparing objects', 'Changing method name', 'Changing memory', 'A', 1, 3),
(425, 'Which of these is true about wrapper classes?', 'Encapsulates primitive data types', 'Encapsulates objects', 'Encapsulates methods', 'Encapsulates classes', 'A', 1, 3),
(426, 'Which of these is true about enums?', 'Defines a fixed set of constants', 'Defines variable constants', 'Defines methods only', 'Defines objects', 'A', 1, 3),
(427, 'Which of these is true about garbage collection?', 'Automatically frees memory', 'Manually frees memory', 'Does not free memory', 'Depends', 'A', 1, 3),
(428, 'Which of these is true about String class?', 'Immutable', 'Mutable', 'Both', 'None', 'A', 1, 3),
(429, 'Which of these is true about StringBuilder?', 'Mutable', 'Immutable', 'Both', 'None', 'A', 1, 3),
(430, 'Which of these is true about StringBuffer?', 'Thread-safe and mutable', 'Thread-unsafe', 'Immutable', 'None', 'A', 1, 3),
(431, 'Which of these is true about packages?', 'Organizes classes', 'Creates objects', 'Groups methods', 'Deletes methods', 'A', 1, 3),
(432, 'Which of these is true about import statement?', 'Used to include packages', 'Used to exclude packages', 'Used to create classes', 'Used to delete classes', 'A', 1, 3),
(433, 'Which of these is true about try-with-resources?', 'Automatically closes resources', 'Manually closes resources', 'Never closes', 'Depends', 'A', 1, 3),
(434, 'Which of these is true about main method?', 'Entry point of program', 'Can have multiple entry points', 'Optional', 'None', 'A', 1, 3),
(435, 'Which of these is true about command-line arguments?', 'Passed to main method', 'Not passed to main method', 'Optional', 'Depends', 'A', 1, 3),
(436, 'Which of these is true about overloading main?', 'Valid in Java', 'Invalid', 'Optional', 'Depends', 'A', 1, 3),
(437, 'Which of these is true about abstract class vs interface?', 'Abstract can have variables; Interface cannot', 'Interface can have variables; Abstract cannot', 'No difference', 'Both same', 'A', 1, 3),
(438, 'Which of these is true about multiple inheritance in Java?', 'Through interfaces only', 'Through classes', 'Not possible', 'Both', 'A', 1, 3),
(439, 'Which of these is true about finalizer method?', 'Called before garbage collection', 'Called after garbage collection', 'Never called', 'Optional', 'A', 1, 3),
(440, 'Which of these is true about JVM?', 'Executes bytecode', 'Compiles source code', 'Interprets source code', 'Runs native code', 'A', 1, 3),
(441, 'Which of these is true about JRE?', 'Java Runtime Environment', 'Java Ready Environment', 'Java Resource Environment', 'Java Reference Environment', 'A', 1, 3),
(442, 'Which of these is true about JDK?', 'Java Development Kit', 'Java Design Kit', 'Java Debug Kit', 'Java Deploy Kit', 'A', 1, 3),
(443, 'Which of these is true about object class methods?', 'toString(), equals(), hashCode()', 'main(), run(), start()', 'get(), set(), add()', 'delete(), insert(), update()', 'A', 1, 3),
(444, 'Which of the following is the correct syntax to output \"Hello World\" in Java?', 'Console.WriteLine(\"Hello World\");', 'System.out.println(\"Hello World\");', 'printf(\"Hello World\");', 'echo \"Hello World\";', 'B', 1, 2),
(445, 'Which data type is used to create a variable that should store text?', 'string', 'String', 'myString', 'char', 'B', 1, 2),
(446, 'How do you insert COMMENTS in Java code?', '// This is a comment', '# This is a comment', '/* This is a comment', '-- This is a comment', 'A', 1, 2),
(447, 'How do you create a variable with the numeric value 5?', 'num x = 5;', 'int x = 5;', 'x = 5;', 'integer x = 5;', 'B', 1, 2),
(448, 'Which operator is used to add together two values?', '+', '-', '*', '%', 'A', 1, 2),
(449, 'Which method can be used to find the length of a string?', 'length()', 'getSize()', 'len()', 'getLength()', 'A', 1, 2),
(450, 'Which keyword is used to define a class in Java?', 'class', 'Class', 'def', 'struct', 'A', 1, 2),
(451, 'Which keyword is used to create an object in Java?', 'new', 'create', 'make', 'object', 'A', 1, 2),
(452, 'Which symbol is used to terminate statements in Java?', ';', '.', ',', ':', 'A', 1, 2),
(453, 'How do you create a method in Java?', 'methodName() {}', 'void methodName() {}', 'function methodName() {}', 'def methodName() {}', 'B', 1, 2),
(454, 'What is the default value of a boolean variable in Java?', 'true', 'false', '0', 'null', 'B', 1, 2),
(455, 'Which keyword is used to inherit a class in Java?', 'extends', 'implements', 'inherits', 'super', 'A', 1, 2),
(456, 'Which of these is NOT a Java primitive data type?', 'int', 'double', 'String', 'boolean', 'C', 1, 2),
(457, 'How do you declare an array of integers in Java?', 'int arr[];', 'array int arr;', 'int arr{};', 'int arr();', 'A', 1, 2),
(458, 'How do you start a FOR loop in Java?', 'for(int i=0; i<5; i++)', 'for i = 0 to 5', 'foreach i in 5', 'for(int i=0; i<=5; i--)', 'A', 1, 2),
(459, 'Which keyword is used to stop a loop?', 'stop', 'break', 'exit', 'return', 'B', 1, 2),
(460, 'Which statement is used to skip an iteration in a loop?', 'skip', 'continue', 'break', 'pass', 'B', 1, 2),
(461, 'Which keyword is used to define a constant?', 'final', 'const', 'static', 'constant', 'A', 1, 2),
(462, 'Which of these is the correct way to declare a Java interface?', 'interface MyInterface {}', 'class MyInterface {}', 'interface: MyInterface {}', 'def MyInterface {}', 'A', 1, 2),
(463, 'Which package contains the Scanner class?', 'java.util', 'java.io', 'java.lang', 'java.net', 'A', 1, 2),
(464, 'Which method is the entry point for a Java application?', 'main()', 'start()', 'init()', 'run()', 'A', 1, 2),
(465, 'How do you create a constructor in Java?', 'public ClassName() {}', 'void ClassName() {}', 'ClassName() {}', 'def ClassName() {}', 'A', 1, 2),
(466, 'Which operator is used to compare two values for equality?', '==', '=', '!=', '<>', 'A', 1, 2),
(467, 'Which operator is used to assign a value to a variable?', '=', '==', '!=', '<-', 'A', 1, 2),
(468, 'Which statement is used to test a condition?', 'if', 'loop', 'switch', 'case', 'A', 1, 2),
(469, 'Which statement is used to choose between multiple options?', 'if', 'switch', 'loop', 'choose', 'B', 1, 2),
(470, 'Which of these is used to handle exceptions in Java?', 'try-catch', 'if-else', 'switch-case', 'do-while', 'A', 1, 2),
(471, 'Which keyword is used to manually throw an exception?', 'throw', 'throws', 'raise', 'catch', 'A', 1, 2),
(472, 'Which of these is used for single-line comments?', '//', '/*', '<!--', '#', 'A', 1, 2),
(473, 'Which access modifier allows visibility only within the class?', 'private', 'protected', 'public', 'default', 'A', 1, 2),
(474, 'Which access modifier allows visibility in the package?', 'private', 'protected', 'public', 'default', 'D', 1, 2),
(475, 'Which access modifier allows visibility in all packages?', 'private', 'protected', 'public', 'default', 'C', 1, 2),
(476, 'Which of these is a non-access modifier?', 'static', 'private', 'public', 'protected', 'A', 1, 2),
(477, 'Which of these is used to declare a method that doesn’t return a value?', 'void', 'int', 'double', 'return', 'A', 1, 2),
(478, 'Which of these is a wrapper class in Java?', 'int', 'Integer', 'boolean', 'String', 'B', 1, 2),
(479, 'Which of these is used to create a thread in Java?', 'Thread', 'Runnable', 'Timer', 'Executor', 'A', 1, 2),
(480, 'Which method starts a thread execution?', 'run()', 'start()', 'execute()', 'init()', 'B', 1, 2),
(481, 'Which of these can be used to compare strings?', '==', 'equals()', 'compareTo()', 'Both B and C', 'D', 1, 2),
(482, 'Which of these is true about Java arrays?', 'Fixed size', 'Resizable', 'Dynamic', 'Both B and C', 'A', 1, 2),
(483, 'Which loop checks the condition before execution?', 'do-while', 'while', 'for', 'switch', 'B', 1, 2),
(484, 'Which loop checks the condition after execution?', 'while', 'do-while', 'for', 'if', 'B', 1, 2),
(485, 'Which keyword is used to inherit multiple interfaces?', 'implements', 'extends', 'import', 'package', 'A', 1, 2),
(486, 'Which keyword is used to prevent inheritance?', 'final', 'static', 'private', 'protected', 'A', 1, 2),
(487, 'Which of these is true about Java Strings?', 'Immutable', 'Mutable', 'Resized', 'None', 'A', 1, 2),
(488, 'Which of these is used to read input from the console?', 'Scanner', 'BufferedReader', 'Console', 'InputStream', 'A', 1, 2),
(489, 'Which keyword is used to call the parent class constructor?', 'super', 'this', 'parent', 'base', 'A', 1, 2),
(490, 'Which operator is used for logical AND?', '&', '&&', '|', '||', 'B', 1, 2),
(491, 'Which operator is used for logical OR?', '|', '||', '&', '&&', 'B', 1, 2),
(492, 'Which of these is true about Java methods?', 'Must be inside a class', 'Can be outside class', 'Can be static', 'Both A and C', 'D', 1, 2),
(493, 'Which of these is true about Java constructors?', 'Name same as class', 'Must have return type', 'Can be private', 'All of the above', 'A', 1, 2),
(494, 'What is the solution to the equation 2x + 3 = 7?', 'x = 1', 'x = 2', 'x = 3', 'x = 4', 'B', 1, 4),
(495, 'Simplify: 5x + 3x - 2', '8x - 2', '8x + 2', '2x + 8', '5x - 3x', 'A', 1, 4),
(496, 'Factor: x^2 + 5x + 6', '(x+2)(x+3)', '(x+1)(x+6)', '(x-2)(x-3)', '(x-1)(x-6)', 'A', 1, 4),
(497, 'Solve for x: x^2 = 16', 'x = 4', 'x = -4', 'x = ±4', 'x = 8', 'C', 1, 4),
(498, 'What is the slope of the line y = 2x + 5?', '2', '5', '-2', '1/2', 'A', 1, 4),
(499, 'If f(x) = 3x + 4, what is f(2)?', '10', '7', '6', '12', 'A', 1, 4),
(500, 'Simplify: (x^2)(x^3)', 'x^5', 'x^6', 'x^8', 'x^9', 'A', 1, 4),
(501, 'Simplify: (2x^3)(3x^2)', '6x^5', '5x^6', '6x^6', '6x^8', 'A', 1, 4),
(502, 'Factor: x^2 - 9', '(x-3)(x+3)', '(x-9)(x+1)', '(x+3)^2', '(x-3)^2', 'A', 1, 4),
(503, 'Solve: 3x - 5 = 10', 'x = 3', 'x = 5', 'x = 15', 'x = 1', 'A', 1, 4),
(504, 'What is the sum of the roots of x^2 - 4x + 3 = 0?', '4', '-4', '3', '-3', 'A', 1, 4),
(505, 'Simplify: 4(x + 2) - 3x', 'x + 8', '7x + 2', 'x - 2', '4x - 6', 'A', 1, 4),
(506, 'Factor completely: x^2 + 7x + 12', '(x+3)(x+4)', '(x+1)(x+12)', '(x-3)(x-4)', '(x+2)(x+6)', 'A', 1, 4),
(507, 'Solve: 2x^2 - 8 = 0', 'x = 2', 'x = -2', 'x = ±2', 'x = 4', 'C', 1, 4),
(508, 'If f(x) = x^2 - 2x, find f(3)', '3', '3', '3', '3', 'A', 1, 4),
(509, 'Simplify: (x^4)/(x^2)', 'x^2', 'x^6', 'x^8', 'x^4', 'A', 1, 4),
(510, 'Solve: x/3 + 2 = 5', 'x = 9', 'x = 6', 'x = 3', 'x = 1', 'A', 1, 4),
(511, 'What is the y-intercept of y = 3x + 7?', '3', '7', '0', '-7', 'B', 1, 4),
(512, 'Simplify: 2(x+3) + 4(x-1)', '6x + 2', '6x + 10', '6x + 4', '2x + 10', 'B', 1, 4),
(513, 'Solve: x^2 - 16 = 0', 'x = 4', 'x = -4', 'x = ±4', 'x = 0', 'C', 1, 4),
(514, 'Factor: x^2 - 5x + 6', '(x-2)(x-3)', '(x+2)(x+3)', '(x-1)(x-6)', '(x+1)(x+6)', 'A', 1, 4),
(515, 'Find the slope of line through points (1,2) and (3,6)', '1', '2', '3', '4', 'B', 1, 4),
(516, 'Simplify: (x^3y^2)(x^2y^3)', 'x^5y^5', 'x^6y^6', 'x^5y^6', 'x^6y^5', 'A', 1, 4),
(517, 'Solve: 5x + 3 = 18', 'x = 3', 'x = 5', 'x = 2', 'x = 6', 'B', 1, 4),
(518, 'Simplify: (x^5)/(x^2)', 'x^3', 'x^7', 'x^2', 'x^5', 'A', 1, 4),
(519, 'Solve: x^2 + 6x + 9 = 0', 'x = 3', 'x = -3', 'x = ±3', 'x = 0', 'C', 1, 4),
(520, 'Factor: x^2 + 8x + 15', '(x+3)(x+5)', '(x+1)(x+15)', '(x+5)(x+5)', '(x+8)(x+15)', 'A', 1, 4),
(521, 'Simplify: 3(x-2) + 2(x+4)', '5x + 2', '5x + 5', 'x + 2', '5x + 4', 'D', 1, 4),
(522, 'Solve: 4x - 7 = 9', 'x = 4', 'x = 5', 'x = 16/4', 'x = 8', 'A', 1, 4),
(523, 'Simplify: 2x + 3x - 7', '5x - 7', '5x + 7', 'x - 7', '5x - 3', 'A', 1, 4),
(524, 'Solve: 3x^2 - 12 = 0', 'x = 2', 'x = -2', 'x = ±2', 'x = 4', 'C', 1, 4),
(525, 'Factor: x^2 - x - 6', '(x-3)(x+2)', '(x+3)(x-2)', '(x+1)(x-6)', '(x-1)(x+6)', 'A', 1, 4);
INSERT INTO `questionbank` (`question_id`, `question_text`, `option_a`, `option_b`, `option_c`, `option_d`, `correct_option`, `marks`, `subject_id`) VALUES
(526, 'What is the solution of 7x + 14 = 0?', 'x = 2', 'x = -2', 'x = -14/7', 'x = 0', 'C', 1, 4),
(527, 'Simplify: (2x^2)(3x^3)', '6x^5', '5x^6', '6x^6', '6x^8', 'A', 1, 4),
(528, 'Solve: x/5 + 3 = 8', 'x = 15', 'x = 10', 'x = 5', 'x = 25', 'A', 1, 4),
(529, 'Simplify: x^3 * x^4', 'x^7', 'x^12', 'x^1', 'x^8', 'A', 1, 4),
(530, 'Solve: x^2 - 25 = 0', 'x = 5', 'x = -5', 'x = ±5', 'x = 0', 'C', 1, 4),
(531, 'Factor: x^2 + 6x + 8', '(x+2)(x+4)', '(x+1)(x+8)', '(x+3)(x+3)', '(x+6)(x+8)', 'A', 1, 4),
(532, 'Simplify: 5(x+1) - 2(x-3)', '3x + 5', '7x + 11', '3x + 11', '5x + 1', 'C', 1, 4),
(533, 'Solve: 2x + 7 = 13', 'x = 2', 'x = 3', 'x = 6', 'x = 7', 'C', 1, 4),
(534, 'Factor: x^2 - 7x + 10', '(x-5)(x-2)', '(x-10)(x-1)', '(x-2)(x-5)', '(x+5)(x+2)', 'A', 1, 4),
(535, 'Solve: 3x - 9 = 0', 'x = 3', 'x = -3', 'x = 0', 'x = 9', 'A', 1, 4),
(536, 'Simplify: (4x^2)*(2x^3)', '8x^5', '6x^6', '8x^6', '6x^5', 'A', 1, 4),
(537, 'Solve: x^2 + 4x + 4 = 0', 'x = 2', 'x = -2', 'x = -2', 'x = -2', 'C', 1, 4),
(538, 'What is the solution for 5x - 15 = 0?', 'x = 2', 'x = 3', 'x = -3', 'x = 0', 'B', 1, 4),
(539, 'Solve: 2x + 5 = 15', 'x = 4', 'x = 5', 'x = 10', 'x = 15', 'A', 1, 4),
(540, 'Simplify: 3x + 7x - 5', '10x - 5', '10x + 5', '4x - 5', 'x + 2', 'A', 1, 4),
(541, 'Factor: x^2 + 11x + 28', '(x+4)(x+7)', '(x+1)(x+28)', '(x+2)(x+14)', '(x+3)(x+9)', 'A', 1, 4),
(542, 'Solve: x^2 = 49', 'x = 7', 'x = -7', 'x = ±7', 'x = 14', 'C', 1, 4),
(543, 'Find slope of line passing through (0,0) and (3,6)', '1', '2', '3', '6', 'B', 1, 4),
(544, 'If f(x) = 2x - 3, find f(5)', '7', '5', '10', '12', 'A', 1, 4),
(545, 'Simplify: x^3 * x^2', 'x^5', 'x^6', 'x^1', 'x^4', 'A', 1, 4),
(546, 'Simplify: (5x^2)(2x^3)', '10x^5', '7x^6', '10x^6', '5x^5', 'A', 1, 4),
(547, 'Factor: x^2 - 16', '(x-4)(x+4)', '(x-8)(x+2)', '(x+4)^2', '(x-4)^2', 'A', 1, 4),
(548, 'Solve: 4x - 9 = 7', 'x = 4', 'x = 2', 'x = 3', 'x = 1', 'B', 1, 4),
(549, 'Sum of roots of x^2 - 5x + 6 = 0?', '5', '-5', '6', '-6', 'A', 1, 4),
(550, 'Simplify: 6(x+2) - 3x', '3x + 12', '9x + 2', '3x - 12', '6x + 2', 'A', 1, 4),
(551, 'Factor completely: x^2 + 9x + 20', '(x+4)(x+5)', '(x+1)(x+20)', '(x+2)(x+10)', '(x+3)(x+7)', 'A', 1, 4),
(552, 'Solve: 3x^2 - 12 = 0', 'x = 2', 'x = -2', 'x = ±2', 'x = 4', 'C', 1, 4),
(553, 'If f(x) = x^2 + x, find f(3)', '12', '9', '6', '15', 'A', 1, 4),
(554, 'Simplify: (x^6)/(x^2)', 'x^4', 'x^8', 'x^3', 'x^2', 'A', 1, 4),
(555, 'Solve: x/4 + 3 = 7', 'x = 16', 'x = 12', 'x = 8', 'x = 4', 'A', 1, 4),
(556, 'Y-intercept of y = 5x + 8?', '5', '8', '0', '-8', 'B', 1, 4),
(557, 'Simplify: 3(x+5) + 2(x-3)', '5x + 9', '5x + 15', '5x + 6', '3x + 2', 'A', 1, 4),
(558, 'Solve: x^2 - 36 = 0', 'x = 6', 'x = -6', 'x = ±6', 'x = 12', 'C', 1, 4),
(559, 'Factor: x^2 - 7x + 10', '(x-5)(x-2)', '(x+5)(x-2)', '(x-2)(x-5)', '(x+2)(x+5)', 'A', 1, 4),
(560, 'Slope of line through (2,3) and (4,11)?', '2', '3', '4', '5', 'C', 1, 4),
(561, 'Simplify: (x^2y^3)*(x^3y^2)', 'x^5y^5', 'x^6y^6', 'x^5y^6', 'x^6y^5', 'A', 1, 4),
(562, 'Solve: 7x + 2 = 16', 'x = 2', 'x = 3', 'x = 5', 'x = 7', 'C', 1, 4),
(563, 'Simplify: (x^7)/(x^4)', 'x^3', 'x^11', 'x^4', 'x^7', 'A', 1, 4),
(564, 'Solve: x^2 + 10x + 25 = 0', 'x = 5', 'x = -5', 'x = ±5', 'x = 0', 'C', 1, 4),
(565, 'Factor: x^2 + 12x + 35', '(x+5)(x+7)', '(x+1)(x+35)', '(x+7)(x+7)', '(x+12)(x+35)', 'A', 1, 4),
(566, 'Simplify: 2(x-3) + 3(x+4)', '5x + 6', '5x + 10', 'x + 1', '5x + 8', 'D', 1, 4),
(567, 'Solve: 5x - 11 = 9', 'x = 4', 'x = 5', 'x = 6', 'x = 7', 'C', 1, 4),
(568, 'Simplify: 3x + 2x - 6', '5x - 6', '5x + 6', 'x - 6', '5x - 3', 'A', 1, 4),
(569, 'Solve: 4x^2 - 16 = 0', 'x = 2', 'x = -2', 'x = ±2', 'x = 4', 'C', 1, 4),
(570, 'Factor: x^2 - 6x + 8', '(x-4)(x-2)', '(x+4)(x+2)', '(x-1)(x-8)', '(x+6)(x+2)', 'A', 1, 4),
(571, 'Solution of 9x + 18 = 0?', 'x = 2', 'x = -2', 'x = -2', 'x = 0', 'C', 1, 4),
(572, 'Simplify: (3x^2)*(4x^3)', '12x^5', '7x^6', '12x^6', '6x^5', 'A', 1, 4),
(573, 'Solve: x/6 + 2 = 5', 'x = 18', 'x = 12', 'x = 6', 'x = 24', 'A', 1, 4),
(574, 'Simplify: x^4 * x^3', 'x^7', 'x^12', 'x^1', 'x^8', 'A', 1, 4),
(575, 'Solve: x^2 - 49 = 0', 'x = 7', 'x = -7', 'x = ±7', 'x = 0', 'C', 1, 4),
(576, 'Factor: x^2 + 7x + 12', '(x+3)(x+4)', '(x+1)(x+12)', '(x+4)(x+3)', '(x+7)(x+12)', 'A', 1, 4),
(577, 'Simplify: 4(x+2) - 3(x-1)', 'x + 11', 'x + 7', 'x + 5', 'x + 9', 'B', 1, 4),
(578, 'Solve: 3x + 8 = 20', 'x = 3', 'x = 4', 'x = 5', 'x = 6', 'C', 1, 4),
(579, 'Factor: x^2 - 5x + 6', '(x-2)(x-3)', '(x+2)(x+3)', '(x-1)(x-6)', '(x+1)(x+6)', 'A', 1, 4),
(580, 'Solve: 2x - 7 = 5', 'x = 5', 'x = 6', 'x = 7', 'x = 8', 'B', 1, 4),
(581, 'Simplify: (2x^3)*(3x^2)', '6x^5', '5x^6', '6x^6', '6x^8', 'A', 1, 4),
(582, 'Solve: x^2 + 8x + 16 = 0', 'x = 4', 'x = -4', 'x = -4', 'x = 0', 'C', 1, 4),
(583, 'What is the solution of 6x - 18 = 0?', 'x = 3', 'x = -3', 'x = 2', 'x = 0', 'A', 1, 4),
(584, 'Factor: x^2 - 9x + 20', '(x-4)(x-5)', '(x-2)(x-10)', '(x-5)(x-4)', '(x-9)(x-2)', 'A', 1, 4),
(585, 'Simplify: 5(x+2) - 3(x-1)', '2x + 11', '8x + 5', '5x + 5', '5x + 1', 'A', 1, 4),
(586, 'Solve: 3x - 9 = 0', 'x = 3', 'x = -3', 'x = 0', 'x = 9', 'A', 1, 4),
(587, 'Simplify: 4x^2 * 2x^3', '8x^5', '6x^6', '8x^6', '6x^5', 'A', 1, 4),
(588, 'Solve: x^2 + 6x + 9 = 0', 'x = 3', 'x = -3', 'x = -3', 'x = 0', 'C', 1, 4),
(589, 'What is the solution for 7x - 14 = 0?', 'x = 2', 'x = 3', 'x = -2', 'x = 0', 'C', 1, 4),
(590, 'Factor: x^2 + 10x + 21', '(x+3)(x+7)', '(x+1)(x+21)', '(x+7)(x+3)', '(x+10)(x+21)', 'A', 1, 4),
(591, 'Simplify: 3(x+4) - 2(x-1)', 'x + 14', 'x + 11', 'x + 10', 'x + 13', 'B', 1, 4),
(592, 'Solve: 5x + 7 = 22', 'x = 3', 'x = 4', 'x = 5', 'x = 6', 'C', 1, 4),
(593, 'Factor: x^2 - 8x + 15', '(x-3)(x-5)', '(x-5)(x-3)', '(x-2)(x-7)', '(x-8)(x-15)', 'A', 1, 4),
(594, 'Solve: 4x - 12 = 0', 'x = 3', 'x = -3', 'x = 0', 'x = 12', 'A', 1, 4),
(595, 'Simplify: (3x^2)*(5x^3)', '15x^5', '8x^6', '15x^6', '15x^8', 'A', 1, 4),
(596, 'Solve: 2x + 5 = 15', 'x = 4', 'x = 5', 'x = 10', 'x = 15', 'A', 1, 4),
(597, 'Simplify: 3x + 7x - 5', '10x - 5', '10x + 5', '4x - 5', 'x + 2', 'A', 1, 4),
(598, 'Factor: x^2 + 11x + 28', '(x+4)(x+7)', '(x+1)(x+28)', '(x+2)(x+14)', '(x+3)(x+9)', 'A', 1, 4),
(599, 'Solve: x^2 = 49', 'x = 7', 'x = -7', 'x = ±7', 'x = 14', 'C', 1, 4),
(600, 'Find slope of line passing through (0,0) and (3,6)', '1', '2', '3', '6', 'B', 1, 4),
(601, 'If f(x) = 2x - 3, find f(5)', '7', '5', '10', '12', 'A', 1, 4),
(602, 'Simplify: x^3 * x^2', 'x^5', 'x^6', 'x^1', 'x^4', 'A', 1, 4),
(603, 'Simplify: (5x^2)(2x^3)', '10x^5', '7x^6', '10x^6', '5x^5', 'A', 1, 4),
(604, 'Factor: x^2 - 16', '(x-4)(x+4)', '(x-8)(x+2)', '(x+4)^2', '(x-4)^2', 'A', 1, 4),
(605, 'Solve: 4x - 9 = 7', 'x = 4', 'x = 2', 'x = 3', 'x = 1', 'B', 1, 4),
(606, 'Sum of roots of x^2 - 5x + 6 = 0?', '5', '-5', '6', '-6', 'A', 1, 4),
(607, 'Simplify: 6(x+2) - 3x', '3x + 12', '9x + 2', '3x - 12', '6x + 2', 'A', 1, 4),
(608, 'Factor completely: x^2 + 9x + 20', '(x+4)(x+5)', '(x+1)(x+20)', '(x+2)(x+10)', '(x+3)(x+7)', 'A', 1, 4),
(609, 'Solve: 3x^2 - 12 = 0', 'x = 2', 'x = -2', 'x = ±2', 'x = 4', 'C', 1, 4),
(610, 'If f(x) = x^2 + x, find f(3)', '12', '9', '6', '15', 'A', 1, 4),
(611, 'Simplify: (x^6)/(x^2)', 'x^4', 'x^8', 'x^3', 'x^2', 'A', 1, 4),
(612, 'Solve: x/4 + 3 = 7', 'x = 16', 'x = 12', 'x = 8', 'x = 4', 'A', 1, 4),
(613, 'Y-intercept of y = 5x + 8?', '5', '8', '0', '-8', 'B', 1, 4),
(614, 'Simplify: 3(x+5) + 2(x-3)', '5x + 9', '5x + 15', '5x + 6', '3x + 2', 'A', 1, 4),
(615, 'Solve: x^2 - 36 = 0', 'x = 6', 'x = -6', 'x = ±6', 'x = 12', 'C', 1, 4),
(616, 'Factor: x^2 - 7x + 10', '(x-5)(x-2)', '(x+5)(x-2)', '(x-2)(x-5)', '(x+2)(x+5)', 'A', 1, 4),
(617, 'Slope of line through (2,3) and (4,11)?', '2', '3', '4', '5', 'C', 1, 4),
(618, 'Simplify: (x^2y^3)*(x^3y^2)', 'x^5y^5', 'x^6y^6', 'x^5y^6', 'x^6y^5', 'A', 1, 4),
(619, 'Solve: 7x + 2 = 16', 'x = 2', 'x = 3', 'x = 5', 'x = 7', 'C', 1, 4),
(620, 'Simplify: (x^7)/(x^4)', 'x^3', 'x^11', 'x^4', 'x^7', 'A', 1, 4),
(621, 'Solve: x^2 + 10x + 25 = 0', 'x = 5', 'x = -5', 'x = ±5', 'x = 0', 'C', 1, 4),
(622, 'Factor: x^2 + 12x + 35', '(x+5)(x+7)', '(x+1)(x+35)', '(x+7)(x+7)', '(x+12)(x+35)', 'A', 1, 4),
(623, 'Simplify: 2(x-3) + 3(x+4)', '5x + 6', '5x + 10', 'x + 1', '5x + 8', 'D', 1, 4),
(624, 'Solve: 5x - 11 = 9', 'x = 4', 'x = 5', 'x = 6', 'x = 7', 'C', 1, 4),
(625, 'Simplify: 3x + 2x - 6', '5x - 6', '5x + 6', 'x - 6', '5x - 3', 'A', 1, 4),
(626, 'Solve: 4x^2 - 16 = 0', 'x = 2', 'x = -2', 'x = ±2', 'x = 4', 'C', 1, 4),
(627, 'Factor: x^2 - 6x + 8', '(x-4)(x-2)', '(x+4)(x+2)', '(x-1)(x-8)', '(x+6)(x+2)', 'A', 1, 4),
(628, 'Solution of 9x + 18 = 0?', 'x = 2', 'x = -2', 'x = -2', 'x = 0', 'C', 1, 4),
(629, 'Simplify: (3x^2)*(4x^3)', '12x^5', '7x^6', '12x^6', '6x^5', 'A', 1, 4),
(630, 'Solve: x/6 + 2 = 5', 'x = 18', 'x = 12', 'x = 6', 'x = 24', 'A', 1, 4),
(631, 'Simplify: x^4 * x^3', 'x^7', 'x^12', 'x^1', 'x^8', 'A', 1, 4),
(632, 'Solve: x^2 - 49 = 0', 'x = 7', 'x = -7', 'x = ±7', 'x = 0', 'C', 1, 4),
(633, 'Factor: x^2 + 7x + 12', '(x+3)(x+4)', '(x+1)(x+12)', '(x+4)(x+3)', '(x+7)(x+12)', 'A', 1, 4),
(634, 'Simplify: 4(x+2) - 3(x-1)', 'x + 11', 'x + 7', 'x + 5', 'x + 9', 'B', 1, 4),
(635, 'Solve: 3x + 8 = 20', 'x = 3', 'x = 4', 'x = 5', 'x = 6', 'C', 1, 4),
(636, 'Factor: x^2 - 5x + 6', '(x-2)(x-3)', '(x+2)(x+3)', '(x-1)(x-6)', '(x+1)(x+6)', 'A', 1, 4),
(637, 'Solve: 2x - 7 = 5', 'x = 5', 'x = 6', 'x = 7', 'x = 8', 'B', 1, 4),
(638, 'Simplify: (2x^3)*(3x^2)', '6x^5', '5x^6', '6x^6', '6x^8', 'A', 1, 4),
(639, 'Solve: x^2 + 8x + 16 = 0', 'x = 4', 'x = -4', 'x = -4', 'x = 0', 'C', 1, 4),
(640, 'What is the solution of 6x - 18 = 0?', 'x = 3', 'x = -3', 'x = 2', 'x = 0', 'A', 1, 4),
(641, 'Factor: x^2 - 9x + 20', '(x-4)(x-5)', '(x-2)(x-10)', '(x-5)(x-4)', '(x-9)(x-2)', 'A', 1, 4),
(642, 'Simplify: 5(x+2) - 3(x-1)', '2x + 11', '8x + 5', '5x + 5', '5x + 1', 'A', 1, 4),
(643, 'Solve: 3x - 9 = 0', 'x = 3', 'x = -3', 'x = 0', 'x = 9', 'A', 1, 4),
(644, 'Simplify: 4x^2 * 2x^3', '8x^5', '6x^6', '8x^6', '6x^5', 'A', 1, 4),
(645, 'Solve: x^2 + 6x + 9 = 0', 'x = 3', 'x = -3', 'x = -3', 'x = 0', 'C', 1, 4),
(646, 'What is the solution for 7x - 14 = 0?', 'x = 2', 'x = 3', 'x = -2', 'x = 0', 'C', 1, 4),
(647, 'Factor: x^2 + 10x + 21', '(x+3)(x+7)', '(x+1)(x+21)', '(x+7)(x+3)', '(x+10)(x+21)', 'A', 1, 4),
(648, 'Simplify: 3(x+4) - 2(x-1)', 'x + 14', 'x + 11', 'x + 10', 'x + 13', 'B', 1, 4),
(649, 'Solve: 5x + 7 = 22', 'x = 3', 'x = 4', 'x = 5', 'x = 6', 'C', 1, 4),
(650, 'Factor: x^2 - 8x + 15', '(x-3)(x-5)', '(x-5)(x-3)', '(x-2)(x-7)', '(x-8)(x-15)', 'A', 1, 4),
(651, 'Solve: 4x - 12 = 0', 'x = 3', 'x = -3', 'x = 0', 'x = 12', 'A', 1, 4),
(652, 'Simplify: (3x^2)*(5x^3)', '15x^5', '8x^6', '15x^6', '15x^8', 'A', 1, 4),
(653, 'Which AI technique is used for anomaly detection?', 'Isolation Forest', 'Binary Search', 'Bubble Sort', 'Quick Sort', 'A', 1, 5),
(654, 'Which AI method is used for dimensionality reduction?', 'PCA', 'Linear Search', 'Binary Search', 'Quick Sort', 'A', 1, 5),
(655, 'Which is a type of machine learning?', 'Supervised Learning', 'Linear Programming', 'Bubble Sort', 'HTML', 'A', 1, 5),
(656, 'Which AI technique is used for text summarization?', 'Natural Language Processing', 'Quick Sort', 'Binary Search', 'Excel', 'A', 1, 5),
(657, 'Which AI tool is used for data visualization?', 'Matplotlib', 'Word', 'Notepad', 'Excel', 'A', 1, 5),
(658, 'Which AI application is in fraud detection?', 'Credit card fraud detection', 'File storing', 'Typing text', 'Printing documents', 'A', 1, 5),
(659, 'Which AI model can generate text?', 'GPT', 'Excel', 'Word', 'Notepad', 'A', 1, 5),
(660, 'Which AI type is used for predicting continuous values?', 'Regression', 'Clustering', 'Sorting', 'Searching', 'A', 1, 5),
(661, 'Which AI type is used for grouping data?', 'Clustering', 'Regression', 'Sorting', 'Searching', 'A', 1, 5),
(662, 'Which AI application is used in email?', 'Spam filtering', 'File storing', 'Printing documents', 'Typing text', 'A', 1, 5),
(663, 'Which AI tool is used for reinforcement learning?', 'OpenAI Gym', 'Excel', 'Word', 'Notepad', 'A', 1, 5),
(664, 'Which AI technique mimics human memory?', 'Neural Networks', 'Sorting', 'Binary Search', 'HTML', 'A', 1, 5),
(665, 'Which AI application is in e-commerce?', 'Product recommendation', 'Typing text', 'Printing documents', 'File storing', 'A', 1, 5),
(666, 'Which AI tool is for deep reinforcement learning?', 'TensorFlow', 'Excel', 'Word', 'Notepad', 'A', 1, 5),
(667, 'Which AI application is in speech synthesis?', 'Text-to-Speech', 'Email sending', 'File storing', 'Printing documents', 'A', 1, 5),
(668, 'Which AI model predicts sequences?', 'RNN', 'Linear Search', 'Quick Sort', 'Bubble Sort', 'A', 1, 5),
(669, 'Which AI technique is used in face detection?', 'Haar Cascade', 'Binary Search', 'Bubble Sort', 'Quick Sort', 'A', 1, 5),
(670, 'Which AI model can translate languages?', 'Transformer', 'Linear Search', 'Bubble Sort', 'Quick Sort', 'A', 1, 5),
(671, 'Which AI technique is used in autonomous drones?', 'Computer Vision', 'Word Processing', 'File Storing', 'Printing', 'A', 1, 5),
(672, 'Which AI type is rule-based?', 'Expert System', 'Machine Learning', 'Neural Network', 'Reinforcement Learning', 'A', 1, 5),
(673, 'Which AI application is in healthcare diagnosis?', 'Disease prediction', 'Typing documents', 'Printing files', 'File storing', 'A', 1, 5),
(674, 'Which AI model is generative?', 'GAN', 'Binary Search', 'Quick Sort', 'Bubble Sort', 'A', 1, 5),
(675, 'Which AI model is discriminative?', 'Decision Tree', 'GAN', 'Quick Sort', 'Bubble Sort', 'A', 1, 5),
(676, 'Which AI technique is used in object detection?', 'YOLO', 'Linear Search', 'Bubble Sort', 'Quick Sort', 'A', 1, 5),
(677, 'Which AI algorithm is used for optimization?', 'Genetic Algorithm', 'Binary Search', 'Quick Sort', 'Bubble Sort', 'A', 1, 5),
(678, 'Which AI type can handle uncertainty?', 'Fuzzy Logic', 'Linear Search', 'Bubble Sort', 'Quick Sort', 'A', 1, 5),
(679, 'Which AI application is in smart homes?', 'Voice assistants', 'Printing documents', 'Typing text', 'File storing', 'A', 1, 5),
(680, 'Which AI application is in manufacturing?', 'Industrial automation', 'Typing text', 'Printing documents', 'File storing', 'A', 1, 5),
(681, 'Which AI technique is used in games like Go?', 'Monte Carlo Tree Search', 'Binary Search', 'Quick Sort', 'Bubble Sort', 'A', 1, 5),
(682, 'Which AI model is used for recommendation systems?', 'Collaborative Filtering', 'Binary Search', 'Bubble Sort', 'Quick Sort', 'A', 1, 5),
(683, 'Which AI tool is used for NLP?', 'NLTK', 'Word', 'Excel', 'Notepad', 'A', 1, 5),
(684, 'Which AI tool is used for computer vision?', 'OpenCV', 'Excel', 'Word', 'Notepad', 'A', 1, 5),
(685, 'Which AI application is in gaming bots?', 'AI opponents', 'Typing text', 'Printing documents', 'File storing', 'A', 1, 5),
(686, 'Which AI algorithm is used in spam detection?', 'Naive Bayes', 'Binary Search', 'Quick Sort', 'Bubble Sort', 'A', 1, 5),
(687, 'Which AI model is used for image classification?', 'CNN', 'Linear Search', 'Bubble Sort', 'Quick Sort', 'A', 1, 5),
(688, 'Which AI technique is unsupervised?', 'Clustering', 'Linear Regression', 'Sorting', 'Searching', 'A', 1, 5),
(689, 'Which AI application is in translation apps?', 'Google Translate', 'Email sending', 'File storing', 'Typing documents', 'A', 1, 5),
(690, 'Which AI algorithm is used for predictive analytics?', 'Regression', 'Binary Search', 'Quick Sort', 'Bubble Sort', 'A', 1, 5),
(691, 'Which AI tool is for deep learning?', 'Keras', 'Excel', 'Word', 'Notepad', 'A', 1, 5),
(692, 'Which AI tool is for ML workflows?', 'Scikit-learn', 'Word', 'Excel', 'Notepad', 'A', 1, 5),
(693, 'Which AI technique is model-based?', 'Bayesian Networks', 'Linear Search', 'Quick Sort', 'Bubble Sort', 'A', 1, 5),
(694, 'Which AI application is in social media analytics?', 'Sentiment analysis', 'Typing text', 'Printing documents', 'File storing', 'A', 1, 5),
(695, 'Which AI algorithm is for time series prediction?', 'ARIMA', 'Binary Search', 'Quick Sort', 'Bubble Sort', 'A', 1, 5),
(696, 'Which AI application is in autonomous robots?', 'Self-operating robots', 'Typing text', 'Printing documents', 'File storing', 'A', 1, 5),
(697, 'Which AI type learns from interaction?', 'Reinforcement Learning', 'Linear Search', 'Bubble Sort', 'Quick Sort', 'A', 1, 5),
(698, 'Which AI model predicts sequences of text?', 'RNN', 'Binary Search', 'Quick Sort', 'Bubble Sort', 'A', 1, 5),
(699, 'Which AI tool is used for data preprocessing?', 'Pandas', 'Excel', 'Word', 'Notepad', 'A', 1, 5),
(700, 'Which AI application is in email assistants?', 'Smart email reply', 'Typing text', 'Printing documents', 'File storing', 'A', 1, 5),
(701, 'Which AI technique is used in recommendation algorithms?', 'Collaborative Filtering', 'Linear Search', 'Bubble Sort', 'Quick Sort', 'A', 1, 5),
(702, 'Which AI tool is used for reinforcement learning?', 'OpenAI Gym', 'Excel', 'Word', 'Notepad', 'A', 1, 5),
(703, 'Which AI application is in image recognition?', 'Face detection', 'Printing documents', 'Typing text', 'File storing', 'A', 1, 5),
(704, 'Which AI model is used for generating images?', 'GAN', 'Linear Search', 'Bubble Sort', 'Quick Sort', 'A', 1, 5),
(705, 'Which AI technique is used in smart assistants?', 'Voice recognition', 'Binary Search', 'Quick Sort', 'Bubble Sort', 'A', 1, 5),
(706, 'Which of the following is a noun?', 'Dog', 'Run', 'Beautiful', 'Quickly', 'A', 1, 6),
(707, 'Which of the following is a verb?', 'Jump', 'Cat', 'Table', 'Red', 'A', 1, 6),
(708, 'Which of the following is an adjective?', 'Happy', 'Run', 'Dog', 'Eat', 'A', 1, 6),
(709, 'Choose the correct plural form of \"Child\".', 'Children', 'Childs', 'Childes', 'Child', 'A', 1, 6),
(710, 'Choose the correct plural form of \"Man\".', 'Men', 'Mans', 'Mens', 'Man', 'A', 1, 6),
(711, 'Choose the correct plural form of \"Woman\".', 'Women', 'Womans', 'Womans', 'Woman', 'A', 1, 6),
(712, 'Identify the pronoun in the sentence: \"She is reading a book.\"', 'She', 'Book', 'Reading', 'Is', 'A', 1, 6),
(713, 'Identify the verb in the sentence: \"They are playing football.\"', 'Playing', 'They', 'Football', 'Are', 'A', 1, 6),
(714, 'Identify the adjective: \"The red car is fast.\"', 'Red', 'Car', 'Fast', 'Is', 'A', 1, 6),
(715, 'Select the correct article: \"__ apple a day keeps the doctor away.\"', 'An', 'A', 'The', 'No article', 'A', 1, 6),
(716, 'Select the correct article: \"__ sun rises in the east.\"', 'The', 'A', 'An', 'No article', 'A', 1, 6),
(717, 'Select the correct article: \"__ university is famous.\"', 'A', 'An', 'The', 'No article', 'A', 1, 6),
(718, 'Choose the correct tense: \"She ____ to school every day.\"', 'Goes', 'Went', 'Going', 'Go', 'A', 1, 6),
(719, 'Choose the correct tense: \"They ____ dinner last night.\"', 'Ate', 'Eat', 'Eats', 'Eating', 'A', 1, 6),
(720, 'Choose the correct tense: \"I ____ my homework now.\"', 'Am doing', 'Did', 'Do', 'Does', 'A', 1, 6),
(721, 'Select the correct preposition: \"He is sitting ___ the chair.\"', 'On', 'In', 'Under', 'Over', 'A', 1, 6),
(722, 'Select the correct preposition: \"The cat is ___ the table.\"', 'On', 'In', 'Under', 'Above', 'A', 1, 6),
(723, 'Select the correct preposition: \"She walked ___ the park.\"', 'Through', 'Over', 'On', 'Under', 'A', 1, 6),
(724, 'Identify the conjunction: \"I like tea and coffee.\"', 'And', 'Tea', 'Coffee', 'Like', 'A', 1, 6),
(725, 'Identify the conjunction: \"I will go if it does not rain.\"', 'If', 'Go', 'Rain', 'Will', 'A', 1, 6),
(726, 'Identify the conjunction: \"He is rich but unhappy.\"', 'But', 'Rich', 'Unhappy', 'He', 'A', 1, 6),
(727, 'Select the correct sentence:', 'She runs fast.', 'She run fast.', 'She running fast.', 'She ran fastly.', 'A', 1, 6),
(728, 'Select the correct sentence:', 'They are playing.', 'They playing.', 'They is playing.', 'They plays.', 'A', 1, 6),
(729, 'Select the correct sentence:', 'I have a pen.', 'I has a pen.', 'I haves a pen.', 'I having a pen.', 'A', 1, 6),
(730, 'Choose the correct synonym of \"Happy\".', 'Joyful', 'Sad', 'Angry', 'Tired', 'A', 1, 6),
(731, 'Choose the correct synonym of \"Big\".', 'Large', 'Small', 'Tiny', 'Short', 'A', 1, 6),
(732, 'Choose the correct synonym of \"Fast\".', 'Quick', 'Slow', 'Late', 'Weak', 'A', 1, 6),
(733, 'Choose the correct antonym of \"Hot\".', 'Cold', 'Warm', 'Boiling', 'Fire', 'A', 1, 6),
(734, 'Choose the correct antonym of \"Easy\".', 'Difficult', 'Simple', 'Light', 'Smooth', 'A', 1, 6),
(735, 'Choose the correct antonym of \"Light\".', 'Heavy', 'Bright', 'Soft', 'Warm', 'A', 1, 6),
(736, 'Identify the correct spelling:', 'Accommodate', 'Acommodate', 'Accomodate', 'Acomodate', 'A', 1, 6),
(737, 'Identify the correct spelling:', 'Definitely', 'Definately', 'Definatly', 'Definitley', 'A', 1, 6),
(738, 'Identify the correct spelling:', 'Necessary', 'Neccessary', 'Necassary', 'Nessary', 'A', 1, 6),
(739, 'Select the correct form of \"Be\": \"He ___ happy.\"', 'Is', 'Are', 'Am', 'Be', 'A', 1, 6),
(740, 'Select the correct form of \"Be\": \"They ___ ready.\"', 'Are', 'Is', 'Am', 'Be', 'A', 1, 6),
(741, 'Select the correct form of \"Be\": \"I ___ a student.\"', 'Am', 'Is', 'Are', 'Be', 'A', 1, 6),
(742, 'Choose the correct sentence:', 'I will call you tomorrow.', 'I will calling you tomorrow.', 'I will calls you tomorrow.', 'I will called you tomorrow.', 'A', 1, 6),
(743, 'Choose the correct sentence:', 'She has eaten her lunch.', 'She have eaten her lunch.', 'She has eat her lunch.', 'She had eats her lunch.', 'A', 1, 6),
(744, 'Choose the correct sentence:', 'They went to the market.', 'They goes to the market.', 'They go to the market.', 'They going to the market.', 'A', 1, 6),
(745, 'Choose the correct question:', 'What is your name?', 'What your name is?', 'Your name is what?', 'Name is what?', 'A', 1, 6),
(746, 'Choose the correct question:', 'Where do you live?', 'Where you live?', 'Do you live where?', 'Your live where?', 'A', 1, 6),
(747, 'Choose the correct question:', 'How old are you?', 'How you are old?', 'Your age how?', 'How you old?', 'A', 1, 6),
(748, 'Choose the correct form of plural:', 'Mice', 'Mouses', 'Mouse', 'Mices', 'A', 1, 6),
(749, 'Choose the correct form of plural:', 'Teeth', 'Tooths', 'Tooth', 'Teeths', 'A', 1, 6),
(750, 'Choose the correct form of plural:', 'Feet', 'Foots', 'Foot', 'Feets', 'A', 1, 6),
(751, 'Choose the correct homonym: \"I want to write a letter.\"', 'Write', 'Right', 'Rite', 'Wright', 'A', 1, 6),
(752, 'Choose the correct homonym: \"Turn right at the corner.\"', 'Right', 'Write', 'Rite', 'Wright', 'A', 1, 6),
(753, 'Choose the correct homonym: \"The ceremony was a rite.\"', 'Rite', 'Right', 'Write', 'Wright', 'A', 1, 6),
(754, 'Choose the correct form: \"He ___ gone to school.\"', 'Has', 'Have', 'Had', 'Having', 'A', 1, 6),
(755, 'Choose the correct form: \"They ___ been friends.\"', 'Have', 'Has', 'Had', 'Having', 'A', 1, 6),
(756, 'Choose the correct form: \"I ___ finished my homework.\"', 'Have', 'Has', 'Had', 'Having', 'A', 1, 6),
(757, 'Select the correct sentence:', 'She is taller than me.', 'She is more tall than me.', 'She taller than me.', 'She tallest than me.', 'A', 1, 6),
(758, 'Select the correct sentence:', 'He runs faster than his brother.', 'He run faster than his brother.', 'He runs more fast than his brother.', 'He running faster than his brother.', 'A', 1, 6),
(759, 'Select the correct sentence:', 'This is the best book I have read.', 'This is the more best book I have read.', 'This is best book I have read.', 'This is the good book I have read.', 'A', 1, 6),
(760, 'Identify the adverb in the sentence: \"She sings beautifully.\"', 'Beautifully', 'Sings', 'She', 'Song', 'A', 1, 6),
(761, 'Identify the adverb in the sentence: \"He runs quickly.\"', 'Quickly', 'He', 'Runs', 'Fast', 'A', 1, 6),
(762, 'Identify the adverb in the sentence: \"They worked hard.\"', 'Hard', 'They', 'Worked', 'Labor', 'A', 1, 6),
(763, 'Choose the correct tense: \"I ___ seen that movie.\"', 'Have', 'Has', 'Had', 'Having', 'A', 1, 6),
(764, 'Choose the correct tense: \"She ___ finished her work.\"', 'Has', 'Have', 'Had', 'Having', 'A', 1, 6),
(765, 'Choose the correct tense: \"They ___ arrived.\"', 'Have', 'Has', 'Had', 'Having', 'A', 1, 6),
(766, 'Identify the pronoun: \"It is raining.\"', 'It', 'Rain', 'Raining', 'Is', 'A', 1, 6),
(767, 'Identify the pronoun: \"We are going to school.\"', 'We', 'Going', 'School', 'Are', 'A', 1, 6),
(768, 'Identify the pronoun: \"You should try.\"', 'You', 'Try', 'Should', 'Do', 'A', 1, 6),
(769, 'Choose the correct conjunction: \"I like tea ___ I like coffee.\"', 'And', 'But', 'Or', 'So', 'A', 1, 6),
(770, 'Which of the following is a strong password?', 'P@ssw0rd123', '123456', 'password', 'abcd', 'A', 1, 7),
(771, 'What does CIA stand for in cybersecurity?', 'Confidentiality, Integrity, Availability', 'Control, Integrity, Access', 'Confidential, Internal, Access', 'Cyber, Integrity, Algorithm', 'A', 1, 7),
(772, 'What is phishing?', 'Tricking users to reveal sensitive information', 'Physical theft', 'Virus infection', 'Password cracking', 'A', 1, 7),
(773, 'Which of these is a malware?', 'Trojan', 'Firewall', 'VPN', 'Encryption', 'A', 1, 7),
(774, 'What is a firewall used for?', 'To block unauthorized access', 'To store passwords', 'To encrypt data', 'To track users', 'A', 1, 7),
(775, 'What does SSL stand for?', 'Secure Sockets Layer', 'Simple Security Layer', 'System Safety Level', 'Secure System Login', 'A', 1, 7),
(776, 'What is a DDoS attack?', 'Distributed Denial of Service', 'Data Delivery over Server', 'Digital Domain of Security', 'Distributed Data on System', 'A', 1, 7),
(777, 'Which is a type of social engineering attack?', 'Phishing', 'SQL Injection', 'DDoS', 'Port scanning', 'A', 1, 7),
(778, 'Which is used to encrypt data?', 'AES', 'HTML', 'CSS', 'JavaScript', 'A', 1, 7),
(779, 'What does VPN stand for?', 'Virtual Private Network', 'Verified Protected Network', 'Virtual Public Network', 'Visual Private Node', 'A', 1, 7),
(780, 'What is the main goal of encryption?', 'Protect data confidentiality', 'Track user activity', 'Block websites', 'Monitor employees', 'A', 1, 7),
(781, 'Which type of attack involves guessing passwords?', 'Brute force', 'Phishing', 'Spoofing', 'Sniffing', 'A', 1, 7),
(782, 'Which is a two-factor authentication method?', 'Password + OTP', 'Username only', 'Password only', 'Email', 'A', 1, 7),
(783, 'What is malware?', 'Malicious software', 'Security software', 'Backup software', 'Firewall', 'A', 1, 7),
(784, 'What is ransomware?', 'Malware that locks data and demands payment', 'A secure software', 'A type of encryption', 'A firewall feature', 'A', 1, 7),
(785, 'What is spyware?', 'Software that spies on user activity', 'Software that encrypts files', 'Firewall tool', 'VPN service', 'A', 1, 7),
(786, 'What is a botnet?', 'Network of compromised computers', 'Secure cloud network', 'Firewall cluster', 'Antivirus system', 'A', 1, 7),
(787, 'What is SQL Injection?', 'Injecting malicious SQL commands', 'Phishing method', 'Network attack', 'Password cracking', 'A', 1, 7),
(788, 'What is XSS in cybersecurity?', 'Cross-site scripting', 'Cross system security', 'Extra security software', 'Encrypted site', 'A', 1, 7),
(789, 'Which is an example of physical security?', 'Locking server room', 'Antivirus software', 'VPN setup', 'Firewall rule', 'A', 1, 7),
(790, 'What is the main goal of a firewall?', 'Prevent unauthorized network access', 'Monitor employee productivity', 'Encrypt emails', 'Store passwords', 'A', 1, 7),
(791, 'What is the purpose of antivirus?', 'Detect and remove malware', 'Encrypt files', 'Block emails', 'Monitor users', 'A', 1, 7),
(792, 'Which protocol is used for secure web browsing?', 'HTTPS', 'HTTP', 'FTP', 'SMTP', 'A', 1, 7),
(793, 'What is a security patch?', 'Update to fix vulnerabilities', 'New hardware', 'Encryption key', 'Network device', 'A', 1, 7),
(794, 'Which is a common method of securing Wi-Fi?', 'WPA2', 'HTTP', 'FTP', 'SMTP', 'A', 1, 7),
(795, 'Which of these is a form of authentication?', 'Password', 'Phishing', 'Malware', 'Trojan', 'A', 1, 7),
(796, 'What is social engineering?', 'Manipulating people to reveal info', 'Encrypting files', 'Setting firewall', 'Scanning network', 'A', 1, 7),
(797, 'Which type of malware spreads by itself?', 'Worm', 'Trojan', 'Spyware', 'Adware', 'A', 1, 7),
(798, 'Which is a secure way to transmit sensitive data?', 'Encrypted connection', 'Email without encryption', 'Public Wi-Fi', 'USB stick', 'A', 1, 7),
(799, 'Which of these attacks intercepts network traffic?', 'Man-in-the-middle', 'Phishing', 'Ransomware', 'SQL Injection', 'A', 1, 7),
(800, 'Which of these is considered personal information?', 'Password', 'Random number', 'Website title', 'Image', 'A', 1, 7),
(801, 'Which is a strong password practice?', 'Mix letters, numbers, symbols', 'Use only name', 'Use \"12345\"', 'Use \"password\"', 'A', 1, 7),
(802, 'What is a certificate authority (CA)?', 'Entity that issues digital certificates', 'Malware software', 'Firewall tool', 'Encryption protocol', 'A', 1, 7),
(803, 'Which is a common cyber threat to businesses?', 'Ransomware', 'Power outage', 'Coffee spill', 'Printer jam', 'A', 1, 7),
(804, 'What is HTTPS used for?', 'Secure web communication', 'Send emails', 'File transfer', 'Network scanning', 'A', 1, 7),
(805, 'Which is a type of cyber attack?', 'Phishing', 'Cycling', 'Reading', 'Walking', 'A', 1, 7),
(806, 'Which protocol secures emails?', 'TLS/SSL', 'HTTP', 'FTP', 'SMTP', 'A', 1, 7),
(807, 'Which of these is a public key encryption method?', 'RSA', 'HTTP', 'SMTP', 'FTP', 'A', 1, 7),
(808, 'What is the purpose of a digital signature?', 'Verify sender authenticity', 'Encrypt files', 'Track location', 'Block malware', 'A', 1, 7),
(809, 'Which is considered sensitive data?', 'Bank account number', 'Company name', 'Street', 'Phonebook', 'A', 1, 7),
(810, 'Which of these is a network attack tool?', 'Sniffer', 'Word processor', 'Calculator', 'Video player', 'A', 1, 7),
(811, 'Which is a method of secure password storage?', 'Hashing', 'Storing as plain text', 'Emailing', 'Printing', 'A', 1, 7),
(812, 'What is brute force attack?', 'Trying all possible passwords', 'Phishing', 'Encryption', 'Firewall', 'A', 1, 7),
(813, 'Which is a security best practice?', 'Regular software updates', 'Ignore updates', 'Open unknown emails', 'Share passwords', 'A', 1, 7),
(814, 'Which is an example of two-factor authentication?', 'Password + SMS code', 'Password only', 'Username only', 'Email only', 'A', 1, 7),
(815, 'Which of these is a type of malware?', 'Trojan', 'Laptop', 'Printer', 'Scanner', 'A', 1, 7),
(816, 'Which is used to detect unauthorized access?', 'Intrusion Detection System', 'Antivirus', 'Firewall', 'VPN', 'A', 1, 7),
(817, 'Which is considered a weak password?', '123456', 'P@ssw0rd!', 'Abc$123', 'Qwerty!9', 'A', 1, 7),
(818, 'Which protocol is used for secure file transfer?', 'SFTP', 'HTTP', 'FTP', 'SMTP', 'A', 1, 7),
(819, 'Which is a security principle in cybersecurity?', 'Least privilege', 'Maximum access', 'Public sharing', 'Unlimited users', 'A', 1, 7),
(820, 'Which of these is a type of malware?', 'Adware', 'Antivirus', 'VPN', 'Firewall', 'A', 1, 7),
(821, 'Which is a common attack on websites?', 'SQL Injection', 'VPN', 'Firewall', 'Email client', 'A', 1, 7),
(822, 'Which is a common social engineering tactic?', 'Phishing', 'Hashing', 'Firewall', 'VPN', 'A', 1, 7),
(823, 'Which is a form of ransomware?', 'CryptoLocker', 'Antivirus', 'Firewall', 'VPN', 'A', 1, 7),
(824, 'Which is used to encrypt data at rest?', 'AES', 'HTML', 'CSS', 'FTP', 'A', 1, 7),
(825, 'Which of these is a password policy?', 'Minimum length', 'Maximum speed', 'Color preference', 'Font style', 'A', 1, 7),
(826, 'What is shoulder surfing?', 'Observing someone’s private info', 'Phishing email', 'Virus attack', 'Network scanning', 'A', 1, 7),
(827, 'What is a honeypot in security?', 'Decoy system to trap attackers', 'Antivirus software', 'Encryption tool', 'Firewall rule', 'A', 1, 7),
(828, 'What is multi-factor authentication?', 'Using more than one verification method', 'Using one password', 'Using username only', 'Using email only', 'A', 1, 7),
(829, 'Which is a security best practice?', 'Do not share passwords', 'Write passwords on paper', 'Use easy passwords', 'Ignore updates', 'A', 1, 7),
(830, 'Which is an example of a brute-force defense?', 'Account lockout', 'Ignore login', 'Use weak passwords', 'Share password', 'A', 1, 7),
(831, 'Which is a type of attack that sends massive traffic to a server?', 'DDoS', 'Phishing', 'Trojan', 'Virus', 'A', 1, 7),
(832, 'Which is a type of attack that exploits software bugs?', 'Exploit attack', 'Phishing', 'Shoulder surfing', 'Brute force', 'A', 1, 7),
(833, 'Which is a type of network attack?', 'Man-in-the-middle', 'Reading a book', 'Watching video', 'Typing document', 'A', 1, 7),
(834, 'Which of these is used to check system vulnerabilities?', 'Penetration testing', 'Word processor', 'Spreadsheet', 'Presentation', 'A', 1, 7),
(835, 'Which is a type of malware?', 'Rootkit', 'Laptop', 'Printer', 'Router', 'A', 1, 7),
(836, 'Which of these is a secure communication protocol?', 'HTTPS', 'HTTP', 'FTP', 'SMTP', 'A', 1, 7),
(837, 'Which is a common attack vector?', 'Email', 'Chair', 'Table', 'Pen', 'A', 1, 7),
(838, 'Which is considered a security threat?', 'Malware', 'Notebook', 'Pencil', 'Desk', 'A', 1, 7),
(839, 'Which is a security best practice?', 'Use strong passwords', 'Use same password everywhere', 'Write password on paper', 'Share password with friends', 'A', 1, 7),
(840, 'What does AI stand for?', 'Artificial Intelligence', 'Automated Interface', 'Advanced Internet', 'Algorithm Integration', 'A', 1, 8),
(841, 'Which of these is a branch of AI?', 'Machine Learning', 'Networking', 'Operating Systems', 'Database', 'A', 1, 8),
(842, 'Which AI technique mimics the human brain?', 'Neural Networks', 'Sorting', 'Compression', 'Encryption', 'A', 1, 8),
(843, 'What is supervised learning?', 'Learning with labeled data', 'Learning without data', 'Learning with encrypted data', 'Learning only online', 'A', 1, 8),
(844, 'What is unsupervised learning?', 'Learning without labeled data', 'Learning with labels', 'Learning using rules', 'Learning with teacher', 'A', 1, 8),
(845, 'Which AI field deals with understanding human language?', 'Natural Language Processing', 'Robotics', 'Networking', 'Database', 'A', 1, 8),
(846, 'Which AI technique is used for pattern recognition?', 'Neural Networks', 'Binary Search', 'Sorting', 'Encryption', 'A', 1, 8),
(847, 'Which AI algorithm is used for decision making?', 'Decision Trees', 'Linear Search', 'Bubble Sort', 'Hashing', 'A', 1, 8),
(848, 'Which is a type of machine learning?', 'Reinforcement Learning', 'Binary Search', 'Linked List', 'Quick Sort', 'A', 1, 8),
(849, 'Which AI branch focuses on robots?', 'Robotics', 'Networking', 'Database', 'Compiler Design', 'A', 1, 8),
(850, 'Which is a common AI application?', 'Chatbots', 'Word Processor', 'Spreadsheet', 'Email Client', 'A', 1, 8),
(851, 'Which is a type of reinforcement learning?', 'Q-Learning', 'Binary Search', 'Quick Sort', 'Hash Table', 'A', 1, 8),
(852, 'Which is an example of AI in healthcare?', 'Disease prediction', 'Typing document', 'Printing files', 'Watching video', 'A', 1, 8),
(853, 'Which AI method uses rewards and penalties?', 'Reinforcement Learning', 'Supervised Learning', 'Unsupervised Learning', 'Sorting Algorithm', 'A', 1, 8),
(854, 'Which is a type of AI search technique?', 'A* Search', 'Linear Search', 'Binary Search', 'Hashing', 'A', 1, 8),
(855, 'Which AI method is used for image recognition?', 'Convolutional Neural Networks', 'Decision Trees', 'Sorting', 'Hashing', 'A', 1, 8),
(856, 'Which is a learning method from experience?', 'Reinforcement Learning', 'Supervised Learning', 'Unsupervised Learning', 'Sorting', 'A', 1, 8),
(857, 'Which is a popular AI programming language?', 'Python', 'HTML', 'CSS', 'SQL', 'A', 1, 8),
(858, 'Which AI model is used for predicting numeric values?', 'Regression', 'Sorting', 'Linked List', 'Encryption', 'A', 1, 8),
(859, 'Which AI model is used for classification?', 'Decision Tree', 'Bubble Sort', 'Quick Sort', 'Hashing', 'A', 1, 8),
(860, 'Which AI technique is inspired by human evolution?', 'Genetic Algorithm', 'Linear Search', 'Sorting', 'Encryption', 'A', 1, 8),
(861, 'Which AI type learns from unlabeled data?', 'Unsupervised Learning', 'Supervised Learning', 'Reinforcement Learning', 'Sorting', 'A', 1, 8),
(862, 'Which AI type learns from labeled data?', 'Supervised Learning', 'Unsupervised Learning', 'Reinforcement Learning', 'Sorting', 'A', 1, 8),
(863, 'Which is a goal of AI?', 'Enable machines to think', 'Play music', 'Print documents', 'Store files', 'A', 1, 8),
(864, 'Which AI technique involves states and actions?', 'Reinforcement Learning', 'Supervised Learning', 'Unsupervised Learning', 'Sorting', 'A', 1, 8),
(865, 'Which AI field focuses on vision?', 'Computer Vision', 'Networking', 'Database', 'Compiler Design', 'A', 1, 8),
(866, 'Which AI is used in self-driving cars?', 'Autonomous AI', 'Database AI', 'Sorting AI', 'Networking AI', 'A', 1, 8),
(867, 'Which AI technique clusters data?', 'K-Means Clustering', 'Binary Search', 'Quick Sort', 'Hash Table', 'A', 1, 8),
(868, 'Which AI technique is used in recommendation systems?', 'Collaborative Filtering', 'Decision Trees', 'Bubble Sort', 'Linear Search', 'A', 1, 8),
(869, 'Which AI type uses reward signals?', 'Reinforcement Learning', 'Supervised Learning', 'Unsupervised Learning', 'Sorting', 'A', 1, 8),
(870, 'Which is an AI application in finance?', 'Fraud Detection', 'Typing document', 'Printing files', 'Watching video', 'A', 1, 8),
(871, 'Which AI method is used for game playing?', 'Minimax Algorithm', 'Binary Search', 'Sorting', 'Hashing', 'A', 1, 8),
(872, 'Which AI technique uses layers of neurons?', 'Neural Networks', 'Decision Trees', 'Sorting', 'Hashing', 'A', 1, 8),
(873, 'Which is a type of AI knowledge representation?', 'Ontology', 'Linked List', 'Array', 'Stack', 'A', 1, 8),
(874, 'Which is a type of search in AI?', 'Heuristic Search', 'Linear Search', 'Binary Search', 'Sorting', 'A', 1, 8),
(875, 'Which AI method is used for predicting sequences?', 'Recurrent Neural Network', 'Decision Tree', 'Quick Sort', 'Hashing', 'A', 1, 8),
(876, 'Which AI method is probabilistic?', 'Bayesian Network', 'Linear Search', 'Sorting', 'Linked List', 'A', 1, 8),
(877, 'Which is an AI application in robotics?', 'Path Planning', 'Typing document', 'Printing files', 'Watching video', 'A', 1, 8),
(878, 'Which AI technique reduces dimensions of data?', 'Principal Component Analysis', 'Decision Tree', 'Sorting', 'Hashing', 'A', 1, 8),
(879, 'Which AI field deals with reasoning?', 'Expert Systems', 'Networking', 'Database', 'Compiler Design', 'A', 1, 8),
(880, 'Which AI algorithm solves optimization problems?', 'Genetic Algorithm', 'Binary Search', 'Sorting', 'Hashing', 'A', 1, 8),
(881, 'Which AI technique predicts probabilities?', 'Naive Bayes', 'Decision Tree', 'Quick Sort', 'Hashing', 'A', 1, 8),
(882, 'Which AI model is used for text generation?', 'GPT', 'Decision Tree', 'Sorting', 'Hashing', 'A', 1, 8),
(883, 'Which is a type of AI agent?', 'Rational Agent', 'Physical Agent', 'Sorting Agent', 'Network Agent', 'A', 1, 8),
(884, 'Which AI field uses logic and rules?', 'Expert Systems', 'Networking', 'Database', 'Compiler Design', 'A', 1, 8),
(885, 'Which AI method improves by experience?', 'Machine Learning', 'Sorting', 'Linear Search', 'Hashing', 'A', 1, 8),
(886, 'Which AI field deals with speech?', 'Speech Recognition', 'Networking', 'Database', 'Compiler Design', 'A', 1, 8),
(887, 'Which AI application is used in translation?', 'Language Translator', 'Typing document', 'Printing files', 'Watching video', 'A', 1, 8),
(888, 'Which AI algorithm uses tree structures?', 'Decision Tree', 'Binary Search', 'Quick Sort', 'Hashing', 'A', 1, 8),
(889, 'Which AI model predicts future trends?', 'Time Series Forecasting', 'Sorting', 'Linked List', 'Encryption', 'A', 1, 8),
(890, 'Which AI method is used in face recognition?', 'Convolutional Neural Network', 'Decision Tree', 'Quick Sort', 'Hashing', 'A', 1, 8),
(891, 'Which AI type is model-free?', 'Reinforcement Learning', 'Supervised Learning', 'Unsupervised Learning', 'Sorting', 'A', 1, 8),
(892, 'Which AI technique is used in clustering?', 'K-Means', 'Decision Tree', 'Quick Sort', 'Hashing', 'A', 1, 8),
(893, 'Which AI is used for natural interaction with machines?', 'Chatbots', 'Database', 'Networking', 'Operating System', 'A', 1, 8),
(894, 'Which AI application is used for object detection?', 'Computer Vision', 'Word Processor', 'Spreadsheet', 'Email Client', 'A', 1, 8),
(895, 'Which AI technique reduces overfitting?', 'Regularization', 'Binary Search', 'Sorting', 'Hashing', 'A', 1, 8),
(896, 'Which AI technique is used in reinforcement environments?', 'Q-Learning', 'Linear Search', 'Bubble Sort', 'Hashing', 'A', 1, 8),
(897, 'Which AI algorithm is used for shortest path finding?', 'A* Algorithm', 'Binary Search', 'Sorting', 'Hashing', 'A', 1, 8),
(898, 'Which AI method uses layers to extract features?', 'CNN', 'Decision Tree', 'Quick Sort', 'Hashing', 'A', 1, 8),
(899, 'Which AI method uses reward feedback?', 'Reinforcement Learning', 'Supervised Learning', 'Unsupervised Learning', 'Sorting', 'A', 1, 8),
(900, 'Which AI technique is used in recommendation engines?', 'Collaborative Filtering', 'Decision Tree', 'Bubble Sort', 'Linear Search', 'A', 1, 8),
(901, 'Which AI method is used to summarize text?', 'NLP Summarization', 'Sorting', 'Binary Search', 'Linked List', 'A', 1, 8),
(902, 'Which AI technique is used for anomaly detection?', 'Isolation Forest', 'Decision Tree', 'Quick Sort', 'Hashing', 'A', 1, 8),
(903, 'Which AI method is probabilistic in nature?', 'Bayesian Networks', 'Binary Search', 'Sorting', 'Linked List', 'A', 1, 8),
(904, 'Which AI algorithm is used in autonomous driving?', 'Reinforcement Learning', 'Sorting', 'Linear Search', 'Hashing', 'A', 1, 8),
(905, 'Which AI field deals with learning from data?', 'Machine Learning', 'Networking', 'Database', 'Compiler Design', 'A', 1, 8),
(906, 'Which AI method handles sequential data?', 'Recurrent Neural Networks', 'Decision Tree', 'Quick Sort', 'Hashing', 'A', 1, 8),
(907, 'Which AI technique is used to extract features?', 'Feature Engineering', 'Binary Search', 'Sorting', 'Hashing', 'A', 1, 8),
(908, 'Which AI method is inspired by human neurons?', 'Neural Networks', 'Decision Tree', 'Quick Sort', 'Hashing', 'A', 1, 8),
(909, 'Which AI field deals with predictive modeling?', 'Machine Learning', 'Networking', 'Database', 'Compiler Design', 'A', 1, 8),
(910, 'Which AI technique handles missing data?', 'Imputation', 'Sorting', 'Linear Search', 'Hashing', 'A', 1, 8),
(911, 'What does SDLC stand for?', 'Software Development Life Cycle', 'System Design Learning Course', 'Structured Data Learning Code', 'Software Design Logic Cycle', 'A', 1, 9),
(912, 'Which SDLC model is linear and sequential?', 'Waterfall Model', 'Agile Model', 'Spiral Model', 'V-Model', 'A', 1, 9),
(913, 'Which SDLC model allows iterative development?', 'Agile Model', 'Waterfall Model', 'V-Model', 'Big Bang Model', 'A', 1, 9),
(914, 'Which SDLC phase involves requirement gathering?', 'Requirement Analysis', 'Design', 'Coding', 'Testing', 'A', 1, 9),
(915, 'Which SDLC phase involves coding the software?', 'Implementation', 'Design', 'Requirement Analysis', 'Maintenance', 'A', 1, 9),
(916, 'Which SDLC phase involves fixing bugs?', 'Maintenance', 'Design', 'Requirement Analysis', 'Coding', 'A', 1, 9),
(917, 'Which model is risk-driven in SDLC?', 'Spiral Model', 'Waterfall Model', 'Agile Model', 'V-Model', 'A', 1, 9),
(918, 'What is the main goal of software testing?', 'Identify defects', 'Write code', 'Design software', 'Deploy software', 'A', 1, 9),
(919, 'Which testing is done by developers?', 'Unit Testing', 'System Testing', 'Acceptance Testing', 'Integration Testing', 'A', 1, 9),
(920, 'Which testing is done by end users?', 'Acceptance Testing', 'Unit Testing', 'Integration Testing', 'System Testing', 'A', 1, 9),
(921, 'Which diagram represents system behavior?', 'Use Case Diagram', 'Class Diagram', 'Component Diagram', 'Deployment Diagram', 'A', 1, 9),
(922, 'Which diagram represents system structure?', 'Class Diagram', 'Use Case Diagram', 'Activity Diagram', 'Sequence Diagram', 'A', 1, 9),
(923, 'Which methodology focuses on rapid delivery?', 'Agile', 'Waterfall', 'V-Model', 'Spiral', 'A', 1, 9),
(924, 'Which model is best for small projects?', 'Waterfall', 'Agile', 'Spiral', 'Incremental', 'A', 1, 9),
(925, 'Which SDLC model allows prototyping?', 'Prototyping Model', 'Waterfall Model', 'V-Model', 'Agile Model', 'A', 1, 9),
(926, 'Which document describes software requirements?', 'SRS', 'Design Document', 'Test Plan', 'User Manual', 'A', 1, 9),
(927, 'Which document describes design details?', 'Design Document', 'SRS', 'Test Plan', 'User Manual', 'A', 1, 9),
(928, 'Which document guides testing?', 'Test Plan', 'SRS', 'Design Document', 'User Manual', 'A', 1, 9),
(929, 'Which is a non-functional requirement?', 'Performance', 'Login feature', 'Data entry', 'Report generation', 'A', 1, 9),
(930, 'Which is a functional requirement?', 'User Authentication', 'System speed', 'Reliability', 'Maintainability', 'A', 1, 9),
(931, 'Which model is also called verification and validation model?', 'V-Model', 'Waterfall', 'Agile', 'Spiral', 'A', 1, 9),
(932, 'Which SDLC phase comes after coding?', 'Testing', 'Design', 'Requirement Analysis', 'Maintenance', 'A', 1, 9),
(933, 'Which testing checks integration of modules?', 'Integration Testing', 'Unit Testing', 'Acceptance Testing', 'System Testing', 'A', 1, 9),
(934, 'Which testing checks entire system?', 'System Testing', 'Unit Testing', 'Acceptance Testing', 'Integration Testing', 'A', 1, 9),
(935, 'Which testing is iterative and continuous?', 'Agile Testing', 'Unit Testing', 'System Testing', 'Acceptance Testing', 'A', 1, 9),
(936, 'Which model is suitable for high-risk projects?', 'Spiral Model', 'Waterfall', 'V-Model', 'Agile', 'A', 1, 9),
(937, 'Which SDLC phase involves deployment?', 'Implementation', 'Requirement Analysis', 'Design', 'Testing', 'A', 1, 9),
(938, 'Which SDLC phase ensures software works as expected?', 'Testing', 'Requirement Analysis', 'Design', 'Implementation', 'A', 1, 9),
(939, 'Which SDLC phase handles user feedback?', 'Maintenance', 'Requirement Analysis', 'Design', 'Implementation', 'A', 1, 9),
(940, 'Which model uses iterations and prototypes?', 'Spiral', 'Waterfall', 'V-Model', 'Big Bang', 'A', 1, 9),
(941, 'Which model is simple and easy to understand?', 'Waterfall', 'Agile', 'Spiral', 'V-Model', 'A', 1, 9),
(942, 'Which SDLC phase plans the project?', 'Requirement Analysis', 'Design', 'Coding', 'Testing', 'A', 1, 9),
(943, 'Which diagram shows object interactions over time?', 'Sequence Diagram', 'Class Diagram', 'Use Case Diagram', 'Activity Diagram', 'A', 1, 9),
(944, 'Which diagram shows workflow of activities?', 'Activity Diagram', 'Class Diagram', 'Use Case Diagram', 'Sequence Diagram', 'A', 1, 9),
(945, 'Which is a model-driven development approach?', 'UML Modeling', 'Waterfall', 'Agile', 'Spiral', 'A', 1, 9),
(946, 'Which SDLC model allows incremental builds?', 'Incremental Model', 'Waterfall', 'Agile', 'V-Model', 'A', 1, 9),
(947, 'Which diagram shows system components?', 'Component Diagram', 'Class Diagram', 'Use Case Diagram', 'Sequence Diagram', 'A', 1, 9),
(948, 'Which document is created for users?', 'User Manual', 'SRS', 'Design Document', 'Test Plan', 'A', 1, 9),
(949, 'Which model focuses on early defect detection?', 'V-Model', 'Waterfall', 'Agile', 'Big Bang', 'A', 1, 9),
(950, 'Which SDLC model is iterative?', 'Agile', 'Waterfall', 'V-Model', 'Big Bang', 'A', 1, 9),
(951, 'Which model is plan-driven?', 'Waterfall', 'Agile', 'Spiral', 'V-Model', 'A', 1, 9),
(952, 'Which testing validates software meets requirements?', 'Acceptance Testing', 'Unit Testing', 'Integration Testing', 'System Testing', 'A', 1, 9),
(953, 'Which is a risk management activity in SDLC?', 'Risk Analysis', 'Coding', 'Testing', 'Deployment', 'A', 1, 9),
(954, 'Which model allows changes at any time?', 'Agile', 'Waterfall', 'V-Model', 'Spiral', 'A', 1, 9),
(955, 'Which model is document-heavy?', 'Waterfall', 'Agile', 'Spiral', 'Incremental', 'A', 1, 9),
(956, 'Which is a software quality factor?', 'Reliability', 'Sorting', 'Searching', 'Encryption', 'A', 1, 9),
(957, 'Which is a software quality factor?', 'Maintainability', 'Bubble Sort', 'Binary Search', 'Linked List', 'A', 1, 9),
(958, 'Which SDLC model emphasizes customer feedback?', 'Agile', 'Waterfall', 'Spiral', 'V-Model', 'A', 1, 9),
(959, 'Which diagram shows static structure?', 'Class Diagram', 'Use Case Diagram', 'Sequence Diagram', 'Activity Diagram', 'A', 1, 9),
(960, 'Which diagram shows dynamic behavior?', 'Sequence Diagram', 'Activity Diagram', 'Class Diagram', 'Use Case Diagram', 'A', 1, 9),
(961, 'Which model allows partial deployment at each iteration?', 'Incremental', 'Waterfall', 'V-Model', 'Spiral', 'A', 1, 9),
(962, 'Which model combines design and prototyping?', 'Spiral', 'Waterfall', 'Agile', 'Incremental', 'A', 1, 9),
(963, 'Which SDLC phase involves system integration?', 'Implementation', 'Requirement Analysis', 'Design', 'Testing', 'A', 1, 9),
(964, 'Which model is best for large and complex projects?', 'Spiral', 'Waterfall', 'Agile', 'V-Model', 'A', 1, 9),
(965, 'Which is a type of non-functional testing?', 'Performance Testing', 'Unit Testing', 'Integration Testing', 'Acceptance Testing', 'A', 1, 9),
(966, 'Which is a type of functional testing?', 'Unit Testing', 'Performance Testing', 'Load Testing', 'Stress Testing', 'A', 1, 9),
(967, 'Which SDLC model handles changes better?', 'Agile', 'Waterfall', 'V-Model', 'Big Bang', 'A', 1, 9),
(968, 'Which testing ensures integration works?', 'Integration Testing', 'Unit Testing', 'System Testing', 'Acceptance Testing', 'A', 1, 9),
(969, 'Which testing ensures the software works as a whole?', 'System Testing', 'Unit Testing', 'Integration Testing', 'Acceptance Testing', 'A', 1, 9),
(970, 'Which testing ensures user satisfaction?', 'Acceptance Testing', 'Unit Testing', 'Integration Testing', 'System Testing', 'A', 1, 9),
(971, 'Which is a method of requirement elicitation?', 'Interviews', 'Sorting', 'Hashing', 'Encryption', 'A', 1, 9),
(972, 'Which SDLC model involves prototyping for requirement validation?', 'Prototyping', 'Waterfall', 'Agile', 'V-Model', 'A', 1, 9),
(973, 'Which SDLC phase involves code review?', 'Implementation', 'Requirement Analysis', 'Design', 'Testing', 'A', 1, 9);
INSERT INTO `questionbank` (`question_id`, `question_text`, `option_a`, `option_b`, `option_c`, `option_d`, `correct_option`, `marks`, `subject_id`) VALUES
(974, 'Which testing is performed after system integration?', 'System Testing', 'Unit Testing', 'Integration Testing', 'Acceptance Testing', 'A', 1, 9),
(975, 'Which SDLC model reduces risk by early prototypes?', 'Spiral', 'Waterfall', 'Agile', 'Incremental', 'A', 1, 9),
(976, 'Which model delivers software in small functional parts?', 'Incremental', 'Waterfall', 'Agile', 'Spiral', 'A', 1, 9),
(977, 'Which SDLC model is best for evolving requirements?', 'Agile', 'Waterfall', 'V-Model', 'Big Bang', 'A', 1, 9),
(978, 'Which diagram shows user interactions with system?', 'Use Case Diagram', 'Class Diagram', 'Sequence Diagram', 'Activity Diagram', 'A', 1, 9),
(979, 'Which model focuses on documentation over flexibility?', 'Waterfall', 'Agile', 'Spiral', 'Incremental', 'A', 1, 9),
(980, 'Which model emphasizes testing from the start?', 'V-Model', 'Waterfall', 'Agile', 'Spiral', 'A', 1, 9),
(981, 'Which model allows feedback at every iteration?', 'Agile', 'Waterfall', 'V-Model', 'Big Bang', 'A', 1, 9),
(982, 'Which SDLC phase ensures correct implementation?', 'Testing', 'Requirement Analysis', 'Design', 'Implementation', 'A', 1, 9),
(983, 'Which model is highly flexible?', 'Agile', 'Waterfall', 'V-Model', 'Spiral', 'A', 1, 9),
(984, 'Which testing identifies defects in modules?', 'Unit Testing', 'System Testing', 'Integration Testing', 'Acceptance Testing', 'A', 1, 9),
(985, 'Which model requires extensive upfront planning?', 'Waterfall', 'Agile', 'Incremental', 'Spiral', 'A', 1, 9),
(986, 'What is a computer network?', 'A system of interconnected computers', 'A single computer', 'A programming language', 'A software application', 'A', 1, 10),
(987, 'Which device connects multiple networks?', 'Router', 'Switch', 'Hub', 'Repeater', 'A', 1, 10),
(988, 'Which device connects computers within a LAN?', 'Switch', 'Router', 'Modem', 'Firewall', 'A', 1, 10),
(989, 'Which device amplifies signals over long distances?', 'Repeater', 'Hub', 'Router', 'Switch', 'A', 1, 10),
(990, 'Which network type covers a small area?', 'LAN', 'WAN', 'MAN', 'VPN', 'A', 1, 10),
(991, 'Which network type covers a large geographical area?', 'WAN', 'LAN', 'PAN', 'VPN', 'A', 1, 10),
(992, 'Which topology has a central hub?', 'Star', 'Ring', 'Bus', 'Mesh', 'A', 1, 10),
(993, 'Which topology connects nodes in a circle?', 'Ring', 'Star', 'Bus', 'Mesh', 'A', 1, 10),
(994, 'Which topology has all nodes connected to each other?', 'Mesh', 'Bus', 'Ring', 'Star', 'A', 1, 10),
(995, 'Which topology has a single backbone cable?', 'Bus', 'Star', 'Ring', 'Mesh', 'A', 1, 10),
(996, 'What does IP stand for?', 'Internet Protocol', 'Internal Program', 'Internet Port', 'Input Process', 'A', 1, 10),
(997, 'What does MAC address identify?', 'Network interface card', 'Computer CPU', 'Router type', 'Software version', 'A', 1, 10),
(998, 'Which layer of OSI handles routing?', 'Network Layer', 'Data Link Layer', 'Application Layer', 'Transport Layer', 'A', 1, 10),
(999, 'Which layer of OSI handles error detection?', 'Data Link Layer', 'Network Layer', 'Application Layer', 'Transport Layer', 'A', 1, 10),
(1000, 'Which layer of OSI provides end-to-end delivery?', 'Transport Layer', 'Network Layer', 'Data Link Layer', 'Physical Layer', 'A', 1, 10),
(1001, 'Which protocol is used for sending emails?', 'SMTP', 'HTTP', 'FTP', 'DNS', 'A', 1, 10),
(1002, 'Which protocol is used for receiving emails?', 'POP3', 'SMTP', 'HTTP', 'DNS', 'A', 1, 10),
(1003, 'Which protocol is used for web browsing?', 'HTTP', 'FTP', 'SMTP', 'DNS', 'A', 1, 10),
(1004, 'Which protocol is used for file transfer?', 'FTP', 'HTTP', 'SMTP', 'DNS', 'A', 1, 10),
(1005, 'Which protocol translates domain names to IP addresses?', 'DNS', 'FTP', 'SMTP', 'HTTP', 'A', 1, 10),
(1006, 'Which IP version uses 32-bit addresses?', 'IPv4', 'IPv6', 'IPX', 'ICMP', 'A', 1, 10),
(1007, 'Which IP version uses 128-bit addresses?', 'IPv6', 'IPv4', 'IPX', 'ICMP', 'A', 1, 10),
(1008, 'What is the default port for HTTP?', '80', '21', '25', '443', 'A', 1, 10),
(1009, 'What is the default port for HTTPS?', '443', '80', '21', '25', 'A', 1, 10),
(1010, 'What is the default port for FTP?', '21', '80', '25', '443', 'A', 1, 10),
(1011, 'What is the default port for SMTP?', '25', '21', '80', '443', 'A', 1, 10),
(1012, 'Which device filters network traffic?', 'Firewall', 'Router', 'Switch', 'Hub', 'A', 1, 10),
(1013, 'Which wireless standard is 802.11ac?', 'Wi-Fi', 'Bluetooth', 'Zigbee', 'Ethernet', 'A', 1, 10),
(1014, 'Which wireless standard has longest range?', '802.11ah', '802.11ac', '802.11n', '802.11g', 'A', 1, 10),
(1015, 'What is the main function of DHCP?', 'Assign IP addresses automatically', 'Route packets', 'Filter traffic', 'Encrypt data', 'A', 1, 10),
(1016, 'Which network is private?', 'LAN', 'Internet', 'WAN', 'MAN', 'A', 1, 10),
(1017, 'Which network connects offices in a city?', 'MAN', 'LAN', 'WAN', 'PAN', 'A', 1, 10),
(1018, 'Which network is used by personal devices?', 'PAN', 'LAN', 'WAN', 'MAN', 'A', 1, 10),
(1019, 'Which protocol provides secure communication?', 'HTTPS', 'HTTP', 'FTP', 'SMTP', 'A', 1, 10),
(1020, 'Which protocol is connectionless?', 'UDP', 'TCP', 'HTTP', 'SMTP', 'A', 1, 10),
(1021, 'Which protocol is connection-oriented?', 'TCP', 'UDP', 'HTTP', 'FTP', 'A', 1, 10),
(1022, 'Which layer of TCP/IP model maps to OSI Network Layer?', 'Internet Layer', 'Transport Layer', 'Application Layer', 'Physical Layer', 'A', 1, 10),
(1023, 'Which layer of TCP/IP model maps to OSI Transport Layer?', 'Transport Layer', 'Internet Layer', 'Application Layer', 'Physical Layer', 'A', 1, 10),
(1024, 'Which layer of TCP/IP model maps to OSI Application Layer?', 'Application Layer', 'Transport Layer', 'Internet Layer', 'Physical Layer', 'A', 1, 10),
(1025, 'Which topology is most fault-tolerant?', 'Mesh', 'Bus', 'Star', 'Ring', 'A', 1, 10),
(1026, 'Which layer adds MAC addresses?', 'Data Link Layer', 'Network Layer', 'Application Layer', 'Transport Layer', 'A', 1, 10),
(1027, 'Which layer adds IP addresses?', 'Network Layer', 'Data Link Layer', 'Transport Layer', 'Application Layer', 'A', 1, 10),
(1028, 'Which layer converts bits to signals?', 'Physical Layer', 'Data Link Layer', 'Network Layer', 'Transport Layer', 'A', 1, 10),
(1029, 'Which topology is cheapest to implement?', 'Bus', 'Star', 'Ring', 'Mesh', 'A', 1, 10),
(1030, 'Which topology requires a central hub?', 'Star', 'Bus', 'Ring', 'Mesh', 'A', 1, 10),
(1031, 'Which layer ensures error-free delivery?', 'Data Link Layer', 'Physical Layer', 'Network Layer', 'Transport Layer', 'A', 1, 10),
(1032, 'Which layer provides end-to-end communication?', 'Transport Layer', 'Network Layer', 'Data Link Layer', 'Application Layer', 'A', 1, 10),
(1033, 'Which protocol is used for secure file transfer?', 'SFTP', 'FTP', 'HTTP', 'SMTP', 'A', 1, 10),
(1034, 'Which protocol is used for remote login?', 'Telnet', 'HTTP', 'FTP', 'SMTP', 'A', 1, 10),
(1035, 'Which protocol is used for secure remote login?', 'SSH', 'Telnet', 'FTP', 'HTTP', 'A', 1, 10),
(1036, 'Which protocol resolves IP to MAC?', 'ARP', 'DNS', 'DHCP', 'ICMP', 'A', 1, 10),
(1037, 'Which protocol is used for error reporting?', 'ICMP', 'TCP', 'UDP', 'HTTP', 'A', 1, 10),
(1038, 'Which protocol is used for monitoring network devices?', 'SNMP', 'HTTP', 'FTP', 'SMTP', 'A', 1, 10),
(1039, 'Which layer formats data for application?', 'Presentation Layer', 'Transport Layer', 'Network Layer', 'Physical Layer', 'A', 1, 10),
(1040, 'Which protocol ensures reliable data transfer?', 'TCP', 'UDP', 'HTTP', 'FTP', 'A', 1, 10),
(1041, 'Which protocol ensures fast but unreliable transfer?', 'UDP', 'TCP', 'HTTP', 'FTP', 'A', 1, 10),
(1042, 'Which protocol resolves domain names?', 'DNS', 'DHCP', 'ARP', 'ICMP', 'A', 1, 10),
(1043, 'Which protocol assigns IP addresses dynamically?', 'DHCP', 'DNS', 'ARP', 'ICMP', 'A', 1, 10),
(1044, 'Which layer encapsulates data into packets?', 'Network Layer', 'Data Link Layer', 'Transport Layer', 'Application Layer', 'A', 1, 10),
(1045, 'Which layer encapsulates packets into frames?', 'Data Link Layer', 'Network Layer', 'Transport Layer', 'Application Layer', 'A', 1, 10),
(1046, 'Which protocol sends emails securely?', 'SMTPS', 'SMTP', 'HTTP', 'FTP', 'A', 1, 10),
(1047, 'Which protocol downloads emails securely?', 'POP3S', 'POP3', 'IMAP', 'SMTP', 'A', 1, 10),
(1048, 'Which topology is used in Ethernet LAN?', 'Bus', 'Star', 'Ring', 'Mesh', 'A', 1, 10),
(1049, 'Which protocol checks network connectivity?', 'Ping', 'FTP', 'SMTP', 'HTTP', 'A', 1, 10),
(1050, 'Which device connects a computer to ISP?', 'Modem', 'Switch', 'Router', 'Hub', 'A', 1, 10),
(1051, 'Which protocol is used for network file sharing?', 'NFS', 'FTP', 'HTTP', 'SMTP', 'A', 1, 10),
(1052, 'Which protocol provides secure web browsing?', 'HTTPS', 'HTTP', 'FTP', 'SMTP', 'A', 1, 10),
(1053, 'Which protocol is stateless?', 'HTTP', 'TCP', 'UDP', 'SMTP', 'A', 1, 10),
(1054, 'Which protocol provides reliable connection?', 'TCP', 'UDP', 'HTTP', 'FTP', 'A', 1, 10),
(1055, 'Which protocol provides best-effort delivery?', 'UDP', 'TCP', 'HTTP', 'FTP', 'A', 1, 10),
(1056, 'Which protocol checks domain name existence?', 'DNS', 'DHCP', 'ARP', 'ICMP', 'A', 1, 10),
(1057, 'Which protocol informs about unreachable hosts?', 'ICMP', 'TCP', 'UDP', 'HTTP', 'A', 1, 10),
(1058, 'Which device separates collision domains?', 'Switch', 'Hub', 'Router', 'Repeater', 'A', 1, 10),
(1059, 'Which device separates broadcast domains?', 'Router', 'Switch', 'Hub', 'Repeater', 'A', 1, 10);

-- --------------------------------------------------------

--
-- Table structure for table `quiz`
--

CREATE TABLE `quiz` (
  `quiz_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `section_id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quiz`
--

INSERT INTO `quiz` (`quiz_id`, `title`, `subject_id`, `section_id`, `teacher_id`) VALUES
(1, 'Quiz1', 1, 1, 1),
(3, 'Clo based', 7, 2, 5),
(4, 'Quiz_2', 3, 2, 2),
(6, 'AHmad quiz', 9, 6, 789);

-- --------------------------------------------------------

--
-- Table structure for table `quizquestion`
--

CREATE TABLE `quizquestion` (
  `id` int(11) NOT NULL,
  `quiz_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quizquestion`
--

INSERT INTO `quizquestion` (`id`, `quiz_id`, `question_id`) VALUES
(7, 1, 2),
(8, 1, 8),
(1, 1, 12),
(5, 1, 24),
(2, 1, 32),
(10, 1, 51),
(9, 1, 57),
(6, 1, 79),
(4, 1, 94),
(3, 1, 138),
(31, 3, 788),
(37, 3, 789),
(35, 3, 791),
(40, 3, 804),
(36, 3, 808),
(34, 3, 811),
(32, 3, 812),
(38, 3, 824),
(39, 3, 826),
(33, 3, 839),
(51, 6, 935),
(46, 6, 938),
(50, 6, 941),
(48, 6, 946),
(49, 6, 960),
(47, 6, 967);

-- --------------------------------------------------------

--
-- Table structure for table `result`
--

CREATE TABLE `result` (
  `result_id` int(11) NOT NULL,
  `attempt_id` int(11) NOT NULL,
  `status` enum('PASS','FAIL') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `result`
--

INSERT INTO `result` (`result_id`, `attempt_id`, `status`) VALUES
(1, 5, 'FAIL'),
(2, 6, 'FAIL'),
(3, 7, 'FAIL'),
(4, 9, 'PASS'),
(6, 11, 'PASS'),
(7, 12, 'FAIL');

-- --------------------------------------------------------

--
-- Table structure for table `section`
--

CREATE TABLE `section` (
  `section_id` int(11) NOT NULL,
  `section_name` varchar(50) NOT NULL,
  `strength` int(11) NOT NULL CHECK (`strength` > 0),
  `subject_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `section`
--

INSERT INTO `section` (`section_id`, `section_name`, `strength`, `subject_id`) VALUES
(1, 'A', 20, 1),
(2, 'B', 30, 2),
(3, 'C', 35, 3),
(4, 'D', 15, 4),
(5, 'E', 20, 5),
(6, 'F', 22, 6),
(7, 'G', 18, 7);

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `student_id` int(11) NOT NULL,
  `roll_no` varchar(20) NOT NULL,
  `section_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`student_id`, `roll_no`, `section_id`) VALUES
(8, 'A002', 1),
(9, 'A003', 1),
(10, 'A004', 1),
(11, 'A005', 1),
(12, 'A006', 1),
(13, 'A007', 4),
(14, 'A008', 1),
(15, 'A009', 1),
(16, 'A010', 1),
(17, 'A011', 1),
(18, 'A012', 1),
(19, 'A013', 1),
(20, 'A014', 1),
(21, 'A015', 1),
(22, 'A016', 1),
(23, 'A017', 1),
(24, 'A018', 1),
(25, 'A019', 1),
(26, 'A020', 1),
(27, 'B001', 2),
(28, 'B002', 2),
(29, 'B003', 2),
(30, 'B004', 2),
(31, 'B005', 2),
(32, 'B006', 2),
(33, 'B007', 2),
(34, 'B008', 2),
(35, 'B009', 2),
(36, 'B010', 2),
(37, 'B011', 2),
(38, 'B012', 2),
(39, 'B013', 2),
(40, 'B014', 2),
(41, 'B015', 2),
(42, 'B016', 2),
(43, 'B017', 2),
(44, 'B018', 2),
(45, 'B019', 2),
(46, 'B020', 2),
(47, 'B021', 2),
(48, 'B022', 2),
(49, 'B023', 2),
(50, 'B024', 2),
(51, 'B025', 2),
(52, 'B026', 2),
(53, 'B027', 2),
(54, 'B028', 2),
(55, 'B029', 2),
(56, 'B030', 2),
(57, 'C001', 3),
(58, 'C002', 3),
(59, 'C003', 3),
(60, 'C004', 3),
(61, 'C005', 3),
(62, 'C006', 3),
(63, 'C007', 3),
(64, 'C008', 3),
(65, 'C009', 3),
(66, 'C010', 3),
(67, 'C011', 3),
(68, 'C012', 3),
(69, 'C013', 3),
(70, 'C014', 3),
(71, 'C015', 3),
(72, 'C016', 3),
(73, 'C017', 3),
(74, 'C018', 3),
(75, 'C019', 3),
(76, 'C020', 3),
(77, 'C021', 3),
(78, 'C022', 3),
(79, 'C023', 3),
(80, 'C024', 3),
(81, 'C025', 3),
(82, 'C026', 3),
(83, 'C027', 3),
(84, 'C028', 3),
(85, 'C029', 3),
(86, 'C030', 3),
(87, 'C031', 3),
(88, 'C032', 3),
(89, 'C033', 3),
(90, 'C034', 3),
(91, 'C035', 3),
(92, 'D001', 4),
(93, 'D002', 4),
(94, 'D003', 4),
(95, 'D004', 4),
(96, 'D005', 4),
(97, 'D006', 4),
(98, 'D007', 4),
(99, 'D008', 4),
(100, 'D009', 4),
(101, 'D010', 4),
(102, 'D011', 4),
(103, 'D012', 4),
(104, 'D013', 4),
(105, 'D014', 4),
(106, 'D015', 4),
(107, 'E001', 5),
(108, 'E002', 5),
(109, 'E003', 5),
(110, 'E004', 5),
(111, 'E005', 5),
(112, 'E006', 5),
(113, 'E007', 5),
(114, 'E008', 5),
(115, 'E009', 5),
(116, 'E010', 5),
(117, 'E011', 5),
(118, 'E012', 5),
(119, 'E013', 5),
(120, 'E014', 5),
(121, 'E015', 5),
(122, 'E016', 5),
(123, 'E017', 5),
(124, 'E018', 5),
(125, 'E019', 5),
(126, 'E020', 5),
(127, 'F001', 6),
(128, 'F002', 6),
(129, 'F003', 6),
(130, 'F004', 6),
(131, 'F005', 6),
(132, 'F006', 6),
(133, 'F007', 6),
(134, 'F008', 6),
(135, 'F009', 6),
(136, 'F010', 6),
(137, 'F011', 6),
(138, 'F012', 6),
(139, 'F013', 6),
(140, 'F014', 6),
(141, 'F015', 6),
(142, 'F016', 6),
(143, 'F017', 6),
(144, 'F018', 6),
(145, 'F019', 6),
(146, 'F020', 6),
(147, 'F021', 6),
(148, 'F022', 6),
(149, 'G001', 7),
(150, 'G002', 7),
(151, 'G003', 7),
(152, 'G004', 7),
(153, 'G005', 7),
(154, 'G006', 7),
(155, 'G007', 7),
(156, 'G008', 7),
(157, 'G009', 7),
(158, 'G010', 7),
(159, 'G011', 7),
(160, 'G012', 7),
(161, 'G013', 7),
(162, 'G014', 7),
(163, 'G015', 7),
(165, 'G017', 7),
(166, 'G018', 7),
(177, '123', 1),
(178, '2345', 1),
(478, '020', 3);

-- --------------------------------------------------------

--
-- Stand-in structure for view `student_details`
-- (See below for the actual view)
--
CREATE TABLE `student_details` (
`student_id` int(11)
,`student_name` varchar(100)
,`email` varchar(100)
,`roll_no` varchar(20)
,`section_id` int(11)
,`section_name` varchar(50)
,`subject_name` varchar(100)
);

-- --------------------------------------------------------

--
-- Table structure for table `subject`
--

CREATE TABLE `subject` (
  `subject_id` int(11) NOT NULL,
  `subject_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subject`
--

INSERT INTO `subject` (`subject_id`, `subject_name`) VALUES
(5, 'AICT'),
(8, 'Artificial Intelligence'),
(4, 'College algebra 1'),
(10, 'Computer Network'),
(1, 'DSA'),
(6, 'English'),
(7, 'Information Security'),
(3, 'OOP'),
(2, 'PF'),
(9, 'Software Engineering');

-- --------------------------------------------------------

--
-- Table structure for table `teacher`
--

CREATE TABLE `teacher` (
  `teacher_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teacher`
--

INSERT INTO `teacher` (`teacher_id`) VALUES
(1),
(2),
(3),
(4),
(5),
(789);

-- --------------------------------------------------------

--
-- Table structure for table `teachersection`
--

CREATE TABLE `teachersection` (
  `id` int(11) NOT NULL,
  `teacher_id` int(11) NOT NULL,
  `section_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teachersection`
--

INSERT INTO `teachersection` (`id`, `teacher_id`, `section_id`) VALUES
(7, 1, 1),
(5, 1, 3),
(1, 2, 2),
(9, 3, 5),
(3, 4, 2),
(6, 5, 2),
(10, 789, 6);

-- --------------------------------------------------------

--
-- Stand-in structure for view `teacher_details`
-- (See below for the actual view)
--
CREATE TABLE `teacher_details` (
`teacher_id` int(11)
,`teacher_name` varchar(100)
,`email` varchar(100)
,`subjects` mediumtext
,`sections` mediumtext
);

-- --------------------------------------------------------

--
-- Table structure for table `teacher_subject`
--

CREATE TABLE `teacher_subject` (
  `teacher_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teacher_subject`
--

INSERT INTO `teacher_subject` (`teacher_id`, `subject_id`) VALUES
(1, 1),
(2, 1),
(3, 8),
(789, 9);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `role` enum('ADMIN','TEACHER','STUDENT') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `name`, `email`, `password`, `role`) VALUES
(1, 'Athar ikhlaq', 'athar.ikhlaq@gift.com', 'athar123', 'TEACHER'),
(2, 'Dr Faheem', 'Faheem@gift.com', 'faheem123', 'TEACHER'),
(3, 'Dr Qamar', 'Qamar@gift.com', 'qamar123', 'TEACHER'),
(4, 'Hammad Cheema', 'Hammad@gift.com', 'hammad123', 'TEACHER'),
(5, 'Sajiya Tariq', 'sajiya@gift.com', 'sajiya123', 'TEACHER'),
(7, 'Ali Khan', 'ali.khan@gift.com', 'ali123', 'STUDENT'),
(8, 'Sara Ahmed', 'sara.ahmed@gift.com', 'sara123', 'STUDENT'),
(9, 'Hassan Raza', 'hassan.raza@gift.com', 'hassan123', 'STUDENT'),
(10, 'Fatima Iqbal', 'fatima.iqbal@gift.com', 'fatima123', 'STUDENT'),
(11, 'Usman Shah', 'usman.shah@gift.com', 'usman123', 'STUDENT'),
(12, 'Ayesha Siddiqui', 'ayesha.siddiqui@gift.com', 'ayesha123', 'STUDENT'),
(13, 'Bilal Tariq', 'bilal.tariq@gift.com', 'bilal123', 'STUDENT'),
(14, 'Hina Malik', 'hina.malik@gift.com', 'hina123', 'STUDENT'),
(15, 'Omar Farooq', 'omar.farooq@gift.com', 'omar123', 'STUDENT'),
(16, 'Zainab Qureshi', 'zainab.qureshi@gift.com', 'zainab123', 'STUDENT'),
(17, 'Ahmed Javed', 'ahmed.javed@gift.com', 'ahmed123', 'STUDENT'),
(18, 'Sana Bukhari', 'sana.bukhari@gift.com', 'sana123', 'STUDENT'),
(19, 'Kamran Ali', 'kamran.ali@gift.com', 'kamran123', 'STUDENT'),
(20, 'Noor Fatima', 'noor.fatima@gift.com', 'noor123', 'STUDENT'),
(21, 'Shahid Iqbal', 'shahid.iqbal@gift.com', 'shahid123', 'STUDENT'),
(22, 'Iqra Khan', 'iqra.khan@gift.com', 'iqra123', 'STUDENT'),
(23, 'Faisal Ahmed', 'faisal.ahmed@gift.com', 'faisal123', 'STUDENT'),
(24, 'Maryam Raza', 'maryam.raza@gift.com', 'maryam123', 'STUDENT'),
(25, 'Tariq Hussain', 'tariq.hussain@gift.com', 'tariq123', 'STUDENT'),
(26, 'Hira Ali', 'hira.ali@gift.com', 'hira123', 'STUDENT'),
(27, 'Adeel Khan', 'adeel.khan@gift.com', 'adeel123', 'STUDENT'),
(28, 'Huma Malik', 'huma.malik@gift.com', 'huma123', 'STUDENT'),
(29, 'Fahad Shah', 'fahad.shah@gift.com', 'fahad123', 'STUDENT'),
(30, 'Sania Tariq', 'sania.tariq@gift.com', 'sania123', 'STUDENT'),
(31, 'Owais Raza', 'owais.raza@gift.com', 'owais123', 'STUDENT'),
(32, 'Zoya Iqbal', 'zoya.iqbal@gift.com', 'zoya123', 'STUDENT'),
(33, 'Usama Ali', 'usama.ali@gift.com', 'usama123', 'STUDENT'),
(34, 'Maryam Farooq', 'maryam.farooq@gift.com', 'maryam123', 'STUDENT'),
(35, 'Bilal Tariq', 'bilal.tariq2@gift.com', 'bilal123', 'STUDENT'),
(36, 'Ayesha Khan', 'ayesha.khan2@gift.com', 'ayesha123', 'STUDENT'),
(37, 'Hamza Javed', 'hamza.javed@gift.com', 'hamza123', 'STUDENT'),
(38, 'Iqra Shah', 'iqra.shah2@gift.com', 'iqra123', 'STUDENT'),
(39, 'Tariq Hussain', 'tariq.hussain2@gift.com', 'tariq123', 'STUDENT'),
(40, 'Noor Shah', 'noor.shah@gift.com', 'noor123', 'STUDENT'),
(41, 'Shahid Farooq', 'shahid.farooq@gift.com', 'shahid123', 'STUDENT'),
(42, 'Fatima Ali', 'fatima.ali2@gift.com', 'fatima123', 'STUDENT'),
(43, 'Kamran Shah', 'kamran.shah2@gift.com', 'kamran123', 'STUDENT'),
(44, 'Sana Qureshi', 'sana.qureshi2@gift.com', 'sana123', 'STUDENT'),
(45, 'Ahmed Farooq', 'ahmed.farooq2@gift.com', 'ahmed123', 'STUDENT'),
(46, 'Hina Raza', 'hina.raza2@gift.com', 'hina123', 'STUDENT'),
(47, 'Omar Ali', 'omar.ali2@gift.com', 'omar123', 'STUDENT'),
(48, 'Zoya Khan', 'zoya.khan2@gift.com', 'zoya123', 'STUDENT'),
(49, 'Ali Shah', 'ali.shah2@gift.com', 'ali123', 'STUDENT'),
(50, 'Sara Farooq', 'sara.farooq2@gift.com', 'sara123', 'STUDENT'),
(51, 'Bilal Khan', 'bilal.khan3@gift.com', 'bilal123', 'STUDENT'),
(52, 'Maryam Ali', 'maryam.ali2@gift.com', 'maryam123', 'STUDENT'),
(53, 'Tariq Shah', 'tariq.shah3@gift.com', 'tariq123', 'STUDENT'),
(54, 'Hira Raza', 'hira.raza2@gift.com', 'hira123', 'STUDENT'),
(55, 'Usman Farooq', 'usman.farooq2@gift.com', 'usman123', 'STUDENT'),
(56, 'Fatima Khan', 'fatima.khan2@gift.com', 'fatima123', 'STUDENT'),
(57, 'Areeb Khan', 'areeb.khan@gift.com', 'areeb123', 'STUDENT'),
(58, 'Hina Shah', 'hina.shah3@gift.com', 'hina123', 'STUDENT'),
(59, 'Fahad Ali', 'fahad.ali2@gift.com', 'fahad123', 'STUDENT'),
(60, 'Sania Khan', 'sania.khan2@gift.com', 'sania123', 'STUDENT'),
(61, 'Omar Farooq', 'omar.farooq3@gift.com', 'omar123', 'STUDENT'),
(62, 'Zoya Shah', 'zoya.shah3@gift.com', 'zoya123', 'STUDENT'),
(63, 'Usama Khan', 'usama.khan2@gift.com', 'usama123', 'STUDENT'),
(64, 'Maryam Ali', 'maryam.ali3@gift.com', 'maryam123', 'STUDENT'),
(65, 'Bilal Farooq', 'bilal.farooq3@gift.com', 'bilal123', 'STUDENT'),
(66, 'Ayesha Shah', 'ayesha.shah3@gift.com', 'ayesha123', 'STUDENT'),
(67, 'Hamza Khan', 'hamza.khan2@gift.com', 'hamza123', 'STUDENT'),
(68, 'Iqra Farooq', 'iqra.farooq3@gift.com', 'iqra123', 'STUDENT'),
(69, 'Tariq Ali', 'tariq.ali2@gift.com', 'tariq123', 'STUDENT'),
(70, 'Noor Shah', 'noor.shah2@gift.com', 'noor123', 'STUDENT'),
(71, 'Shahid Ali', 'shahid.ali2@gift.com', 'shahid123', 'STUDENT'),
(72, 'Fatima Khan', 'fatima.khan3@gift.com', 'fatima123', 'STUDENT'),
(73, 'Kamran Farooq', 'kamran.farooq3@gift.com', 'kamran123', 'STUDENT'),
(74, 'Sana Shah', 'sana.shah3@gift.com', 'sana123', 'STUDENT'),
(75, 'Ahmed Khan', 'ahmed.khan2@gift.com', 'ahmed123', 'STUDENT'),
(76, 'Hira Shah', 'hira.shah4@gift.com', 'hira123', 'STUDENT'),
(77, 'Omar Ali', 'omar.ali3@gift.com', 'omar123', 'STUDENT'),
(78, 'Zoya Khan', 'zoya.khan3@gift.com', 'zoya123', 'STUDENT'),
(79, 'Ali Farooq', 'ali.farooq3@gift.com', 'ali123', 'STUDENT'),
(80, 'Sara Shah', 'sara.shah3@gift.com', 'sara123', 'STUDENT'),
(81, 'Bilal Khan', 'bilal.khan4@gift.com', 'bilal123', 'STUDENT'),
(82, 'Maryam Farooq', 'maryam.farooq4@gift.com', 'maryam123', 'STUDENT'),
(83, 'Tariq Shah', 'tariq.shah4@gift.com', 'tariq123', 'STUDENT'),
(84, 'Hira Ali', 'hira.ali3@gift.com', 'hira123', 'STUDENT'),
(85, 'Usman Shah', 'usman.shah2@gift.com', 'usman123', 'STUDENT'),
(86, 'Fatima Raza', 'fatima.raza2@gift.com', 'fatima123', 'STUDENT'),
(87, 'Adeel Ali', 'adeel.ali2@gift.com', 'adeel123', 'STUDENT'),
(88, 'Huma Khan', 'huma.khan2@gift.com', 'huma123', 'STUDENT'),
(89, 'Fahad Shah', 'fahad.shah3@gift.com', 'fahad123', 'STUDENT'),
(90, 'Sania Farooq', 'sania.farooq2@gift.com', 'sania123', 'STUDENT'),
(91, 'Omar Khan', 'omar.khan3@gift.com', 'omar123', 'STUDENT'),
(92, 'Ali Raza', 'ali.raza@gift.com', 'ali123', 'STUDENT'),
(93, 'Sara Iqbal', 'sara.iqbal2@gift.com', 'sara123', 'STUDENT'),
(94, 'Hassan Khan', 'hassan.khan2@gift.com', 'hassan123', 'STUDENT'),
(95, 'Fatima Shah', 'fatima.shah4@gift.com', 'fatima123', 'STUDENT'),
(96, 'Usman Farooq', 'usman.farooq3@gift.com', 'usman123', 'STUDENT'),
(97, 'Ayesha Raza', 'ayesha.raza2@gift.com', 'ayesha123', 'STUDENT'),
(98, 'Bilal Khan', 'bilal.khan5@gift.com', 'bilal123', 'STUDENT'),
(99, 'Hina Ali', 'hina.ali2@gift.com', 'hina123', 'STUDENT'),
(100, 'Omar Shah', 'omar.shah2@gift.com', 'omar123', 'STUDENT'),
(101, 'Zainab Farooq', 'zainab.farooq2@gift.com', 'zainab123', 'STUDENT'),
(102, 'Ahmed Raza', 'ahmed.raza2@gift.com', 'ahmed123', 'STUDENT'),
(103, 'Sana Ali', 'sana.ali2@gift.com', 'sana123', 'STUDENT'),
(104, 'Tariq Khan', 'tariq.khan2@gift.com', 'tariq123', 'STUDENT'),
(105, 'Noor Shah', 'noor.shah3@gift.com', 'noor123', 'STUDENT'),
(106, 'Shahid Farooq', 'shahid.farooq2@gift.com', 'shahid123', 'STUDENT'),
(107, 'Adeel Shah', 'adeel.shah3@gift.com', 'adeel123', 'STUDENT'),
(108, 'Huma Farooq', 'huma.farooq3@gift.com', 'huma123', 'STUDENT'),
(109, 'Fahad Raza', 'fahad.raza2@gift.com', 'fahad123', 'STUDENT'),
(110, 'Sania Ali', 'sania.ali3@gift.com', 'sania123', 'STUDENT'),
(111, 'Omar Khan', 'omar.khan4@gift.com', 'omar123', 'STUDENT'),
(112, 'Zoya Farooq', 'zoya.farooq3@gift.com', 'zoya123', 'STUDENT'),
(113, 'Usama Shah', 'usama.shah3@gift.com', 'usama123', 'STUDENT'),
(114, 'Maryam Khan', 'maryam.khan3@gift.com', 'maryam123', 'STUDENT'),
(115, 'Bilal Ali', 'bilal.ali3@gift.com', 'bilal123', 'STUDENT'),
(116, 'Ayesha Farooq', 'ayesha.farooq3@gift.com', 'ayesha123', 'STUDENT'),
(117, 'Hamza Shah', 'hamza.shah3@gift.com', 'hamza123', 'STUDENT'),
(118, 'Iqra Ali', 'iqra.ali3@gift.com', 'iqra123', 'STUDENT'),
(119, 'Tariq Farooq', 'tariq.farooq3@gift.com', 'tariq123', 'STUDENT'),
(120, 'Noor Khan', 'noor.khan3@gift.com', 'noor123', 'STUDENT'),
(121, 'Shahid Ali', 'shahid.ali3@gift.com', 'shahid123', 'STUDENT'),
(122, 'Fatima Shah', 'fatima.shah5@gift.com', 'fatima123', 'STUDENT'),
(123, 'Kamran Khan', 'kamran.khan3@gift.com', 'kamran123', 'STUDENT'),
(124, 'Sana Farooq', 'sana.farooq3@gift.com', 'sana123', 'STUDENT'),
(125, 'Ahmed Ali', 'ahmed.ali3@gift.com', 'ahmed123', 'STUDENT'),
(126, 'Hira Shah', 'hira.shah5@gift.com', 'hira123', 'STUDENT'),
(127, 'Areeb Ali', 'areeb.ali2@gift.com', 'areeb123', 'STUDENT'),
(128, 'Hina Farooq', 'hina.farooq4@gift.com', 'hina123', 'STUDENT'),
(129, 'Fahad Khan', 'fahad.khan3@gift.com', 'fahad123', 'STUDENT'),
(130, 'Sania Shah', 'sania.shah4@gift.com', 'sania123', 'STUDENT'),
(131, 'Omar Ali', 'omar.ali4@gift.com', 'omar123', 'STUDENT'),
(132, 'Zoya Khan', 'zoya.khan4@gift.com', 'zoya123', 'STUDENT'),
(133, 'Usama Farooq', 'usama.farooq4@gift.com', 'usama123', 'STUDENT'),
(134, 'Maryam Shah', 'maryam.shah4@gift.com', 'maryam123', 'STUDENT'),
(135, 'Bilal Khan', 'bilal.khan6@gift.com', 'bilal123', 'STUDENT'),
(136, 'Ayesha Ali', 'ayesha.ali4@gift.com', 'ayesha123', 'STUDENT'),
(137, 'Hamza Farooq', 'hamza.farooq3@gift.com', 'hamza123', 'STUDENT'),
(138, 'Iqra Khan', 'iqra.khan3@gift.com', 'iqra123', 'STUDENT'),
(139, 'Tariq Shah', 'tariq.shah5@gift.com', 'tariq123', 'STUDENT'),
(140, 'Noor Ali', 'noor.ali3@gift.com', 'noor123', 'STUDENT'),
(141, 'Shahid Farooq', 'shahid.farooq3@gift.com', 'shahid123', 'STUDENT'),
(142, 'Fatima Ali', 'fatima.ali3@gift.com', 'fatima123', 'STUDENT'),
(143, 'Kamran Shah', 'kamran.shah4@gift.com', 'kamran123', 'STUDENT'),
(144, 'Sana Ali', 'sana.ali3@gift.com', 'sana123', 'STUDENT'),
(145, 'Ahmed Farooq', 'ahmed.farooq4@gift.com', 'ahmed123', 'STUDENT'),
(146, 'Hira Khan', 'hira.khan4@gift.com', 'hira123', 'STUDENT'),
(147, 'Omar Shah', 'omar.shah3@gift.com', 'omar123', 'STUDENT'),
(148, 'Zoya Ali', 'zoya.ali3@gift.com', 'zoya123', 'STUDENT'),
(149, 'Adeel Farooq', 'adeel.farooq4@gift.com', 'adeel123', 'STUDENT'),
(150, 'Huma Shah', 'huma.shah4@gift.com', 'huma123', 'STUDENT'),
(151, 'Fahad Ali', 'fahad.ali3@gift.com', 'fahad123', 'STUDENT'),
(152, 'Sania Farooq', 'sania.farooq4@gift.com', 'sania123', 'STUDENT'),
(153, 'Omar Khan', 'omar.khan5@gift.com', 'omar123', 'STUDENT'),
(154, 'Zoya Shah', 'zoya.shah4@gift.com', 'zoya123', 'STUDENT'),
(155, 'Usama Ali', 'usama.ali4@gift.com', 'usama123', 'STUDENT'),
(156, 'Maryam Farooq', 'maryam.farooq5@gift.com', 'maryam123', 'STUDENT'),
(157, 'Bilal Shah', 'bilal.shah2@gift.com', 'bilal123', 'STUDENT'),
(158, 'Ayesha Khan', 'ayesha.khan5@gift.com', 'ayesha123', 'STUDENT'),
(159, 'Hamza Ali', 'hamza.ali3@gift.com', 'hamza123', 'STUDENT'),
(160, 'Iqra Farooq', 'iqra.farooq4@gift.com', 'iqra123', 'STUDENT'),
(161, 'Tariq Khan', 'tariq.khan3@gift.com', 'tariq123', 'STUDENT'),
(162, 'Noor Ali', 'noor.ali4@gift.com', 'noor123', 'STUDENT'),
(163, 'Shahid Khan', 'shahid.khan2@gift.com', 'shahid123', 'STUDENT'),
(165, 'Kamran Ali', 'kamran.ali4@gift.com', 'kamran123', 'STUDENT'),
(166, 'Sana Shah', 'sana.shah4@gift.com', 'sana123', 'STUDENT'),
(167, 'admin', 'admin@gift.com', 'admin1234', 'ADMIN'),
(169, 'sharmeen', 'sharmeen@gift.edu', '12345', 'STUDENT'),
(171, 'sana', 'sana@gift.com', '12345', 'STUDENT'),
(173, 'hamza', 'hamza@email.com', '1234', 'STUDENT'),
(174, 'Hadiya', 'hadiya@gift.edu', 'hadiya123', 'STUDENT'),
(175, 'hadiya', 'hadiya@email.com', '123', 'STUDENT'),
(176, 'Ali', 'ali@email.com', '123', 'STUDENT'),
(177, 'ali', 'ali@gmail.com', '123', 'STUDENT'),
(178, 'huzaima', 'huzaima@gift.edu', '123', 'STUDENT'),
(478, 'umaima', 'umaima@gift.com', '111', 'STUDENT'),
(789, 'Ahmad Raza', 'ahmad@gift.com', '111', 'TEACHER');

-- --------------------------------------------------------

--
-- Structure for view `admin_details`
--
DROP TABLE IF EXISTS `admin_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `admin_details`  AS SELECT `u`.`user_id` AS `admin_id`, `u`.`name` AS `admin_name`, `u`.`email` AS `email`, `u`.`password` AS `password` FROM `user` AS `u` WHERE `u`.`role` = 'ADMIN' ;

-- --------------------------------------------------------

--
-- Structure for view `student_details`
--
DROP TABLE IF EXISTS `student_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `student_details`  AS SELECT `s`.`student_id` AS `student_id`, `u`.`name` AS `student_name`, `u`.`email` AS `email`, `s`.`roll_no` AS `roll_no`, `s`.`section_id` AS `section_id`, `sec`.`section_name` AS `section_name`, `sub`.`subject_name` AS `subject_name` FROM (((`student` `s` join `user` `u` on(`s`.`student_id` = `u`.`user_id`)) join `section` `sec` on(`s`.`section_id` = `sec`.`section_id`)) join `subject` `sub` on(`sec`.`subject_id` = `sub`.`subject_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `teacher_details`
--
DROP TABLE IF EXISTS `teacher_details`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `teacher_details`  AS SELECT `t`.`teacher_id` AS `teacher_id`, `u`.`name` AS `teacher_name`, `u`.`email` AS `email`, group_concat(distinct `sub`.`subject_name` separator ', ') AS `subjects`, group_concat(distinct `sec`.`section_name` separator ', ') AS `sections` FROM (((((`teacher` `t` join `user` `u` on(`t`.`teacher_id` = `u`.`user_id`)) left join `teacher_subject` `ts` on(`t`.`teacher_id` = `ts`.`teacher_id`)) left join `subject` `sub` on(`ts`.`subject_id` = `sub`.`subject_id`)) left join `teachersection` `tsec` on(`t`.`teacher_id` = `tsec`.`teacher_id`)) left join `section` `sec` on(`tsec`.`section_id` = `sec`.`section_id`)) GROUP BY `t`.`teacher_id`, `u`.`name`, `u`.`email` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`admin_id`);

--
-- Indexes for table `attempt`
--
ALTER TABLE `attempt`
  ADD PRIMARY KEY (`attempt_id`),
  ADD UNIQUE KEY `student_id` (`student_id`,`quiz_id`),
  ADD KEY `quiz_id` (`quiz_id`);

--
-- Indexes for table `questionbank`
--
ALTER TABLE `questionbank`
  ADD PRIMARY KEY (`question_id`),
  ADD KEY `subject_id` (`subject_id`);

--
-- Indexes for table `quiz`
--
ALTER TABLE `quiz`
  ADD PRIMARY KEY (`quiz_id`),
  ADD KEY `subject_id` (`subject_id`),
  ADD KEY `section_id` (`section_id`),
  ADD KEY `teacher_id` (`teacher_id`);

--
-- Indexes for table `quizquestion`
--
ALTER TABLE `quizquestion`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `quiz_id` (`quiz_id`,`question_id`),
  ADD KEY `question_id` (`question_id`);

--
-- Indexes for table `result`
--
ALTER TABLE `result`
  ADD PRIMARY KEY (`result_id`),
  ADD UNIQUE KEY `attempt_id` (`attempt_id`);

--
-- Indexes for table `section`
--
ALTER TABLE `section`
  ADD PRIMARY KEY (`section_id`),
  ADD UNIQUE KEY `section_name` (`section_name`),
  ADD KEY `subject_id` (`subject_id`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`student_id`),
  ADD UNIQUE KEY `roll_no` (`roll_no`);

--
-- Indexes for table `subject`
--
ALTER TABLE `subject`
  ADD PRIMARY KEY (`subject_id`),
  ADD UNIQUE KEY `subject_name` (`subject_name`);

--
-- Indexes for table `teacher`
--
ALTER TABLE `teacher`
  ADD PRIMARY KEY (`teacher_id`);

--
-- Indexes for table `teachersection`
--
ALTER TABLE `teachersection`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `teacher_id` (`teacher_id`,`section_id`),
  ADD KEY `section_id` (`section_id`);

--
-- Indexes for table `teacher_subject`
--
ALTER TABLE `teacher_subject`
  ADD PRIMARY KEY (`teacher_id`,`subject_id`),
  ADD KEY `subject_id` (`subject_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `user_id_unique` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `attempt`
--
ALTER TABLE `attempt`
  MODIFY `attempt_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `questionbank`
--
ALTER TABLE `questionbank`
  MODIFY `question_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1060;

--
-- AUTO_INCREMENT for table `quiz`
--
ALTER TABLE `quiz`
  MODIFY `quiz_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `quizquestion`
--
ALTER TABLE `quizquestion`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `result`
--
ALTER TABLE `result`
  MODIFY `result_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `section`
--
ALTER TABLE `section`
  MODIFY `section_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `subject`
--
ALTER TABLE `subject`
  MODIFY `subject_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `teachersection`
--
ALTER TABLE `teachersection`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=892;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin`
--
ALTER TABLE `admin`
  ADD CONSTRAINT `admin_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `attempt`
--
ALTER TABLE `attempt`
  ADD CONSTRAINT `attempt_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`),
  ADD CONSTRAINT `attempt_ibfk_2` FOREIGN KEY (`quiz_id`) REFERENCES `quiz` (`quiz_id`);

--
-- Constraints for table `questionbank`
--
ALTER TABLE `questionbank`
  ADD CONSTRAINT `questionbank_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`) ON DELETE CASCADE;

--
-- Constraints for table `quiz`
--
ALTER TABLE `quiz`
  ADD CONSTRAINT `quiz_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`),
  ADD CONSTRAINT `quiz_ibfk_2` FOREIGN KEY (`section_id`) REFERENCES `section` (`section_id`),
  ADD CONSTRAINT `quiz_ibfk_3` FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`);

--
-- Constraints for table `quizquestion`
--
ALTER TABLE `quizquestion`
  ADD CONSTRAINT `quizquestion_ibfk_1` FOREIGN KEY (`quiz_id`) REFERENCES `quiz` (`quiz_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `quizquestion_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `questionbank` (`question_id`);

--
-- Constraints for table `result`
--
ALTER TABLE `result`
  ADD CONSTRAINT `result_ibfk_1` FOREIGN KEY (`attempt_id`) REFERENCES `attempt` (`attempt_id`) ON DELETE CASCADE;

--
-- Constraints for table `section`
--
ALTER TABLE `section`
  ADD CONSTRAINT `section_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`) ON DELETE CASCADE;

--
-- Constraints for table `student`
--
ALTER TABLE `student`
  ADD CONSTRAINT `student_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `teacher`
--
ALTER TABLE `teacher`
  ADD CONSTRAINT `teacher_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `user` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `teachersection`
--
ALTER TABLE `teachersection`
  ADD CONSTRAINT `teachersection_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `teachersection_ibfk_2` FOREIGN KEY (`section_id`) REFERENCES `section` (`section_id`) ON DELETE CASCADE;

--
-- Constraints for table `teacher_subject`
--
ALTER TABLE `teacher_subject`
  ADD CONSTRAINT `teacher_subject_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teacher` (`teacher_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `teacher_subject_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subject` (`subject_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
