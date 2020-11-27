$title LogMIP User's Manual Example 4 - Job Shop Scheduling (LOGMIP4,SEQ=337)

$onText
This model solves a jobshop scheduling, which has a set of jobs (5)
which must be processed in sequence of stages (5) but not all jobs
require all stages. A zero wait transfer policy is assumed between
stages. To obtain a feasible solution it is necessary to eliminate
all clashes between jobs. It requires that no two jobs be performed
at any stage at any time. The objective is to minimize the makespan,
the time to complete all jobs.

References:

Raman & Grossmann, Computers and Chemical Engineering 18, 7, p.563-578, 1994.

Aldo Vecchietti, LogMIP User's Manual, 2007
http://www.logmip.ceride.gov.ar/files/pdfs/logmip_manual.pdf

Keywords: extended mathematical programming, disjunctive programming, job shop scheduling,
          execution sequence
$offText

Set 
   I 'jobs'   / A, B, C, D, E, F, G /
   J 'stages' / 1*5 /;

Alias (I,K), (J,M);

Set L(I,K,J) 'subset to prevent clashes at stage j between stage j and k'
             / A.B.3, A.B.5, A.C.1, A.D.3, A.E.3, A.E.5, A.F.1, A.F.3, A.G.5
               B.C.2, B.D.2, B.D.3, B.E.2, B.E.3, B.E.5, B.F.3, B.G.2, B.G.5
               C.D.2, C.D.4, C.E.2, C.F.1, C.F.4, C.G.2, C.G.4
               D.E.2, D.E.3, D.F.3, D.F.4, D.G.2, D.G.4
               E.F.3, E.G.2, E.G.5
               F.G.4                                                         /;

Table TAU(I,J) 'processing time of job i in stage j'
       1  2  3  4  5
   A   3     5     2
   B      3  4     3
   C   6  3     6
   D      8  5  1
   E      4  6     2
   F   2     5  7
   G      8     5  4;

Variable MS 'makespan';

Binary   Variable  Y(I,K,J) 'sequencing variable between jobs i and k';
Positive Variable  T(I);

Equation
   FEAS(I)         'makespan greater than all processing times'
   NOCLASH1(I,K,J) 'when i precedes k'
   NOCLASH2(I,K,J) 'when k precedes i'
   DUMMY;

FEAS(I).. MS =g= T(I) + sum(M, TAU(I,M));

NOCLASH1(I,K,J)$((ord(I) <  ord(K)) and L(I,K,J))..
   T(I) + sum(M$(ord(M)  <= ord(J)), TAU(I,M)) =l=
   T(K) + sum(M$(ord(M)  <  ord(J)), TAU(K,M));

NOCLASH2(I,K,J)$((ord(I) <  ord(K)) and L(I,K,J))..
   T(K) + sum(M$(ord(M)  <= ord(J)), TAU(K,M)) =l=
   T(I) + sum(M$(ord(M)  <  ord(J)), TAU(I,M));

DUMMY..
   sum((I,K,J)$((ord(I) < ord(K)) and L(I,K,J)), Y(I,K,J)) =g= 0;

Model JOBSHOP / all /;

* Find a quick and dirty BigM to overwrite LOGMIP's default
Scalar BIGM;
BIGM = sum((I,J), TAU(I,J));

File fx /"%lm.info%"/;
putClose fx 'default bigm' BIGM 'disjunction Y NOCLASH1 else NOCLASH2';

option optCr = 0.0, optCa = 0.0, emp = logmip;

solve JOBSHOP minimizing MS using emp;

display Y.l, T.l;