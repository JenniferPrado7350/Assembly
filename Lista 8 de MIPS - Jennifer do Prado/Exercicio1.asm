.data
entradaN: .asciiz "Entre com o valor inteiro positivo de N (quantidade de numeros no vetor): "
Ent1: .asciiz "Insira o valor de vet["
Ent2: .asciiz "]: "
saidaNumero: .asciiz "\nNumero: "
saidaFrequencia: .asciiz " , frenquencia: "
msg_erro: .asciiz "O valor digitado tem que ser inteiro maior que 0. "  
numero1: .float -0.0
.text
main:
	N: 
        li $v0, 4               #usando o codigo SysCall para escrever strings
        la $a0, entradaN        #passando a mensagem que estava na memoria na variavel "entradaN" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        li $v0, 5               #usando o codigo SysCall para ler inteiros
        syscall                 #o inteiro de entrada "N" foi lido e esta em $v0
        blt $v0, 1, Erro        #caso o valor digitado que esta no registrador de valor $v0 for menor que o inteiro "1", vai para Erro
        add $s0, $v0, $zero     #guarda em $s0 o número digitado "N" que esta em $v0

    Estrutura:
        lwc1 $f7, numero1       #carrego em $f7 o valor null
        move $a0, $s0		    #carrega em $a0 o tamanho N do vetor 
        mul $a0, $a0, 4		    #multiplica N por 4 bits
        li $v0, 9		        #codigo para alocação dinâmica
        syscall                 #aloca o vetor
        move $s1, $v0 		    #vai guardar o endereço base do vetor em $s1
        move $a0, $s1		    #vai guardar o endereço base do vetor em $a0
        move $a1, $s0		    #vai guardar o tamanho do vetor em $a1
        jal Leitura             #vai receber os elementos do vetor
        move $a0, $s1		    #guarda o endereco do vetor em $a0
        move $a1, $s0		    #guarda o tamanho N do vetor em $a1
        jal CalculaFrequencia   #funcao para calcular a frequencia
        li $v0, 10              #codigo para finalizar o programa
	    syscall                 #finaliza o programa
	

    Leitura:
        move $t0, $a0		    #vai guardar o endereço base do vetor em $t0
        move $t1, $t0		    #vai guardar o endereço base do vetor em $t1
        li $t2, 0		        #inicio $t2 com 0, será o indice i
        move $t3, $a1		    #guarda o tamanho N do vetor em $t3
        L:	la $a0, Ent1	    #vai carregar o endereço da String Ent1
            li $v0, 4		    #codigo para imprimir string
            syscall             #vai imprimir a string Ent1
            move $a0, $t2       #imprimo o indice i
            li $v0, 1		    #codigo para imprimir inteiro
            syscall             #vai imprimir o inteiro i
            la $a0, Ent2        #vai carregar o endereço da String Ent2
            li $v0 4		    #codigo para imprimir string
            syscall             #vai imprimir a string Ent1
            li $v0, 6		    #codigo para ler float
            syscall             #vai ler o float
            s.s $f0, ($t1)		#guarda o valor float lido em $t1
            addi $t1, $t1, 4	#vai para a proxima posicao do vetor
            addi $t2, $t2, 1	#vai incrementar o valor do indice i
            blt $t2, $t3, L		#se o indice i for < que o tamanho do vetor, va para L
            jr $ra              #retorna para a instrucao que chamou a funcao Leitura
        

    CalculaFrequencia:
        move $t0, $a0		#guarda em $t0 o endereco base do vetor
        move $t1, $t0		#guarda em $t1 o endereco base do vetor
        move $t2, $a1		#guarda em $t2 o tamanho do vetor
        li $t3, 0		    #inicio o indice i com 0
        AnalizaElementosVet:	
            mul $t1, $t3, 4                     #$t1 recebe i*4
            add $t1, $t1, $t0	                #$t1 vai receber o endereço da posicao i do vetor, &vet[i]
            l.s $f1, ($t1)		                #guarda em $f1 o float armazenado na posicao $t1, ou seja, vet[i]
            c.eq.s $f1, $f7		                #se o float em $f1 < float em $f7
	        bc1t ProximoElementoVet		        #va para ProximoElementoVet
            li $t5, 0		                    #o contador de frequencia $t5 recebe 0
            move $t6, $t0		                #guarda em $t6 o endereco base do vetor, vet[0]
            li $t7, 0		                    #inicio o indice j com 0
            ProcuraFrequencia:	
                mul $t6, $t7, 4                 #$t6 vai receber o indice j*4
                add $t6, $t6, $t0               #$t6 recebe a adicao da multiplicacao j*4 + &vet (endereco do vetor), ou seja, &vet[j]
                l.s $f2, ($t6)		            #vai carregar em $f2 o valor do float no endereco calculado acima, vet[j]
                c.eq.s $f1, $f2		            #guarda o resultado da condicao se $f1 == $f2
	            bc1f ImprimeFrequencia		    #caso a condicao anterior for falsa($f1 != $f2) vai para ImprimeFrequencia
                addi $t5, $t5, 1	            #vai incrementar o contador de frequencia $t5
                s.s $f7, ($t6)		            #carrego o valor null de $f7 no endereco vet[j] para nao encontra-lo novamente
                ImprimeFrequencia:	
                    addi $t7, $t7, 1	            #vai incrementar o indice j
                    blt $t7, $t2, ProcuraFrequencia #se o indice j < N, va para ProcuraFrequencia
                    la $a0, saidaNumero             #carrega o endereco da string saidaNumero
                    li $v0, 4                       #codigo para imprimir string
                    syscall                         #vai imprimir a string saidaNumero
                    mov.s $f12, $f1                  #carrega o valor do float de $f1 em $f0
                    li $v0, 2                       #codigo para imprimir float
                    syscall                         #vai imprimir o float
                    la $a0, saidaFrequencia         #carrega o endereco da string saidaFrequencia
                    li $v0, 4                       #codigo para imprimir string
                    syscall                         #vai imprimir a string saidaFrequencia
                    move $a0, $t5                   #carrega o valor do inteiro de $t5 em $a0
                    li $v0, 1                       #codigo para imprimir inteiro
                    syscall                         #vai imprimir o inteiro
            ProximoElementoVet:	
                addi $t3, $t3, 1	                #vai incrementar o indice i
                blt $t3, $t2, AnalizaElementosVet	#se o indice i < N, va para AnalizaElementosVet
                jr $ra                              #retorna para a instrucao que chamou CalculaFrequencia

    Erro:
        li $v0, 4               #usando o codigo SysCall para escrever strings      
        la $a0, msg_erro        #passando a mensagem que estava na memoria na variavel "msg_erro" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        jal N                   #vai pular para o bloco N novamente
