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
			*seek = 0; // I know mutating the string sucks but there is no strncpy!
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


U0 Main() {

	
	

	I64 len = 0;
	
	I64 split_count;

	U8 *buffer = FileRead("./INPUT.TXT",&len);
	if(buffer == NULL) {
		"Could not open file!";
		throw;
	}

	U8** split_str = Split(buffer, '\n', &split_count);

	I64 i;
	for(i = 0; i < split_count; i++)
		"%s\n", split_str[i];

	I64 x, y, dx, dy;

	I64 w = StrLen(split_str[0]);
	I64 h = split_count;

	I64 paper_count = 0;
	I64 rolls_accessible = 0;

	for(y = 0; y < h; y++) {
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
			if(paper_count < 4) rolls_accessible++;

			point_skip: ;
		}
	}



	"%d\n", rolls_accessible;  


	return;
}

Main;
