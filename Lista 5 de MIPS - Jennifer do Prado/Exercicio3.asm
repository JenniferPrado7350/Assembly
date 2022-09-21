.data
Ent1: .asciiz "Insira o valor de Mat["
Ent2: .asciiz "]["
Ent3: .asciiz "]: "
entradaN: .asciiz "Entre com o valor inteiro de N (0 < N < 9) que será a dimensão da matriz quadrada: "               
msg_erro: .asciiz "O valor digitado tem que ser inteiro maior que 0 e menor que 9. "  
resultado_subtracao: .asciiz "\n\nA subtração da somatória dos elementos acima da diagonal principal menos a somatória dos elementos abaixo da diagonal principal é: "
maior_elemento: .asciiz "\n\nO maior elemento acima da diagonal principal é: "
menor_elemento: .asciiz "\n\nO menor elemento abaixo da diagonal principal é: "
ordem_crescente: .asciiz "\n\nA matriz na ordem crescente:\n\n"


.text
main:  

    N: 
        li $v0, 4               #usando o codigo SysCall para escrever strings
        la $a0, entradaN        #passando a mensagem que estava na memoria na variavel "entradaN" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        li $v0, 5               #usando o codigo SysCall para ler inteiros
        syscall                 #o inteiro de entrada "N" foi lido e esta em $v0
        blt $v0, 1, Erro        #caso o valor digitado que esta no registrador de valor $v0 for menor que o inteiro "1", vai para Erro
        bgt	$v0, 8, Erro	    #caso o valor digitado que esta no registrador de valor $v0 for maior que o inteiro "8", vai para Erro
        add $s0, $v0, $zero     #guarda em $s0 o número digitado "N" que esta em $v0

    Estrutura:
        move $s1, $s0       #número de linhas
        move $s2, $s0       #número de colunas
        jal leitura         #le os elementos da matriz Mat
        move $a1, $v0       #Coloca o endereco da matriz Mat retornado da funcao "leitura" em $a1
        jal escrita         #escrita(Mat, nlin, ncol)
        move $a1, $v0       #Coloca o endereco da matriz Mat retornado da funcao "escrita" em $a1
        jal Verifica_Elementos   #vai para Verifica_Elementos
        move $a1, $v0       #Coloca o endereco da matriz Mat retornado da funcao "Verifica_Elementos" em $a1
        jal Ordena_Mat_Crescente #vai ordenar a matriz Mat
        move $a1, $v0       #Coloca o endereco da matriz Mat retornado da funcao "Ordena_Mat_Crescente" em $a1
        jal escrita         #escrita(Mat, nlin, ncol)
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
        move $a3, $a1    #aux = endereço base de mat
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

    Verifica_Elementos:  
        move $a3, $a1    #aux = endereço base de Mat    
        li $s3, 0        #inicio $s3 com 0, irá guardar o somatório dos elementos acima da diagonal principal
        li $s4, 0        #inicio $s4 com 0, irá guardar o somatório dos elementos abaixo da diagonal principal
        li $s6, 0        #inicio $s6 com 0, irá guardar o maior elemento acima da diagonal principal
        li $s7, 999999999        #inicio $s7 com 0, irá guardar o menor elemento abaixo da diagonal principal
        subi $sp, $sp, 4 #Espaço para 1 item na pilha
        sw $ra, ($sp)    #Salva o retorno para a main
    M:  jal indice       #calcula o endereço de Mat[i][j]
        lw $s5, ($v0)    #guardo em $s5 o valor de Mat[i][j]
        Somatorios_Acima_e_Abaixo_DiagP:
            beq	$t0, $t1, Continua	        #se $t0 == $t1 então é elemneto da diagonal principal, vá para Continua
                bgt	$t0, $t1, ElementoAbaixoDiagP	#se i > j então ElementoAbaixoDiagP
                    add $s3, $s3, $s5            #$s3 = $s3 + Mat[i][j], com i < j
                    Verifica_Maior_Elemento:
                    ble	$s5, $s6, Continua	#se $s5 <= $s6(se o elemento atual Mat[i][j] n for maior que o valor guardado em $s6) entao Continua
                        addi $s6, $s5, 0		#s6 = $s5 ($s6 recebe um novo "maior valor")           
                    j Continua
                ElementoAbaixoDiagP:
                    add $s4, $s4, $s5            #$s4 = $s4 + Mat[i][j], com i > j
                    bge	$s5, $s7, Continua	#se $s5 >= $s7(se o elemento atual Mat[i][j] n for menor que o valor guardado em $s7) entao Continua
                        addi $s7, $s5, 0		#s7 = $s5 ($s7 recebe um novo "menor valor") 
        Continua:
            addi $t1, $t1, 1            #j++
            blt $t1, $s2, M             #se (j < ncol) goto M
            li $t1, 0                   #j = 0
            addi $t0, $t0, 1            #i++
            blt $t0, $s1, M             #se (i < nlin) goto M
            li $t0, 0                   #i = 0
        Imprime_Resultado_Subtracao:
            la $a0, resultado_subtracao #carrega a informacao armazenada no endereco da string resultado_subtracao
            li $v0, 4                   #usando o codigo SysCall para escrever strings
            syscall                     #escrevendo a string
            sub	$s3, $s3, $s4		    #$s3 = $s3 - $s4
            move $a0, $s3               #passo para $a0 o valor em $s3
            li $v0, 1                   #codigo de impressão de inteiro
            syscall                     #imprime o resultado do contador
        Imprime_Maior_Elemento:
            la $a0, maior_elemento      #carrega a informacao armazenada no endereco da string maior_elemento
            li $v0, 4                   #usando o codigo SysCall para escrever strings
            syscall                     #escrevendo a string
            move $a0, $s6               #passo para $a0 o valor em $s6
            li $v0, 1                   #codigo de impressão de inteiro
            syscall                     #imprime o resultado do contador
        Imprime_Menor_Elemento:
            la $a0, menor_elemento      #carrega a informacao armazenada no endereco da string menor_elemento
            li $v0, 4                   #usando o codigo SysCall para escrever strings
            syscall                     #escrevendo a string
            move $a0, $s7               #passo para $a0 o valor em $s7
            li $v0, 1                   #codigo de impressão de inteiro
            syscall                     #imprime o resultado do contador
        Retorna:
            lw $ra, ($sp)    #recupera o retorno para a main
            addi $sp, $sp, 4 #libera o espaço na pilha
            move $v0, $a1    #devolve endereco de mat para retorno da funcao
            jr $ra           #retorna para a main

     Ordena_Mat_Crescente:
        move $a2, $a1                   #guarda o endereco base de mat em $a1
        mul $t3, $s0, $s0               #passando o tamanho N*N da matriz para registrador temporario $t3
        subi $t3, $t3, 1                #decrementando o valor de $t3(indice j) em 1 para iniciar o laco
        Percorre_Elemento1:             #é a primeira estrutura de repeticao for, funciona como: for(j = N-1 ; j>=1 ; j--)
            li $t2, 0                   #inicia o indice i da matriz com 0
            beq	$t2, $t3, Retorna_Ordena#se i == j entao va para a funcao Retorna_Ordena
            move $t5, $a2               #guarda o endereco de mat em $t5
            move $t4, $a2               #guarda o endereco de mat em $t4
            add $t4, $t4, 4             #o registrador temporario $t4 recebe o endereco de mat[i+1][j]
            Percorre_Elemento2:         #é a segunda estrutura de repeticao for, funciona como: for(i = 0 ; i<j ; i++)
                lw $t6, ($t5)           #o registrador $t6 recebe o valor armazenado no endereco $t5, ou seja, mat[i][j]
                lw $t7, ($t4)           #o registrador $t7 recebe o valor armazenado no endereco $t4, ou seja, mat[i][j+1]
                ble	$t6, $t7, Proximo_Laco	#se mat[i][j] <= mat[i][j+1] entao va para a funcao Proximo_Laco, pois não precisaremos trocar os numeros de lugar                 
                    sw $t7, ($t5)       #guarda o inteiro que estava em $t4(mat[i][j+1]) em $t5(mat[i][j])
                    sw $t6, ($t4)       #guarda o inteiro que estava em $t5(mat[i][j]) em $t4(mat[i][j+1])
           
               
                Proximo_Laco:
                    add $t5, $t5, 4      #o registrador temporario $t5 recebe o endereco de mat[i][j+1] ou mat[i+1][j0]
                    add $t4, $t4, 4      #o registrador temporario $t4 recebe o endereco de mat[i][j+2] ou mat[i+1][j0+1]
                    addi $t2, $t2, 1     #incrementa o indice j da matriz em 1
                    blt	$t2, $t3, Percorre_Elemento2	#se $t2 < $t3, ou seja, se i < j, então va para Percorre_Elemento2, pois não percorremos a matriz toda
                    
            subi $t3, $t3, 1             #decrementa uma posicao matriz
            bge $t3, 1, Percorre_Elemento1 # se j >= 1 va para a funcao Percorre_Elemento1
        Retorna_Ordena:
            la $a0, ordem_crescente      #carrega a informacao armazenada no endereco da string ordem_crescente
            li $v0, 4                    #usando o codigo SysCall para escrever strings
            syscall                      #escrevendo a string
            move $v0, $a1                #devolve endereco de mat para retorno da funcao
            jr $ra                       #retorna para a funcao main Estrutura

    Erro:
        li $v0, 4               # usando o codigo SysCall para escrever strings      
        la $a0, msg_erro        # passando a mensagem que estava na memoria na variavel "msg_erro" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 # vai imprimir a mensagem que esta em $a0
        jal N                   #vai pular para o bloco N novamente