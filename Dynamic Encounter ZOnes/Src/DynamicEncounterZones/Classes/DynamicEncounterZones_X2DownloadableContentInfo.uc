class DynamicEncounterZones_X2DownloadableContentInfo extends X2DownloadableContentInfo config(DEZ);

var config float AddWidth;
var config float AddDepth;
var config float SubtractOffsetAlongLOP;
var config float AdjustOffsetFromLOP;
var config bool bBoxMode;
var config float BoxModeOffsetDepthRatio;
var config float BoxModeOffsetWidthRatio;
var config float ChanceToKeepGuardPod;
var config array<name> ExcludedEncounters;
var config array<string> ExcludedMissionFamilies;

/// <summary>
/// Called from XComGameState_MissionSite:CacheSelectedMissionData
/// Encounter Data is modified immediately prior to being added to the SelectedMissionData, ported from LW2
/// </summary>
static function PostEncounterCreation(out name EncounterName, out PodSpawnInfo Encounter, int ForceLevel, int AlertLevel, optional XComGameState_BaseObject SourceObject)
{
	local float Width, Depth, OffsetAlongLOP, OffsetFromLOP, NewWidth, NewDepth, NewOffsetAlongLOP, NewOffsetFromLOP, Roll;
	local name ExcludedEncounter;
	local string ExcludedMissionFamily;
	local XComGameState_BattleData BattleData;
	local XComGameState_MissionSite MissionState;
		
	MissionState = XComGameState_MissionSite(SourceObject);

	if (MissionState == none)
	{
		BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData', true));
		if (BattleData == none)
		{
			`Log("Could not detect mission type. Aborting with no mission encounter variations applied.");
			return;
		}
		else
		{
			MissionState = XComGameState_MissionSite(`XCOMHISTORY.GetGameStateForObjectID(BattleData.m_iMissionID));
		}
	}

	Width = Encounter.EncounterZoneWidth;
	Depth = Encounter.EncounterZoneDepth;
	OffsetAlongLOP = Encounter.EncounterZoneOffsetAlongLOP;
	OffsetFromLOP = Encounter.EncounterZoneOffsetFromLOP;

	`Log("Found Encounter: "$EncounterName$" Width: "$Width$" Depth: "$Depth$" OffsetAlongLOP: "$OffsetAlongLOP$" OffsetFromLOP: "$OffsetFromLOP);

	//Look for excluded mission Families
	foreach Default.ExcludedMissionFamilies(ExcludedMissionFamily)
	{
		if (MissionState.GeneratedMission.Mission.MissionFamily == ExcludedMissionFamily)
		{
			`Log(ExcludedMissionFamily$" Mission Family Excluded: aborting");
			return;
		}
	}

	//Look for excluded encounters in ini
	foreach Default.ExcludedEncounters(ExcludedEncounter)
	{
		If(ExcludedEncounter == EncounterName)
		{
			`Log("Encounter Excluded: aborting");
			return;
		}
	}
	//Check to exclude guard pods using the chance specified in the ini
	if(Encounter.EncounterZoneWidth < 10)
	{
		Roll = `SYNC_FRAND_STATIC();
		`Log(GetFuncName() $ ": Roll = " @ Roll @ " and chance = " @ Default.ChanceToKeepGuardPod );
		if (roll < Default.ChanceToKeepGuardPod)
		{ 
			`Log("Encounter is a guard pod and did not meet chance to adjust: Aborting");
			return;
		}
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

	`Log("New Encounter "$EncounterName$" Width: "$NewWidth$" Depth: "$NewDepth$" OffsetAlongLOP: "$NewOffsetAlongLOP$" OffsetFromLOP: "$NewOffsetFromLOP);
				
}