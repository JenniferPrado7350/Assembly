.data
entradaK: .asciiz "\nEntre com o valor inteiro de K (0 <= K):"
entradaN: .asciiz "\nEntre com o valor inteiro de N (0 <= N):"
resultadoPotencia: .asciiz "\nO valor de 'K' elevado a 'n' e: "
msg_erro: .asciiz "O valor digitado tem que ser inteiro maior ou igual a 0.\n"

.text
main:		
	K: 
        li $v0, 4               #usando o codigo SysCall para escrever strings
        la $a0, entradaK        #passando a mensagem que estava na memoria na variavel "entradaK" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        li $v0, 5               #usando o codigo SysCall para ler inteiros
        syscall                 #o inteiro de entrada "K" foi lido e esta em $v0
        bge $v0, 0, ContinuaK   #caso o valor digitado que esta no registrador de valor $v0 for >= que o inteiro "1", vai para ContinuaK
		jal Erro				#se chegou aqui, o k é < 1, entao pula para Erro
		j K						#inicia o bloco K novamente
		ContinuaK:
        	add $s0, $v0, $zero #guarda em $s0 o número digitado "K" que esta em $v0
	
	N: 
        li $v0, 4               #usando o codigo SysCall para escrever strings
        la $a0, entradaN        #passando a mensagem que estava na memoria na variavel "entradaN" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        li $v0, 5               #usando o codigo SysCall para ler inteiros
        syscall                 #o inteiro de entrada "N" foi lido e esta em $v0
        bge $v0, 0, ContinuaN   #caso o valor digitado que esta no registrador de valor $v0 for >= que o inteiro "1", vai para ContinuaN
		jal Erro				#se chegou aqui, o N é < 1, entao pula para Erro
		j N						#inicia o bloco N novamente
		ContinuaN:
        	add $s1, $v0, $zero #guarda em $s1 o número digitado "N" que esta em $v0
	

	Estrutura:
		la $a0, resultadoPotencia	#passando a mensagem que estava na memoria na variavel "resultadoPotencia" para o registrador de argumento $a0 (string a ser escrita)
		li $v0, 4					#usando o codigo SysCall para escrever strings
		syscall						#vai imprimir a mensagem que esta em $a0
		jal Potencia				#pula para Potencia, vai calcular a potencia K^n
		li $v0, 1					#usando o codigo SysCall para escrever inteiro
		syscall						#vai imprimir a potencia calculada que esta em $a0
		li $v0, 10					#codigo para finalizar o programa
		syscall						#finaliza o programa


	Potencia:
		li $t0, 1							#inicia $t0 com 1, ira incrementar n auxiliar ate chegar em N digitado pelo usuario
		li $a0, 1							#inicia $a0 com 1, ira guardar a potencia
		beqz $s1, RetornaPotencia			#caso o N digitado pelo usuario for == 0, va para RetornaPotencia, pois a potencia sera 1
		move $a0, $s0						#passa para $a0 o valor de K, para inicia-lo antes da multiplicacao		
		MultiplicaK_Por_K:
			beq $t0, $s1, RetornaPotencia	#caso o valor n auxiliar for == N, significa que ja calculou a potencia, va para RetornaPotencia
			mul $a0, $a0, $s0				#guarda em a0 a multiplicacao do valor ja em $a0 por K em $s0
			addi $t0, $t0, 1				#incrementa o indice i
			j MultiplicaK_Por_K				#pula para MultiplicaK_Por_K novamente
		RetornaPotencia: 
			jr $ra
	
	Erro:
        li $v0, 4               #usando o codigo SysCall para escrever strings      
        la $a0, msg_erro        #passando a mensagem que estava na memoria na variavel "msg_erro" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        jr $ra                  #vai pular para o bloco que o chamou