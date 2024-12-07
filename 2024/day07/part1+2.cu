#include <atomic>
#include <fstream>
#include <iostream>
#include <sstream>
#include <thread>
#include <vector>

#ifndef PART2
  #define __A 2
  #define __B 1
  #define __C 1
#else
  #define __A 4
  #define __B 2
  #define __C 3
#endif

__device__ unsigned long concat(unsigned long a, unsigned long b) {
  unsigned long mp = 1;
  while (mp <= b) mp *= 10;
  return a * mp + b;
}

__global__ void find_operators(
  // IN
  const unsigned int    total_combinations,
  const unsigned int  * operands,
  const unsigned int    operands_count,
  const unsigned long   target,

  // OUT
  unsigned int  * found
) {
  unsigned long idx = blockIdx.x * blockDim.x + threadIdx.x;

  ///// ///// ///// ///// /////

  if (idx >= total_combinations || *found) {
    return;
  }

  ///// ///// ///// ///// /////

  unsigned long result = operands[0];

  for (unsigned int i = 1; i < operands_count; i++) {
    switch ((idx >> ((i - 1) * __B)) & __C) {
      case 0: result += operands[i]; break;
      case 1: result *= operands[i]; break;
      case 2: result = concat(result, operands[i]); break;
      default: return;
    }
  }

  ///// ///// ///// ///// /////

  if (result == target) {
    atomicExch(found, 1);
  }
}

int main() {
  std::ifstream file("input.txt");
  std::string line;
  std::vector<std::thread> threads;
  std::atomic<unsigned long> results = 0;

  while (std::getline(file, line)) {
    std::istringstream stream(line);

    ///// ///// ///// ///// /////

    unsigned long target;
    unsigned char colon;
    unsigned int operand;

    std::vector<unsigned int> operands_vec;

    ///// ///// ///// ///// /////

    if (stream >> target) {
      stream >> colon;

      while (stream >> operand) {
        operands_vec.push_back(operand);
      }
    }

    ///// ///// ///// ///// /////

    threads.push_back(
      std::thread(
        [& results, target, operands_vec] () {
          const unsigned int  * h_operands       = operands_vec.data();
          const unsigned int    h_operands_count = operands_vec.size();
          const unsigned long   h_target         = target;
                unsigned int    h_found          = 0;

                unsigned int  * d_operands;
                unsigned int  * d_found;

          ///// ///// ///// ///// /////

          cudaMalloc(&d_operands, h_operands_count * sizeof(unsigned int));
          cudaMalloc(&d_found   ,                    sizeof(unsigned int));

          ///// ///// ///// ///// /////

          cudaMemcpy( d_operands,  h_operands, h_operands_count * sizeof(unsigned int), cudaMemcpyHostToDevice);
          cudaMemcpy( d_found   , &h_found   ,                    sizeof(unsigned int), cudaMemcpyHostToDevice);

          ///// ///// ///// ///// /////

          unsigned int threads_per_block = 256;
          unsigned int total_combinations = pow(__A, h_operands_count - 1);
          unsigned int blocks = (total_combinations + threads_per_block - 1) / threads_per_block;
          find_operators<<<blocks, threads_per_block>>>(total_combinations, d_operands, h_operands_count, h_target, d_found);

          ///// ///// ///// ///// /////

          cudaMemcpy(&h_found   ,  d_found   ,                    sizeof(unsigned int), cudaMemcpyDeviceToHost);

          ///// ///// ///// ///// /////

          if (h_found) {
            results += h_target;
          }
        }
      )
    );
  }

  ///// ///// ///// ///// /////

  for (auto & thread : threads) {
    thread.join();
  }

  ///// ///// ///// ///// /////

  std::cout << results << std::endl;

  ///// ///// ///// ///// /////

  file.close();

  ///// ///// ///// ///// /////

  return 0;
}
