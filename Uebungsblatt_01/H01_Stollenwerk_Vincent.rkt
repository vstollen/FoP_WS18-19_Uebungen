;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname H01_Stollenwerk_Vincent) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f () #f)))
(define-struct binary-tree-node (value left right))

;; example tree 1
(define tree-small (make-binary-tree-node
 5
 (make-binary-tree-node 3 (make-binary-tree-node 1 '() '()) (make-binary-tree-node 4 '() '()))
 (make-binary-tree-node 9 (make-binary-tree-node 6 '() '()) (make-binary-tree-node 11 '() '()))))

;; example tree 2
(define tree-middle (make-binary-tree-node
 6
 (make-binary-tree-node 3 (make-binary-tree-node 1 '() '()) (make-binary-tree-node 4 '() '()))
 (make-binary-tree-node 12 (make-binary-tree-node 8 '() (make-binary-tree-node 9 '() '())) (make-binary-tree-node 14 '() '()))))

;; example tree 3
(define tree-large (make-binary-tree-node
 20
 (make-binary-tree-node
  19
  (make-binary-tree-node
   14
   (make-binary-tree-node 8 (make-binary-tree-node 2 '() '()) (make-binary-tree-node 12 (make-binary-tree-node 10 '() '()) '()))
   '())
  '())
 (make-binary-tree-node
  23
  '()
  (make-binary-tree-node
   24
   '()
   (make-binary-tree-node
    29
    '()
    (make-binary-tree-node
     44
     (make-binary-tree-node 31 '() (make-binary-tree-node 43 (make-binary-tree-node 33 '() '()) '()))
     (make-binary-tree-node 77 (make-binary-tree-node 47 '() '()) '())))))))


;; H1
;; Type: number binary-tree-node -> boolean
;; Returns: If a binary search tree contains a given number
(define (binary-tree-contains? value btn)
  (if (empty? btn)
      false
      (if (= (binary-tree-node-value btn) value)
          true
          (binary-tree-contains? value (if (< (binary-tree-node-value btn) value)
                                           (binary-tree-node-right btn)
                                           (binary-tree-node-left btn))))))

(check-expect (binary-tree-contains? 5 (make-binary-tree-node 3 empty (make-binary-tree-node 5 empty empty))) true)
(check-expect (binary-tree-contains? 12 tree-small) false)
(check-expect (binary-tree-contains? 14 tree-middle) true)
(check-expect (binary-tree-contains? 42 empty) false)


;; H2
;; Type: number binary-tree-node -> binary-tree-node
;; Returns: Given binary tree after inserting value
(define (insert-into-binary-tree value btn)
  (if (empty? btn)
      (make-binary-tree-node value empty empty)
      (if (= value (binary-tree-node-value btn))
             btn
             (if (< (binary-tree-node-value btn) value)
                 (make-binary-tree-node (binary-tree-node-value btn) (binary-tree-node-left btn) (insert-into-binary-tree value (binary-tree-node-right btn)))
                 (make-binary-tree-node (binary-tree-node-value btn) (insert-into-binary-tree value (binary-tree-node-left btn)) (binary-tree-node-right btn))))))

(check-expect (insert-into-binary-tree 100 empty) (make-binary-tree-node 100 empty empty))

(check-expect (insert-into-binary-tree 44 tree-small) (make-binary-tree-node
 5
 (make-binary-tree-node 3 (make-binary-tree-node 1 '() '()) (make-binary-tree-node 4 '() '()))
 (make-binary-tree-node 9 (make-binary-tree-node 6 '() '()) (make-binary-tree-node 11 '() (make-binary-tree-node 44 '() '()))))) 

(check-expect (insert-into-binary-tree 6 tree-large) (make-binary-tree-node
 20
 (make-binary-tree-node
  19
  (make-binary-tree-node
   14
   (make-binary-tree-node
    8
    (make-binary-tree-node 2 '() (make-binary-tree-node 6 '() '()))
    (make-binary-tree-node 12 (make-binary-tree-node 10 '() '()) '()))
   '())
  '())
 (make-binary-tree-node
  23
  '()
  (make-binary-tree-node
   24
   '()
   (make-binary-tree-node
    29
    '()
    (make-binary-tree-node
     44
     (make-binary-tree-node 31 '() (make-binary-tree-node 43 (make-binary-tree-node 33 '() '()) '()))
     (make-binary-tree-node 77 (make-binary-tree-node 47 '() '()) '())))))))

;; H3
;; Type: (list of number) -> binary-tree-node
;; Returns: Binary search tree given a list
(define (binary-tree-from-list lst)
  ;; Insert code here
  (insert-list-into-binary-tree lst empty)
)

(check-expect (binary-tree-from-list (list 9 12 13)) (make-binary-tree-node 9 empty (make-binary-tree-node 12 empty (make-binary-tree-node 13 empty empty))))
(check-expect (binary-tree-from-list (list 20 23 19 14 24 29 44 8 12 31 77 47 43 33 10 2)) tree-large)
(check-expect (binary-tree-from-list (list 5 9 3 11 6 4 1)) tree-small)

;; Hilfsmethode H3
;; Type: (list of number) binary-tree-node -> binary-tree-node
;; Returns: Binary search tree after inserting each list item
(define (insert-list-into-binary-tree lst btn)
  (if (empty? lst)
      btn
      (insert-list-into-binary-tree (rest lst) (insert-into-binary-tree (first lst) btn))))

(check-expect (insert-list-into-binary-tree empty tree-large) tree-large)
(check-expect (insert-list-into-binary-tree empty empty) empty)
(check-expect (insert-list-into-binary-tree (list 44 8 12 31 77 47 43 33 10 2) (insert-list-into-binary-tree (list 20 23 19 14 24 29) empty)) tree-large)

;; H4
;; Type: number binary-tree-node -> binary-tree-node
;; Returns: Binary tree after inserting a given value, allowing duplicates in form of a list of numbers
(define (insert-into-binary-tree-duplicates value btn)
  (if (empty? btn)
      (make-binary-tree-node value empty empty)
      (if (= value (if (list? (binary-tree-node-value btn))
                       (first (binary-tree-node-value btn))
                       (binary-tree-node-value btn)))
             (make-binary-tree-node (append (if (list? (binary-tree-node-value btn))
                                                       (binary-tree-node-value btn)
                                                       (list (binary-tree-node-value btn))) (list value)) (binary-tree-node-left btn) (binary-tree-node-right btn))
             (if (< (binary-tree-node-value btn) value)
                 (make-binary-tree-node (binary-tree-node-value btn) (binary-tree-node-left btn) (insert-into-binary-tree-duplicates value (binary-tree-node-right btn)))
                 (make-binary-tree-node (binary-tree-node-value btn) (insert-into-binary-tree-duplicates value (binary-tree-node-left btn)) (binary-tree-node-right btn))))))

(check-expect (insert-into-binary-tree-duplicates 5 (make-binary-tree-node 3 empty (make-binary-tree-node 5 empty empty))) (make-binary-tree-node 3 empty (make-binary-tree-node (list 5 5) empty empty)))

(check-expect (insert-into-binary-tree-duplicates 11 tree-small) (make-binary-tree-node
 5
 (make-binary-tree-node 3 (make-binary-tree-node 1 '() '()) (make-binary-tree-node 4 '() '()))
 (make-binary-tree-node 9 (make-binary-tree-node 6 '() '()) (make-binary-tree-node (list 11 11) '() '()))))

(check-expect (insert-into-binary-tree-duplicates 4 (insert-into-binary-tree-duplicates 4 tree-middle)) (make-binary-tree-node
 6
 (make-binary-tree-node 3 (make-binary-tree-node 1 '() '()) (make-binary-tree-node (list 4 4 4) '() '()))
 (make-binary-tree-node 12 (make-binary-tree-node 8 '() (make-binary-tree-node 9 '() '())) (make-binary-tree-node 14 '() '()))))