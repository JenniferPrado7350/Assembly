.data
vet: .space 12 #3 * 4 (inteiro)
vetResult: .space 16 #4 * 4 (inteiro)
Mat: .space 48 #4x3 * 4 (inteiro)
entrada: .asciiz "Entre com o valor de Vet["                              
fim_vet: .asciiz "]:"  
Ent1: .asciiz "Insira o valor de Mat["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "
matriz: .asciiz "Matriz: "
saida_vet: .asciiz "Vetor Resultado: "

.text
main:   la $a0, vet             #endereco do vetor
        jal leitura_vet         #le o vetor vet
        move $a0, $v0           #Coloca o endereco do vetor retornado da funcao "leitura_vet" em $a0
        move $t3, $a0           #endereco do vetor em $a0 guardo em $t3
        la $a0, Mat             #endereco base de mat
        li $a1,4                #número de linhas
        li $a2,3                #número de colunas
        jal leitura_mat         #leitura_mat(mat,nlin,ncol)
        move $a0, $v0           #Endereço da matriz lida
        jal escrita_mat         #escrita_mat(mat, nlin, ncol, vet)
        move $a0, $v0           #Endereço da matriz retornada em $a0
        jal Soma_Matriz_Vetor   #Soma_Matriz_Vetor(mat, nlin, ncol, vet_Result)
        move $a0, $v0           #Endereço do vetor vet_Result retornado em $a0
        jal escrita_vet         #printa o vetor vet_Result
        li $v0, 10              #codigo para finalizar o programa
        syscall                 #finaliza o programa
    
    leitura_vet:
        li $s0, 3            #guardo em $s0 o tamanho do vetor, que será tamanho 3 
        move $t0, $a0        #guarda o endereco base de vet
        move $t1, $t0        #guarda o endereco de vet em $t1
        li $t2, 0            #inicia o indice i do vetor com 0
    L_vet:  la $a0, entrada  #carrega a informacao armazenada no endereco da string entrada
        li $v0, 4            #usando o codigo SysCall para escrever strings
        syscall              #escrevendo a string
        move $a0, $t2        #carrega o indice i do vetor
        li $v0, 1            #usando o codigo SysCall para escrever inteiros
        syscall              #escrevendo o inteiro
        la $a0, fim_vet      #carrega a informacao armazenada no endereco da string fim_vet
        li $v0, 4            #usando o codigo SysCall para escrever strings
        syscall              #escrevendo a string
        li $v0, 5            #usando o codigo SysCall para ler inteiros
        syscall              #lendo o inteiro
        sw $v0, ($t1)        #guarda o inteiro lido em vet[i]
        add $t1, $t1, 4      #o registrador temporario $t1 recebe o endereco de vet[i+1]
        addi $t2, $t2, 1     #incrementa o indice i do vetor em 1
        blt $t2, $s0, L_vet  #se i < N em $s0, va para L
        move $v0, $t0        #devolve endereco de vet para retorno da funcao
        jr $ra               #retorna para a funcao main Estrutura

    indice:
        mul $v0, $t0, $a2    #i * ncol
        add $v0, $v0, $t1    #(i * ncol) + j
        sll $v0, $v0, 2      #[(i * ncol) + j] * 4 (inteiro)
        add $v0, $v0, $a3    #soma o endereço base de mat
        jr $ra               #retorna para o caller

    leitura_mat:
        li $t0, 0        #reiniciando $t0 com 0
        li $t1, 0        #reiniciando $t1 com 0
        li $t2, 0        #reiniciando $t2 com 0
        subi $sp, $sp, 4 #Espaço para 1 item na pilha
        sw $ra, ($sp)    #salva o retorno para a main
        move $a3, $a0    #aux = endereço base de mat
    l:  la $a0, Ent1     #Carrega o endereço da String
        li $v0, 4        #Codigo de impressão da string
        syscall          #imprime a string
        move $a0, $t0    #valor de i para a impressão
        li $v0, 1        #codigo de impressão de inteiro
        syscall          #imprime i
        la $a0, Ent2     #Carrega o endereco da string
        li $v0, 4        #codigo de impressão de string
        syscall          #imprime a string
        move $a0, $t1    #valor de j para a impressão
        li $v0, 1        #codigo de impressão de inteiro
        syscall          #imprime j
        la $a0, Ent3     #carrega o endereço da string
        li $v0, 4        #Codigo de impressão da string
        syscall          #imprime a string
        li $v0, 5        #codigo de leitura de inteiro
        syscall          #leitura do valor (retorna em $v0)
        move $t2, $v0    #aux = valor lido
        jal indice       #calcula o endereço de mat[i][j]
        sw $t2, ($v0)    #mat [i][j] = aux
        addi $t1, $t1, 1 #j++
        blt $t1, $a2, l  #se (j < ncol) goto l
        li $t1, 0        #j = 0
        addi $t0, $t0, 1 #i++
        blt $t0, $a1, l  #se (i < nlin) goto l
        li $t0, 0        #i = 0
        lw $ra, ($sp)    #recupera o retorno para a main
        addi $sp, $sp, 4 #libera o espaço na pilha
        move $v0, $a3    #Endereço base da matriz para retorno
        jr $ra           #Retorna para a main
        
    escrita_mat:
        move $t4, $t3    #endereco de vet em $t4, vet[0]
        subi $sp, $sp, 4 #Espaço para 1 item na pilha
        sw $ra, ($sp)    #Salva o retorno para a main
        move $a3, $a0    #aux = endereço base de mat
        la $a0, 10       #codigo ASCII parea newline ('\n')
        li $v0, 11       #codigo de impressão de caractere
        syscall          #pula a linha
        la $a0, matriz   #carrega a informacao armazenada no endereco da string matriz
        li $v0, 4        #usando o codigo SysCall para escrever strings
        syscall          #escrevendo a string
        la $a0, 10       #codigo ASCII parea newline ('\n')
        li $v0, 11       #codigo de impressão de caractere
        syscall          #pula a linha
    e:  jal indice       #calcula o endereço de mat[i][j]
        lw $a0, ($v0)    #valor em mat[i][j] guardo em $a0
        addi $t1, $t1, 1 #j++
        lw $s1, ($v0)    #$s1 recebe o valor em mat[i][j]
        lw $s2, ($t4)    #$s2 recebe o valor em vet[j]
        mul $s3, $s1, $s2#$s3 recebe mat[i][j] * vet[j]      
        sw $s3, ($v0)    #guardo a multiplicação em mat[i][j]
        addi $t4, $t4, 4 #vetor vai para proxima posição, vet[j+1]
        li $v0, 1        #codigo de impressão de inteiro
        syscall          #imprime [i][j] antes da multiplicação
        la $a0, 32       #codigo ASCII para espaço
        li $v0, 11       #codigo de impressão de caractere
        syscall          #imprime o espaço
        blt $t1, $a2, e  #se (j < ncol) goto e
        la $a0, 10       #codigo ASCII parea newline ('\n')
        syscall          #pula a linha
        li $t1, 0        #j = 0
        move $t4, $t3    #endereco de vet em $t4, voltando a vet[0]
        addi $t0, $t0, 1 #i++
        blt $t0, $a1, e  #se (i < nlin) goto e
        li $t0, 0        #i = 0
        lw $ra, ($sp)    #recupera o retorno para a main
        addi $sp, $sp, 4 #libera o espaço na pilha
        la $a0, 10       #codigo ASCII parea newline ('\n')
        syscall          #pula a linha
        move $v0, $a3    #endereço base da matriz para retorno
        jr $ra           #retorna para a main

    Soma_Matriz_Vetor:   #soma os elementos da matriz, pois ja multiplicamos
        li $s2, 0        #inicio $s2 com 0
        move $a3, $a0    #aux = endereço base de mat
        la $a0, vetResult#endereco base do vetor resultado em $a0
        move $t5, $a0    #guarda o endereco base de vetResult em $t5
        move $t6, $t5    #guarda o endereco de vetResult em $t6
        subi $sp, $sp, 4 #Espaço para 1 item na pilha
        sw $ra, ($sp)    #Salva o retorno para a main
    M:  jal indice       #calcula o endereço de mat[i][j]
        lw $s1, ($v0)    #valor em mat[i][j]
        addi $t1, $t1, 1 #j++
        add $s2, $s2, $s1#$s2 = valor em $s2 + mat[i][j]
        blt $t1, $a2, M  #se (j < ncol) goto M
        li $t1, 0        #j = 0
        addi $t0, $t0, 1 #i++
        sw $s2, ($t6)    #vetResult[i] = $s2(somatorio da linha i)
        li $s2, 0        #reinicio $s2 com 0
        addi $t6, $t6, 4 #vetor vetResult vai para proxima posição, vetResult[i+1]
        blt $t0, $a1, M  #se (i < nlin) goto M
        li $t0, 0        #i = 0
        lw $ra, ($sp)    #recupera o retorno para a main
        addi $sp, $sp, 4 #libera o espaço na pilha
        move $v0, $t5    #endereço base do vetor vetResult para retorno
        jr $ra           #retorna pa a main

    escrita_vet:
        li $s1, 4            #guardo em $s1 o tamanho do vetor vetResult, que é tamanho 4 
        move $t0, $a0        #guarda o endereco base de vet
        move $t1, $t0        #guarda o endereco de vet em $t1
        li $t2, 0            #inicia o indice i do vetor com 0
        la $a0, saida_vet    #carrega a informacao armazenada no endereco da string saida_vet
        li $v0, 4            #usando o codigo SysCall para escrever strings
        syscall              #escrevendo a string
    E_vet:  lw $a0, ($t1)    #carrega o valor do inteiro armazenado na posicao vetResult[i]
        li $v0, 1            #usando o codigo SysCall para escrever inteiros        
        syscall              #escrevendo o inteiro
        li $a0, 32           #usando o codigo SysCall de ASCII para escrever espaco
        li $v0, 11           #usando o codigo SysCall para imprimir caracteres
        syscall              #escrevendo o espaco
        add $t1, $t1, 4      #o registrador temporario $t1 recebe o endereco de vetResult[i+1]
        addi $t2, $t2, 1     #incrementa o indice i do vetor vetResult em 1
        blt $t2, $s1, E_vet  #se i < tamanho do vetor vetResult em $s1, va para E_vet
        move $v0, $t0        #devolve endereco de vetResult para retorno da funcao
        jr $ra               #retorna para a funcao main Estrutura