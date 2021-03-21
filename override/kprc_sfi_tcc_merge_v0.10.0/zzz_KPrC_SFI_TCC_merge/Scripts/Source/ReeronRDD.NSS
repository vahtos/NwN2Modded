/* Reeron created to add proper level of bonus slots to RDD  */
/* Updated on 3-19-08 to account for the changes in patch 1.12  */

int BONUSSLOT(int i2)
    {
    int nRDDhelper;
    if (i2>=4350 && i2<=4356)
        {
        nRDDhelper=0;
        }
    if (i2>=4357 && i2<=4363)
        {
        nRDDhelper=1;
        }
    if (i2>=4364 && i2<=4370)
        {
        nRDDhelper=2;
        }
    if (i2>=4371 && i2<=4377)
        {
        nRDDhelper=3;
        }
    if (i2>=4378 && i2<=4384)
        {
        nRDDhelper=4;
        }
    if (i2>=4385 && i2<=4391)
        {
        nRDDhelper=5;
        }
    if (i2>=4392 && i2<=4398)
        {
        nRDDhelper=6;
        }
    if (i2>=4399 && i2<=4405)
        {
        nRDDhelper=7;
        }
    if (i2>=4406 && i2<=4412)
        {
        nRDDhelper=8;
        }
    if (i2>=4413 && i2<=4419)
        {
        nRDDhelper=9;
        }
    if (i2>=4420 && i2<=4426)
        {
        nRDDhelper=0;
        }
    if (i2>=4427 && i2<=4433)
        {
        nRDDhelper=1;
        }
    if (i2>=4434 && i2<=4440)
        {
        nRDDhelper=2;
        }
    if (i2>=4441 && i2<=4447)
        {
        nRDDhelper=3;
        }
    if (i2>=4448 && i2<=4454)
        {
        nRDDhelper=4;
        }
    if (i2>=4455 && i2<=4461)
        {
        nRDDhelper=5;
        }
    if (i2>=4462 && i2<=4468)
        {
        nRDDhelper=6;
        }
    return nRDDhelper;
    }
int RDDLEVEL(int i7)
    {
    int i8;
    if (i7>8)
        {
        i8 = 7;
        }
    else 
        {
        i8 = i7;
        if(i7>2) {i8--;}
        if(i7>6) {i8--;}
        }
    return i8;
    }