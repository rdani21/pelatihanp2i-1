#include <iostream>
#include <cuda_runtime.h>
#include <device_launch_parameters.h>

// kernel menambahkan vector
__global__ 
void tambahVector(
	const float *cVectorA, 
	const float *cVectorB, 
	float *cVectorC, 
	const int cJumlahElemen)
{
	// cari indeks saya
	int idx_ = 0;
}

// fungsi main untuk panggil kernel
int main(void)
{
	// gunakan GPU ke-1 
	cudaSetDevice(0);
	const int kJumlahElemen = 25600;
  	size_t ukuran_vector_bytes_ = kJumlahElemen * sizeof(float);
	std::cout << "[Penjumlahan vector dengan jumlah elemen  " << kJumlahElemen << std::endl;
  	float *h_A_ = (float *)malloc(ukuran_vector_bytes_);
  	float *h_B_ = (float *)malloc(ukuran_vector_bytes_);
  	float *h_C_ = (float *)malloc(ukuran_vector_bytes_);

  	if (h_A_ == NULL || h_B_ == NULL || h_C_ == NULL)
  	{
		std::cerr << "Failed to allocate host vectors!\n";
    		exit(-1);
  	}

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
	cudaMalloc((void **)&d_C_, ukuran_vector_bytes_);

	std::cout << "Salin input dari host ke  CUDA device\n";

	
  	cudaMemcpy(d_A_, h_A_, ukuran_vector_bytes_, cudaMemcpyHostToDevice);
  	cudaMemcpy(d_B_, h_B_, ukuran_vector_bytes_, cudaMemcpyHostToDevice);

  	int threads_per_block_ = 256;
	int blocks_per_grid_ = 1;

	dim3 block(threads_per_block_, 1, 1);
	dim3 grid(blocks_per_grid_, 1, 1);
	
	std::cout << "Peluncuran kernel Cuda dengan ukuran  " << blocks_per_grid_ << " block  " << threads_per_block_ << " threads\n";
  	
	tambahVector<<<block, grid>>>(d_A_,d_B_,d_C_,kJumlahElemen);
	cudaError_t err_ = cudaGetLastError();
  	if (err_ != cudaSuccess)
  	{
		std::cerr << "Gagal meluncurkan kernel Cuda  (error code " << cudaGetErrorString(err_) << ")!\n";
    		exit(-1);
	}

	std::cout << "Salin data dari CUDA device ke  host memory\n";
  	cudaMemcpy(h_C_, d_C_, ukuran_vector_bytes_, cudaMemcpyDeviceToHost);

 	 // verifikasi nilai
 	for (int i = 0; i < kJumlahElemen; ++i)
  	{
    		if (fabs(h_A_[i] + h_B_[i] - h_C_[i]) > 1e-5)
    		{

			std::cerr << "Verifikasi gagal " << i << "!\n";
      			exit(-1);
    		}
  	}


	std::cout << "Test PASSED\n";

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
