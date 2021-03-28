//////////////////////////////////////////
//  Author: Drammel						//
//  Date: 3/11/2009						//
//  Title: c_sfx_hit_f2ct				//
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
		DelayCommand(0.1f, PlaySound("cb_ht_chitin1"));
	}
	else if (nCoin == 2)
	{
		DelayCommand(0.1f, PlaySound("cb_ht_chitin2"));
	}
	
	DelayCommand(0.2f, DestroyObject(oMe, 0.0f, FALSE));
}