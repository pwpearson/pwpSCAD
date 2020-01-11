/*
 *
 *
 *
 */

 // move and rotate
 module mvrot(x=0,y=0,z=0,rx=0,ry=0,rz=0){
   translate([x,y,z])rotate([rx,ry,rz]) children();
 }

 // stamp
 module stamp(num, space=0) {
    for (i = [0 : num-1])
      translate([ space*i, 0, 0 ]) children(0);
 }

 // creates a ruler with 12 inch alternating colors
 // assumes scale of 1:1
 module ruler(length){
   colors = ["red", "white"];

   for (i = [0 : length]){
     color(colors[ceil(i%2)])
       move(x=i * 12)
         cube([12, 1, .1]);
   }
 }
