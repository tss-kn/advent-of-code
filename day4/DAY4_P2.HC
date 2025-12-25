U8** Split(U8* string, U8 delimiter, I64* count) {
	U8* base = string;
	U8* seek = string;

	I64 tokens_count = 0;
	U8** tokens = MAlloc(sizeof(U8*) * 150);
	if(!tokens) {
		"Could not allocate!";
		return NULL;
	}


	if(!tokens) {
		"Could not allocate";
		throw;
		//return NULL;
	}
	while(*seek != 0) {
		if(*seek == delimiter) {
			*seek = 0; // I know mutating the string sucks but there is no strncpy!
			tokens[tokens_count++] = MStrPrint("%s",base);
			base = seek+1;
		}
		seek++;
	}

	if(base != seek)
		tokens[tokens_count++] = MStrPrint("%s",base);

	*count = tokens_count;
	return tokens;

}

U0 FreeStrList(U8** str_arr, I64 count) {
	I64 i;
	for(i = 0; i < count; i++) {
		Free(str_arr[i]);
	}
	Free(str_arr);


}

U0 CpyStrList(U8** dst, U8** src, I64 count) {
	I64 i;
	
	if(!src && !src[0]) {
		"Src list not allocated\n";
		throw;
	}	
	if(!dst && !dst[0]) {
		"Dest list not allocated\n";
		throw;
	}
	for(i = 0; i < count; i++) {
		StrCpy(dst[i], src[i]);
	}
	"Successfully copied%d entries from src to dest\n", i;

	
}

Bool CmpStrList(U8** dst, U8** src, I64 count) {
	I64 i;
	
	if(!src && !src[0]) {
		"Src list not allocated\n";
		throw;
	}	
	if(!dst && !dst[0]) {
		"Dest list not allocated\n";
		throw;
	}


	for(i = 0; i < count; i++) {
		I64 result = StrCmp(dst[i], src[i]);
		//"Strings %s == %s? %d\n", dst[i], src[i], result;
		if(result != 0) returnFALSE;
	}


	returnTRUE;

}


U0 Main() {

	I64 len = 0;
	
	I64 split_count;

	U8 *buffer = FileRead("./INPUT.TXT",&len);
	if(buffer == NULL) {
		"Could not open file!";
		throw;
	}

	U8** split_str = Split(buffer, '\n', &split_count);
	U8** split_bak = MAlloc(sizeof(U8*) * split_count);
	
	
	
	I64 i;
	
	"Initial:\n";
	for(i = 0; i < split_count; i++) {
		"%s\n", split_str[i];
	
	}

	I64 x, y, dx, dy;

	I64 w = StrLen(split_str[0]);
	I64 h = split_count;

	I64 paper_count = 0;
	I64 removed_rolls = 0;


	roll_removed:

	
	for(y = 0; y < h; y++) {
		split_bak[y] = MStrPrint("%s", split_str[y]);

		for(x = 0; x < w; x++) {
			if(split_str[y][x] != '@') goto point_skip;

			paper_count = 0;
			for(dx = x-1; dx <= x+1; dx++) {				
				for(dy = y-1; dy <= y+1; dy++) {
					if(dx < 0 || dx >= w) goto skip;
					if(dy < 0 || dy >= h) goto skip; 
					if(dx == x && dy == y) goto skip;
					if(split_str[dy][dx] == '@') paper_count++;

					skip: ;
				}
			
			
		
			}
			if(paper_count < 4) {
				split_bak[y][x] = '.';
				removed_rolls++;
			}

			point_skip: ;
		}
	}
	/*

	"\nFinal:\n";
	for(i = 0; i < split_count; i++) {
		"%s\n", split_bak[i];
	}*/

	//"Strings the same?: %d\n", CmpStrList(split_str, split_bak, split_count);
	if (CmpStrList(split_str, split_bak, split_count) == FALSE) {
		CpyStrList(split_str, split_bak, split_count);
		goto roll_removed;
	}

	"Rolls that can be removed: %d\n", removed_rolls;

  
	FreeStrList(split_bak, split_count);
	FreeStrList(split_str, split_count);
	return;
}

Main;
