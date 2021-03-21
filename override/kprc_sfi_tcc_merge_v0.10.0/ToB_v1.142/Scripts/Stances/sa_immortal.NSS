///////////////////////////////////////////////////////////
//	Author: Drammel										 //
//	Date: 10/26/2009									 //
//	Name: sa_immortal									 //
//	Description: So long as you remain in this stance,   //
//  you cannot be killed or incapacitated by effects or  //
//  attacks that reduce you to 0 or fewer hit points. If //
//  you take such damage, you can make a Fortitude save  //
//  with a DC equal to your negative hit point total. If //
//  you fail this save, you die or fall unconscious      //
//  (as appropriate). If this save is successful, you are//
//  still alive and conscious, with 1 hit point          //
//  remaining. This stance provides no protection against//
//  effects that slay you without dealing hit point      //
//  damage, or other effects that petrify, paralyze, and //
//  so forth. You can still be slain by a coup de grace  //
//  if a spell or effect renders you helpless.  After you//
//  attempt three saving throws to avoid death or        //
//  unconsciousness, this stance automatically ends. You //
//  can activate it again on your turn as normal.        //
///////////////////////////////////////////////////////////

#include "tob_i0_spells"

void ImmortalFortitude(object oPC, object oToB)
{
	if ((GetLocalInt(oToB, "Stance") == 41) || (GetLocalInt(oToB, "Stance2") == 41))
	{
		int nHp = GetCurrentHitPoints(oPC);
		int nImmortal = GetLocalInt(oToB, "ImmortalFortitude");

		if ((nHp <= 0) && (nImmortal > 0))
		{
			int nHelp;
			effect eTest;

			nHelp = 0;
			eTest = GetFirstEffect(oPC);

			while (GetIsEffectValid(eTest))
			{
				if (GetEffectType(eTest) == EFFECT_TYPE_PARALYZE)
				{
					nHelp = 1;
					break;
				}
				else if (GetEffectType(eTest) == EFFECT_TYPE_PETRIFY)
				{
					nHelp = 1;
					break;
				}
				else if (GetEffectType(eTest) == EFFECT_TYPE_STUNNED)
				{
					nHelp = 1;
					break;
				}
				else if (GetEffectType(eTest) == EFFECT_TYPE_TIMESTOP)
				{
					nHelp = 1;
					break;
				}

				eTest = GetNextEffect(oPC);
			}

			if (nHelp == 0)
			{
				SetLocalInt(oToB, "ImmortalFortitude", nImmortal - 1);

				int nFort = MySavingThrow(SAVING_THROW_FORT, oPC, nHp);

				if (nFort > 0)
				{
					effect eRaise = EffectResurrection();
					ApplyEffectToObject(DURATION_TYPE_INSTANT, eRaise, oPC);
				}
			}
		}

		if (nImmortal < 1)
		{
			SendMessageToPC(oPC, "<color=red>Immortal Fortitude has expended all its uses.  The stance has come to an end.</color>");
			SetLocalInt(oToB, "Stance", 0);
			SetLocalInt(oToB, "Stance2", 0);
		}

		DelayCommand(6.0f, ImmortalFortitude(oPC, oToB));
	}
}

void main()
{
	object oPC = OBJECT_SELF;
	object oToB = GetItemPossessedBy(oPC, "tob");

	SetLocalInt(oToB, "ImmortalFortitude", 3); // As per the rules initiating the stance resets the uses.
	ImmortalFortitude(oPC, oToB);
}