#s0-11 :save registers
#a0-7 :argument registers
#t0-6 :temp registers
.data
#ret_arr: .word 0,0,0,0,0,0,0,0,0,0
str1:   .string " "
newline:   .string "\n"
.bss
ret_arr: .word 0
.text
main:
    addi a3,x0,0 #a3 = rowIndex
    la s0,ret_arr #
    la s1,str1
    jal getRow
    addi t1,x0,0 #t1 = i
    jal print_loop

    addi a3,x0,10 #a3 = rowIndex
    la s0,ret_arr #
    la s1,str1
    jal getRow
    addi t1,x0,0 #t1 = i
    jal print_loop
    
    addi a3,x0,33 #a3 = rowIndex
    la s0,ret_arr #
    la s1,str1
    jal getRow
    addi t1,x0,0 #t1 = i
    jal print_loop
    
    li a7, 10		 # Halts the simulator
    ecall

getRow:
    addi sp,sp,-4
    sw ra,0(sp)   
    addi a4,a3,1 #a4 = returnSize
    addi a5,x0,0 #a5 = layer
while_loop: # to determine whether the target layer has been calculated
    srli a6,a5,1 #a6 = middle, to ack the boundary of keft side
    addi t1,a6,0 #t1 = i
    
    la s0,ret_arr #s0 = base addr of ret_arr

    jal for_loop1
    #bge t1,x0, for_loop1
    addi t1,x0,0 #t1 = i
    jal for_loop2
    addi a5,a5,1
    bge a3,a5,while_loop # rowIndex>=layer? if true, while loop continue becaue while loop hasn't reached the target layer
while_end:
    lw ra,0(sp)
    addi sp,sp,4
    jr ra   

for_loop1:   # to calculate left half elements of a layer
    blt t1,x0,for_loop1_end # determine whether loop continue
    bne t1,x0,else1 # determine i==0? determine if-else statement
    addi t3,x0,1 #t3 = 1
    slli t2,t1,2 #t2 = i*4, word addr to byte addr
    add t2,t2,s0 #t2 =offset+base addr
    sw t3,0(t2) #store 1 to array[0]
    addi t1,t1,-1 # update iteration variable
    j for_loop1
for_loop1_end:
    jr ra # return to caller
else1:   
    addi t2,t1,-1 #t2 = i-1
    slli t2,t2,2 #to byte address
    add t2,s0,t2
    lw t3,0(t2) # load ret_arr[i-1]
    add t4,t3,x0 # t4 = ret_arr[i-1]
    addi t2,t1,0 #t2 = i
    slli t2,t2,2 #to byte address
    add t2,s0,t2 #base addr + i*4, to update the address of storing
    lw t3,0(t2) # load ret_arr[i]
    add t4,t3,t4 #t4+=ret_arr[i]
    sw t4,0(t2)
    addi t1,t1,-1
    j for_loop1
for_loop2:
    bge a6,t1,for_loop2_itr
    jr ra
for_loop2_itr: # for copy left to right
    sub t2,a5,t1 # t2=layer-i
    slli t2,t2,2 
    slli t3,t1,2
    add t3,s0,t3
    add t2,s0,t2
    lw t4,0(t3)
    sw t4,0(t2)
    addi t1,t1,1
    j for_loop2
    
print_loop: # to show the result
    bge t1,a4,print_loop_end

    lw a0, 0(s0) # a0 used for return print number
    li a7,1  #to print int
    ecall

    la a0,str1
    li a7,4  #to print string
    ecall
    
    addi t1,t1,1
    addi s0,s0,4
    j print_loop
print_loop_end:        
    la a0,newline
    li a7,4  #to print string
    ecall
    
    jr ra