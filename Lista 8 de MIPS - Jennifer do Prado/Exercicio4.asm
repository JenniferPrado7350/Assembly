.data
entradaN: .asciiz "Entre com o valor inteiro positivo de N (quantidade de numeros no vetor): "
Ent1: .asciiz "Insira o valor de vet["
Ent2: .asciiz "]: "
segmentoSoma: .asciiz "\nA soma do maior segmento sera: "
msg_erro: .asciiz "O valor digitado tem que ser inteiro maior que 0. "  
zero: .float 0.0

.text

main:

   N: 
        li $v0, 4               #usando o codigo SysCall para escrever strings
        la $a0, entradaN        #passando a mensagem que estava na memoria na variavel "entradaN" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        li $v0, 5               #usando o codigo SysCall para ler inteiros
        syscall                 #o inteiro de entrada "N" foi lido e esta em $v0
        blt $v0, 1, Erro        #caso o valor digitado que esta no registrador de valor $v0 for menor que o inteiro "1", vai para Erro
        add $s0, $v0, $zero     #guarda em $s0 o número digitado "N" que esta em $v0, sera o tamanho do vetor
	
    Estrutura:
        move $a0, $s0		    #tamanho do vetor em $a0
        jal Leitura             #pula para a funcao Leitura
        move $a0, $s1		    #carrega o endereço base do vetor retornado da funcao Leitura em $a0
        jal DescobreSegmento    #pula para a funcao DescobreSegmento
        mov.s $f12, $f20	    #carrega o maior para o argumento $f12
        jal ImprimeSomaSegmento #pula para a funcao ImprimeSomaSegmento
        li $v0, 10              #codigo para finalizar o programa
	    syscall                 #finaliza o programa
	 

    Leitura:
        mul $a0, $a0, 4		#guardo em $a0 o tamanho do vetor * 4
        li $v0, 9		    #codigo para alocação dinamica
        syscall             #vai alocar o vetor
        move $t0, $v0 		#passa o endereco do vetor para $t0
        move $s1, $t0		#passa o endereco do vetor para $s1
        move $t1, $t0		#passa o endereco do vetor para $t1
        li $t2, 0		    #inicia $t2 com 0, sera o indice i 
        move $t3, $s0		#tamanho do vetor em $t3
    l:	la $a0, Ent1	    #passando a mensagem que estava na memoria na variavel "Ent1" para o registrador de argumento $a0 (string a ser escrita)
        li $v0, 4		    #usando o codigo SysCall para escrever strings
        syscall             #vai imprimir a mensagem que esta em $a0
        move $a0, $t2       #passa o indice i do vetor para $a0
        li $v0, 1		    #usando o codigo SysCall para escrever inteiro
        syscall             #vai imprimir o inteiro que esta em $a0
        la $a0, Ent2        #passando a mensagem que estava na memoria na variavel "Ent2" para o registrador de argumento $a0 (string a ser escrita)
        li $v0, 4		    #usando o codigo SysCall para escrever strings
        syscall             #vai imprimir a mensagem que esta em $a0
        li $v0, 6		    #usando o codigo SysCall para ler float
        syscall             #vai ler o float
        s.s $f0, ($t1)		#vai guardar o valor lido na posicao com endereço guardado em $t1
        addi $t1, $t1, 4	#vai ir para a proxima posicao do vetor
        addi $t2, $t2, 1	#vai incrementar o indice i
        blt $t2, $t3, l		#se o indice i for < que o tamanho do vetor, va para l novamente
        jr $ra              #vai retornar para a instrucao que chamou a funcao Leitura
        
    DescobreSegmento:
        move $t0, $a0		#passa o endereco do vetor para $t0
        move $t1, $t0		#passa o endereco do vetor para $t1
        move $t3, $s0		#tamanho do vetor em $t3
        li $t4, 0		    #Variável X (para verificação)
        li $t5, 0		    #Variável Y (para verificação)
        li $t6, 0		    #indice i
        l.s $f20, ($t0)		#maior = vet[0]
        l.s $f22, zero	    #soma = 0
        AnalisaValores:                         #vai procurar o segmento, considere que o segmento vai de X a Y
            beq $t5, $t3, RetornaSeg	        #se o indice Y == N va para RetornaSeg
            move $t6, $t5		                #indice i recebe indice Y
            ProcuraMaiorSoma:	
                mul $t1, $t6, 4		            #vai multiplicar o indice i por 4 para ter o endereço da posição do vetor
                add $t1, $t1, $t0	            #guarda em $t1 o valor ja em $t1 + o endereço base do vetor
                l.s $f4, ($t1)		            #guarda o float em $f4 na posicao do vetor de endereço $t1                               
                add.s $f22, $f22, $f4	        #guarda em $f22 a soma ja em $f22 + valor em $f4 
                addi $t6, $t6, 1	            #vai incrementar o indice i em 1
                blt $t6, $t4, ProcuraMaiorSoma	#se o indice i for < X, va para ProcuraMaiorSoma
                bne $t4, $t3, VerificaSoma	    #se X != N, va para VerificaSoma
                addi $t5, $t5, 1	            #vai incrementar o indice Y em 1
                move $t4, $t5		            #o indice X vai receber o indice Y
            VerificaSoma:	
                c.lt.s $f22, $f20	            #guarda o resultado boolean da condicao: soma < maior soma em $f20
                bc1t Reseta_ProxSegmento        #caso a condicao anterior for verdadeira, va para Reseta_ProxSegmento
                mov.s $f20, $f22	            #o maior soma ($f20) vai receber float em $f22
            Reseta_ProxSegmento:	
                l.s $f22, zero	                #vai reiniciar $f22 com 0.0
                addi $t4, $t4, 1	            #vai incrementar o indice X em 1
                j AnalisaValores			    #pula para AnalisaValores
            RetornaSeg:
                jr $ra			                #vai retornar para a instrucao que chamou a funcao DescobreSegmento
        
    ImprimeSomaSegmento:
        mov.s $f4, $f12		    #vai carregar a maior soma do segmento em $f4
        la $a0, segmentoSoma	#passando a mensagem que estava na memoria na variavel "segmentoSoma" para o registrador de argumento $a0 (string a ser escrita)
        li $v0, 4		        #usando o codigo SysCall para escrever strings
        syscall                 #vai imprimir a mensagem que esta em $a0
        mov.s $f12, $f4		    #vai carregar a maior soma do segmento em $f12
        li $v0, 2		        #codigo para imprimir float
        syscall                 #vai imprimir a maior soma
        jr $ra                  #vai retornar para a instrucao que chamou a funcao ImprimeSomaSegmento
	
    Erro:
        li $v0, 4               #usando o codigo SysCall para escrever strings      
        la $a0, msg_erro        #passando a mensagem que estava na memoria na variavel "msg_erro" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        jal N                   #vai pular para o bloco N novamente