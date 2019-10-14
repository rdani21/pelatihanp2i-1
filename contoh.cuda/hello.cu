
#include <stdio.h>
#include <cuda_runtime.h>

__global__ void cuda_hello(){
    printf("Hello World from GPU!\n");
}

int main() {
<<<<<<< HEAD
    cuda_hello<<<1,1>>>();
    cudaDeviceReset();
	 
=======
    cuda_hello<<<1,1>>>(); 
    cudaDeviceSynchronize();
    cudaDeviceReset();
>>>>>>> b3ed746430a99b81299d328a171dbd11bd1df781
    return 0;
}
