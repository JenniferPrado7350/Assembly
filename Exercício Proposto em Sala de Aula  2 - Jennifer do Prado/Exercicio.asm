.data
 buffer: .asciiz " "
 Arquivo: .asciiz "data.txt"
 Resultado: .asciiz "\n\nResultado Soma: "
 Erro: .asciiz "Arquivo não encontrado!\n"
 .text
 main:
 	la $a0, Arquivo # Nome do arquivo
 	li $a1, 0 # Somente leitura
 	li $s2, 0 # inicio o somatório final com 0
 	li $s3, 0 # inicio o somatório para os numeros
 	jal abertura # Retorna file descriptor no sucesso
 	move $s0, $v0 # Salva o file descriptor em $s0
 	jal Leitura # Retorna em $v0 o num. de carac.
 	la $a0, Resultado  #carrega a informacao armazenada no endereco da string Resultado
        li $v0, 4            #usando o codigo SysCall para escrever strings
        syscall              #escrevendo a string
 	move $a0, $s2
 	li $v0, 1
 	syscall
 	li $v0, 16 # Código para fechar o arquivo
 	move $a0, $s0 # Parâmetro file descriptor
	syscall # Fecha o arquivo
 	li $v0, 10 # Código para finalizar o programa
 	syscall # Finaliza o programa
 	
 	
 	
 Leitura:
 	move $a0, $s0 # Parâmetro file descriptor
 	la $a1, buffer # Buffer de entrada
 	li $a2, 1 # 1 caractere por leitura
 	li $v0, 14 	#Código de leitura de arquivo
 	syscall 	#Faz a leitura de 1 caractere
 	beqz $v0, Saida # if(ch != EOF) goto contagem
 	move $a0, $a1  #recebe o caractere lido
    	li $v0, 4      #codigo de impressão de caractere
    	syscall        #imprime o espaço
    	lb $t1, ($a1)    #passo o valor lido pata $t1
    	subi $t1, $t1, 48  #converto em int
    	li $s1, -16     # 32(ASCII do espaço) - 48 = -16
    	bne $t1, $s1, Multiplica #se o valor lido não for o espaço vá para Multiplica
    	beq $t1, $s1, Divide     #se for o espaço precisamos dividir o numero por 10, pois multiplicamos devido ao ultimo numero
    	j Leitura
 	Saida:
 		div $s3, $s3, 10    #divido por 10 caso tenha apenas um numero entre os espaços ou caso o caractere seja o ultimo da sequencia
 		add $s2, $s2, $s3    #realizo a soma dos numeros ja convertidos em int e como unidade, dezena, centena, etc
 		move $v0, $t0 # Move o resultado para retorno
 		jr $ra # Retorna para a main
 		
 Multiplica:
 	add $s3, $s3, $t1    #adiciono o(s) numero(s) entre os espaços
 	mul $s3, $s3, 10     #multiplico por 10 para aumentar uma  casa numerica (dezena, centena, milhar...)
 	j Leitura	
 	
 Divide:
 	div $s3, $s3, 10    #divido por 10 caso tenha apenas um numero entre os espaços ou caso o caractere seja o ultimo da sequencia
 	add $s2, $s2, $s3    #realizo a soma dos numeros ja convertidos em int e como unidade, dezena, centena, etc
 	li $s3, 0
 	j Leitura	
 	
 abertura:
 	li $v0, 13 # Código de abertura de arquivo
 	syscall # Tenta abrir o arquivo
 	bgez $v0, a # if(file_descriptor >= 0) goto a
 	la $a0, Erro # else erro: carrega o endereço da string
 	li $v0, 4 # Código de impressão de string
 	syscall # Imprime o erro
 	li $v0, 10 # Código para finalizar o programa
 	syscall # Finaliza o programa
 	a: jr $ra # Retorna para a main

        
