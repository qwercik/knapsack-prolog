% Dynamic programming solution for discrete knapsack problem
% Implementation in Prolog

% The main predicate are: knapsack_value/3, knapsack_items/3

% knapsack_value(+items, +capacity, -value)
% 	items -> is list of sublists of size 2 (like [weight, value])
% 		each item should have positive integer weight and positive value
% 	capacity -> integer >= 0
% 	value -> capacity is max total weight of items

% knapsack_items(+items, +capacity, -result_items)
%	items -> the same as above
%	capacity -> the same as above
%	result_items -> result set of items

max_of_two(X, Y, X) :- X >= Y, !.
max_of_two(_, Y, Y).

knapsack_value(_, 0, 0) :- !.
knapsack_value([[Weight, _]], Capacity, 0) :- Weight > Capacity, !.
knapsack_value([[_, Value]], _, Value) :- !.

knapsack_value(Items, Capacity, Value) :-
	append(PreviousItems, [CurrentItem], Items),
	CurrentItem = [CurrentItemWeight, CurrentItemValue],

	knapsack_value(PreviousItems, Capacity, ValueIfCurrentItemNotInSet),

	Capacity >= CurrentItemWeight,
	!,
	CapacityIfCurrentItemInSet is Capacity - CurrentItemWeight,
	knapsack_value(PreviousItems, CapacityIfCurrentItemInSet, ValueIfCurrentItemInSetButWithoutCurrentItemValue),
	ValueIfCurrentItemInSet is ValueIfCurrentItemInSetButWithoutCurrentItemValue + CurrentItemValue,

	max_of_two(ValueIfCurrentItemNotInSet, ValueIfCurrentItemInSet, Value)
.
knapsack_value(Items, Capacity, Value) :-
	append(PreviousItems, [_], Items),
	!,
	knapsack_value(PreviousItems, Capacity, Value)
.

knapsack_items(Items, Capacity, ItemsInSet) :-
	append(PreviousItems, [_], Items),

	knapsack_value(Items, Capacity, CurrentValue),
	knapsack_value(PreviousItems, Capacity, CurrentValue),
	!,

	knapsack_items(PreviousItems, Capacity, ItemsInSet)
.
knapsack_items(Items, Capacity, ItemsInSet) :-
	append(PreviousItems, [CurrentItem], Items),
	CurrentItem = [CurrentItemWeight, _],

	PreviousCapacity is Capacity - CurrentItemWeight,
	knapsack_items(PreviousItems, PreviousCapacity, PreviousItemsInSet),
	append(PreviousItemsInSet, [CurrentItem], ItemsInSet),
	!
.
knapsack_items(_, Capacity, []) :- Capacity >= 0.

