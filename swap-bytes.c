#include <stdio.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {

  unsigned long int i, bufsize;
  unsigned char *buf;

  FILE *fin1, *fin2, *fout;

    if (argc != 3) {
	  printf("syntax: swap-bytes [input] [output]\n");
	  return(1);
	}

	fin1 = fopen(argv[1], "rb");
	if (!fin1) {
  	  printf("[input] missing!\n");
	  return(1);
	} else {
      // ok
	}

	fout = fopen(argv[2], "wb");
	if (!fout) {
	  printf("[output] error.\n");
	  return(1);
	} else {
	  printf("creating [output] file.\n");
	}
	
  fseek(fin1, 0, SEEK_END);
  bufsize = ftell(fin1);
  fseek(fin1, 0, SEEK_SET);

  printf("swapping %ubytes.\n", bufsize);
  bufsize = bufsize;
  buf = (unsigned char *)malloc(bufsize);

  for(i=0; i < (bufsize / 2); i++) {
    fread(&buf[(i*2) + 1], 1, 1, fin1);
    fread(&buf[(i*2) + 0], 1, 1, fin1);
  }
  fwrite(&buf[0], 1, bufsize, fout);
  
  free(buf);
  fclose(fout);
  fclose(fin2);
  fclose(fin1);
  
}
