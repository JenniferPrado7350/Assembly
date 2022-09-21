.data
string: .space 256
Entrada: .asciiz "Insira a string a ser verificada: "
SaidaNaoPalindromo: .asciiz "0 (Nao e Palindromo)"
SaidaPalindromo: .asciiz "1 (Palindromo)"

.text
main:
	la $a0, Entrada			                #vai carregar o endreço da string Entrada
	la $a1, string			                #vai carregar o endereco base da string
	jal LeituraString		                #chama a função LeituraString para ler a string
	la $a0, string			                #vai carregar o endereco base da string
	jal TamanhoString		                #vai verifica o tamanho da string de entrada
	move $s0, $v0			                #guarda o retorno da função em $s0
	la $a0, string 			                #vai carregar o endereco base da string
	move $a1, $s0			                #guarda em $a1 a quantidade de caracteres da string em $s0
	jal Verifica_Se_Palindromo		        #chama a funcao Verifica_Se_Palindromo para verificar se uma string e um Palindromo
	move $s1, $v0			                #guarda o retorno da funcao em $s1
	li $v0, 4			                    #codigo para escrever uma string
	beq $s1, 1, ImprimeSaidaPalindromo	    #se o valor em $s1(retorno da funcao Verifica_Se_Palindromo) for == 1, va para a funcao ImprimeSaidaPalindromo
	la $a0, SaidaNaoPalindromo		        #carrega em $a0 o endereco da string SaidaNaoPalindromo
	syscall                                 #imprime a string
    Finaliza:                               #função para encerrar a execução e finalizar o programa
        li $v0, 10                          #codigo para finalizar o programa
        syscall                             #finaliza o programa
        
    LeituraString:                          #funcao para receber a string
        li $v0, 4	                        #codigo para escrever string
        syscall                             #imprime a string
        move $a0, $a1	                    #carrega em $a0 o endereco da string
        li $a1, 64	                        #carrega $a1 com o numero de caracteres a serem lidos
        li $v0, 8	                        #codigo para ler string
        syscall                             #le a string inserida pelo usuario
        jr $ra		                        #retorna para a instrução que chamou a funcao LeituraString
        
    TamanhoString:                          #funcao para contar quantos caracteres tem na string
        move $t1, $a0		                #carrega em $t1 o endereco base da string
        la $t0, 0		                    #inicio $t0 com 0
        ContaCaracteres:	                #loop para contar quantos caracteres foram inseridos na string
            lb $t2, ($t1)		            #carrega em $t2 o conteudo armazenado no endereco de $t1
            beqz $t2, RetornaTamanhoString	#se o valor em $t2 for 0, va para RetornaTamanhoString 
            beq $t2, 10, ProximoCaractere	#se o valor em $t2 for 10, va para ProximoCaractere para ignorar a quebra de linha (\n)
            addi $t0, $t0, 1	            #vai incrementar o contador $t0
            ProximoCaractere:	            #funcao para ir para o proximo caractere
                addi $t1, $t1, 1	        #vai para o proximo caractere na string
                j ContaCaracteres			#vai pular para ContaCaracteres   
        RetornaTamanhoString:	            #funcao para retornar
            sub $v0, $t0, 1		            #vai decrementar em 1 o contador guardando o resultado em $v0
            jr $ra			                #retorna para a instrução que chamou a funcao TamanhoString
        
    Verifica_Se_Palindromo:                 #funcaao para verificar se a string e palindromo
        move $t0, $a0		                #carrega em $t0 o endereco base da string
        move $t1, $a1		                #carrega em $t1 o tamanho da string para
        add $t3, $t0, $t1	                #$t3 vai receber o endereco do ultimo caracter da string
        AnalisaCaracteres:	                #loop para verificar dois caractere por vez, comecando com o primeiro e o ultimo caractere
            lb $t5, ($t0)		            #carrega em $t5 o caractere no endereco $t0
            lb $t6, ($t3)		            #carrega em $t6 o caractere no endereco $t3
            addi $t0, $t0, 1	            #vai incrementar em 1 o endereco em $t0, vai para o proximo caractere
            subi $t3, $t3, 1	            #vai decrementar em 1 o endereco em $t3, vai para o caractere anterior
            bne $t5, $t6, Nao_E_Palindromo	#se o caractere em $t5 for != do caractere em $t6, va para Nao_E_Palindromo
            blt $t0, $t3, AnalisaCaracteres	#se endereco em $t0 for < que o endereco em $t3, va para AnalisaCaracteres novamente
        E_Palindromo:                       #se chegou aqui, a string e palindromo
            li $v0, 1		                #vai retornar 1, pois a string e Palindromo
            jr $ra                          #retorna para a instrução que chamou a funcao Verifica_Se_Palindromo
        Nao_E_Palindromo:	                #se chegou aqui, a string nao e palindromo
            li $v0, 0		                #vai retornar 0, pois a string nao e Palindromo
            jr $ra                          #retorna para a instrução que chamou a funcao Verifica_Se_Palindromo
        
    ImprimeSaidaPalindromo:	                #funcao para imprimir a string de retorno quando a string recebida e palindromo
        la $a0, SaidaPalindromo		        #carrega em $a0 o endereco da string SaidaPalindromo
        syscall                             #vai imprimir a string
        j Finaliza                          #vai pular para a funcao Finaliza