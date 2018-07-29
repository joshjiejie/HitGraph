#include <assert.h>
#include <getopt.h>
#include <limits.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct{
	unsigned int	LUT;
	unsigned int	Reg;
	unsigned int	DSP;
	unsigned int	BRAM;	
} Design;

#define		MAX			4294967295
#define 	FALSE 	0
#define 	TRUE 		1
#define 	Dwidth 	32

void print_usage() {
    printf("Malformed command, correct command should be: ./explore -ALG ALG_name -LUT LUT -REG REG -DSP DSP -BRAM BRAM -URAM URAM -DRAM number_of_DRAMs\n");
}

void print_user_input(unsigned int lut, unsigned int reg, unsigned int dsp, unsigned int bram, unsigned int uram) {
    printf("The design can use up to\n");    
    printf("%u LUTs\n", lut);
    printf("%u REGs\n", reg);
    printf("%u DSPs\n", dsp);
    printf("%u BRAMs\n", bram);
    printf("%u URAMs\n", uram);    
}

int check_whether_positive_integer(char * string){
	int i;
	for(i=0; i<strlen(string); i++){
		if((string[i]< '0' || string[i]> '9') && string[i] != '\0' && string[i] != '\n')
			return FALSE;		
	}
	return TRUE;
}

unsigned char design_id(unsigned char input){
	if(input == 4)
		return 2;
	if(input ==2)
		return 1;
	if(input ==1)
		return 0;
		
	return 0;		
}

void explore(Design alg[3][4], unsigned int lut, unsigned int reg, unsigned int dsp, unsigned int bram, unsigned int uram, unsigned int dram){
	unsigned int p, q, m; 
	//printf("%u\n", alg[0][0].LUT);
	p = dram;
	q = 1;
	while(q<8){
		if(alg[design_id(p)][design_id(q)].LUT>lut || alg[design_id(p)][design_id(q)].Reg>reg || alg[design_id(p)][design_id(q)].DSP>dsp || alg[design_id(p)][design_id(q)].BRAM>bram){ 
			if(q==1){
				printf("No feasible solution\n"); return;				
			} else {
				q=q/2;
			}
			break;
		} else {
			q=q*2;
		}	
	}
	m=1;
	while(1){
		if(m*p*Dwidth>bram*3600){
			m = m/2;
			break;
		} else {
			m = m*2;
		}
	}	
	printf("p=%u, q=%u, m=%u\n", p, q, m);
	
}

// To compile: gcc -o explore design_space_explore.c
// To run: ./explore -ALG ALG_name -LUT LUT -REG REG -DSP DSP -BRAM BRAM -URAM URAM -DRAM number_of_DRAMs



int main(int argc, char *argv[]) {
	unsigned int lut = MAX;
	unsigned int reg = MAX; 
	unsigned int dsp = MAX;
	unsigned int bram = 1024;
	unsigned int uram = 960;	
	unsigned int dram = 4;
	char algorithm[15];
	unsigned char n;
	int i;
		
	if(argc%2==0 || argc==1) {
		print_usage();	
		exit(1);
	}
  for(i=1; i<argc; i=i+2){
  	if (strcmp(argv[i], "-LUT") == 0) {
  		if(check_whether_positive_integer(argv[i+1])){
  			lut = atoi(argv[i+1]);  	
  			printf("%u\n", lut);
  		} else {
  			printf("Invalid LUT input\n");
  			exit(1);
  		}    			
  	}	
  	else if(strcmp(argv[i], "-REG") == 0) {
  		if(check_whether_positive_integer(argv[i+1])){
  			reg = atoi(argv[i+1]);    			
  		} else {
  			printf("Invalid REG input\n");
  			exit(1);
  		}
  	} 
  	else if(strcmp(argv[i], "-DSP") == 0) {
  		if(check_whether_positive_integer(argv[i+1])){
  			dsp = atoi(argv[i+1]);  				  			
  		} else {
  			printf("Invalid DSP input\n");
  			exit(1);
  		}	
  	}
  	else if(strcmp(argv[i], "-BRAM") == 0) {
  		if(check_whether_positive_integer(argv[i+1])){
  			bram = atoi(argv[i+1]);	  			
  		} else {
  			printf("Invalid BRAM input\n");
  			exit(1);
  		}
  	} 
  	else if(strcmp(argv[i], "-URAM") == 0) {
  		if(check_whether_positive_integer(argv[i+1])){
  			uram = atoi(argv[i+1]);	  			
  		} else {
  			printf("Invalid URAM input\n");
  			exit(1);
  		}
  	}   	
  	else if(strcmp(argv[i], "-DRAM") == 0) {	  		
			if(check_whether_positive_integer(argv[i+1])){
  			n = atoi(argv[i+1]);
  			if(n>4){
  				printf("Invalid DRAM input\n: too large");
  				exit(1);
  			} else if (n==3){ 
  				printf("Invalid DRAM input\n: to be added");
  				exit(1);
  			}	else{
  				dram = n;
  			}  					  			
  		} else {
  			printf("Invalid DRAM input\n");
  			exit(1);
  		}	  	
  	} 
  	else if(strcmp(argv[i], "-ALG") == 0) {	  		
  			strcpy(algorithm, argv[i+1]);
  			if(strcmp(algorithm, "wcc") == 0){  				  				
  			} else if(strcmp(algorithm, "sssp") == 0){  				  				
  			} else if(strcmp(algorithm, "spmv") == 0){  				  				
  			} else if(strcmp(algorithm, "pagerank") == 0){  				  				
  			} else {
  				printf("Invalid ALG input: not supported\n"); exit(1);
  			}
  	} 
  	else {
  		printf("Invalid argument %s\n", argv[i]); exit(1);
  	}    	   	
	}
	//print_user_input(lut, reg, dsp, bram, uram);	
	
	Design wcc[3][4];
	Design spmv[3][4];
	Design pr[3][4];
	Design sssp[3][4];
	
	wcc[0][0].LUT = 24091;
	wcc[0][0].Reg = 25197;
	wcc[0][0].DSP = 0;
	wcc[0][0].BRAM = 1;	
	wcc[0][1].LUT = 24557;
	wcc[0][1].Reg = 26300;
	wcc[0][1].DSP = 0;
	wcc[0][1].BRAM = 2;	
	wcc[0][2].LUT = 27928;
	wcc[0][2].Reg = 26500;
	wcc[0][2].DSP = 0;
	wcc[0][2].BRAM = 4;
	wcc[0][3].LUT = 42933;
	wcc[0][3].Reg = 28800;
	wcc[0][3].DSP = 0;
	wcc[0][3].BRAM = 8;	
	wcc[1][0].LUT = 37496;
	wcc[1][0].Reg = 36732;
	wcc[1][0].DSP = 0;
	wcc[1][0].BRAM = 2;	
	wcc[1][1].LUT = 47151;
	wcc[1][1].Reg = 37729;
	wcc[1][1].DSP = 0;
	wcc[1][1].BRAM = 4;	
	wcc[1][2].LUT = 56405;
	wcc[1][2].Reg = 40846;
	wcc[1][2].DSP = 0;
	wcc[1][2].BRAM = 8;
	wcc[1][3].LUT = 87277;
	wcc[1][3].Reg = 48509;
	wcc[1][3].DSP = 0;
	wcc[1][3].BRAM = 16;
	wcc[2][0].LUT = 75542;
	wcc[2][0].Reg = 72926;
	wcc[2][0].DSP = 0;
	wcc[2][0].BRAM = 4;	
	wcc[2][1].LUT = 94282;
	wcc[2][1].Reg = 74908;
	wcc[2][1].DSP = 0;
	wcc[2][1].BRAM = 8;	
	wcc[2][2].LUT = 112857;
	wcc[2][2].Reg = 81136;
	wcc[2][2].DSP = 0;
	wcc[2][2].BRAM = 16;
	wcc[2][3].LUT = 173779;
	wcc[2][3].Reg = 96473;
	wcc[2][3].DSP = 0;
	wcc[2][3].BRAM = 32;
	sssp[0][0].LUT = 21683;
	sssp[0][0].Reg = 23211;
	sssp[0][0].DSP = 0;
	sssp[0][0].BRAM = 1;	
	sssp[0][1].LUT = 22495;
	sssp[0][1].Reg = 23697;
	sssp[0][1].DSP = 0;
	sssp[0][1].BRAM = 2;	
	sssp[0][2].LUT = 28959;
	sssp[0][2].Reg = 27632;
	sssp[0][2].DSP = 0;
	sssp[0][2].BRAM = 4;
	sssp[0][3].LUT = 41625;
	sssp[0][3].Reg = 28885;
	sssp[0][3].DSP = 0;
	sssp[0][3].BRAM = 8;	
	sssp[1][0].LUT = 33852;
	sssp[1][0].Reg = 33188;
	sssp[1][0].DSP = 0;
	sssp[1][0].BRAM = 2;	
	sssp[1][1].LUT = 42693;
	sssp[1][1].Reg = 34142;
	sssp[1][1].DSP = 0;
	sssp[1][1].BRAM = 4;	
	sssp[1][2].LUT = 54925;
	sssp[1][2].Reg = 40092;
	sssp[1][2].DSP = 0;
	sssp[1][2].BRAM = 8;
	sssp[1][3].LUT = 84625;
	sssp[1][3].Reg = 57288;
	sssp[1][3].DSP = 0;
	sssp[1][3].BRAM = 16;
	sssp[2][0].LUT = 68199;
	sssp[2][0].Reg = 65893;
	sssp[2][0].DSP = 0;
	sssp[2][0].BRAM = 4;	
	sssp[2][1].LUT = 85861;
	sssp[2][1].Reg = 67800;
	sssp[2][1].DSP = 0;
	sssp[2][1].BRAM = 8;	
	sssp[2][2].LUT = 109828;
	sssp[2][2].Reg = 79629;
	sssp[2][2].DSP = 0;
	sssp[2][2].BRAM = 16;
	sssp[2][3].LUT = 156642;
	sssp[2][3].Reg = 88410;
	sssp[2][3].DSP = 0;
	sssp[2][3].BRAM = 32;
	spmv[0][0].LUT = 48551;
	spmv[0][0].Reg = 47082;
	spmv[0][0].DSP = 2;
	spmv[0][0].BRAM = 2;	
	spmv[0][1].LUT = 54314;
	spmv[0][1].Reg = 49359;
	spmv[0][1].DSP = 4;
	spmv[0][1].BRAM = 20;	
	spmv[0][2].LUT = 62822;
	spmv[0][2].Reg = 54794;
	spmv[0][2].DSP = 8;
	spmv[0][2].BRAM = 22;
	spmv[0][3].LUT = 79276;
	spmv[0][3].Reg = 70000;
	spmv[0][3].DSP = 16;
	spmv[0][3].BRAM = 8;		
	spmv[1][0].LUT = 99070;
	spmv[1][0].Reg = 94750;
	spmv[1][0].DSP = 4;
	spmv[1][0].BRAM = 3;	
	spmv[1][1].LUT = 109527;
	spmv[1][1].Reg = 97997;
	spmv[1][1].DSP = 8;
	spmv[1][1].BRAM = 38;	
	spmv[1][2].LUT = 127864;
	spmv[1][2].Reg = 108953;
	spmv[1][2].DSP = 16;
	spmv[1][2].BRAM = 40;
	spmv[1][3].LUT = 158806;
	spmv[1][3].Reg = 138960;
	spmv[1][3].DSP = 32;
	spmv[1][3].BRAM = 54;
	spmv[2][0].LUT = 198637;
	spmv[2][0].Reg = 188951;
	spmv[2][0].DSP = 8;
	spmv[2][0].BRAM = 6;	
	spmv[2][1].LUT = 229861;
	spmv[2][1].Reg = 209800;
	spmv[2][1].DSP = 16;
	spmv[2][1].BRAM = 16;	
	spmv[2][2].LUT = 255713;
	spmv[2][2].Reg = 217352;
	spmv[2][2].DSP = 32;
	spmv[2][2].BRAM = 86;
	spmv[2][3].LUT = 374558;
	spmv[2][3].Reg = 285105;
	spmv[2][3].DSP = 64;
	spmv[2][3].BRAM = 108;
	pr[0][0].LUT = 52148;
	pr[0][0].Reg = 54374;
	pr[0][0].DSP = 2;
	pr[0][0].BRAM = 17;	
	pr[0][1].LUT = 58369;
	pr[0][1].Reg = 56566;
	pr[0][1].DSP = 4;
	pr[0][1].BRAM = 18;	
	pr[0][2].LUT = 65878;
	pr[0][2].Reg = 54747;
	pr[0][2].DSP = 8;
	pr[0][2].BRAM = 20;
	pr[0][3].LUT = 99769;
	pr[0][3].Reg = 71554;
	pr[0][3].DSP = 16;
	pr[0][3].BRAM = 24;		
	pr[1][0].LUT = 109070;
	pr[1][0].Reg = 104750;
	pr[1][0].DSP = 4;
	pr[1][0].BRAM = 4;	
	pr[1][1].LUT = 118062;
	pr[1][1].Reg = 112485;
	pr[1][1].DSP = 8;
	pr[1][1].BRAM = 36;	
	pr[1][2].LUT = 133967;
	pr[1][2].Reg = 109858;
	pr[1][2].DSP = 16;
	pr[1][2].BRAM = 40;
	pr[1][3].LUT = 200263;
	pr[1][3].Reg = 142495;
	pr[1][3].DSP = 32;
	pr[1][3].BRAM = 47;
	pr[2][0].LUT = 211844;
	pr[2][0].Reg = 218187;
	pr[2][0].DSP = 8;
	pr[2][0].BRAM = 68;	
	pr[2][1].LUT = 236096;
	pr[2][1].Reg = 224417;
	pr[2][1].DSP = 16;
	pr[2][1].BRAM = 72;	
	pr[2][2].LUT = 267921;
	pr[2][2].Reg = 217160;
	pr[2][2].DSP = 32;
	pr[2][2].BRAM = 80;
	pr[2][3].LUT = 400556;
	pr[2][3].Reg = 284434;
	pr[2][3].DSP = 64;
	pr[2][3].BRAM = 94;
	
	if(strcmp(algorithm, "wcc") == 0){  				  				
		explore(wcc, lut, reg, dsp, bram, uram, dram);
	} else if(strcmp(algorithm, "sssp") == 0){  				  				
		explore(sssp, lut, reg, dsp, bram, uram, dram);
	} else if(strcmp(algorithm, "spmv") == 0){  				  				
		explore(spmv, lut, reg, dsp, bram, uram, dram);
	} else if(strcmp(algorithm, "pagerank") == 0){  				  				
		explore(pr, lut, reg, dsp, bram, uram, dram);
	}
	
	return 1;
}
