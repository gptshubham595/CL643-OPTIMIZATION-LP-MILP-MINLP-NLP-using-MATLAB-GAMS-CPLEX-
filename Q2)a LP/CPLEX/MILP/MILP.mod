/*********************************************
 * OPL 12.10.0.0 Model
 * Author: SHUBHAM
 * Creation Date: 26-Oct-2020 at 7:07:05 PM
 *********************************************/

 dvar int+ a;
 dvar int+ b;
 dvar int+ c;
 dvar int+ d;
 dvar float+ e;
 dvar float+ f;
 dvar float+ g;
 
 maximize 2*(a+b)+2*(c+d)+2*e+3*f+g;
 
 
 subject to{
   e+f+g>=10;
   e+f+g<=100;
   e-f>=2;
   g>=1;
   a+b+c+d >=  100;
   b+2*c >= 50;
   b+c <= 70;
   2*c-d == 20;
   a+b+c+d <= 200;
   }