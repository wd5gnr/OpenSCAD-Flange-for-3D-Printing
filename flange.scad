$fn=64;
// This is the odd-shaped part in question
module part() {
  union () {

    difference() {
      sphere(r=20);
      translate([-20,-20,0]) cube([45,45,20]);
      }

    difference() {
      translate([-9,-9,0]) cube([18,18,30]);
      translate([-2.5,0,0]) cube([5,25,15]);
      }

    translate([0,0,30]) cylinder(r=5,h=5);
    }
}

// Flange parameters
od=60;   // outside diameter
odr=od/2;  
id=48;    // inside diameter
idr=id/2;
flangeh=2;  // height of flange
flangeboltr=1.9;  // size of bolt holes
flangebeamw=2;  // width of flange beams
flangebeamh=2;   // height of flange beams (usually same as flangeh)
flangerotate=34;  // rotation of flange beams

module flange()
{
    union()
    {
    difference() 
      {
          cylinder(r=odr,flangeh);  // outside ring
          translate([0,0,-1]) cylinder(r=idr,h=flangeh+2);  // cut out inside
// 4 bolt holes
          translate([idr+(odr-idr)/2,0,-1]) cylinder(r=flangebolt,h=flangeh+2);
          translate([0,idr+(odr-idr)/2,-1]) cylinder(r=flangebolt,h=flangeh+2);
          translate([-(idr+(odr-idr)/2),0,-1]) cylinder(r=flangebolt,h=flangeh+2);
          translate([0,-(idr+(odr-idr)/2),-1]) cylinder(r=flangebolt,h=flangeh+2);

      }
 // connectors
    rotate(flangerotate) union() {
      cube([idr,flangebeamw,flangebeamh]);
      translate([-idr,0,0]) cube([45,flangebeamw,flangebeamh]);
      cube([flangebeamw,idr,flangebeamh]);  
      translate([0,-idr,0]) cube([flangebeamw,idr,flangebeamh]);
    }
  } 
}

// now generate 1/2 part plus flange.
// part offset
offsetx=50;  // put the other part this far away
offsety=50;
bigcutbox=1000;  // box used to cut away half the model; just has to be bigger than model
// You could use two boxes if you don't want to cut right on the XY plane


// Get first half of part
module part1() 
{
rotate([180,0,0]) difference()   // flip upside down
{
   part();
   translate([-bigcutbox/2,-bigcutbox/2,0]) cube([bigcutbox, bigcutbox, bigcutbox]);
}
}

// Get second half of part
module part2()
{
    difference() 
    {
        part();
       translate([-bigcutbox/2,-bigcutbox/2,-bigcutbox]) cube([bigcutbox,bigcutbox,bigcutbox]);
    }
}

// Here's where we create the stuff to print

// bottom half
translate([0,0,0])
  {
      difference()
      {
      flange();   // add flange
      hull() part1();  // but cut away "outline" of part
      }
    part1();   // now add part
  }
 
// top half (same logic but use part2 instead of part1)
translate([offsetx,offsety,0])
 { 
  difference() 
   { 
    flange();
    hull() part2();  
   }  
part2();
}

