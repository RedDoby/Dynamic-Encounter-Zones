class DynamicEncounterZones_X2DownloadableContentInfo extends X2DownloadableContentInfo config(DEZ);

/// <summary>
/// Called from XComGameState_MissionSite:CacheSelectedMissionData
/// Encounter Data is modified immediately prior to being added to the SelectedMissionData, ported from LW2
/// </summary>
static function PostEncounterCreation(out name EncounterName, out PodSpawnInfo Encounter, int ForceLevel, int AlertLevel, optional XComGameState_BaseObject SourceObject)
{
	local float Width, Depth, Offset;
	
	Width = Encounter.EncounterZoneWidth;
	Depth = Encounter.EncounterZoneDepth;
	Offset = Encounter.EncounterZoneOffsetAlongLOP;
	
	`Log("Encounter Width: "$Width$" Depth: "$Depth$" Offset: "$Offset);
				
}