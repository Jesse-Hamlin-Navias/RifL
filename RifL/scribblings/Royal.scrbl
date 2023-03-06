#lang scribble/manual

@title{Royal Cards}

@section{Jacks}

@subsection{Js}

@bold{Form: [Name (stack exclusive)], Js}

@bold{Instruction:} Move the pointer to the named deck.

@subsection{Jc}

@bold{Form: [Force Integer X], [Force Integer Y], Js}

@bold{Instruction:} Starting at the current deck space, count to the right
[X] times, and up [Y] times. Diamonds wrap around to spades.
Negative [X] moves left. Negative [Y] moves down.
Push the name of the landed on deck space onto the stack (reversed).
If the landed on deck space is below the bottom row of the table,
throw an error.

@subsection{Jh}

@bold{Form: [Name (stack inclusive)], Jh}

@bold{Instruction:} Count the number of arguments of the named deck.
Royal cards count as arguments. Turn that number into
a card sequence, and put it on top of the stack (reversed).

@subsection{Jd}

@bold{Form: [Name (stack inclusive)], [Operation], Jd}

@bold{Instruction:} The leading suit of [Operation] changes the function.

@italic{Spades: Print Cards} Output the named deck as a list of cards.
Outputting a deck does not change it.

@italic{Clubs: Print Data} Output the named deck as interpreted data. If the
named deck is the stack, it gets outputted in reversed order.
Data with the leading suit spades or clubs
gets interpreted as a forced number. Data with the leading suit hearts
gets interpreted as a character. Data with the leading suit diamonds gets
interpreted as a boolean. Jokers and Royal cards do not get outputted.
Outputting a deck does not change it.

@italic{Hearts: Read Cards} Take an input of cards and puts
it on top of the named deck. If the named deck is the stack,
reverse the inputted cards before putting them on top of the stack.

@italic{Diamonds: Read Data} Take an input of characters,
and transform it into cards, and put it on top of the named deck.
If the named deck is the stack, reverse the cards before putting it
on top of the stack.
Every character gets turned into its ascii number, then that
number gets turned into a card sequence with the suit hearts.
A face-down R is put between each datum read in.

However, there are special characters that get turned into
cards differently.

@itemlist[@item{A string of characters that are all digits
          gets turned into a number, then turned into a spades card sequence.
          If the string of digits starts with a #\- the cards are
          club suit. If a #\. appears before the digits, the
          card sequence starts with a 10s (or 10c if the digits
          have a #\- before them), then a 10d, then the digits as cards.
          If a #\. appears in between digits, a 10d is placed in
          between those digits.}
          @item{The string "#t" gets turned into the card As.
           The string "#f" gets turned into the card 10d.}]


@italic{Joker:} Error

@section{Queens}

@subsection{Qs}

@bold{Form: [A], [B], [Operation] Qs}

@bold{Instruction:} The leading suit of [Operation] changes the function.

@italic{Spades: Greater-than/OR:} If [A] & [B] have the same leading suit, put the larger
of [Force Number A] & [Force Number B] onto stack (reversed). If they
are both equal to 0, the one with less cards is the larger value.

If [A] & [B] have different leading suits, put the one with the
"larger" leading suit. @italic{spades > clubs > hearts > diamonds > Jokers}

@italic{Clubs: Less-than/AND:} If [A] & [B] have the same leading suit, put the smaller
of [Force Number A] & [Force Number B] onto stack (reversed). If they
are both equal to 0, the one with more cards is the smaller value.

If [A] & [B] have different leading suits, put the one with the
"smaller" leading suit. @italic{spades > clubs > hearts > diamonds > Jokers}

@italic{Hearts: Equal/XNOR:} If [Card Sequence A] is exactly the same as [Card Sequence B],
put [Card Sequence A] on top of the stack. Otherwise, put 0d on top of the stack.

@italic{Diamonds: Equivalent/NOT:} If [Force Integer A] is the same as [Force Integer B],
put [A] on top of the stack. If both [Boolean A] & [Boolean B] are false,
put Ad on top of the stack. Otherwise, put 10d on top of the stack.

@italic{Joker:} Error

@subsection{Qc}

@bold{Form: [Force Number A], [Force Number B], [Operation] Qc}

@bold{Instruction:} The leading suit of [Operation] changes the function.

@italic{Spades: Add:} Put [A] + [B] on top of the stack (reversed).

@italic{Clubs: Subtract:} Put [A] - [B] on top of the stack (reversed).

@italic{Hearts: Multiply:} Put [A] * [B] on top of the stack (reversed).

@italic{Diamonds: Divide:} Put [A] / [B] on top of the stack (reversed).
If [B] is zero, throw an error.

@italic{Joker: Concatenate:} Put [Card Sequence A] on top of the stack (reversed),
then put [Card Sequence B] on top of the stack (reversed). Do not put any
face-down cards between them.


@subsection{Qh}

@bold{Form: [A], [B], [Boolean Operation] Qh}

@bold{Instruction:} If [Boolean Operation] is #t,
put [A] on top of the stack (reversed). If
[Boolean Operation] if #f, put [B] on top of the stack
(reversed). If [Boolean Operation] is null,
do nothing.


@subsection{Qd}

@italic{Currently does nothing. Will be added in the future.}


@section{Kings}

@subsection{Ks}

@bold{Form: [Name (stack inclusive) Origin], [Name (stack exclusive) Destination], [Force Integer Operation] Ks}

@bold{Instruction:} Find the [Operation] argument of deck [Origin].
If there are not enough arguments in deck [Origin], throw an error.
The leading suit of [Operation] changes the function.

@italic{Spades: Copy One:} Copy the the found argument and the face-down
cards directly below it and put it on top of deck [Destination].
If [Origin] is the stack, instead copy the found argument and the
face-down cards directly above it, reverse all of those cards,
and put it on top of deck [Destination].

@italic{Clubs: Copy Up To:} Copy all the cards above and including
the found argument, and put it on top of deck [Destination].
If [Origin] is the stack, reverse all of those cards before
putting it on top of deck [Destination].

@italic{Hearts: Move One:} Remove the the found argument and the face-down
cards directly below it and put them on top of deck [Destination].
If [Origin] is the stack, instead remove the found argument and the
face-down cards directly above it, reverse all of those cards,
and put them on top of deck [Destination].

@italic{Diamonds: Move Up To:} Remove all the cards above and including
the found argument, and put them on top of deck [Destination].
If [Origin] is the stack, reverse all of those cards before
putting them on top of deck [Destination].

@italic{Joker: Copy Whole:} Copy deck [Origin] and put it on top
of deck [Destination]. If [Origin] is the stack, reverse the copy
before putting in on top of [Destination]


@subsection{Kc}

@italic{Currently does nothing. Will be added in the future.}


@subsection{Kh}

@bold{Form: [Name (stack inclusive)], Ks}

@bold{Instruction:} Flip the named deck over.
The deck is in reverse order, and each card that
was face-down becomes face-up. Each card that was
face-up becomes face-down.


@subsection{Kd}

@bold{Form: [Name (stack inclusive)], Kd}

@bold{Instruction:} Shuffle the named deck.
The order of the cards in that deck are randomly
re-ordered.


