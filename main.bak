#lang br/quicklang
(require "parser.rkt" "tokenizer.rkt")

(define (read-syntax path port)
  (define parse-tree (parse path (make-tokenizer port path)))
  (strip-bindings
   #`(module RifL-mod RifL/expander
       #,parse-tree)))

(define (get-info port src-mod src-line src-col src-pos)
    (define (handle-query key default)
      (case key
        [(color-lexer)
           (dynamic-require 'RifL/colorer 'RifL-colorer)]
        #;[(drracket:indentation)
           (dynamic-require 'jsonic/indenter 'indent-jsonic)]
        #;[(drracket:toolbar-buttons)
           (dynamic-require 'RifL/buttons 'button-list)]
        [else default]))
    handle-query)

(module+ reader
  (provide read-syntax get-info))