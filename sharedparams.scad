use <common.scad>

/*
// Main parameters
compartmentDiameter = 40;
compartmentHeight = 30;
numRings = 2;
positionLabels = [
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
    "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
    "U", "V", "W", "X", "Y", "Z"
];
//positionLabels = [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" ];
*/
include <mainparams.scad>

numPositions = len(positionLabels);

ringRotateClearance = 0.2; // used for a couple of different clearances relating to Z spacing of rings rotating next to each other

// Lock ring
lockRingHeightClearance = ringRotateClearance;
lockRingHeight = max(compartmentDiameter/10, 3 + lockRingHeightClearance);
//lockRingHeightClearance = max(0.1 * numRings, 0.35); // clearance for rings to rotate against each other, in addition to ring height clearance
lockRingActualHeight = lockRingHeight - lockRingHeightClearance;
lockRingFingerAngles = [60, 180, 300];
lockRingFingerWidth = compartmentDiameter * 0.075;
lockRingSlotWidthClearance = 0.6;
//lockRingDetentOsProtrusion = 0.3; // amount lock ring detents protrude into the outer shell

// Inner shell
isInnerRadius = compartmentDiameter / 2;
isThick = max(compartmentDiameter/20, 2);
isOuterRadius = isInnerRadius + isThick;
isInnerHeight = compartmentHeight;
isBaseThick = 3;
isOuterHeight = isInnerHeight + isBaseThick;
isProngSpanAngle = 10; // angular width of the lock prongs
isProngOffsetZ = -((numRings + 1) * ringRotateClearance); // vertical clearance between each ring and the prongs below it in locked position

// Outer shell
isOsClearance = 0.3; // Clearance on radius
osInnerRadius = isOuterRadius + isOsClearance;
osThick = max(compartmentDiameter/20, min(compartmentHeight/15, 3.2), 2);
osOuterRadius = osInnerRadius + osThick;
osInnerHeight = isInnerHeight;
osBaseThick = isBaseThick + lockRingHeight;
osOuterHeight = osInnerHeight + osBaseThick;
osSlotClearance = 0.3; // Clearance on each side of the fins to the outer shell slots
osSlotSpanAngle = isProngSpanAngle + 360 * osSlotClearance / (2 * PI * osInnerRadius) * 2;

lockRingSpanAngle = lockRingHeight / (2 * PI * osOuterRadius) * 360;

// Rings
ringSpacing = (isInnerHeight - lockRingHeight) / numRings;
osRingClearance = 0.3;
osProngProtrusion = compartmentDiameter * 0.0675 + osRingClearance; // Amount lock prongs protrude from the OD of the outer shell
isProngProtrusion = isOsClearance + osThick + osProngProtrusion; // amount the lock prongs extend from the OD of the inner shell cylinder
prongHeight = osProngProtrusion + 1; // total height of lock prongs, at the OD of the outer shell
ringInnerRadius = osOuterRadius + osRingClearance;
ringProngEndClearance = 0.3; // Clearance between the end of the prongs and the ring
ringProngCoverThick = min(max(compartmentDiameter / 20, 1), 3);
ringMinThick = osProngProtrusion + ringProngCoverThick + ringProngEndClearance;
ringOuterMinRadius = ringInnerRadius + ringMinThick;
ringOuterRadius = ringOuterMinRadius / regularPolygonInnerRadiusMultiplier(numPositions);
ringHeightClearance = ringRotateClearance;
ringHeight = ringSpacing - ringHeightClearance;
ringSlotClearance = 0.5;
ringSlotSpanAngle = isProngSpanAngle + 360 * ringSlotClearance / (2 * PI * ringInnerRadius) * 2;
prongCoverHeightClearance = 0.6; // amount shells will open before prongs engage on rings
lockSlotOuterRadius = osOuterRadius + osProngProtrusion + ringProngEndClearance; // outer radius of slots for lock prongs
falseLockSlotDepth = 0.3; // depth of false lock slots to make cracking more difficult
prongCoverHeight = prongHeight - isProngOffsetZ + prongCoverHeightClearance;

// Detents
detentCutoutDepthClearance = 0.25;
detentCutoutHeightClearance = 0.2;
detentDepth = 0.85;  // radius of detent cylindrical depressions
detentArm1Angle = 90; // Angle of the part of the arm that actually contacts the detent
detentArm2Angle = (numPositions % 2 == 0) ? detentArm1Angle + 180 : detentArm1Angle + 180 - (360 / numPositions / 2); 
detentArmThick = 1.5;
detentArmLength = min(10, ringInnerRadius * 1.3);
detentArmHeightMin = 1; // minimum amount of surface of lock prongs in contact with rings
minLockProngEngagement = min(1, osProngProtrusion - 2*osRingClearance);
detentArmHeightMax = ringHeight - prongCoverHeight - detentArmThick - detentDepth - detentCutoutDepthClearance - detentCutoutHeightClearance + (osProngProtrusion - 2*osRingClearance) + minLockProngEngagement;
// detentArmHeightIdeal = ringOuterRadius * 0.1; // depends on radius, so as torque increases, resistance linearly increases
detentArmHeightIdeal = (ringOuterRadius + 35) * 0.0375;
detentArmHeight = max(detentArmHeightMin, min(detentArmHeightMax, detentArmHeightIdeal));

// Label rings
labelRingRingClearanceMax = 0.3; // clearance tapers to allow for easier press fit
labelRingRingClearanceMin = 0.2;
labelRingMinThick = max(compartmentDiameter / 20, 1);
labelRingHeight = ringHeight;
labelRingInnerHeight = labelRingHeight * 0.8; // thickness/height tapers to prevent label rings from slipping vertically
labelRingInnerMinRadius = ringOuterMinRadius + labelRingRingClearanceMin;
labelRingInnerRadius = labelRingInnerMinRadius / regularPolygonInnerRadiusMultiplier(numPositions);
labelRingInnerBufferMinRadius = max(labelRingInnerMinRadius, ringOuterRadius + osRingClearance + labelRingRingClearanceMax); // inner radius on the top and bottom of label ring to prevent engaging adjacent rings if they slide
labelRingInnerBufferRadius = labelRingInnerBufferMinRadius / regularPolygonInnerRadiusMultiplier(numPositions);
labelRingInnerBufferHeight = labelRingHeight / 6;
labelRingContactHeight = labelRingHeight / 3; // amount of label ring in contact with ring (tapering from clearanceMax to clearanceMin)
labelRingOuterMinRadius = max(labelRingInnerMinRadius, labelRingInnerBufferMinRadius) + labelRingMinThick;
labelRingOuterRadius = labelRingOuterMinRadius / regularPolygonInnerRadiusMultiplier(numPositions);
labelRingKeyRadius = labelRingRingClearanceMax + 0.1;
labelRingKeyHeight = max(labelRingHeight / 5, labelRingKeyRadius * 2);
labelDepth = 0.5;
labelRingReverseLabelOrder = true;
labelRingReverseLabelDirection = false;
labelRingEmbossLabels = false;

// Spacer ring
// This part is entirely optional and usually not needed.  If there's extra slack for the
// rings on the outer shell, it can be measured and a spacer ring can be printed
// to take up the slack.
spacerRingHeight = 1.0;

osBaseRadius = labelRingOuterMinRadius;
//lockRingDetentRadius = lockRingDetentOsProtrusion + osRingClearance;
lockRingDetentRadius = detentDepth;

lockRingPinAngles = lockRingFingerAngles;
lockRingPinRadius = (osBaseRadius - ringInnerRadius) / 4;
lockRingPinX = (osBaseRadius + ringInnerRadius) / 2;
lockRingPinClearance = 0.3;
lockRingPinHeight = lockRingActualHeight * 0.9;

topMarkerDotRadius = 0.5;
topMarkerDotDepth = 0.4;

// Misc
latchAngles = [ 0, 180+30, 180-40 ];
falseLockSlotAngles = [ for (a = latchAngles) a + 360/numPositions*floor(numPositions/2) ];

// System
$fa = 2;
$fs = 1;
