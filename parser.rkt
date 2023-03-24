#lang brag
RifL-program: debug (convert-to-deck | RifL-program-sub /NEWLINE convert-to-deck)
debug: /NEWLINE* [STEP] /NEWLINE* [RSTEP] /NEWLINE* [END] /NEWLINE*
@RifL-program-sub: convert-to-deck | RifL-program-sub /NEWLINE convert-to-deck
convert-to-deck: convert-to-name /DIVIDER convert-to-stack
convert-to-name: [s-name [/COMMA]] S-PIP-CARD | [c-name [/COMMA]] C-PIP-CARD |
                 [h-name [/COMMA]] H-PIP-CARD | [d-name [/COMMA]] D-PIP-CARD
@s-name: S-PIP-CARD | s-name [/COMMA] S-PIP-CARD
@c-name: C-PIP-CARD | c-name [/COMMA] C-PIP-CARD
@h-name: H-PIP-CARD | h-name [/COMMA] H-PIP-CARD
@d-name: D-PIP-CARD | d-name [/COMMA] D-PIP-CARD
convert-to-stack: () | (/NEWLINE | entry) | sub-stack (/NEWLINE | entry)
@sub-stack: (/NEWLINE | entry [/COMMA]) | sub-stack (/NEWLINE | entry [/COMMA])
entry: S-PIP-CARD | C-PIP-CARD | H-PIP-CARD | D-PIP-CARD| ROYAL-CARD | JOKER | FACE-DOWN