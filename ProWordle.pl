main:- 
		write('Welcome to Pro-Wordle!'),nl,
		write('----------------------'),nl,nl,
		build_kb,
		play.

		
build_kb:-
		write('Please enter a word and its category on separate lines:'),nl,
		read(W) ,
		(W\==done , 
		read(C) , 
		assert(word(W,C)) , 
		build_kb); 
		write('Done building the words database...'),nl,nl. %When writing done
		
play:-
		write('The available categories are: '),
		categories(L),
		write(L),nl, 
		choosing_category(C),
		choosing_length(C, Length),
		NoOfGuesses is Length+1 ,
		write('Game started.You have  ') , write(NoOfGuesses) ,write('  gusses'),nl,nl,
		pick_word(W,Length,C),
		guess(W,NoOfGuesses,NoOfGuesses).
		
guess(W,NoOfGuesses,RemGuesses):-
		RemGuesses>0,
		Length is NoOfGuesses-1 ,
		write('Enter a word composed of   '), write(Length) , write('  letters'),nl,
		read(G),
		guessH(W,G,NoOfGuesses,RemGuesses).

guessH(W,W,_,_):- %winning case
		write('You won!').

guessH(W,G,_,1):- %losing case
		W\==G,
		write('You lost!') .

		

guessH(W,G,NoOfGuesses,RemGuesses):-
		RemGuesses>1,
		W\==G,
		string_length(W,L1),
		string_length(G,L2),
		L1==L2,
		string_chars(G,WL),
		string_chars(W,GL),
		correct_letters(WL,GL,CL),
		write('Correct letters are:   '),write(CL),nl,
		correct_positions(WL,GL,CP),
		write('Correct letters in correct positions are:   '),write(CP),nl,
		NewRemGuesses is RemGuesses-1,
		write('Remaining Guesses are   '),write(NewRemGuesses),nl,nl,
		guess(W,NoOfGuesses,NewRemGuesses).
		
guessH(W,G,NoOfGuesses,RemGuesses):- %incase the user entered a guess that is not the same length as the word
		RemGuesses>1,
		W\==G,
		string_length(W,L1),
		string_length(G,L2),
		L1\==L2,
		write('Word is not composed of  '),write(L1), write('  letters. Try again.'),nl,
		write('Remaining Guesses are   '),write(RemGuesses),nl,nl,
		guess(W,NoOfGuesses,RemGuesses).		
		
	
choosing_category(C):-   %Player keeps choosing a category until he chooses an available one
		write('Choose a category:'),nl,
		read(C), 
		is_category(C) ;
		(write('This category does not exist.'),nl, choosing_category(C)).
		
		
choosing_length(C,Length):-   %Player keeps choosing a length until he chooses an available one
		write('Choose a length: '),nl,
		read(Length),
		number(Length),
		is_length(C,Length);
		(write('There are no words of this length.') ,nl, choosing_length(C,Length)).
		

is_length(C,L):-   %succeeds if L is a length of a word in C 
		word(_,C),
		available_length(L).
		
is_category(C):-  %succeeds if C is an avaialable category in the KB 
		word(_,C).
		
categories(L):- %succeeds if L is a list containing all the available categories without duplicates.
		setof(C,is_category(C),L).
		
		
available_length(L):- %succeeds if L is a length of a word in the KB 
		number(L),
		word(W,_),
		string_length(W,L).
		
		
pick_word(W,L,C):-	
		word(W,C),
		atom_length(W,L).

		
correct_letters([],_,[]).

correct_letters([H|T],L2,[H|T1]):-
		member(H,L2),
		correct_letters(T,L2,T1).
		
correct_letters([H|T],L2,CL):-
		\+member(H,L2),
		correct_letters(T,L2,CL).
	
	
correct_positions(_,[],[]).

correct_positions([H1|T1],[H2|T2],[H1|T3]):-
	H1==H2,
	correct_positions(T1,T2,T3).
	
correct_positions([H1|T1],[H2|T2],PL):-
	H1\==H2,
	correct_positions(T1,T2,PL).

		
		