.data
entradaA: .asciiz "\n\nMatA\n"                            #criando uma variavel na memoria que ira guardar o texto de entrada de MatA
entradaB: .asciiz "\n\nMatB\n"                            #criando uma variavel na memoria que ira guardar o texto de entrada de MatB
Ent1: .asciiz "Insira o valor de Mat["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "
entradaN: .asciiz "Entre com o valor inteiro de N (0 < N < 7) que será a dimensão da matriz quadrada: "               
msg_erro: .asciiz "O valor digitado tem que ser inteiro maior que 0 e menor que 7. "  
qtd_Valores_Iguais: .asciiz "\n\nA quantidade de valores iguais que estão na mesma posição em ambas as matrizes é: "
soma_Posicoes: .asciiz "\n\nA soma das posições (i linha + j coluna, com i e j iniciando com 0) de todos os elementos iguais que estão na mesma posição é: "

.text
main:  

    N: 
        li $v0, 4               #usando o codigo SysCall para escrever strings
        la $a0, entradaN        #passando a mensagem que estava na memoria na variavel "entradaN" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        li $v0, 5               #usando o codigo SysCall para ler inteiros
        syscall                 #o inteiro de entrada "N" foi lido e esta em $v0
        blt $v0, 1, Erro        #caso o valor digitado que esta no registrador de valor $v0 for menor que o inteiro "1", vai para Erro
        bgt	$v0, 6, Erro	    #caso o valor digitado que esta no registrador de valor $v0 for maior que o inteiro "6", vai para Erro
        add $s0, $v0, $zero     #guarda em $s0 o número digitado "N" que esta em $v0

    Estrutura:
        move $s1, $s0       #número de linhas
        move $s2, $s0       #número de colunas
        la $a0, entradaA    #carrega a informacao armazenada no endereco da string entradaA
        li $v0, 4           #usando o codigo SysCall para escrever strings
        syscall             #escrevendo a string
        jal leitura         #le os elementos da matriz MatA
        move $a1, $v0       #Coloca o endereco da matriz MatA retornado da funcao "leitura" em $a1
        la $a0, entradaB    #carrega a informacao armazenada no endereco da string entradaB
        li $v0, 4           #usando o codigo SysCall para escrever strings
        syscall             #escrevendo a string
        jal leitura         #le os elementos da matriz MatB
        move $a2, $v0       #Coloca o endereco da matriz MatB retornado da funcao "leitura" em $a2
        la $a0, entradaA    #carrega a informacao armazenada no endereco da string entradaA
        li $v0, 4           #usando o codigo SysCall para escrever strings
        syscall             #escrevendo a string
        move $a0, $a1       #Endereço da matriz MatA lida
        jal escrita         #escrita(MatA, nlin, ncol)
        la $a0, entradaB    #carrega a informacao armazenada no endereco da string entradaB
        li $v0, 4           #usando o codigo SysCall para escrever strings
        syscall             #escrevendo a string
        move $a0, $a2       #Endereço da matriz MatB lida
        jal escrita         #escrita(MatB, nlin, ncol)
        jal Qtd_Valores_Iguais_e_Soma_Posicoes   #vai para Qtd_Valores_Iguais_e_Soma_Posicoes
        li $v0, 10          #codigo para finalizar o programa
        syscall             #finaliza o programa

    indice:
        mul $v0, $t0, $s2 #i * ncol
        add $v0, $v0, $t1 #(i * ncol) + j
        sll $v0, $v0, 2   #[(i * ncol) + j] * 4 (inteiro)
        add $v0, $v0, $a3 # soma o endereço base de mat
        jr $ra            #retorna para o caller

    leitura:
        mul $s3, $s0, 4      #guardando em $s3 N*4 bytes
        mul $s3, $s3, $s0    #guardando em $s3 N*(N*4) bytes, ja que vamos alocar uma matriz N*N
        move $a0, $s3        #passando N*(N*4) bytes guardados em $s3 para o registrador de argumento $a0
        li $v0, 9            #codigo de alocação dinamica help
        syscall              #aloca N*(N*4) bytes (endereço em $v0)
        move $a3, $v0        #move para $a3
        subi $sp, $sp, 4     #Espaço para 1 item na pilha
        sw $ra, ($sp)        #salva o retorno para a main
    l:  la $a0, Ent1         #Carrega o endereço da String
        li $v0, 4            #Codigo de impressão da string
        syscall              #imprime a string
        move $a0, $t0        #valor de i para a impressão
        li $v0, 1            #codigo de impressão de inteiro
        syscall              #imprime i
        la $a0, Ent2         #Carrega o endereco da string
        li $v0, 4            #codigo de impressão de string
        syscall              #imprime a string
        move $a0, $t1        #valor de j para a impressão
        li $v0, 1            #codigo de impressão de inteiro
        syscall              #imprime j
        la $a0, Ent3         #carrega o endereço da string
        li $v0, 4            #Codigo de impressão da string
        syscall              #imprime a string
        li $v0, 5            #codigo de leitura de inteiro
        syscall              #leitura do valor (retorna em $v0)
        move $s3, $v0        #aux = valor lido
        jal indice           #calcula o endereço de mat[i][j]
        sw $s3, ($v0)        #mat [i][j] = aux
        addi $t1, $t1, 1     #j++
        blt $t1, $s2, l      #se (j < ncol) goto l
        li $t1, 0            #j = 0
        addi $t0, $t0, 1     #i++
        blt $t0, $s1, l      #se (i < nlin) goto l
        li $t0, 0            #i = 0
        lw $ra, ($sp)        #recupera o retorno para a main
        addi $sp, $sp, 4     #libera o espaço na pilha
        move $v0, $a3        #Endereço base da matriz para retorno
        jr $ra               #Retorna para a main

    escrita:
        subi $sp, $sp, 4 #Espaço para 1 item na pilha
        sw $ra, ($sp)    #Salva o retorno para a main
        move $a3, $a0    #aux = endereço base de mat
    e:  jal indice       #calcula o endereço de mat[i][j]
        lw $a0, ($v0)    #valor em mat[i][j]
        li $v0, 1        #codigo de impressão de inteiro
        syscall          #imprime [i][j]
        la $a0, 32       #codigo ASCII para espaço
        li $v0, 11       #codigo de impressão de caractere
        syscall          #imprime o espaço
        addi $t1, $t1, 1 #j++
        blt $t1, $s2, e  #se (j < ncol) goto e
        la $a0, 10       #codigo ASCII parea newline ('\n')
        syscall          #pula a linha
        li $t1, 0        #j = 0
        addi $t0, $t0, 1 #i++
        blt $t0, $s1, e  #se (i < nlin) goto e
        li $t0, 0        #i = 0
        lw $ra, ($sp)    #recupera o retorno para a main
        addi $sp, $sp, 4 #libera o espaço na pilha
        move $v0, $a3    #endereço base da matriz para retorno
        jr $ra           #retorna para a main

     Qtd_Valores_Iguais_e_Soma_Posicoes:      
        li $s3, 0        #inicio $s3 com 0, irá contar quantos valores iguais estão na mesma posição em ambas as matrizes
        li $s6, 0        #inicio $s6 com 0, será a soma das posições(linha+coluna) de todos os elementos iguais que estão na mesma posição
        subi $sp, $sp, 4 #Espaço para 1 item na pilha
        sw $ra, ($sp)    #Salva o retorno para a main
    M:  move $a3, $a1    #aux = endereço base de MatA
        jal indice       #calcula o endereço de MatA[i][j]
        lw $s4, ($v0)    #guardo em $s4 o valor de MatA[i][j]
        move $a3, $a2    #aux = endereço base de MatB
        jal indice       #calcula o endereço de MatB[i][j]
        lw $s5, ($v0)    #guardo em $s5 o valor de MatB[i][j]
        bne	$s4, $s5, Continua	        #se $s4 != $s5 então Continua
            addi $s3, $s3, 1            #$s3 = $s3 + 1
            add $s6, $s6, $t0          #$s6 = $s6 + i
            add $s6, $s6, $t1          #$s6 = $s6 + j
        Continua:
            addi $t1, $t1, 1            #j++
            blt $t1, $s2, M             #se (j < ncol) goto M
            li $t1, 0                   #j = 0
            addi $t0, $t0, 1            #i++
            blt $t0, $s1, M             #se (i < nlin) goto M
            li $t0, 0                   #i = 0
        Imprime_Qtd_Valores_Iguais:
            la $a0, qtd_Valores_Iguais  #carrega a informacao armazenada no endereco da string qtd_Valores_Iguais
            li $v0, 4                   #usando o codigo SysCall para escrever strings
            syscall                     #escrevendo a string
            move $a0, $s3               #passo para $a0 o valor em $s3
            li $v0, 1                   #codigo de impressão de inteiro
            syscall                     #imprime o resultado do contador
        Imprime_Soma_Posicoes:
            la $a0, soma_Posicoes       #carrega a informacao armazenada no endereco da string soma_Posicoes
            li $v0, 4                   #usando o codigo SysCall para escrever strings
            syscall                     #escrevendo a string
            move $a0, $s6               #passo para $a0 o valor em $s6
            li $v0, 1                   #codigo de impressão de inteiro
            syscall                     #imprime o resultado do contador
        Retorna:
            lw $ra, ($sp)    #recupera o retorno para a main
            addi $sp, $sp, 4 #libera o espaço na pilha
            jr $ra           #retorna para a main

    Erro:
        li $v0, 4               # usando o codigo SysCall para escrever strings      
        la $a0, msg_erro        # passando a mensagem que estava na memoria na variavel "msg_erro" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 # vai imprimir a mensagem que esta em $a0
        jal N                   #vai pular para o bloco N novamente