/*
 * Window holder
 *
 * This is a wedge to keep the BOKU windows in the Guttenberghaus open. It is very likely that it
 * fits well also for other windows.
 */


/* * * * *  Configuration  * * * * * */
// all values in mm

HEIGHT = 45;
DEPTH1 = 15;

// few from top, where the letters L/R are:
// width is in the writing direction of letters L/R
// a1, a2, a3 are adjustment variables after the first design
a1 = 1.6;
a2 = 0.8;
a3 = 6;
WIDTH1 = 10.5 + a1;              // distance from left edge to wedge
WIDTH2 = 10.5 + a3;              // distance from wedge to right edge
WEDGE_WIDTH = 20 + a2;           // width of top of wedge
WEDGE_WIDTH_SLOPE1 = 1.5 - a2;   // left width of slope
WEDGE_WIDTH_SLOPE2 = 1.5;   // right width of slope

WEDGE_DEPTH =  33;

WEDGE_HEIGHT = 30;

SHACKLE_DEPTH = 6;
SHACKLE_GAP = 18;
SHACKLE_HEIGHT = 15;

TEXT_DEPTH = 3;
FONT_SIZE = 10;

// distance between the two parts for printing at the same time
DISTANCE = 5;

/* * * * * * * * * * * * */


// total width of the box part (where the letter L/R is printed on)
width = WIDTH1 + WEDGE_WIDTH_SLOPE1 + WEDGE_WIDTH + WEDGE_WIDTH_SLOPE2 + WIDTH2;


window_holder(is_left=true);

window_holder(is_left=false);



module window_holder(is_left) {
    sign = is_left ? -1: 1;
    translate([width/2., sign * DISTANCE, HEIGHT])
        rotate([180, 0, 180])
            mirror_if_left(is_left)
                difference() {
                    union() {
                        cube([width, DEPTH1, HEIGHT]);

                        translate([WIDTH2, DEPTH1, HEIGHT - WEDGE_HEIGHT])
                            prisma_trapez(WEDGE_WIDTH_SLOPE1, WEDGE_WIDTH_SLOPE2, WEDGE_WIDTH, WEDGE_DEPTH, WEDGE_HEIGHT);
                    }

                    letter(is_left);

                    translate([0., DEPTH1 + WEDGE_DEPTH - SHACKLE_GAP - SHACKLE_DEPTH, HEIGHT - WEDGE_HEIGHT - SHACKLE_HEIGHT])
                        cube([width, SHACKLE_GAP, 2 * SHACKLE_HEIGHT]);
                }
}

module mirror_if_left(is_left) {
    if(is_left)
        mirror([0., 1., 0.])
            children();
    else
        children();
}

module letter(is_left=true) {
    lr_letter = is_left ? "L" : "R";
    flip_it = is_left ? 180. : 0.;

    translate([width/ 2., DEPTH1 / 2., HEIGHT - TEXT_DEPTH + 0.1])
        linear_extrude(TEXT_DEPTH)
            mirror_if_left(is_left)  // stupid workaround to mirror back the letter again
                rotate([0., 0., flip_it])
                    text(lr_letter, FONT_SIZE, "Arial", valign="center", halign="center");
}


module prisma_trapez(width_slope1, width_slope2, width_short, depth, height) {
    /*
     * width_slope1: left width of the slop part
     * width_slope2: right width of the slop part
     * width_short:  width of the part without slope
     */
    width_long = width_slope1 + width_slope2 + width_short;

    difference() {
        cube([width_long, depth, height]);
        alpha1 = atan(width_slope1 / depth);
        translate([width_long, 0., -height])
            rotate([0., 0., alpha1])
                cube([width_long, 2 * depth, 3 * height]);

        alpha2 = atan(width_slope2 / depth);
        translate([0., 0., -height])
            mirror([1., 0., 0.])
                rotate([0., 0., alpha2])
                    cube([width_long, 2 * depth, 3 * height]);
    }
}
