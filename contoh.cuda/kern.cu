#include <stdio.h>
#include <cuda_runtime.h>

// tugas1: alokasi memori dan transfer dari device ke host
#define N 12

__global__ void
kern(int *A)
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
	int *A = (int *) malloc (N*sizeof(int)); //alokasi di host

	
	//alokasi global memori di device memakai cuda malloc
	int *dev_A ;
	cudaMalloc(&dev_A,N*sizeof(int));

	//copy data dari host ke device
	//cudaMemcpy(dev_A,A,N*sizeof(int),cudaMemcpyHostToDevice);
 
	dim3 grid,block;
	block.x = 4;
	grid.x = 12/block.x;

	kern<<<grid,block>>>(dev_A);
	// copy result

	//copy hasil dari device ke host
        cudaMemcpy(A,dev_A,N*sizeof(int),cudaMemcpyDeviceToHost);

	for(int i=0;i<N;i++){
		printf("A[%d]=%d\n,",i,A[i]);
	}
	free(A);
	cudaFree(dev_A);

	return 0;
}
