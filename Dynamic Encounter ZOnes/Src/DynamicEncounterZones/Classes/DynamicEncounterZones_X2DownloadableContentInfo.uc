class DynamicEncounterZones_X2DownloadableContentInfo extends X2DownloadableContentInfo config(DEZ);

var config float AddWidth;
var config float AddDepth;
var config float SubtractOffsetAlongLOP;
var config float AdjustOffsetFromLOP;
var config bool bBoxMode;
var config float BoxModeOffsetDepthRatio;
var config float BoxModeOffsetWidthRatio;
var config bool bKeepGuardPods;

/// <summary>
/// Called from XComGameState_MissionSite:CacheSelectedMissionData
/// Encounter Data is modified immediately prior to being added to the SelectedMissionData, ported from LW2
/// </summary>
static function PostEncounterCreation(out name EncounterName, out PodSpawnInfo Encounter, int ForceLevel, int AlertLevel, optional XComGameState_BaseObject SourceObject)
{
	local float Width, Depth, OffsetAlongLOP, OffsetFromLOP, NewWidth, NewDepth, NewOffsetAlongLOP, NewOffsetFromLOP;
	
	Width = Encounter.EncounterZoneWidth;
	Depth = Encounter.EncounterZoneDepth;
	OffsetAlongLOP = Encounter.EncounterZoneOffsetAlongLOP;
	OffsetFromLOP = Encounter.EncounterZoneOffsetFromLOP;

	`LogAI("Found Encounter Width: "$Width$" Depth: "$Depth$" OffsetAlongLOP: "$OffsetAlongLOP$" OffsetFromLOP: "$OffsetFromLOP);

	//Check for guard pods
	if(Encounter.EncounterZoneWidth < 10 && default.bKeepGuardPods)
	{
		`LogAI("Found Guard Pod Encounter Width: "$Width$" Depth: "$Depth$" OffsetAlongLOP: "$OffsetAlongLOP);
		return;
	}
	
	If (default.bBoxMode)
	{
		If (Width > Depth)
		{
			OffsetAlongLOP -= (Width - Depth) * default.BoxModeOffsetDepthRatio; 
			Depth = Width;
		}
		else if (Depth > Width)
		{
			if (OffsetFromLOP>0)//If it's positive we want to add more
			{
				OffsetFromLOP += (Depth - Width) * default.BoxModeOffsetWidthRatio;
			}
			else if (OffsetFromLOP<0)//If it's negative we want to subtract more
			{
				OffsetFromLOP -= (Depth - Width) * default.BoxModeOffsetWidthRatio;
			}
			Width = Depth;
		}
	}

	NewWidth = Width + default.AddWidth;
	NewDepth = Depth + default.AddDepth;
	NewOffsetAlongLOP = OffsetAlongLOP - default.SubtractOffsetAlongLOP;
	if (OffsetFromLOP>0)//If it's positive we want to add more
	{
		NewOffsetFromLOP = OffsetFromLOP + default.AdjustOffsetFromLOP;
	}
	else if (OffsetFromLOP<0)//If it's negative we want to subtract more
	{
		NewOffsetFromLOP = OffsetFromLOP - default.AdjustOffsetFromLOP;
	}

	Encounter.EncounterZoneWidth = NewWidth;
	Encounter.EncounterZoneDepth = NewDepth;
	Encounter.EncounterZoneOffsetAlongLOP = NewOffsetAlongLOP;
	Encounter.EncounterZoneOffsetFromLOP = NewOffsetFromLOP;

	`LogAI("New Encounter Width: "$NewWidth$" Depth: "$NewDepth$" OffsetAlongLOP: "$NewOffsetAlongLOP$" OffsetFromLOP: "$NewOffsetFromLOP);
				
}