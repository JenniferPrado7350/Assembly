.data
entrada: .asciiz "Entre com o valor inteiro de N (N >= 3): "
Arquivo: .asciiz "PrimosGemeos.txt"
buffer: .asciiz " "
Erro: .asciiz "Arquivo texto nao encontrado!\n"

.text
main:
    la $a0, Arquivo #vai carrega o nome do arquivo
    li $a1, 1       #somente escrita
    jal abertura    #abre o arquivo de nome guardado em "Arquivo" ou cria caso não exista
    move $s0, $v0   #parâmetro file descriptor
    la $a0, entrada #passando a string em entrada para $a0
    li $v0, 4       #vai imprimir a string em $a0
    syscall         #imprime a string
    li $v0, 5       #codigo para ler inteiro
    syscall         #le o inteiro
    blt $v0, 3, finaliza    #se N < 3 vá para finaliza, pois não há primo abaixo de 3 que é gemeo
    subi $sp, $sp, 4        #espaco para 1 item na pilha
    sw $v0, ($sp)           #guardo o valor N lido na pilha
    move $a0, $v0           #N sera parametro para o Metodo_Criva
    jal Metodo_Criva        #vamos chamar o Metodo de Criva de erastotenes
    move $a0, $v0           #passo o endereço do vetor de primos
    lw $a1, ($sp)           #passo o valor de N que estava guardado na pilha para $a1
    addi $sp, $sp, 4        #libera 1 espaco da pilha
    jal PrimosGemeos        #vai verificar quais primos são gemeos
    finaliza:
        move $a0, $s0       #file descriptor
        li $v0, 16          #codigo para fechar um arquivo
        syscall             #fecha o arquivo
        li $v0, 10          #codigo para finalizar o programa
        syscall             #finaliza o programa   
    
    Metodo_Criva:
        move $a3, $a0       #passo o valor de N em $a0 para $a3
        addi $a0, $a0, 3    #incremento N em 3, ou seja, N = N + 3
        sll $a0, $a0, 2     #N = N * 4
        li $v0, 9           #codigo para alocacao dinamica
        syscall             #alocação de um vetor com N + 1 posições
        addi $a3, $a3, 2    #acrescento 2 ao valor de N em $a3 para verificaar se N é primo gemeo
        move $s2, $v0       #passo o endereço do vetor para $s2
        li $t5, 1           #passo o 1 que é uma não primo para $t5
        sw $t5, ($s2)       #guardo o valor 1 em $t5 em vet[0]
        sw $t5, 4($s2)      #guardo o valor 1 em $t5 em vet[1]
        addi $s2, $s2, 8    #vou para a posição vet[2]
        li $s1, 2           #inicio $s2 com 2
        mul $t1, $s1, $s1   #$t1 recebe produto de $s1 por $s1
        Verifica_Primos_Vet:
            lw $t3, ($s2)               #$t3 recebe vetPrimos[p]
            bnez $t3, Metodo_Criva_prox #se vetPrimos[p] != 0 va para Metodo_Criva_prox
            move $t3, $t1               #$t3 recebe valor em $t1
            Laco_Verifica_Primos_Vet:
                bgt $t3, $a3, Metodo_Criva_prox #se $t3 > $a3 va para Metodo_Criva_prox
                sll $t4, $t3, 2                 #$t4 recebe valor em $t3 * 4
                add $t4, $t4, $v0               #$t4 recebe valor em $t4 + endereço inicial do vetor
                sw $t5, ($t4)                   #carrego valor de $t5 em $t4, ou seja, vetPrimos[i] = 1
                add $t3, $t3, $s1               #$t3 recebe $t3 + valor em $s1
                j Laco_Verifica_Primos_Vet      #repita Laco_Verifica_Primos_Vet
            Metodo_Criva_prox:
                addi $s1, $s1, 1                    #incremento $s1 em 1
                addi $s2, $s2, 4                    #vou para a proxima posição do vetor
                mul $t1, $s1, $s1                   #$t1 recebe produto de $s1 por $s1
                ble $t1, $a3, Verifica_Primos_Vet   #se $t1 <= $a3 repita Verifica_Primos_Vet
                jr $ra                              #retorna para a linha que chamou esta função
        
        
    PrimosGemeos:
        subi $sp, $sp, 4        #espaço para 1 item na pilha
        sw $ra, ($sp)           #guardo o retorno da função na pilha
        li $s1, 2               #inicio $s1 com 2
        addi $a0, $a0, 8        #endereço da posição inicial do vetor mais 8
        VerificaPrimosGemeos:
            addi $t1, $s1, 2                    #$t1 recebe valor em $s1 + 2, ou seja, i + 2
            bgt $s1, $a1, FinalizaPrimosGemeos  #se i($s1) > N vá para FinalizaPrimosGemeos
            lw $s2, ($a0)                       #carrego em $s2 o endereço do vetor na posição 2, vetPrimos[i]
            bnez $s2, ProximoPrimosGemeos       #se $s2 != 0 vá para ProximoPrimosGemeos
            addi $t1, $a0, 8                    #vamos para 2 posições a frente no vetor de primos, vetPrimos[i+2]
            lw $s2, ($t1)                       #carrego em $s2 o endereço da posição do vetor guardada em $t1, vetPrimos[j+2]
            bnez $s2, ProximoPrimosGemeos       #se $s2 != 0 vá para ProximoPrimosGemeos
            subi $sp, $sp, 4                    #espaco para 1 item na pilha
            sw $a0, ($sp)                       #guardo o endereco da posição do vetor na pilha
            subi $sp, $sp, 4                    #espaco para 1 item na pilha
            sw $a1, ($sp)                       #guardo o valor de N na pilha
            subi $sp, $sp, 4                    #espaco para 1 item na pilha
            sw $s1, ($sp)                       #guardo o valor de i($s1) na pilha
            move $a0, $s1                       #move valor de i em $s1 para $a0
            move $a1, $s0                       #passo o file descriptor como argumento
            jal ImprimeNumero                   #vai imprimir o numero no arquivo texto
            lw $s1, ($sp)                       #irá recuperar o valor de i da pilha
            addi $sp, $sp, 4                    #vai liberar o espaco na pilha
            lw $a1, ($sp)                       #irá recuperar o valor de N da pilha
            addi $sp, $sp, 4                    #vai liberae o espaco na pilha
            lw $a0, ($sp)                       #irá recuperar o endereco do vetor da pilha
            addi $sp, $sp, 4                    #vai liberar o espaco na pilha
            ProximoPrimosGemeos:
                addi $s1, $s1, 1                #incremento o valor de i
                addi $a0, $a0, 4                #vai para a proxima posição do vetor
                j VerificaPrimosGemeos          #pula para VerificaPrimosGemeos
        FinalizaPrimosGemeos:
            lw $ra, ($sp)           #vai recuperar o endereco de retorno da função na pilha
            addi $sp, $sp, 4        #irá liberar o espaco na pilha
            jr $ra                  #retorna para a função que chamou

    ImprimeNumero:
        move $a3, $a0                   #passo o numero que será impresso para $a3
        move $a0, $a1                   #carrego o file descriptor em $a0
        la $a1, buffer                  #carrego o buffer em $a1
        li $a2, 1                       #imprimir apenas um caractere
        bnez $a3, NumeroDiferenteDeZero #se o numero que for ser impresso for != de 0 vá para NumeroDiferenteDeZero
        li $v0, 15                      #codigo para escrever caractere
        li $s1, '0'                     #vai escrever o caractere 0
        sb $s1, ($a1)                   #vai armazenar o caractere 0 no buffer de escrita
        syscall                         #escreve o caractere no arquivo
        jr $ra                          #retorna para a função que a chamou

    NumeroDiferenteDeZero:
        li $s1, 0                   #inicio $s1 com 0
        li $s2, 10                  #inicio $s2 com 10
        bgtz $a3, IteracaoNumero    #se o numero for > 0 vá para IteracaoNumero
        li $t1, '-'                 #carrego o caractere - em $t1
        sb $t1, ($a1)               #amazeno este caractere no buffer de escrita
        li $v0, 15                  #codigo para escrever caractere
        syscall                     #escreve o caractere no arquivo
        mul $a3, $a3, -1            #multiplico valor em $a3 por -1
    IteracaoNumero: 
        subi $sp, $sp, 1            #espaco para 1 caractere na pilha
        addi $s1, $s1, 1            #incremento valor em $s1 com 1
        div $a3, $s2                #divido o numero por 10
        mfhi $t1                    #$t1 irá guardar o caractere de resto da divisão
        addi $t1, $t1, '0'          #adiciono ao caractere $t1 o caractere 0
        sb $t1, ($sp)               #guardo o caractere em $t1 na pilha
        mflo $a3                    #guardo em $a3 a parte inteira da divisão
        bgtz $a3, IteracaoNumero    #se o numero for > 0 vá para IteracaoNumero
    EscreveNumero:
        lb $t1, ($sp)               #vai carregar o caractere da pilha
        sb $t1, ($a1)               #irá armazenar o valor em $t1 no buffer de escrita
        li $v0, 15                  #codigo para escrever caractere
        syscall                     #escreve no arquivo o caractere
        addi $sp, $sp, 1            #irá liberar um espaco na pilha
        subi $s1, $s1, 1            #decremento o digito($s1) em 1
        bgtz $s1, EscreveNumero     #se o digito em $s1 for > 0 vá para EscreveNumero
        li $t1, ' '                 #carrego o espaço em $t1
        sb $t1, ($a1)               #armazeno o espaço no buffer de escrita
        li $v0, 15                  #codigo para escrever caractere
        syscall                     #vai escrever o caractere no arquivo
        jr $ra                      #retorna para a função que a chamou

    abertura:
        li $v0, 13                  #codigo para leitura de arquivo
        syscall                     #vai tenta abrir arquivo
        bgez $v0, RetornaAbertura   #se o file_descriptor for >= 0 vá para RetornaAbertura
        la $a0, Erro                #se não for, carrega a string em Erro
        li $v0, 4                   #codigo para impressao de string
        syscall                     #vai Imprimir a string Erro
        li $v0, 10                  #codigo para finalizar o programa
        syscall                     #vai finalizar o programa
        RetornaAbertura:  
            jr $ra                  #Retorna para a função que chamou "abertura"