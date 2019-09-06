class DynamicEncounterZones_X2DownloadableContentInfo extends X2DownloadableContentInfo config(DEZ);

var config float AddWidth;
var config float AddDepth;
var config float SubtractOffset;
var config bool bBoxMode;
var config float BoxModeOffsetDepthRatio;
var config bool bKeepGuardPods;

/// <summary>
/// Called from XComGameState_MissionSite:CacheSelectedMissionData
/// Encounter Data is modified immediately prior to being added to the SelectedMissionData, ported from LW2
/// </summary>
static function PostEncounterCreation(out name EncounterName, out PodSpawnInfo Encounter, int ForceLevel, int AlertLevel, optional XComGameState_BaseObject SourceObject)
{
	local float Width, Depth, Offset, NewWidth, NewDepth, NewOffset;
	
	Width = Encounter.EncounterZoneWidth;
	Depth = Encounter.EncounterZoneDepth;
	Offset = Encounter.EncounterZoneOffsetAlongLOP;

	//Check for guard pods
	if(Encounter.EncounterZoneWidth < 10 && default.bKeepGuardPods)
	{
		`LogAI("Found Guard Pod Encounter Width: "$Width$" Depth: "$Depth$" Offset: "$Offset);
		return;
	}
	
	If (default.bBoxMode)
	{
		If (Width > Depth)
		{
			Offset -= (Width - Depth) * default.BoxModeOffsetDepthRatio; 
			Depth = Width;
		}
		else if (Depth > Width)
		{
			Width = Depth;
		}
	}

	NewWidth = Width + default.AddWidth;
	NewDepth = Depth + default.AddDepth;
	NewOffset = Offset - default.SubtractOffset;

	Encounter.EncounterZoneWidth = NewWidth;
	Encounter.EncounterZoneDepth = NewDepth;
	Encounter.EncounterZoneOffsetAlongLOP = NewOffset;

	`LogAI("Encounter Width: "$NewWidth$" Depth: "$NewDepth$" Offset: "$NewOffset);
				
}