
       ORG      START
       MOV.I  }     4, > -2000     
       MOV.I  $     6, >    -1     
       ADD.F  $     5, $     1     
START  SNE.I  $  2608, $  2616     
       DJN.F  $    -2, <  1214     
       MOV.AB $    -2, $    -5     
       JMN.B  {    -2, $    -6     
       SPL.B  #  2608, #  2608     
       MOV.I  $     2, >   -11     
       DJN.F  $    -1, >   -12     
       DAT.F  > -2665, $    15     

