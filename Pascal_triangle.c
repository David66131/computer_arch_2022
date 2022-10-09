
#include<stdio.h>
#include<stdlib.h>
int *getRow(int ,int*);

int main(){
	
	int *ans = NULL;
	int ans_size ;
	int i;
	
	int rowIndex = 0;
	ans = getRow(rowIndex, &ans_size);
    for(i=0;i<ans_size;i++){
		printf("%d ",ans[i]);
	}
	printf("\n");
	
	rowIndex = 10;
	ans = getRow(rowIndex, &ans_size);
    for(i=0;i<ans_size;i++){
		printf("%d ",ans[i]);
	}
	printf("\n");
	
	rowIndex = 33;
	ans = getRow(rowIndex, &ans_size);
    for(i=0;i<ans_size;i++){
		printf("%d ",ans[i]);
	}
	printf("\n");
	
	return 0;
}

int* getRow(int rowIndex, int* returnSize){
	int *ret_arr =  malloc(sizeof(int)* (rowIndex + 1));
    *returnSize = (rowIndex + 1);
    int layer = 0;
	int middle = layer >> 1;
    while(rowIndex>=layer){
        int i=0;
        for(i=layer/2;i>=0;i--){
            if(i==0)
                ret_arr[i] = 1;
            else
                ret_arr[i] = ret_arr[i] + ret_arr[i-1];
            
        }
        for(i=0;i<=layer/2;i++){
            ret_arr[layer-i] = ret_arr[i];
        }
         layer++; 
    }
    
	return ret_arr;
}