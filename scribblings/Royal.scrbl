#lang scribble/manual

@title{Royal}

@section{Instruction Notation}
Each Royal card below lists its form, which
shows the number of @seclink["Arguments"]{arguments} it takes, and
gives each @seclink["Arguments"]{argument} a name. Named @seclink["Arguments"]{arguments} are
written between square brackets.

After the form, the instructions, that is
the digital/physical process to follow is listed.
@seclink["Arguments"]{argument} might be written with @seclink["Data"]{data} types before them,
which is an instruction to convert the @seclink["Arguments"]{argument}
into that @seclink["Data"]{data} type.

Anytime an @seclink["Arguments"]{argument} gets put on top of the @seclink["The_Stack"]{stack},
the @seclink["Arguments"]{argument} must first be reversed in order.

@section{Jacks}

@subsection{Js}

@bold{Form: [Deck], Js}

@bold{Instruction:} Move the pointer to [@secref{Name} (@seclink["The_Stack"]{stack} exclusive) Deck].

@subsection{Jc}

@bold{Form: [X], [Y], Jc}

@bold{Instruction:} Starting at the current @seclink["Decks"]{deck} space, count to the right
[@secref{Integer} X] times, and up [@secref{Integer} Y] times. Diamonds wrap around to spades.
Negative [@secref{Integer} X] moves left. Negative [@secref{Integer} Y] moves down.
Push the @seclink["Name"]{name} of the landed on @seclink["Decks"]{deck} space onto the @seclink["The_Stack"]{stack}.
If the landed on @seclink["Decks"]{deck} space is below the bottom row of the table,
throw an error.

@subsection{Jh}

@bold{Form: [Deck], Jh}

@bold{Instruction:} Count the number of @seclink["Arguments"]{arguments} of [@secref{Name} (@seclink["The_Stack"]{stack} inclusive) Deck].
Turn that integer into cards,
and put it on top of the @seclink["The_Stack"]{stack}.

@subsection{Jd}

@bold{Form: [Deck], [Operation], Jd}

@bold{Instruction:} The leading suit of [Operation] changes the function.

@italic{Spades: Print Cards} Output the [@secref{Name} (@seclink["The_Stack"]{stack} inclusive) Deck] as a list of cards.
Outputting a @seclink["Decks"]{deck} does not change it.

@italic{Clubs: Print Data} Output the [@secref{Name} (@seclink["The_Stack"]{stack} inclusive) Deck] as interpreted @seclink["Data"]{data}. If the
named @seclink["Decks"]{deck} is the @seclink["The_Stack"]{stack}, it gets outputted in reversed order.
@seclink["Data"]{Data} with the leading suit spades or clubs
gets interpreted as a @seclink["Real_Number"]{real number}. @seclink["Data"]{Data} with the leading suit hearts and Jokers
gets interpreted as a @seclink["Character"]{character}. @seclink["Data"]{Data} with the leading suit diamonds gets
interpreted as a @seclink["Boolean"]{boolean}. Royal cards do not get outputted.
Outputting a @seclink["Decks"]{deck} does not change it.

@italic{Hearts: Read Cards} Take an input of cards and puts
it on top of the [@secref{Name} (@seclink["The_Stack"]{stack} inclusive) Deck]. If the named @seclink["Decks"]{deck} is the stack,
reverse the inputted cards before putting them on top of the @seclink["The_Stack"]{stack}.

@italic{Diamonds: Read Data} Take an input of @seclink["Character"]{characters},
and transform it into cards, and put it on top of the named @seclink["Decks"]{deck}.
If the named @seclink["Decks"]{deck} is the @seclink["The_Stack"]{stack}, reverse the cards before putting it
on top of the @seclink["The_Stack"]{stack}. FR is put between each datum read in.

However, there are special strings of characters that do not
get interpreted as characters:

@itemlist[@item{A string of characters that are digits
                and has up to one '.' in it
                is intepreted as a @seclink["Real_Number"]{real number}.}
           @item{A string of characters that starts with
                 '-', followed by digits, with up to one
                 '.' in it is intepreted as a @seclink["Real_Number"]{real number}.}
          @item{The string "#t" and "#f" gets interpreted as a @seclink["Boolean"]{boolean}.}]


@italic{Joker:} Error

@italic{This card is likely to be updated in the future.
Use tens cards for [Operation] for future proofing.}


@section{Queens}

@subsection{Qs}

@bold{Form: [A], [B], [Operation] Qs}

@bold{Instruction:} The leading suit of [Operation] changes the function.

@italic{Spades: Greater-than/OR:} If [A] & [B] have the same leading suit, put the larger
of [@seclink["Real_Number"]{Real} A] & [@seclink["Real_Number"]{Real} B] onto @seclink["The_Stack"]{stack}. If they
are both equal to 0, the one with less cards is the larger value.

If [A] & [B] have different leading suits, put the one with the
"larger" leading suit. @italic{spades > clubs > hearts > diamonds > Jokers}

@italic{Clubs: Less-than/AND:} If [A] & [B] have the same leading suit, put the smaller
of [@seclink["Real_Number"]{Real} A] & [@seclink["Real_Number"]{Real} B] onto @seclink["The_Stack"]{stack}. If they
are both equal to 0, the one with more cards is the smaller value.

If [A] & [B] have different leading suits, put the one with the
"smaller" leading suit. @italic{spades > clubs > hearts > diamonds > Jokers}

@italic{Hearts: Equal/XNOR:} If [A] is exactly the same as [B],
put [A] on top of the @seclink["The_Stack"]{stack}. Otherwise, put 0d on top of the @seclink["The_Stack"]{stack}.

@italic{Diamonds: Equivalent/NOT:} If both [@secref{Boolean} A] & [@secref{Boolean} B] are false,
put Ad on top of the @seclink["The_Stack"]{stack}. Otherwise, if [@secref{Integer} A] is the same as [@secref{Integer} B],
put [A] on top of the @seclink["The_Stack"]{stack}. Otherwise, put 0d on top of the @seclink["The_Stack"]{stack}.

@italic{Joker:} Error

@subsection{Qc}

@bold{Form: [A], [B], [Operation] Qc}

@bold{Instruction:} The leading suit of [Operation] changes the function.

@italic{Spades: Add:} Put [@seclink["Real_Number"]{Real} A] + [@seclink["Real_Number"]{Real} B] on top of the @seclink["The_Stack"]{stack}.

@italic{Clubs: Subtract:} Put [@seclink["Real_Number"]{Real} A] - [@seclink["Real_Number"]{Real} B] on top of the @seclink["The_Stack"]{stack}.

@italic{Hearts: Multiply:} Put [@seclink["Real_Number"]{Real} A] * [@seclink["Real_Number"]{Real} B] on top of the @seclink["The_Stack"]{stack}.

@italic{Diamonds: Divide:} Put [@seclink["Real_Number"]{Real} A] / [@seclink["Real_Number"]{Real} B] on top of the @seclink["The_Stack"]{stack}.
If [@seclink["Real_Number"]{Real} B] is zero, throw an error.

@italic{Joker: Concatenate:} Put [A] on top of the @seclink["The_Stack"]{stack},
then put [B] on top of the @seclink["The_Stack"]{stack}. Do not put any
face-down cards between them.


@subsection{Qh}

@bold{Form: [A], [B], [Proposition] Qh}

@bold{Instruction:} If [@secref{Boolean} Proposition] is #t,
put [A] on top of the @seclink["The_Stack"]{stack}. If
[@secref{Boolean} Proposition] is #f, put [B] on top of the @seclink["The_Stack"]{stack}.
If [@secref{Boolean} Proposition] is null, do nothing.


@subsection{Qd}

@bold{Form: [Sequence], [Modifier] Qd}

@bold{Instruction:} If [Sequence] or [Modifier] is a Joker,
throw an error. Otherwise, make a copy of [Sequence],
except the suit of every card in the copy of [Sequence] is the
same as the leading suit of [Modifier]. Put the copy of [Sequence]
on top of the @seclink["The_Stack"]{stack}.

@italic{This card is likely to be updated in the future,
such that [Modifier] had multiple functions. Use tens cards
for [Modifier] for future proofing.}

@section{Kings}

@subsection{Ks}

@bold{Form: [Origin], [Destination], [Operation] Ks}

@bold{Instruction:} Find the [@secref{Integer} Operation] @seclink["Arguments"]{argument} of [@secref{Name} (@seclink["The_Stack"]{stack} inclusive) Origin].
If there are not enough @seclink["Arguments"]{arguments} in [@secref{Name} (@seclink["The_Stack"]{stack} inclusive) Origin], throw an error.
The leading suit of [Operation] changes the function.

@italic{Spades: Copy One:} If [Destination] is a Joker, do nothing.
Otherwise copy the found @seclink["Arguments"]{argument} and the face-down
cards directly below it and put it on top of [@secref{Name} (@seclink["The_Stack"]{stack} exclusive) Destination].
If [@secref{Name} (@seclink["The_Stack"]{stack} inclusive) Origin] is the @seclink["The_Stack"]{stack}, instead copy the found @seclink["Arguments"]{argument} and the
face-down cards directly above it, reverse all of those cards,
and put it on top of [@secref{Name} (@seclink["The_Stack"]{stack} exclusive) Destination].

@italic{Clubs: Copy Up To:} If [Destination] is a Joker, do nothing.
Otherwise, copy all the cards above and including
the found @seclink["Arguments"]{argument}, and put it on top of [@secref{Name} (@seclink["The_Stack"]{stack} exclusive Destination].
If [@secref{Name} (@seclink["The_Stack"]{stack} inclusive) Origin] is the @seclink["The_Stack"]{stack}, reverse all of those cards before
putting it on top of [@secref{Name} (@seclink["The_Stack"]{stack} exclusive Destination].

@italic{Hearts: Move One:} Remove the the found @seclink["Arguments"]{argument} and the face-down
cards directly below it from [@secref{Name} (@seclink["The_Stack"]{stack} inclusive) Origin]: if [Destination]
is a Joker, the removed cards go nowhere, otherwise
put them on top of [@secref{Name} (@seclink["The_Stack"]{stack} exclusive) Destination].
If [@secref{Name} (@seclink["The_Stack"]{stack} inclusive) Origin] is the @seclink["The_Stack"]{stack},
reverse the found cards before moving them.

@italic{Diamonds: Move Up To:} Remove all the cards above and including
the found @seclink["Arguments"]{argument}, as well as the face down cards directly below it.
If [Destination] is a Joker, the removed cards go nowhere,
otherwise put them on top of [@secref{Name} (@seclink["The_Stack"]{stack} exclusive) Destination].
If [@secref{Name} (@seclink["The_Stack"]{stack} inclusive) Origin] is the @seclink["The_Stack"]{stack}, reverse all of those cards before
putting them on top of [@secref{Name} (@seclink["The_Stack"]{stack} exclusive) Destination].

@italic{Joker: Copy Whole:} If [Destination] is a Joker, delete
[@secref{Name} (@seclink["The_Stack"]{stack} inclusive) Origin].
Otherwise copy [@secref{Name} (@seclink["The_Stack"]{stack} inclusive) Origin] and put it on top
of [@secref{Name} (@seclink["The_Stack"]{stack} exclusive) Destination].
If [@secref{Name} (@seclink["The_Stack"]{stack} inclusive) Origin] is the @seclink["The_Stack"]{stack},
reverse the copy before putting in on top of [@secref{Name} (@seclink["The_Stack"]{stack} exclusive) Destination]


@subsection{Kc}

@italic{Currently does nothing. Will be added in the future.}


@subsection{Kh}

@bold{Form: [Deck], Kh}

@bold{Instruction:} Flip [@secref{Name} (@seclink["The_Stack"]{stack} inclusive) Deck] over.


@subsection{Kd}

@bold{Form: [Deck], Kd}

@bold{Instruction:} Shuffle [@secref{Name} (@seclink["The_Stack"]{stack} inclusive) Deck].
