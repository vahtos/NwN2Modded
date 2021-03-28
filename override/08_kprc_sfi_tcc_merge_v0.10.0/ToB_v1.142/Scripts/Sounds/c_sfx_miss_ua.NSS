//////////////////////////////////////////
//  Author: Drammel						//
//  Date: 3/11/2009						//
//  Title: c_sfx_miss_ua				//
//  Description: Creates an intangible	//
//	creature which can run sounds that	//
//	simulate the results of an attack	//
//	roll for a strike maneuver.			//
//////////////////////////////////////////

void main()
{
	object oMe = OBJECT_SELF;
	int nDie = d6(1);
	
	if (nDie == 1)
	{
		DelayCommand(0.1f, PlaySound("cb_sw_unarmed1"));
	}
	else if (nDie == 2)
	{
		DelayCommand(0.1f, PlaySound("cb_sw_unarmed2"));
	}
	else if (nDie == 3)
	{
		DelayCommand(0.1f, PlaySound("cb_sw_unarmlo01"));
	}
	else if (nDie == 4)
	{
		DelayCommand(0.1f, PlaySound("cb_sw_unarmlo02"));
	}
	else if (nDie == 5)
	{
		DelayCommand(0.1f, PlaySound("cb_sw_unarmlo03"));
	}
	else if (nDie == 6)
	{
		DelayCommand(0.1f, PlaySound("cb_sw_unarmlo04"));
	}
	
	DelayCommand(0.2f, DestroyObject(oMe, 0.0f, FALSE));
}