/*(
~bufrates = [
	1, 1, 1, 1, 3/2, 16/9, 17/9, 12/11
];

~bufoct = [1, 1, -1, -2, -1, -1, -1, 1];
8.do({ |i| ~tremloop.loop_data[i].bufrate = ~bufrates[i] * (2 ** (~bufoct[i])) });


(
~tremloopdyr= [
	1, 1, 1, 1, 3/2, 16/9, 17/9, 12/11
] * 8;

~tremrate= [
	1, 1, 1, 1, 3/2, 16/9, 17/9, 12/11
] * 8;

8.do({ |i| ~tremloop.loop_data[i].dur = ~tremloopdyr[i]; });
)
*/
~tremloop.loop_data[0].amp = 0.125;
~tremloop.loop_data[0].looprate = 6/5 * 0.25;
~tremloop.loop_data[0].dur= 2.0;
~tremloop.loop_data[0].tremrate = 6/5 * 0.25;
~tremloop.loop_data[0].pan = -0.5;
~tremloop.loop_data[0].lpfhz= 1200;

~tremloop.loop_data[1].amp = 0.125;
~tremloop.loop_data[1].ix = 1;
~tremloop.loop_data[1].looprate = 9/7 * 0.25;
~tremloop.loop_data[1].pos = 0;
~tremloop.loop_data[1].dur= 2.0;
~tremloop.loop_data[1].tremrate = 9/8 * 0.25;
~tremloop.loop_data[1].pan = 0.5;
~tremloop.loop_data[1].lpfhz= 1200;


~tremloop.loop_data[2].amp = 0.125;
~tremloop.loop_data[2].ix = 1;
~tremloop.loop_data[2].looprate = 9/8 * 0.25;
~tremloop.loop_data[2].pos = 0;
~tremloop.loop_data[2].dur= 3.0;
~tremloop.loop_data[2].tremrate = 6/5 * 0.25;
~tremloop.loop_data[2].pan = 1;
~tremloop.loop_data[2].lpfhz= 1200;


~tremloop.loop_data[3].amp = 0.125;
~tremloop.loop_data[3].ix = 1;
~tremloop.loop_data[3].looprate = 4/3 * 0.25;
~tremloop.loop_data[3].pos = 0;
~tremloop.loop_data[3].dur= 3.0;
~tremloop.loop_data[3].tremrate = 9/8 * 0.25;
~tremloop.loop_data[3].pan = -1;
~tremloop.loop_data[3].lpfhz= 1200;


~tremloop.loop_data[4].amp = 0.125;
~tremloop.loop_data[4].ix = 1;
~tremloop.loop_data[4].looprate = 9/8 * 0.25;
~tremloop.loop_data[4].pos = 0;
~tremloop.loop_data[4].dur= 3.0;
~tremloop.loop_data[4].tremrate = 6/5 * 0.25;
~tremloop.loop_data[4].pan = 0.5;
~tremloop.loop_data[4].bufrate = 1/3;
~tremloop.loop_data[4].lpfhz= 900;


~tremloop.loop_data[5].amp = 0.125;
~tremloop.loop_data[5].ix = 0;
~tremloop.loop_data[5].looprate = 4/3 * 0.25;
~tremloop.loop_data[5].pos = 0;
~tremloop.loop_data[5].dur= 3.0;
~tremloop.loop_data[5].tremrate = 3/2 * 0.25;
~tremloop.loop_data[5].bufrate = 1/3;
~tremloop.loop_data[5].pan = -0.5;
~tremloop.loop_data[5].lpfhz= 900;


~tremloop.loop_data[6].amp = 0.125;
~tremloop.loop_data[6].ix = 0;
~tremloop.loop_data[6].looprate = 7/8 * 0.125;
~tremloop.loop_data[6].pos = 0;
~tremloop.loop_data[6].dur= 3.0;
~tremloop.loop_data[6].tremrate = 8/5 * 0.125;
~tremloop.loop_data[6].pan = 0.5;
~tremloop.loop_data[6].bufrate = 0.25;
~tremloop.loop_data[6].lpfhz= 900;
~tremloop.loop_data[6].tremfb= 0.5;


~tremloop.loop_data[7].amp = 0.125;
~tremloop.loop_data[7].ix = 1;
~tremloop.loop_data[7].looprate = 7/3 * 0.125;
~tremloop.loop_data[7].pos = 0;
~tremloop.loop_data[7].dur= 4.0;
~tremloop.loop_data[7].tremrate = 5/2 * 0.125;
~tremloop.loop_data[7].bufrate = 0.25;
~tremloop.loop_data[7].lpfhz= 800;
~tremloop.loop_data[7].tremfb= 0.5;
~tremloop.loop_data[7].pan = -0.5;

/*
8.do({ |i| ~tremloop.loop_data[i].amp = 0.0; });
8.do({ |i| ~tremloop.loop_data[i].amp = -8.dbamp; });
8.do({ |i| ~tremloop.loop_data[i].amp = -10.dbamp; });
*/