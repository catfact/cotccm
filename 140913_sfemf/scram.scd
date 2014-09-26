// 'keyed' array scrambling...

// test pattern
x = Array.fill(10, { 1.0.rand; });

// apply key to array
// a key is an arbitrary permutation of indices up to the array size
// e.g, for array size=10:
k = Array.series(10).scramble;

~encrypt = { arg arr, key;
	var b;
	key.size.postln;
	b = Array.fill(key.size, { 
		arg i;
		arr[key[i]];
	});
	b.postln;
	^b;
};


~decrypt = { arg arr, key;
	var b = Array.newClear(key.size);
	key.size.do({ |i|
		b[key[i]] = arr[i];
	});
	b.postln;
	^b;
};

x.postln;
k.postln;

y = ~encrypt.value(x, k);
z = ~decrypt.value(y, k);