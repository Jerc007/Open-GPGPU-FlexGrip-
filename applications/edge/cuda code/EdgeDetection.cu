#include <stdio.h>
#include <stdint.h>
#include <cuda_runtime.h>
#define DIM1 16
#define DIM2 16


typedef struct {
	uint8_t R;
	uint8_t G;
	uint8_t B;
} pixel;					


__device__ uint8_t img_grayscaled[DIM1][DIM2]; // intermediate grayscaled image	
// IMPORTANT NOTE: the compiler takes into account that the address of this global variable (0x400) is stored in the constant memory at address c [0xe] [0x0]. 
// This zone is unknown, so to avoid problems, after compilation all the instructions containing that address in the SASS are to be changed to c [0x1] [0x6]. 		


// Edge Detection kernel
__global__ void EdgeDetection(pixel imgin[][DIM2], uint8_t imgout[][DIM2], size_t M, size_t N) 
{
	// MAINTAIN THIS PART
	int a = blockDim.x;
	int b = blockDim.y;
	int w = blockDim.z;
	int A = gridDim.x;
	int B = gridDim.y;
	int x = threadIdx.x;
	int y = threadIdx.y;
	int z = threadIdx.z;
	int X = blockIdx.x;
	int Y = blockIdx.y;
	int ops = x + (y*a) + (z*a*b) + (X*a*b*w) + (Y*a*b*w*A);
	// MAINTAIN THIS PART

	// image is MxN pixels, divided into as many subimages as the threads are
	// each thread takes as many pixels as it can in a single row
	// if pixels per thread (ppt) number is lower than pixels in a line (N), then more than one thread occupies a line, and each subimage has m=1 and n=N/tpl (threads per line)
	// if ppt is equal to N, then just one thread occupies a line, and each subimage has m=1 and n=N
	// if ppt is greater than N, then more than 1 line is assigned to a single thread, and each subimage has m=M/lpt (lines per thread) and n=N  
	//  ____________________________________
	// |_________________|__________________| ^
	// |_________________|__________________| |
	// |_________________|__________________| M
	// |_________________|__________________| |	
	// |_________________|__________________| ^	
	// |_________________|__________________|
	// 				  <- N ->	
	
	int m; // height of subimage
	int n; // width of subimage
	int r, c; // starting pixel coordinates
	int i, j; // cursors for moving through the pixels
	int16_t s; // temporary accumulator for computation
	int totPix = M*N; // total number of pixels
	int totThreads = a*b*w*A*B; // total number of threads
	int ppt; // pixels-per-thread
	int tpl; // threads-per-line (not used if ppt > N)
	int lpt; // lines-per-thread (not used if ppt <= N)

	// unfortunately division is not supported by FlexGrip architecture, but since divisions are between powers of 2, we can use the logarithm method 
	// ppt computation
	int k1 = totPix;
	int k2 = totThreads;
	int lg1 = 0;
	int lg2 = 0;
	while(k1 > 0) {
     	k1 = k1 >> 1;
    	lg1++;
    }
 	lg1--;
 	while(k2 > 0) {
 		k2 = k2 >> 1;
 		lg2++;
 	}
 	lg2--;
	ppt = 1 << (lg1 - lg2);

	if(ppt <= N) {
		// tpl computation
		k1 = N;
		k2 = ppt;
		lg1 = 0;
		lg2 = 0;
		while(k1 > 0) {
		 	k1 = k1 >> 1;
			lg1++;
		}
		lg1--;
		while(k2 > 0) {
			k2 = k2 >> 1;
			lg2++;
		}
		lg2--;
		tpl = 1 << (lg1 - lg2);
		// starting row index is found as ops shifted right of the logarithm of the number of threads contained in a line
		k1 = tpl;
		lg1 = 0;
		while(k1 > 0) {
			k1 = k1 >> 1;
			lg1++;
		}
		lg1--;
		r = ops >> lg1;
		// starting column index is found as ppt*(ops MOD tpl), i.e., ppt*(ops AND (tpl-1))
		c = ppt*(ops & (tpl-1));
		// number of rows of the subimage is just 1
		m = 1;
		// number of columns of the subimage is N/tpl (possibly all columns if ppt == N)
		k1 = N;
		k2 = tpl;
		lg1 = 0;
		lg2 = 0;
		while(k1 > 0) {
		 	k1 = k1 >> 1;
			lg1++;
		}
		lg1--;
		while(k2 > 0) {
			k2 = k2 >> 1;
			lg2++;
		}
		lg2--;
		n = 1 << (lg1 - lg2);
	}
	else {
		// lpt computation
		k1 = ppt;
		k2 = N;
		lg1 = 0;
		lg2 = 0;
		while(k1 > 0) {
		 	k1 = k1 >> 1;
			lg1++;
		}
		lg1--;
		while(k2 > 0) {
			k2 = k2 >> 1;
			lg2++;
		}
		lg2--;
		lpt = 1 << (lg1 - lg2);
		// starting row index is found as ops shifted left of the logarithm of lpt
		k1 = lpt;
		lg1 = 0;
		while(k1 > 0) {
			k1 = k1 >> 1;
			lg1++;
		}
		lg1--;
		r = ops << lg1;
		// starting column index is just 0
		c = 0;
		// number of rows of subimage is given by M/lpt
		k1 = M;
		k2 = lpt;
		lg1 = 0;
		lg2 = 0;
		while(k1 > 0) {
		 	k1 = k1 >> 1;
			lg1++;
		}
		lg1--;
		while(k2 > 0) {
			k2 = k2 >> 1;
			lg2++;
		}
		lg2--;
		m = 1 << (lg1 - lg2);
		// number of columns of subimage all the columns, so N
		n = N;
	}

	// transformation of the image in grayscale by applying Y = 0.2989*R + 0.5870*G + 0.1140*B for each pixel
	// a mixed multiplication/shifting is perfomed substitutes the division
	// multiplying for 0.2989 means multiplying for 19588/65536, i.e. shifting right of 16 positions
	// multiplying for 0.5870 means multiplying for 38469/65536, i.e. shifting right of 16 positions
	// multiplying for 0.1140 means multiplying for 7471/65536, i.e. shifting right of 16 positions
	for(i=0; i<m; i++) {
		for(j=0; j<n; j++) {
			s = ((imgin[r+i][c+j].R*0x4C84)>>16) + ((imgin[r+i][c+j].G*0x9645)>>16) + ((imgin[r+i][c+j].B*0x12DF)>>16);
			if(s > 255) img_grayscaled[r+i][c+j] = 255; 
			else img_grayscaled[r+i][c+j] = (uint8_t)s;
		}
	}

	// Then we should compute a matrix convolution between the grayscaled image and a filter which highlights edges (* indicates a convolution):
	//      			    	   0   1   0        	 
	// 		A    	   *    	   1  -4   1          
	//      			    	   0   1   0        	 
	// input matrix    *    edge detector filter      
	
	for(i=0; i<m; i++) {
		for(j=0; j<n; j++) {
			// clockwise sense
			s = 0;
			s = s + (img_grayscaled[r+i][c+j])*-4;
			if(c+j+1 <= N-1) s = s + img_grayscaled[r+i][c+j+1];
			if(r+i+1 <= M-1) s = s + img_grayscaled[r+i+1][c+j];
			if(c+j-1 >= 0) s = s + img_grayscaled[r+i][c+j-1];
			if(r+i-1 >= 0) s = s + img_grayscaled[r+i-1][c+j];
			if(s < 0) s = 0;
			else if(s > 255) s = 255;
			imgout[r+i][c+j] = (uint8_t)s;
		}
	}

}



int main(void)
{

	int blocksPerGrid = 2;
	int threadsPerBlock = 32;

	pixel input_image[DIM1][DIM2];
	uint8_t output_image[DIM1][DIM2];

	// please make sure that the number of thread is at most equal to the number of pixels, not more 
	EdgeDetection<<<blocksPerGrid, threadsPerBlock>>>(input_image, output_image, DIM1, DIM2);								

	return 0;	

}