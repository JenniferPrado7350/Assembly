.data
entradaN: .asciiz "Entre com o valor de N(com N >= 0): "
resultadoCatalan: .asciiz "O numero de Catalan de N e: "
.align 2
quebraLinha: .asciiz "\n"
um: .float 1
dois: .float 2
zero: .float 0
.text

main:
    jal Leitura             #vai ler os valores de x e n
    jal CalculaCatalan      #vai encontrar o numero de catalan de N 
    li $v0, 4               #usando o codigo SysCall para escrever strings
    la $a0, resultadoCatalan#passando a mensagem que estava na memoria na variavel "resultadoCatalan" para o registrador de argumento $a0 (string a ser escrita)
    syscall                 #vai imprimir a mensagem que esta em $a0
    mov.s $f12, $f4		    #move o do catalan de N encontrado para $f12
    li $v0, 2               #codigo para imprimir float
    syscall                 #imprime o float
    li $v0, 10              #codigo para finalizar o programa
	syscall                 #finaliza o programa


    Leitura:
        li $v0, 4               #usando o codigo SysCall para escrever strings
        la $a0, entradaN        #passando a mensagem que estava na memoria na variavel "entradaN" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        li $v0, 5				#codigo para ler inteiro
        syscall                 #vai ler o inteiro N
        blt $v0, 0, Leitura     #caso o valor lido for negativo, n<0, retorna para Leitura novamente
        move $s0, $v0           #move para $s0 o inteiro lido em $v0
        lw $a0, quebraLinha     #passando a mensagem que estava na memoria na variavel "quebraLinha" para o registrador de argumento $a0 
        li $v0, 11              #codigo para imprimir caractere
        syscall                 #vai imprimir o caractere \n(quebra de linha)
        jr $ra                  #retorna para a instrucao que chamou a funcao Leitura


    CalculaCatalan:
        l.s $f4, um                     #carrega em $f4 o float 1, ira guardar o numero de catalan de cada iteracao, comecando com N = 0, catalan 1
        l.s $f5, um                     #carrega em $f5 o float 1, sera a variavel n que sera incrementada 1 em 1
        mtc1 $s0, $f6                   #guarda em $f6 o valor em $s0
        cvt.s.w $f6, $f6                #converte word para single precision, $f6 sera o $s0, ou seja, o N final, digitado pelo usuario
        l.s $f9, zero                   #carrega em $f9 o float 0
        c.eq.s $f6, $f9		            #guarda o resultado boolean da condicao: N de entrada em $f6 == 0.0 em $f9
        bc1t RetornaCatalan             #caso for true(verdadeiro) va para RetornaCatalan, pois o catalan de n=0 sera 1
        l.s $f9, um                     #carrega em $f9 o float 1
        Catalan_N_Maior_Que_0:
            Denominador:
                l.s $f7, dois           #carrega em $f7 o float 2
                mul.s $f8, $f7, $f5     #multiplica 2 em $f7 por n em $f5 que é incrementado, ou seja, $f8 recebe 2*n
                sub.s $f8, $f8, $f9     #$f8 recebe seu valor menos 1, ou seja, 2*n - 1
                mul.s $f8, $f7, $f8     #multiplica $f7 por $f8, ou seja, $f8 recebe 2*(2*n - 1)
            Numerador:
                add.s $f5, $f5, $f9     #incrementa $f5 em 1, ou seja, n + 1
            RealizaDivisao:
                div.s $f8, $f8, $f5     #guarda em $f8 a divisao de seu valor por $f5, ou seja, ( 2( 2n - 1) ) / ( n + 1 )
            MultiplicaCatalan:
                mul.s $f4, $f8, $f4     #guarda o valor do novo catalan, fazendo a multiplicacao do valor calculado * o catalan de n-1:  ( ( 2( 2n - 1) ) / ( n + 1 ) ) * C( n - 1 )
            c.le.s $f5, $f6		        #guarda o resultado boolean da condicao: n em $f4 que é incrementado <= que N de entrada em $f6
            bc1t Catalan_N_Maior_Que_0  #caso for true(verdadeiro) va para Catalan_N_Maior_Que_0
        RetornaCatalan:
            jr $ra                          #retorna para a instrucao que chamou a funcao CalculaCatalan

   