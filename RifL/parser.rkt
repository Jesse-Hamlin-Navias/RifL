#lang brag
RifL-program: (/WHITESPACE)* [deck] (/NEWLINE (/WHITESPACE)* [deck])*
deck: name /DIVIDER (/WHITESPACE)* convert-to-stack
name: ((S-PIP-CARD [/","] (/WHITESPACE)+)* S-PIP-CARD (/WHITESPACE)*) |
      ((C-PIP-CARD [/","] (/WHITESPACE)+)* C-PIP-CARD (/WHITESPACE)*) |
      ((H-PIP-CARD [/","] (/WHITESPACE)+)* H-PIP-CARD (/WHITESPACE)*) |
      ((D-PIP-CARD [/","] (/WHITESPACE)+)* D-PIP-CARD (/WHITESPACE)*)
convert-to-stack: ([entry] ((/WHITESPACE)+ entry)* (/WHITESPACE)* /NEWLINE)*
       ([entry] ((/WHITESPACE)+ entry)* (/WHITESPACE)*)
@entry: (pip-card| ROYAL-CARD | JOKER | FACE-DOWN) [/","]
@pip-card: S-PIP-CARD | C-PIP-CARD | H-PIP-CARD | D-PIP-CARD