.data
EntN: .asciiz "Entre com o valor inteiro positivo de N: "
EntP: 	.asciiz "Entre com o valor inteiro positivo de P: "
msg_erroN: .asciiz "O valor de N tem que ser inteiro maior que 0. "  
msg_erroP: .asciiz "O valor de P tem que ser inteiro maior que 0. "
saida:		.asciiz "\nO numero de arranjos e: "
erroArranjo: .asciiz "\nErro. Os valores de entrada sao invalidos para o calculo!"

.text

main:	
    N: 
        li $v0, 4               #usando o codigo SysCall para escrever strings
        la $a0, EntN            #passando a mensagem que estava na memoria na variavel "EntN" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        li $v0, 5               #usando o codigo SysCall para ler inteiros
        syscall                 #o inteiro de entrada "N" foi lido e esta em $v0
        blt $v0, 1, ErroN       #caso o valor digitado que esta no registrador de valor $v0 for menor que o inteiro "1", vai para ErroN
        add $t1, $v0, $zero     #guarda em $t1 o número digitado "N" que esta em $v0

    P: 
        li $v0, 4               #usando o codigo SysCall para escrever strings
        la $a0, EntP            #passando a mensagem que estava na memoria na variavel "EntP" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        li $v0, 5               #usando o codigo SysCall para ler inteiros
        syscall                 #o inteiro de entrada "P" foi lido e esta em $v0
        blt $v0, 1, ErroP       #caso o valor digitado que esta no registrador de valor $v0 for menor que o inteiro "1", vai para ErroP
        add $t2, $v0, $zero     #guarda em $t2 o número digitado "P" que esta em $v0


    Estrutura:
		move $a0, $t1		#vai mover para $a0 o valor N em $t1
		move $a1, $t2		#vai mover para $a1 o valor P em $t2
		jal CalculaArranjo	#pula para a funcao CalculaArranjo
		move $a0, $v0		#vai mover para $a0 o retorno da funcao CalculaArranjo em $v0
		jal ImprimeArranjo	#pula para a funcao ImprimeArranjo
		li $v0, 10		    #código para finalizar o programa
		syscall			    #vai finalizar o programa
		

    CalculaArranjo:	
        sw $ra, ($sp)		                #carrega o retorno para a main na stack
		bge $a1, $a0, RetornaErroArranjo    #se o valor de P for >= valor de N, va para RetornaErroArranjo
		jal CalculaFatorial		            #pula para a funcao CalculaFatorial
		move $s2, $v0		                #move para $s2 o retorno da funcao CalculaFatorial, ou seja, n!
		sub $a0, $a0, $a1 	                #subtrai em $a0(N) o valor em $a1(P), ou seja, n - p
        beq $a0, 1, RetornaCalculaArranjo   #se N-P for == a 1, significa que o fatorial do divisor sera 1 tambem, entao nao precisa dividir N!, va para RetornaCalculaArranjo
		jal CalculaFatorial		            #pula para a funcao CalculaFatorial
		move $s1, $v0		                #move para $s1 o retorno da funcao CalculaFatorial, ou seja, (n-p)!
		div $v0, $s2, $s1	                #vai dividir o fatorial de N pelo fatorial de N-P, ou seja, (n)! / (n-p)!
		j RetornaCalculaArranjo             #pula para a funcao RetornaCalculaArranjo
        RetornaErroArranjo:		
            li $v0, -1		                #carrega em $v0 o valor -1 para indicar que apresentou erros
        RetornaCalculaArranjo:
            lw $ra, ($sp)		            #vai recuperar o retorno para a main na stack
            jr $ra			                #vai retornar para a instrucao que chamou a funcao CalculaArranjo				
		

    CalculaFatorial:	
        move $t4, $a0		                    #move para $t4 o numero X para calculo do fatorial
		li $v0, 0		                        #inicia $v0 com 0
		subi $t4, $t4, 1	                    #decrementa em 1 o valor em $t4
		mul $v0, $a0, $t4	                    #guarda em $v0 a multiplicacao do valor X em $a0 * valor em $t4
        Fatorial:	        
            subi $t4, $t4, 1	                #decrementa em 1 o valor em $t4
            beq $t4, 0, RetornaCalculaFatorial	#se o valor em $t4 for == a 0, va para RetornaCalculaFatorial, pois ja fanalizou o calculo do fatorial
            mul $v0, $v0, $t4	                #senao, o valor ja em $v0 sera multiplicado pelo valor em $t4
            j Fatorial			                #pula para a funcao Fatorial
    RetornaCalculaFatorial:		
        jr $ra			                        #vai retornar para a instrucao que chamou a funcao CalculaFatorial	


    ImprimeArranjo:	
        move $t4, $a0		        #vai mover para $t4 o numero de arranjos, ou -1 caso apresentar erro
        beq $t4, -1, ErroNoArranjo  #se o valor em $t4 for -1, o calculo apresentou erro, va para ErroNoArranjo
		la $a0, saida		        #passando a mensagem que estava na memoria na variavel "saida" para o registrador de argumento $a0 (string a ser escrita)
		li $v0, 4		            #usando o codigo SysCall para escrever strings
		syscall			            #vai imprimir a mensagem que esta em $a0
		move $a0, $t4		        #vai mover para $a0 o numero de arranjos em $t4
		li $v0, 1		            #usando o codigo SysCall para escrever inteiro
		syscall			            #vai imprimir o numero de arranjos
        RetornaImpressao:
		    jr $ra			        #vai retornar para a instrucao que chamou a funcao ImprimeArranjo


    ErroNoArranjo:
        la $a0, erroArranjo		#passando a mensagem que estava na memoria na variavel "erroArranjo" para o registrador de argumento $a0 (string a ser escrita) 
		li $v0, 4		        #usando o codigo SysCall para escrever strings
		syscall			        #vai imprimir a mensagem que esta em $a0
        j RetornaImpressao      #pula para a funcao RetornaImpressao


    ErroN:
        li $v0, 4               #usando o codigo SysCall para escrever strings      
        la $a0, msg_erroN       #passando a mensagem que estava na memoria na variavel "msg_erroN" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        j N                   	#vai pular para o bloco N novamente

    ErroP:
        li $v0, 4               #usando o codigo SysCall para escrever strings      
        la $a0, msg_erroP       #passando a mensagem que estava na memoria na variavel "msg_erroP" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        j P                   	#vai pular para o bloco P novamente
		