﻿Players can now dynamically adjust Encounter Zones size and location on the map.  What are encounter zones?  They are the areas defined in the schedules.ini that enemy groups can spawn and patrol in.

Requires the Community Highlander..

Default settings and configurable options in DEZ.ini:

How much width to add to the encounter zones (This is evenly divided and increases the zone on both sides)
AddWidth = 20

How much depth to add to the encounter zones (this adds to the front of the zone closest to the Xcom Spawn)
AddDepth = 20

How Much offset along LOP to take away (This moves the entire zone towards the back of the map)
SubtractOffsetAlongLOP = 20

This adjuster is used to move the center of the encounter areas to the left or right of the objective.  Note that this only applies to encounters that are intended to be offset from LOP in the original schedule.  It will move the zone further from the objective to the left or right.  For example if the encounter schedule calls for an OffsetFromLOP greater than 0 this will add more to that making the area further away from the objective to the right.  If it is negative this will subtract that much bringing the center of the encounter more to the left.  The whole idea is to make encounter zones shift outward to the right and left sides of the objective more
AdjustOffsetFromLOP = 10

Boxed Mode turns the zone into a box using the largest of the width or depth as the new width and depth.  With box mode I would recommended setting the above values to 0 since the width or depth and offset will automatically adjust.  If you use box mode along with any added or subtracted values, those will be applied after the box is made and the offsets ratios are applied
bBoxMode = false

Percent of the added depth amount to subtract the offset along line of play when the depth is increased due to box mode.  For example if you have a default encounter width of 36 and depth of 6, when using box mode this will add 30 to the depth making it 36.  To account for this it is important to move the encounter area back by decreasing the offset along line of play.  I like 100%.  In this case 100% would decrease the offset by 30 
BoxModeOffsetDepthRatio = 1 ; 1 = 100% .50 = 50% 

Note that this only applies to encounters that are intended to be offset from line of play in the original schedule. 
 Percent of the added depth amount to subtract the offset from line of play when the width is increased due to box mode.  For example if you have a default encounter width of 6 and depth of 48, when using box mode this will add 42 to the width making it 48.  To account for this it is important to move the encounter area out more away from the objective perpendicular to the line of play by adjusting the offset from line of play.  I like 50%.  In this example 50% would adjust the offset away from the objective by 21
BoxModeOffsetWidthRatio = .50 ; 1 = 100% .50 = 50% 

Guards that have a width less than 10 are considered guard pods, if you keep this true those units encounter areas stay the same
bKeepGuardPods = True;