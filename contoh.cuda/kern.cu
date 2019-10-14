#include <stdio.h>
#include <cuda_runtime.h>

<<<<<<< HEAD
// tugas1: alokasi memori dan transfer dari device ke host
#define N 12
=======
#define N 12
// tugas 1: alokasi memori dan transfer dari device ke host
>>>>>>> b3ed746430a99b81299d328a171dbd11bd1df781

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
<<<<<<< HEAD
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

=======
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
>>>>>>> b3ed746430a99b81299d328a171dbd11bd1df781
	return 0;
}
