wall = 1.5;
thin_wall = 1.5;
cell_diam = 20 + 0.5;
cell_thickness = 3.2 + 0.5;
rail_thickness = 5;
snap_thickness = 2;
overlap = 3;
width = 2*cell_diam+wall-overlap;
width_extra = 3;
spacing = 0.75;
first_snap_width = cell_diam/2;
second_snap_width = cell_diam*3/4 - 2;
snap_spacing = 1;
pin_diam = 1.7; // 1.2;

clip_positive_d = 0.8;
clip_negative_d = 1.3;

slide_overlap = 5;
overlap_len = 15;

module batteryclip() {
    difference() {
        union() {
            cube([width, cell_diam+2*wall,wall]);
            translate([0,cell_diam+wall,wall]) cube([width, wall, cell_thickness]);
            translate([0,0,cell_thickness+wall]) cube([width, wall+rail_thickness, wall]);
            translate([0, cell_diam+wall-rail_thickness, cell_thickness+wall]) cube([width, wall+rail_thickness, wall]);
            translate([0,0,wall]) {
                translate([width-wall-cell_diam/2,0,0]) cube([wall+cell_diam/2,wall+cell_diam,cell_thickness]);
                translate([width-wall-cell_diam/2-second_snap_width,wall-thin_wall,spacing]) cube([second_snap_width,wall+snap_thickness,cell_thickness-2*spacing]);
                translate([0,wall-thin_wall,spacing]) cube([first_snap_width,wall+snap_thickness, cell_thickness-2*spacing]);
                translate([first_snap_width,0,0]) cube([width-wall-cell_diam/2-second_snap_width-first_snap_width-snap_spacing,wall,cell_thickness]);
                translate([width,0,-wall]) cube([width_extra,cell_diam+2*wall,cell_thickness+2*wall]);
            }
        }
        translate([0,0,wall]) {
            //translate([0,wall+rail_thickness,0]) cube([width,cell_diam-2*rail_thickness,cell_thickness]);
            translate([0,wall+rail_thickness,0]) cube([width-2*wall,cell_diam-2*rail_thickness,cell_thickness]);
            translate([width-wall-cell_diam/2,wall+cell_diam/2,0]) cylinder(h=cell_thickness, d=cell_diam, $fn=32);
            translate([wall+cell_diam/2,wall+cell_diam/2,0]) cylinder(h=cell_thickness, d=cell_diam, $fn=32);
        }
        // Openings for clip
        translate([0,0,1]) rotate([0,90,0]) cylinder(d=clip_negative_d, h=width+width_extra, $fn=32);
        translate([0,cell_diam+2*wall,1]) rotate([0,90,0]) cylinder(d=clip_negative_d, h=width+width_extra, $fn=32);
        // Overlapping opening
        translate([width+width_extra-overlap_len-slide_overlap,cell_diam+2*wall-1,-1]) cube([overlap_len+1,1,2]);
    }
}


module battery_holder() {
    translate([slide_overlap,0,0]) difference() {
        batteryclip();
        // Hole for negative
        translate([width-wall-3,wall+cell_diam/2+1.3,0]) cylinder(d=pin_diam, h=wall, $fn=16);
        translate([width-wall-3-5,wall+cell_diam/2+1.3,0]) cylinder(d=pin_diam, h=wall, $fn=16);
        translate([width-wall-3,wall+cell_diam/2+1.3,wall]) rotate([-90,0,90]) cylinder(d=pin_diam*2/3, h=5, $fn=16);
        // Hole for positive
        translate([width-wall-1,wall+cell_diam/2-1.3,0]) cylinder(d=pin_diam, h=2*wall+cell_thickness, $fn=16);
        // Shortened version
        cube([first_snap_width,cell_diam+2*wall,cell_thickness+2*wall]);
    }
}


module lid() {
    tolerance = 0.3;
    lid_z = 7;
    fiber_diam = 6.1;
    translate([first_snap_width,-wall-tolerance,-wall-lid_z]) {
        difference() {
            cube([width+width_extra-first_snap_width, cell_diam+4*wall+2*tolerance, wall + 2 + lid_z]);
            translate([0,wall,wall]) cube([width+width_extra-first_snap_width, cell_diam+2*wall+2*tolerance, wall + 2 + lid_z]);
        }
        difference() {
            union() {
                translate([width+width_extra-first_snap_width-wall,0,wall]) cube([wall, cell_diam+4*wall,lid_z-tolerance]);
                translate([wall+8,0,wall]) cube([wall, cell_diam+4*wall,lid_z-tolerance]);
                translate([0,0,wall]) cube([wall, cell_diam+4*wall,lid_z-tolerance]);
            }
            translate([0,(cell_diam+4*wall)/2,wall+3.1]) rotate([0,90,0]) cylinder(d=fiber_diam, h=width+10, $fn=32);
        }
        translate([0,wall,lid_z+wall+1]) rotate([0,90,0]) cylinder(d=clip_positive_d, h=width+width_extra-first_snap_width, $fn=32);
        // ...with overlapping opening
        translate([0,cell_diam+3*wall+2*tolerance,lid_z+wall+1]) rotate([0,90,0]) difference() {
            cylinder(d=0.8, h=width+width_extra-first_snap_width, $fn=32);
            translate([0,0,slide_overlap-1]) cylinder(d=clip_positive_d, h=width+width_extra-first_snap_width-overlap_len-3.7, $fn=32);
        }
    }
}


battery_holder();
lid();
