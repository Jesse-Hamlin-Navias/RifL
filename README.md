# RifL
RifL is a tactile esoteric coding langauge. Tactile means that code in RifL can be represented by physical objects, in this case a deck of playing cards. This provides the opportunity to perform code step by step, and to learn how computers execute code, creating a intimate understanding of the language. Esoteric means that RifL is not intended for software programming. Instead, it pushes the boundaries of what is possible in coding languages, and to entertain with outlandish and novel coding patterns. 

## The Basics
Below is an introdcution to RifL. It will provide a guided overview of the concepts needed to code and run RifL. Later, in the Nitty Gritty, those beginning concepts will be completed and connected to all the others, giving you the tools you need to run RifL.

### Numbers
The first thing needed to learn RifL is understanding how RifL represent numbers. Playing cards have numbered cards 2 through 10. In RifL, 10 cards represents 0s, and Aces represent 1s. With this structure, we have access to all digits 0 through 9. If we wanted to represent the number 301 in RifL, we would use the series of cards: 3 of spades, 10 of spades, Ace of spades.

### Data Structure
Code for RifL is placed into a 2D grid. A pile of cards can be placed in each grid space. The grid has four columns, from left to right: the spades column, hearts, clubs, and diamonds. The grid has a bottom row, row 1. The row above that is row 2, and so on. Each grid spaces has a name. For example, the bottom leftmost grid space is row 1 column spades, or, written differently, the grid space Ace of spades. The grid space above that is the 2 of spades, then 3 of spades, and so on. In this way, we have named every grid space using cards.

Piles of cards in the grid represent written code. RifL looks at one grid space at a time, always starting at the Ace of spades space. If the space we are looking at has cards in it, we move those cards one by one over to a special extra pile called the stack. The stack always starts empty. Face cards we encounter do not go to the stack, but instead are instructions to use cards in the stack to do things, such calculate, manipulate cards in the grid, or return outputs. The grid space we are looking at is refered to as the current space. If at any time the curent space has no cards in it, RifL stops running.

### Tactility
To run RifL physically, you will need 6-10 decks of playing cards, including jokers, table space, a poker chip or some other token to mark the current space, and the execution instructions printed out. It is recommended that you also use masking tape and a marker to make your grid. Also make sure that you have some table space to the right or left of your grid for the stack.

### Writing RifL Code
When executing RifL, we read the pile at our current space from top to bottom.

#### Card Shorthands
When typing out RifL code, it is easiest to use a series of shorthands for the different cards. They are as follows:
R : Joker, A: Ace, 2-10: 2-10, J: Jack, Q: Queen, K: King, Spade: s, Diamond: d, Club: c, Heart: h, Face down card: F
The Jack of Clubs is written Jc. A facedown Jack of clubs is FJc.

#### Postfix Notation
Normaly, we write mathmatical and logical expressions in Infix Notation. The expression 3 + 2 is written in Infix, because the oporator, +, is between the operands, 3 and 2. Postfix notation writes the opporator after the opperands. The earlier expression is Postfix would be written 3 2 +.

Here is a more complex example of Infix notation: 6 - 7 * 4 / 2. Without the use of parenthases or PEMDAS, how cane we know the intended order of operations? Its always a guess. Parenthases and PEMDAS help make up for this weakness of Infix notation. Using parenthases, let us rewrite the expression to: (6 - 7) * (4 / 2). Now it is clear what order to execute the operands in. If we rewrite this expression in Postfix, it will show how Postfix does not have this same confusion: 6 7 - 4 2 / *.

RifL is written in this same Postfix notation. If we wanted to add two numbers in RifL, we use the Queen of spades, which is the math face card. The Queen of spades requires three arguments: two numbers, and an operator. If we wanted to execute 3 + 2, we rewrite that in postfix as 3 2 +, and then convert those to cards: 3 of spades, Face Down, 2 of spades, Face Down, Ace of Spades, Queen of spades. The Ace of spades is interpreted by the queen of spades as a + symbol.
