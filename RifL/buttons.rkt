#lang br
#;((require racket/draw)

(define step-by-step #t)

(define (swap-step)
  (set! step-by-step (not step-by-step)))

(define (button-func drr-window)
  '()
  )
  #;((set! step-by-step (not step-by-step))
  (display step-by-step))
  #;((define expr-string "@$  $@")
  (define editor (send drr-window get-definitions-text))
  (send editor insert expr-string)
  (define pos (send editor get-start-position))
  (send editor set-position (- pos 3)))

(define our-RifL-button
  (list
   "Step by Step"
   (make-object bitmap% 16 16) ; a 16 x 16 white square
   button-func
   #f))

(provide button-list step-by-step)
(define button-list (list our-RifL-button)))