/*********************************************
 * OPL 12.10.0.0 Model
 * Author: SHUBHAM
 * Creation Date: 26-Oct-2020 at 6:25:52 PM
 *********************************************/

 dvar int+ x;
 dvar int+ y;
 //z=600-x
 //w=400-y
 
 minimize 5*x+10*y+15*(600-x)+4*(400-y);
 
 
 subject to{
   x+y<=700;
   x+y>=200;
   x<=600;
   y<=400;
   x>=0;
   y>=0;
   }