//////////////////////////////////////////////////
//	Author: Drammel								//
//	Date: 10/18/2009							//
//	Title: bo_clarion_call						//
//	Description: As a swift action, you can     //
//  initiate this boost before you have reduced //
//  an opponent to fewer than 0 hit points.  If //
//  that opponent is reduced to 0 or fewer hit  //
//  points within the next six seconds, you and //
//  allies within range can immediately make one//
//  melee attack at their highest attack bonus. //
//  These allies must be able to see and hear   //
//  you. These extra attacks are not attacks of //
//  opportunity.                                //
//////////////////////////////////////////////////

#include "bot9s_inc_constants"
#include "bot9s_inc_maneuvers"
#include "bot9s_include"

void GenerateFriends()
{
	object oPC = OBJECT_SELF;
	location lPC = GetLocation(oPC);
	float fRange = FeetToMeters(60.0f);

	object oFriend;
	int n;

	n = 1;
	oFriend = GetFirstObjectInShape(SHAPE_SPHERE, fRange, lPC);

	while (GetIsObjectValid(oFriend))
	{
		if ((oFriend != oPC) && (!GetIsReactionTypeHostile(oFriend, oPC)) && (GetObjectHeard(oFriend, oPC)) && (GetObjectSeen(oFriend, oPC)))
		{
			SetLocalObject(oPC, "ClarionCallAlly" + IntToString(n), oFriend);
			n++;
		}

		if (n > 6)
		{
			break;
		}

		oFriend = GetNextObjectInShape(SHAPE_SPHERE, fRange, lPC);
	}
}

void CleanUp()
{
	object oPC = OBJECT_SELF;

	DeleteLocalObject(oPC, "ClarionCallAlly1");
	DeleteLocalObject(oPC, "ClarionCallAlly2");
	DeleteLocalObject(oPC, "ClarionCallAlly3");
	DeleteLocalObject(oPC, "ClarionCallAlly4");
	DeleteLocalObject(oPC, "ClarionCallAlly5");
	DeleteLocalObject(oPC, "ClarionCallAlly6");
}

void Attack()
{
	object oPC = OBJECT_SELF;
	object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
	object oTarget = GetAttackTarget(oPC);
	float fDist = GetDistanceBetween(oPC, oTarget) - GetGirth(oTarget);
	float fRange = GetMeleeRange(oPC);

	fRange = GetMeleeRange(oPC);

	if (fRange < FeetToMeters(8.0f)) //Maximum distance the engine allows a melee attack at.
	{
		fRange = FeetToMeters(8.0f);
	}

	if (GetIsObjectValid(oTarget) && (fDist <= fRange))
	{
		int nHit = StrikeAttackRoll(oWeapon, oTarget);

		BasicAttackAnimation(oWeapon, nHit, TRUE);
		StrikeAttackSound(oWeapon, oTarget, nHit, 0.2f);
		DelayCommand(0.3f, StrikeWeaponDamage(oWeapon, nHit, oTarget));
	}
}

void ClarionCall(object oPC, object oToB)
{
	object oTarget = GetLocalObject(oToB, "ClarionCall");

	if (!GetIsObjectValid(oTarget) || (GetCurrentHitPoints(oTarget) < 1))
	{
		object oFriend1 = GetLocalObject(oPC, "ClarionCallAlly1");
		object oFriend2 = GetLocalObject(oPC, "ClarionCallAlly2");
		object oFriend3 = GetLocalObject(oPC, "ClarionCallAlly3");
		object oFriend4 = GetLocalObject(oPC, "ClarionCallAlly4");
		object oFriend5 = GetLocalObject(oPC, "ClarionCallAlly5");
		object oFriend6 = GetLocalObject(oPC, "ClarionCallAlly6");
		effect eClarion = EffectVisualEffect(VFX_TOB_CLARION_CALL);

		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eClarion, oPC, 1.5f);
		PlayVoiceChat(VOICE_CHAT_LAUGH, oPC);
		AssignCommand(oPC, Attack());

		if (GetIsObjectValid(oFriend1))
		{
			AssignCommand(oFriend1, Attack());
		}

		if (GetIsObjectValid(oFriend2))
		{
			AssignCommand(oFriend2, Attack());
		}

		if (GetIsObjectValid(oFriend3))
		{
			AssignCommand(oFriend3, Attack());
		}

		if (GetIsObjectValid(oFriend4))
		{
			AssignCommand(oFriend4, Attack());
		}

		if (GetIsObjectValid(oFriend5))
		{
			AssignCommand(oFriend5, Attack());
		}

		if (GetIsObjectValid(oFriend6))
		{
			AssignCommand(oFriend6, Attack());
		}

		DelayCommand(0.1f, CleanUp());
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");
	object oTarget = IntToObject(GetLocalInt(oToB, "Target"));
	
	if (NotMyFoe(oPC, oTarget))
	{
		SendMessageToPC(oPC, "<color=red>You must target an opponent with this ability.</color>");
		return;
	}
	
	if (GetLocalInt(oToB, "Swift") == 0)	
	{
		RunSwiftAction(190, "B");
		ExpendManeuver(190, "B");
		SetLocalObject(oToB, "ClarionCall", oTarget);
		DelayCommand(5.9f, GenerateFriends());
		DelayCommand(6.0f, ClarionCall(oPC, oToB));
	}
}