//////////////////////////////////////////
//  Author: Drammel						//
//  Date: 3/15/2009						//
//  Title: c_ihit_dark					//
//  Description: Creates an intangible	//
//	creature which can run sounds that	//
//	simulate the results of an attack	//
//	roll for a strike maneuver.			//
//////////////////////////////////////////

void main()
{
	object oMe = OBJECT_SELF;
	int nCoin = d2(1);
	
	if (nCoin == 1)
	{
		DelayCommand(0.1f, PlaySound("sfx_hit_Dark"));
	}
	else if (nCoin == 2)
	{
		DelayCommand(0.1f, PlaySound("sfx_hit_DarkR"));
	}
	
	DelayCommand(0.2f, DestroyObject(oMe, 0.0f, FALSE));
}