include <sharedparams.scad>
include <rotate_extrude.scad>

module InnerShell() {
    translate([0, 0, isBaseThick])
        difference() {
            // Main cylinder
            cylinder(h=isInnerHeight, r=isOuterRadius);
            // Inner cutout
            cylinder(h=isInnerHeight, r=isInnerRadius);
        };
    // Base/cap
    cylinder(h=isBaseThick, r=osBaseRadius);
        
    // Side ridges
    sideRidgeProtrusion = isOsClearance + osThick; // how far the ridges protrude from the outer edge of the main cylinder
    module sideRidge() {
        rotate([0, 0, -isProngSpanAngle/2])
            rotate_extrude2(angle=isProngSpanAngle)
                translate([isInnerRadius, 0])
                    square([isOsClearance + osThick + isThick, isInnerHeight]);
    };
    for (ang = latchAngles)
        rotate([0, 0, ang])
            translate([0, 0, isBaseThick])
                sideRidge();
    
        
    // Side prongs
    module prong() {
        // module produces a single prong, at the correct X offset, centered on the X axis, with a bottom Z of 0
        protrusion = isProngProtrusion - sideRidgeProtrusion;
        height = prongHeight;
        angle = isProngSpanAngle;
        rotate([0, 0, -angle/2])
            rotate_extrude2(angle=angle)
                translate([isOuterRadius + sideRidgeProtrusion, 0])
                    polygon([
                        [0, 0],
                        [protrusion, protrusion],
                        [protrusion, height],
                        [0, height]
                    ]);
    };
    for (ang = latchAngles)
        rotate([0, 0, ang])
            for (z = [isInnerHeight + isBaseThick - prongHeight : -ringSpacing : isBaseThick])
                translate([0, 0, z])
                    prong();
};

InnerShell();
