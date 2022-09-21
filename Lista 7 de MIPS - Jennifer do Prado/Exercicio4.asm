.data
ArqEntrada: .asciiz "matriz.txt"
ArqSaida: .asciiz "matriz saida.txt"
Buffer: .asciiz " "
Erro: .asciiz "Arquivo texto nao encontrado!\n"
Zero: .asciiz "0 "
Um: .asciiz "1 "
NovaLinha: .asciiz "\r\n"

.text
main:
    la $a0, ArqEntrada      #carrego em $a0 a string ArqEntrada
    li $a1, 0               #modo de leitura
    jal abertura            #pulo para abertura
    move $s0, $v0           #carrego em $s0 o file descriptor
    la $a0, ArqSaida        #carrego em $a0 a string ArqSaida
    li $a1, 1               #modo de  escrita
    jal abertura            #pulo para a funcao abertura
    move $s4, $v0           #carrego em $s4 o file descriptor
    jal LeituraArqEntrada   #pulo para a funcao LeituraArqEntrada
    jal EscritaArqSaida     #pulo para a funcao EscritaArqSaida
    li $v0, 10              #codigo para finalizar o programa
    syscall                 #finaliza o programa


    LeituraArqEntrada:
        subi $sp, $sp, 4        #vai disponibilizar espaço para 1 item na pilha
        sw $ra, ($sp)           #carrega na pilha o endereco de retorno
        move $a0, $s0           #passo para $a0 o file descriptor
        jal EntradaParametro    #le quantidade de linhas da matriz
        move $s2, $v0           #passo valor lido para $s2
        jal EntradaParametro    #le quantidade de colunas da matriz
        move $s3, $v0           #passo valor lido para $s3
        mul $a0, $s2, $s3       #guardo em $a0 o tamanho da matriz(linhas * colunas)
        li $v0, 9               #codigo para alocacao dinamica
        syscall                 #vai alocar a matriz com base no tamanho em $a0
        move $s1, $v0           #passo o endereço base da matriz para $s1
        move $a0, $s0           #carrego em $a0 o file descriptor
        jal EntradaParametro    #leio a quantidade de posições que serão nulas
        move $t3, $v0           #carrego o valor lido em $t3
        li $t4, 0               #inicio $t4 com 0, irá contabilizar quantas posições eu já li
        LeituraPosicoes:
            bge $t4, $t3, FinalizaLeitura   #se i(verificador de quantas posições eu li) >= nposicoes(quantidade total de posições que devo ler) vá para FinalizaLeitura
            subi $sp, $sp, 4                #vai disponibilizar espaço para 1 item na pilha
            sw $t4, ($sp)                   #carrega na pilha o valor de i
            jal EntradaParametro            #vai ler a linha da posição a ser anulada
            mul $t1, $v0, $s3               #guardo em $t1 a multiplicação da quantidade total de colunas da matriz * a linha da posição
            jal EntradaParametro            #vai ler a coluna da posição a ser anulada
            add $t1, $t1, $v0               #guardo em $t1 a adição do valor ja em $t1(quantidade total de colunas da matriz * a linha da posição) + coluna da posição
            add $t1, $t1, $s1               #guardo em $t1 a adição do valor ja em $t1 + endereço base do vetor
            li $t2, 1                       #inicio $t2 com 1
            sb $t2, ($t1)                   #guardo o 1 em $t2 no endereço encontrado nas instruções anteriores, ou seja, matriz[linha][coluna] = 1
            lw $t4, ($sp)                   #recupero na pilha o valor de i e carrego em $t4
            addi $sp, $sp, 4                #vai liberar o espaco para 1 item na pilha
            addi $t4, $t4, 1                #incremento o valor de i, i++
            j LeituraPosicoes               #pula para a função LeituraPosicoes
        FinalizaLeitura:                    #função para finalizar a leitura do arquivo e fecha-lo
            li $v0, 16                      #codigo para fechar arquivo
            syscall                         #vai fechar o arquivo
            lw $ra, ($sp)                   #recupero na pilha o endereco de retorno
            addi $sp, $sp, 4                #vai liberar espaco para 1 item na pilha
            jr $ra                          #faço o retorno para a instrução que chamou LeituraArqEntrada


    EntradaParametro:                       #faz a entrada dos parametros do arquivo
        li $t5, 0                           #inicio $t5 com 0
        li $t0, 0                           #inicio $t0 com 0
        LeituraNumero:                      #faz a leitura dos caracteres do arquivo e os transformam em inteiro
            la $a1, Buffer                  #carrego em $a1 o buffer de leitura
            li $a2, 1                       #passo para $a2 a quantidade de caractere para ser lido (1 caractere)
            li $v0, 14                      #codigo para leitura em arquivo
            syscall                         #vai ler o caractere do arquivo
            blez $v0, FimArquivo            #se for o fim do arquivo vá para FimArquivo
            lb $t4, ($a1)                   #carrega em $t4 o caractere lido
            blt $t4, '0', NumeroInvalido    #se o caractere for menor que o caractere '0' vá para NumeroInvalido
            bgt $t4, '9', NumeroInvalido    #se o caractere for maior que o caractere '9' vá para NumeroInvalido
            j NumeroValido                  #caso não ocorra as condições acima pula para NumeroValido
            NumeroInvalido:                 #se chegou aqui, o caractere lido NÃO pode ser transformado em numero inteiro
                bgt $t5, 0, FimArquivo      #se valor em $t5 for maior que 0 vá para FimArquivo
                j LeituraNumero             #pula para LeituraNumero novamente caso não for
            NumeroValido:                   #se chegou aqui, o caractere lido pode ser transformado em numero inteiro
                subi $t4, $t4, '0'          #vai converter o caractere lido para numero inteiro
                addi $t5, $t5, 1            #incremento a quantidade de digitos lido em $t5(digitos++)
                mul $t0, $t0, 10            #multiplico o numero em $t0 por 10
                add $t0, $t0, $t4           #$t0 recebe valor em $t0 + o algarismo
                j LeituraNumero             #pula para LeituraNumero novamente
        FimArquivo:                         #vai finalizar a leitura do parametro do arquivo
            move $v0, $t0                   #vai retornar o numero em $t0, 0 ou o caractere convertido em inteiro lido do arquivo
            jr $ra                          #retorna para a instrução que chamou EntradaParametro
        

    EscritaArqSaida:                        #vai escrever no arquivo de saída a matriz criada
        li $t4, 0                           #inicio $t4(indice i) com 0
        li $t5, 0                           #inicio $t5(indice j) com 0
        move $t0, $s1                       #carrego em $t0 o endereço base inicial da matriz, ou seja, &matriz[0][0]
        move $a0, $s4                       #carrego em $a0 o file descriptor da saida
        li $a2, 2                           #passo 2( numero de caracteres) para $a2
    ImprimeMatriz:                          #vai escrever a matriz
        lb $t1, ($t0)                       #carrego em $t1 o inteiro salvo na posição matriz[i][j]
        beqz $t1, CarregaCaractereUm        #se o inteiro em $t1 que foi carregado da matriz for == 0 vá para CarregaCaractereUm
        la $a1, Zero                        #carrega em $a1 a string Zero, que possui o numero 0 e um espaço
        j ImprimeElementoDaMatriz           #pula para ImprimeElementoDaMatriz
        CarregaCaractereUm:                 #vai carregar o 1
            la $a1, Um                      #carrega em $a1 a string Um, que possui o numero 1 e um espaço
        ImprimeElementoDaMatriz:            #vai imprimir os elementos da matriz
            li $v0, 15                      #codigo para escrever em um arquivo
            syscall                         #vai escrever no arquivo
            addi $t0, $t0, 1                #vou para a proxima posição da matriz
            addi $t5, $t5, 1                #incremento o indice j
            blt $t5, $s3, ImprimeMatriz     #se o indice j for < o numero de colunas da matriz vá para ImprimeMatriz
            li $t5, 0                       #inicio $t5, indice j, com 0
            la $a1, NovaLinha               #carrego em $a1 a string NovaLinha
            li $v0, 15                      #passo o codigo de escrita em arquivo para $v0
            syscall                         #vai escrever a nova linha no arquivo
            addi $t4, $t4, 1                #incremento o indice i
            blt $t4, $s2, ImprimeMatriz     #se o indice i for < o numero de linhas vá para ImprimeMatriz
        FimEscritaArquivo:                  #vai finalizar a escrita do arquivo
            li $v0, 16                      #codigo para fechar um arquivo
            syscall                         #vai fechar o arquivo
            jr $ra                          #retorna para a instrução que chamou EscritaArqSaida

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