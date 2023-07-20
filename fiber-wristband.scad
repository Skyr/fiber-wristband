wall = 2;
thin_wall = 2;
cell_diam = 20 + 0.5;
cell_thickness = 3.2 + 0.5;
rail_thickness = 5;
snap_thickness = 2;
overlap = 3;
width = 2*cell_diam+wall-overlap;
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
        }
        translate([0,wall+rail_thickness,0]) cube([width,cell_diam-2*rail_thickness,cell_thickness]);
        translate([width-wall-cell_diam/2,wall+cell_diam/2,0]) cylinder(h=cell_thickness, d=cell_diam, $fn=32);
        translate([wall+cell_diam/2,wall+cell_diam/2,0]) cylinder(h=cell_thickness, d=cell_diam, $fn=32);
    }
}


difference() {
    batteryclip();
    translate([width-cell_diam/2,wall+cell_diam/2+3,0]) cylinder(d=pin_diam, h=wall, $fn=16);
    translate([width-cell_diam/2,wall+cell_diam/2-3,0]) cylinder(d=pin_diam, h=wall, $fn=16);
    translate([width-cell_diam/2,wall+cell_diam/2-3,wall]) rotate([-90,0,0]) cylinder(d=pin_diam*2/3, h=6, $fn=16);
    translate([width-wall-4.5,5,0]) cylinder(d=pin_diam, h=2*wall+cell_thickness, $fn=16);
}
