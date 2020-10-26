/*********************************************
 * OPL 12.10.0.0 Model
 * Author: SHUBHAM
 * Creation Date: 26-Oct-2020 at 7:07:05 PM
 *********************************************/

 dvar int+ a;
 dvar int+ b;
 dvar int+ c;
 dvar int+ d;
 
 maximize 2*(a+b)+2*(c+d);
 
 
 subject to{
   a+b+c-14*d>=0;
   b+2*c-8*d>=0;
   2*c-d>=0;
   a-b-c>=0;	
   }