/*
~grch1.value; // CM
~grch2.value; // am
~grch3.value; // em
~grch4.value; // dm
~grch5.value; // FM
~setgr.value; // 
*/

~chgrfn = [

~grch1, // CM
~grch2, // am
~grch3, // em
~grch4, // dm
~grch5, // FM
~setgr	
];

~chgridx = 0;

~changegrains = { |dir=1|
	~chgrfn[~chgridx].value;	
	~chgridx = (~chrgridx + dir).wrap(0, ~chgrfn.size - 1);
};

