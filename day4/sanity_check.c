#include <stdio.h>
int main() {
    int x = 1;
    int y = 0;
    int w = 5;
    int h = 5;
    for(int dx = x-1; dx < x+2; dx++) {
        for(int dy = y-1; dy < y+2; dy++) {
            if(dx < 0 || dx >= w) goto skip;
            if(dy < 0 || dy >= h) goto skip;
            if(dx == x && dy == y) goto skip;
            printf("%d, %d\n", dx, dy);

            skip: ;
        }
    }

}