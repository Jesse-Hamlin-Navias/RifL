# RifL
RifL is a tactile esoteric coding langauge. Tactile means that it code in RifL can be represented by physical objects, in this case a deck of playing cards. This provides the opportunity to perform code step by step, and to learn how computers execute code, creating a intimate understanding of the language. Esoteric means that RifL is not intended for software programming. Instead, it is to push the boundary of what is possible in coding languages, and to entertain with outlandish and new coding patterns. 

## The Basics
Below is an introdcution to RifL. It will provide a guided overview of the concepts needed to code and run RifL. Later, in the Nitty Gritty, those beginning concepts will be completed and connected to all the others, giving you the tools you need to run RifL.

### Numbers
The first thing needed to learn RifL is understanding how RifL represent numbers. Playing cards have numbered cards 2 through 10. In RifL, 10 cards represents 0s, and Aces represent 1s. With this structure, we have access to all digits 0 through 9. If we wanted to represent the number 301 in RifL, we would use the series of cards: 3 of spades, 10 of spades, Ace of spades.

### Data Structure
RifL uses a grid, where each grid space we can place a pile of cards. The grid has four columns, from left to right: the spades column, hearts, clubs, diamonds. The grid has a bottom row, row 1. The row above that is row 2, and so on. Each grid spaces has a name. For example, the bottom leftmost grid space is row 1 column spades, or, written differently, the grid space Ace of spades. The grid space above that is the 2 of spades, then 3 of spades, and so on. In this way, we have named every grid space using cards.

Piles of cards in your grid represent written code. RifL looks at one grid space at a time, always starting at the Ace of spades space. If the space we are looking at has cards in it, we move those cards one by one over to a special extra pile called the stack. Face cards we encounter do not go to the stack, but instead are instructions to use cards in the stack to calculate or manipulate other cards. The grid space we are looking at is refered to as the current space. If the code gets to a point where our curent space has no cards in it, the code stops.

### Tactility
To run RifL physically, you will need 6-10 decks of playing cards, including jokers, table space, a poker chip or some other token to mark the current space, and the execution instructions printed out. It is recommended that you also use masking tape and a marker to make your grid. Also make sure that you have some table space to the right or left of your grid for the stack.

### Face Cards and Pile Ordering
When executing RifL, we read the pile at our current space from top to bottom. RifL is written in 
