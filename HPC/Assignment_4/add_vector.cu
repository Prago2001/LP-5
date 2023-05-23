#include<iostream>
#include<bits/stdc++.h>
#include<cuda.h>
#define BLOCK_SIZE 16
using namespace std;

void fill_array(int *arr,int size){
    for(int i = 0;i < size; i++){
        arr[i] = rand() % 100;
    }
}

void add_cpu(int *arr1, int *arr2, int *result, int size){
    for(int i = 0;i < size; i++){
        result[i] = arr1[i] + arr2[i];
    }
}

void print_matrix(int *arr, int size){
    for(int i = 0; i < size; i++){
        cout << arr[i] << " ";
    }
    cout << endl;
}

__global__ void add(int *arr1, int *arr2, int *arr3,int size){
    int block_id = blockIdx.x * blockDim.x + threadIdx.x;
    if(block_id < size){
        arr3[block_id] = arr1[block_id] + arr2[block_id];
    }
}

int main(){
    int *arr1_cpu,*arr2_cpu,*result_cpu;
    int size;
    cout << "Enter size of vector: ";
    cin >> size;

    arr1_cpu = new int[size];
    arr2_cpu = new int[size];
    result_cpu = new int[size];

    fill_array(arr1_cpu,size);
    cout << "Array 1: ";
    print_matrix(arr1_cpu,size);
    fill_array(arr2_cpu,size);
    cout << "Array 2: ";
    print_matrix(arr2_cpu,size);

    int *arr1_gpu,*arr2_gpu,*result_gpu;
    
    cudaMallocManaged(&arr1_gpu, size * sizeof(int));
    cudaMallocManaged(&arr2_gpu, size * sizeof(int));
    cudaMallocManaged(&result_gpu, size * sizeof(int));

    cudaMemcpy(arr1_gpu,arr1_cpu,size * sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(arr2_gpu,arr2_cpu,size * sizeof(int),cudaMemcpyHostToDevice);
    cudaEvent_t start,stop;
    float elapsedTime;
    
    dim3 dimGrid(size + BLOCK_SIZE - 1 / BLOCK_SIZE);
    dim3 dimBlock(BLOCK_SIZE);

    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start,0);

    add<<<dimGrid,dimBlock>>>(arr1_gpu,arr2_gpu,result_gpu,size);
    cudaEventRecord(stop,0);
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&elapsedTime,start,stop);
    cudaEventDestroy(start);
    cudaEventDestroy(stop);
    cudaMemcpy(result_cpu,result_gpu,size * sizeof(int),cudaMemcpyDeviceToHost);
    cout << "GPU result:\n";
    print_matrix(result_cpu,size);
    cout<<"Elapsed Time = "<<elapsedTime<<" milliseconds" << endl;
    cudaFree(arr1_gpu);
    cudaFree(arr2_gpu);
    cudaFree(result_gpu);

    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start,0);

    add_cpu(arr1_cpu,arr2_cpu,result_cpu,size);
    cudaEventRecord(stop,0);
    cudaEventSynchronize(stop);
    cudaEventElapsedTime(&elapsedTime,start,stop);
    cudaEventDestroy(start);
    cudaEventDestroy(stop);
    cout << "CPU result:\n";
    print_matrix(result_cpu,size);
    cout<<"Elapsed Time = "<<elapsedTime<<" milliseconds" << endl;

    return 0;
}