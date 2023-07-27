wall = 2;
thin_wall = 2;
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

module batteryclip() {
    cube([width, cell_diam+2*wall,wall]);
    translate([0,cell_diam+wall,wall]) cube([width, wall, cell_thickness]);
    translate([0,0,cell_thickness+wall]) cube([width, wall+rail_thickness, wall]);
    translate([0, cell_diam+wall-rail_thickness, cell_thickness+wall]) cube([width, wall+rail_thickness, wall]);
    translate([0,0,wall]) difference() {
        union() {
            translate([width-wall-cell_diam/2,0,0]) cube([wall+cell_diam/2,wall+cell_diam,cell_thickness]);
            translate([width-wall-cell_diam/2-second_snap_width,wall-thin_wall,spacing]) cube([second_snap_width,wall+snap_thickness,cell_thickness-2*spacing]);
            translate([0,wall-thin_wall,spacing]) cube([first_snap_width,wall+snap_thickness, cell_thickness-2*spacing]);
            translate([first_snap_width,0,0]) cube([width-wall-cell_diam/2-second_snap_width-first_snap_width-snap_spacing,wall,cell_thickness]);
            translate([width,0,-wall]) cube([width_extra,cell_diam+2*wall,cell_thickness+2*wall]);
        }
        //translate([0,wall+rail_thickness,0]) cube([width,cell_diam-2*rail_thickness,cell_thickness]);
        translate([0,wall+rail_thickness,0]) cube([width-2*wall,cell_diam-2*rail_thickness,cell_thickness]);
        translate([width-wall-cell_diam/2,wall+cell_diam/2,0]) cylinder(h=cell_thickness, d=cell_diam, $fn=32);
        translate([wall+cell_diam/2,wall+cell_diam/2,0]) cylinder(h=cell_thickness, d=cell_diam, $fn=32);
        // Openings for clip
        //translate([0,0,-1]) rotate([0,90,0]) cylinder(d=1, h=width+width_extra, $fn=32);
    }
}


difference() {
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
