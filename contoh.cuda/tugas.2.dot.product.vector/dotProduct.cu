#include <iostream>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

const size_t GRID_SIZE = 100;
const size_t BLOCK_SIZE = 256;

// kernel menambahkan vector
__global__ 
void dotProduct(
	const float *cVectorA, 
	const float *cVectorB, 
	float *dotProductSebagian, 
	const int cJumlahElemen)
{
    	__shared__ float cache[ BLOCK_SIZE ];
	// caching
    	int idx_ = blockIdx.x * blockDim.x + threadIdx.x;
	
    	__syncthreads(); 

	// gunakan idx_ untuk mentrace ukuran block
	
	//hasil akhir pada cache[0]
	if (threadIdx.x == 0) dotProductSebagian[blockIdx.x] = cache[0];
}

// fungsi main untuk panggil kernel
int main(void)
{
	// gunakan GPU ke-1 
	cudaSetDevice(0);
	const int kJumlahElemen = GRID_SIZE * BLOCK_SIZE;
  	size_t ukuran_vector_bytes_ = kJumlahElemen * sizeof(float);
	std::cout << "[Penjumlahan vector dengan jumlah elemen  " << kJumlahElemen << std::endl;
  	
	float *h_A_ = (float *)malloc(ukuran_vector_bytes_);
  	float *h_B_ = (float *)malloc(ukuran_vector_bytes_);
  	float *h_C_ = (float *)malloc(GRID_SIZE * sizeof(float));

  	if (h_A_ == NULL || h_B_ == NULL || h_C_ == NULL)
  	{
		std::cerr << "Failed to allocate host vectors!\n";
    		exit(-1);
  	}

	srand(time(NULL));
  	for (int i = 0; i < kJumlahElemen; ++i)
  	{
		h_A_[i] = rand()/(float)RAND_MAX;
		h_B_[i] = rand()/(float)RAND_MAX;
  	}	

  	float *d_A_ = NULL;
	float *d_B_ = NULL;
	float *d_C_ = NULL;

  	cudaMalloc((void **)&d_A_, ukuran_vector_bytes_);
	cudaMalloc((void **)&d_B_, ukuran_vector_bytes_);
	cudaMalloc((void **)&d_C_, GRID_SIZE * sizeof(float));

	std::cout << "Salin input dari host ke  CUDA device\n";

	
  	cudaMemcpy(d_A_, h_A_, ukuran_vector_bytes_, cudaMemcpyHostToDevice);
  	cudaMemcpy(d_B_, h_B_, ukuran_vector_bytes_, cudaMemcpyHostToDevice);


	dim3 block(BLOCK_SIZE, 1, 1);
	dim3 grid(GRID_SIZE, 1, 1);
	
	std::cout << "Peluncuran kernel Cuda dengan ukuran  " << GRID_SIZE << " block  " << BLOCK_SIZE << " threads\n";
  	
	dotProduct<<<grid,block>>>(d_A_,d_B_,d_C_,kJumlahElemen);
	cudaError_t err_ = cudaGetLastError();
  	if (err_ != cudaSuccess)
  	{
		std::cerr << "Gagal meluncurkan kernel Cuda  (error code " << cudaGetErrorString(err_) << ")!\n";
    		exit(-1);
	}

	std::cout << "Salin data dari CUDA device ke  host memory\n";
  	cudaMemcpy(h_C_, d_C_, GRID_SIZE * sizeof(float), cudaMemcpyDeviceToHost);

	float resultGPU  = 0.0;
	for (int i=0;i<GRID_SIZE;i++) resultGPU += h_C_[i];
	
	float resultCPU	 = 0.0;
	for (int i=0;i<kJumlahElemen;i++) resultCPU += h_A_[i] * h_B_[i];

	std::cout << "GPU = " << resultGPU << std::endl;
	std::cout << "CPU = " << resultCPU << std::endl;

	if (fabs(resultGPU - resultCPU) < 1e-1)
		std::cout << "Test PASSED\n";
	else
		std::cout << "Test FAILED\n";


  	cudaFree(d_A_);
  	cudaFree(d_B_);
	cudaFree(d_C_);

  	free(h_A_);
  	free(h_B_);
  	free(h_C_);

  	cudaDeviceReset();

	std::cout << "Done\n";
  	return 0;
}
