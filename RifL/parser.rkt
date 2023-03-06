#lang brag
RifL-program: [convert-to-deck] (/NEWLINE [convert-to-deck])*
convert-to-deck: convert-to-name /DIVIDER convert-to-stack
convert-to-name: ((S-PIP-CARD [/COMMA])* S-PIP-CARD) |
                 ((C-PIP-CARD [/COMMA])* C-PIP-CARD) |
                 ((H-PIP-CARD [/COMMA])* H-PIP-CARD) |
                 ((D-PIP-CARD [/COMMA])* D-PIP-CARD)
convert-to-stack: (entry* /NEWLINE)* entry*
entry: (S-PIP-CARD | C-PIP-CARD | H-PIP-CARD | D-PIP-CARD| ROYAL-CARD | JOKER | FACE-DOWN) [/COMMA]