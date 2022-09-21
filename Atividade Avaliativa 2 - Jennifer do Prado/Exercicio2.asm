.data
Ent1: .asciiz "Insira o valor de vet["
Ent2: .asciiz "]: "
Ent3: .asciiz "\n\nO desvio padrao e: "
numero0: .float 0.0
numero1: .float 1.0

.text
main:
    Estrutura:
        lwc1 $f7, numero0                       #carrego em $f7 o valor 0.0, $f7 sera a media dos valores
        lwc1 $f8, numero0                       #carrego em $f8 o valor 0.0, $f8 sera o somatorio (v[i]-m)^2 dos valores
        lwc1 $f9, numero0                       #carrego em $f9 o valor 0.0, $f9 sera o desvio padrao 
        add $s0, $zero, 10                      #guarda em $s0 o número 10 do vetor
        move $a0, $s0		                    #carrega em $a0 o tamanho N do vetor 
        mul $a0, $a0, 4		                    #multiplica N por 4 bits
        li $v0, 9		                        #codigo para alocação dinâmica
        syscall                                 #aloca o vetor
        move $a0, $v0 		                    #vai guardar o endereço base do vetor em $a0
        jal Leitura                             #vai receber os elementos do vetor
        move $a0, $v0		                    #guarda o endereco do vetor em $a0
        jal Media                               #funcao para calcular a media m
        move $a0, $v0		                    #guarda o endereco do vetor em $a0
        jal Somatorio                           #funcao para calcular a Somatorio (v[i]-m)^2
        jal DesvioPadrao                        #funcao para calcular o desvio padrao
        li $v0, 10                              #codigo para finalizar o programa
	    syscall                                 #finaliza o programa
	

    Leitura:
        move $t0, $a0		                    #vai guardar o endereço base do vetor em $t0
        move $t1, $t0		                    #vai guardar o endereço base do vetor em $t1
        li $t2, 0		                        #inicio $t2 com 0, será o indice i
        move $t3, $s0		                    #guarda o tamanho N do vetor em $t3
        L:	la $a0, Ent1	                    #vai carregar o endereço da String Ent1
            li $v0, 4		                    #codigo para imprimir string
            syscall                             #vai imprimir a string Ent1
            move $a0, $t2                       #imprimo o indice i
            li $v0, 1		                    #codigo para imprimir inteiro
            syscall                             #vai imprimir o inteiro i
            la $a0, Ent2                        #vai carregar o endereço da String Ent2
            li $v0 4		                    #codigo para imprimir string
            syscall                             #vai imprimir a string Ent2
            li $v0, 6		                    #codigo para ler float
            syscall                             #vai ler o float
            s.s $f0, ($t1)		                #guarda o valor float lido em $t1
            addi $t1, $t1, 4	                #vai para a proxima posicao do vetor
            addi $t2, $t2, 1	                #vai incrementar o valor do indice i
            blt $t2, $t3, L		                #se o indice i for < que o tamanho do vetor, va para L
            move $v0, $t0		                #vai guardar o endereço base do vetor em $v0 para retorno
            jr $ra                              #retorna para a instrucao que chamou a funcao Leitura
        
    Media:
        move $t0, $a0                           #vai guardar o endereço base do vetor em $t0
        move $t1, $t0                           #vai guardar o endereço base do vetor em $t1
        li $t3, 0		                        #inicio o indice i com 0
        li $t2, 0		                        #inicio $t2 com 0, vai receber o endereco da posicao i do vetor
        Somatorio_Media:
            mul $t2, $t3, 4                     #$t2 recebe i*4
            add $t2, $t2, $t0	                #$t2 vai receber o endereço da posicao i do vetor, &vet[i]
            l.s $f1, ($t2)		                #guarda em $f1 o float armazenado na posicao $t2, ou seja, vet[i]
            add.s $f7, $f7, $f1                 #soma o float ja em $f7 + valor lido do vetor na posicao i
            addi $t3, $t3, 1                    #incrementa o indice i
            blt $t3, $s0,  Somatorio_Media      #se o indice i for < N, va para Somatorio_Media novamente
        Retorna_Media: 
            mtc1 $s0, $f6                       #registrador do coprocessador 1 $f6 para o valor em $s0, passo N para float $f6
            cvt.s.w $f6, $f6                    #converte word para single precision 
            div.s $f7, $f7, $f6                 #divide float em $f7(somatorio) por $f6(N)
            move $v0, $t0		                #vai guardar o endereço base do vetor em $v0 para retorno
            jr $ra                              #retorna para a instrucao que chamou a funcao Media

    Somatorio:
        move $t0, $a0                           #vai guardar o endereço base do vetor em $t0
        move $t1, $t0                           #vai guardar o endereço base do vetor em $t1
        li $t3, 0		                        #inicio o indice i com 0
        li $t2, 0		                        #inicio $t2 com 0, vai receber o endereco da posicao i do vetor
        CalculaSomatorio:
            mul $t2, $t3, 4                     #$t2 recebe i*4
            add $t2, $t2, $t0	                #$t2 vai receber o endereço da posicao i do vetor, &vet[i]
            l.s $f1, ($t2)		                #guarda em $f1 o float armazenado na posicao $t2, ou seja, vet[i]
            sub.s $f1, $f1, $f7                 #subtrai o float em vet[i] - media em $f7
            mul.s $f1, $f1, $f1                 #faz a potencia (vet[i] - media)^2
            add.s $f8, $f8, $f1                 #soma o float ja em $f8 + valor (vet[i] - media)^2 calculado acima  
            addi $t3, $t3, 1                    #incrementa o indice i
            blt $t3, $s0,  CalculaSomatorio     #se o indice i for < N, va para CalculaSomatorio novamente
        Retorna_Somatorio: 
            move $v0, $t0		                #vai guardar o endereço base do vetor em $v0 para retorno
            jr $ra                              #retorna para a instrucao que chamou a funcao Somatorio


    DesvioPadrao:
        lwc1 $f4, numero1                       #carrego em $f4 o valor 1.0
        sub.s $f6, $f6, $f4                     #guarda em $f6 o valor N ja em $f6 - 1.0 em $f4, ou seja, N-1   
        div.s $f9, $f4, $f6                     #guarda em $f9 a divisao de 1.0 em $f4 por (N - 1.0) em $f6
        mul.s $f9, $f9, $f8                     #guarda em $f9 a multiplcacao de (1.0/(N - 1.0))  *  (somatorio de (vet[i] - media)^2)
        sqrt.s $f9, $f9                         #guarda em $f9 a raiz quadrada de (1.0/(N - 1.0))  *  (somatorio de (vet[i] - media)^2) em $f9
        ImprimeDesvioPadrao:
            la $a0, Ent3                        #vai carregar o endereço da String Ent3
            li $v0 4		                    #codigo para imprimir string
            syscall                             #vai imprimir a string Ent3
            mov.s $f12, $f9		                #move o valor do desvio padrao encontrado para $f12
            li $v0, 2                           #codigo para imprimir float
            syscall                             #imprime o float
        Retorna_DesvioPadrao:
            jr $ra                              #retorna para a instrucao que chamou a funcao DesvioPadrao