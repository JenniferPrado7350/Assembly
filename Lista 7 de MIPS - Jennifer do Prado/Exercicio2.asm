.data
Entrada: .asciiz "Digite o nome do arquivo texto com a extensao .txt: "
ArqEntrada: .space 32
ArqSaida: .asciiz "SaidaSemVogal.txt"
Buffer: .asciiz " "
Erro: .asciiz "Arquivo texto nao encontrado!\n"

.text
main:
    la $a0, Entrada         #vai carregar o endereco da string Entrada
    li $v0, 4               #codigo para imprimir string
    syscall                 #vai imprimir a string em $a0
    la $a0, ArqEntrada      #vai carregar o endereco da string ArqEntrada
    li $a1, 31              #carrego em $a1 o numero maximo de caracteres do arquivo
    li $v0, 8               #codigo para ler string
    syscall                 #vai ler o nome do arquivo de entrada
    jal RemoveQuebraLinha   #vai remover a quebra de linha \n do final
    li $a1, 0               #modo de leitura
    jal abertura            #pula para abertura
    move $s0, $v0           #carrego em $s0 o file descriptor
    la $a0, ArqSaida        #carrego em $a0 a string ArqSaida
    li $a1, 1               #codigo para escrita do arquivo
    jal abertura            #pula para abertura
    move $s1, $v0           #carrego em $s1 o file descriptor
    jal TrocaVogal          #chamo a função TrocaVogal para trocar as vogais por *
    li $v0, 10              #codigo para finalizar o programa
    syscall                 #finaliza o programa
    

    RemoveQuebraLinha:
        li $t1, 0                           #inicio $t1 com 0, irá guardar a quantidade de caracteres do arquivo
        move $s2, $a0                       #guardo em $t1 o endereço base(endereço da primeira posição)da string, ou seja, &string[0]
        BuscaQuebraLinha:                   #laço de repetição para procurar "\n" e altera-lo para \0
            lb $t0, ($s2)                   #guardo em $t0 o caractere que está no endereço $s2 do vetor string[i]
            bne $t0, '\n', ProximoCaracter  #se o caractere for != de '\n' vá para ProximoCaracter
            li $t0, '\0'                    #$t0 recebe o caractere '\0'
            sb $t0, ($s2)                   #guardo na posição de endereço $s2 do vetor de string o caractere em $t0('\0')
            jr $ra                          #retorna para a função que o chamou
        ProximoCaracter:                    #irá para o proximo caractere do vetor de string
            addi $t1, $t1, 1                #incremento o numero em $t1(quantidade de caracteres do arquivo)
            addi $s2, $s2, 1                #vou para a proxima posição do vetor de string, ou seja, string[i+1]
            blt $t1, 32, BuscaQuebraLinha   #se a quantidade de caracteres do arquivo em $t1 for < 32 vá para BuscaQuebraLinha, pois ainda não atingiu o máximo
            jr $ra                          #retorna para a main


    TrocaVogal:
        li $t0, '*'                         #guado em $t0 o caractere *, que ficará no lugar das vogais
        la $a1, Buffer                      #buffer onde sera armazenado o caractere
        li $a2, 1                           #carrego $a2 com o numero maximo de caractere por leitura
    VerificaSeVogal:                        #vai verificar se o caractere é uma vogal
        move $a0, $s0                       #carrego o file descriptor
        li $v0, 14                          #codigo para leitura de arquivo
        syscall                             #vai ler o arquivo
        blez $v0, FinalizaTrocaVogal        #se $v0 for 0, chegou no final do arquivo
        lb $s2, ($a1)                       #vai carregar o caractere que está no buffer
        beq $s2, 'a', AlteraParaAsterisco   #verifica se o caractere em $s2 é igual a vogal 'a'
        beq $s2, 'A', AlteraParaAsterisco   #verifica se o caractere em $s2 é igual a vogal 'A'
        beq $s2, 'e', AlteraParaAsterisco   #verifica se o caractere em $s2 é igual a vogal 'e'
        beq $s2, 'E', AlteraParaAsterisco   #verifica se o caractere em $s2 é igual a vogal 'E'
        beq $s2, 'i', AlteraParaAsterisco   #verifica se o caractere em $s2 é igual a vogal 'i'
        beq $s2, 'I', AlteraParaAsterisco   #verifica se o caractere em $s2 é igual a vogal 'I'
        beq $s2, 'o', AlteraParaAsterisco   #verifica se o caractere em $s2 é igual a vogal 'o'
        beq $s2, 'O', AlteraParaAsterisco   #verifica se o caractere em $s2 é igual a vogal 'O'
        beq $s2, 'u', AlteraParaAsterisco   #verifica se o caractere em $s2 é igual a vogal 'u'
        beq $s2, 'U', AlteraParaAsterisco   #verifica se o caractere em $s2 é igual a vogal 'U'
        j ImprimeTrocaVogal                 #pula para a função ImprimeTrocaVogal
    AlteraParaAsterisco:                    #função para alterar a vogal por asterisco
        sb $t0, ($a1)                       #vai trocar o caractere no buffer por asterisco
    ImprimeTrocaVogal:                      #função para escrever no arquivo de saída o caractere, seja ele não vogal ou asterisco
        move $a0, $s1                       #carrego em $a0 o file descriptor para saida
        li $v0, 15                          #codigo para escrever no arquivo
        syscall                             #vai escrever o caractere no arquivo
        j VerificaSeVogal                   #pula para a função VerificaSeVogal novamente
    FinalizaTrocaVogal:                     #função para finalizar o loop de troca de vogais
        jr $ra                              #retorna para a main


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
