0.6::heads1.
0.3::heads2.
0.5::heads3.

someheads:- heads1.
someheads:- heads2. 
someheads:- heads3.

allheads:- heads1, heads2, heads3.

% evidence(heads2, false).


% query(heads1, heads2, heads3).
% query(heads1, heads2, \+heads3).
% query(heads1, \+heads2, heads3).
% query(heads1, \+heads2, \+heads3).
% query(\+heads1, heads2, heads3).
% query(\+heads1, heads2, \+heads3).
% query(\+heads1, \+heads2, heads3).
% query(\+heads1, \+heads2, \+heads3).
