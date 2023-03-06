#lang br
(require "lexer.rkt" brag/support)
(provide RifL-colorer)

(define (RifL-colorer port)
  (define (handle-lexer-error excn)
    (define excn-srclocs (exn:fail:read-srclocs excn))
    (srcloc-token (token 'ERROR) (car excn-srclocs)))
  (define srcloc-tok
    (with-handlers ([exn:fail:read? handle-lexer-error])
      (RifL-lexer port)))
  (match srcloc-tok
    [(? eof-object?) (values srcloc-tok 'eof #f #f #f)]
    [else
     (match-define
       (srcloc-token
        (token-struct type val _ _ _ _ _)
        (srcloc _ _ _ posn span)) srcloc-tok)
        (define start posn)
     (define end (+ start span))
     (match-define (list cat paren)
       (match type
         ;'DIVIDER #-PIP-CARD ROYAL-CARD JOKER
         ;'error, 'comment, 'sexp-comment, 'white-space,
         ;'constant, 'string, 'no-color, 'parenthesis,
         ;?'hash-colon-keyword, 'symbol, 'eof, or 'other.
         ['COMMA '(string #f)]
         ['FACE-DOWN '(parenthesis #f)]
         ['COMMENT '(comment #f)]
         ['DIVIDER '(string #f)]
         ['S-PIP-CARD '(symbol #f)]
         ['C-PIP-CARD '(symbol #f)]
         ['H-PIP-CARD '(symbol #f)]
         ['D-PIP-CARD '(symbol #f)]
         ['JOKER      '(symbol #f)]
         ['ROYAL-CARD '(constant #f)]
         [else '(error #f)]))
     (values val cat paren start end)]))