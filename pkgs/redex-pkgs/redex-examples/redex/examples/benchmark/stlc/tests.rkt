#lang racket/base

(require redex/reduction-semantics
         "stlc-base.rkt")

(test-equal (term (uses-bound-var? () 5))
            #f)
(test-equal (term (uses-bound-var? () nil))
            #f)
(test-equal (term (uses-bound-var? () (λ (x int) x)))
            #t)
(test-equal (term (uses-bound-var? () (λ (x int) y)))
            #f)
(test-equal (term (uses-bound-var? () ((λ (x int) x) 5)))
            #t)
(test-equal (term (uses-bound-var? () ((λ (x int) xy) 5)))
            #f)

(test-equal (judgment-holds (typeof • 5 τ) τ)
            (list (term int)))
(test-equal (judgment-holds (typeof • nil τ) τ)
            (list (term (list int))))
(test-equal (judgment-holds (typeof • (cons 1) τ) τ)
            (list (term ((list int) → (list int)))))
(test-equal (judgment-holds (typeof • ((cons 1) nil) τ) τ)
            (list (term (list int))))
(test-equal (judgment-holds (typeof • (λ (x int) x) τ) τ)
            (list (term (int → int))))
(test-equal (judgment-holds (typeof • (λ (x (int → int)) (λ (y int) x)) τ) τ)
            (list (term ((int → int) → (int → (int → int))))))

(test-->> red (term ((λ (x int) x) 7)) (term 7))
(test-->> red (term (((λ (x int) (λ (x int) x)) 2) 1)) (term 1))
(test-->> red (term (((λ (x int) (λ (y int) x)) 2) 1)) (term 2))
(test-->> red 
          (term ((λ (x int) ((cons x) nil)) 11))
          (term ((cons 11) nil)))
(test-->> red 
          (term ((λ (x int) ((cons x) nil)) 11))
          (term ((cons 11) nil)))
(test-->> red 
          (term ((cons ((λ (x int) x) 11)) nil))
          (term ((cons 11) nil)))
(test-->> red
          (term (cons ((λ (x int) x) 1)))
          (term (cons 1)))
(test-->> red
          (term ((cons ((λ (x int) x) 1)) nil))
          (term ((cons 1) nil)))
(test-->> red
          (term (hd ((λ (x int) ((cons x) nil)) 11)))
          (term 11))
(test-->> red
          (term (tl ((λ (x int) ((cons x) nil)) 11)))
          (term nil))
(test-->> red
          (term (tl nil))
          "error")
(test-->> red
          (term (hd nil))
          "error")

(test-equal (Eval (term ((λ (x int) x) 3)))
            (term 3))

(test-equal (reduction-step-count (term (λ (x int) x)))
            0)
(test-equal (reduction-step-count (term ((λ (x int) x) 1)))
            1)
(test-equal (reduction-step-count (term ((λ (x int) x) 1)))
            1)
(test-equal (reduction-step-count (term ((cons 1) nil)))
            0)
(test-equal (reduction-step-count (term (hd ((cons 1) nil))))
            1)
(test-equal (reduction-step-count (term (hd nil)))
            1)
(test-equal (reduction-step-count (term ((λ (x int) x) (hd ((cons 1) nil)))))
            2)

(test-results)