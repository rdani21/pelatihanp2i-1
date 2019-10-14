#include <stdio.h>
#include <cuda_runtime.h>

#define N 12
// tugas 1: alokasi memori dan transfer dari device ke host

__global__ void kern(int *A)
{
    	int idx = blockDim.x * blockIdx.x + threadIdx.x;
 	A[idx] = idx;
}

/**
 * Host main routine
 */
int   main(void)
{
	// alokasikan memori, dan salin nilainya
	int *A = (int *) malloc(N*sizeof(int)); // alokasi memory di host
	int *d_A;
	cudaMalloc((void **)&d_A,N*sizeof(int)); // alokasi memori di device
	cudaMemcpy(d_A,A,N*sizeof(int),cudaMemcpyHostToDevice); // 

	dim3 grid,block;
	block.x = 4;
	grid.x = 12/block.x;
	kern<<<grid,block>>>(d_A);
	cudaMemcpy(A,d_A,N*sizeof(int),cudaMemcpyDeviceToHost); // copy device ke host 
	// copy result
	for (int i = 0;i < N;i++) 
		printf("A[%d] = %d\n",i,A[i]);
	free(A);
	cudaFree(d_A);
	return 0;
}
