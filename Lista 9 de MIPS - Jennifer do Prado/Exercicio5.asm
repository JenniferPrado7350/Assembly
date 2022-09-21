.data
entradaN: .asciiz "Entre com o valor de N(com N >= 0): "
resultadoHiperfatorial: .asciiz "O Hiperfatorial de N e: "
.align 2
quebraLinha: .asciiz "\n"
um: .float 1
zero: .float 0
.text

main:
    jal Leitura                     #vai ler os valores de x e n
    jal CalculaHiperfatorial        #vai encontrar o Hiperfatorial de N 
    li $v0, 4                       #usando o codigo SysCall para escrever strings
    la $a0, resultadoHiperfatorial  #passando a mensagem que estava na memoria na variavel "resultadoHiperfatorial" para o registrador de argumento $a0 (string a ser escrita)
    syscall                         #vai imprimir a mensagem que esta em $a0
    mov.s $f12, $f4		            #move o hiperfatorial de N encontrado para $f12
    li $v0, 2                       #codigo para imprimir float
    syscall                         #imprime o float
    li $v0, 10                      #codigo para finalizar o programa
	syscall                         #finaliza o programa


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


    CalculaHiperfatorial:
        l.s $f4, um                     #carrega em $f4 o float 1, ira guardar o hiperfatorial de cada iteracao, comecando com N = 0, hiperfatorial 1
        l.s $f5, um                     #carrega em $f5 o float 1, sera a variavel n que sera incrementada 1 em 1
        mtc1 $s0, $f6                   #guarda em $f6 o valor em $s0
        cvt.s.w $f6, $f6                #converte word para single precision, $f6 sera o $s0, ou seja, o N final, digitado pelo usuario
        l.s $f9, zero                   #carrega em $f9 o float 0
        c.eq.s $f6, $f9		            #guarda o resultado boolean da condicao: N de entrada em $f6 == 0.0 em $f9
        bc1t RetornaHiperfatorial       #caso for true(verdadeiro) va para RetornaHiperfatorial, pois o hiperfatorial de n=0 sera 1
        l.s $f9, um                     #carrega em $f9 o float 1
        Hiperfatorial_N_Maior_Que_0:
            l.s $f10, um                            #carrega em $f10 o float 1
            mov.s $f11, $f5                         #carrega n atual que é incrementado em $f11, ira guardar o resultado da potencia n^n
            Potencia:
                c.lt.s $f10, $f5		            #guarda o resultado boolean da condicao: potencia em $f10 < que n que é incrementado em $f5
                bc1f MultiplicaHiperfatorial        #caso for false(falso) va para MultiplicaHiperfatorial
                mul.s $f11, $f11, $f5               #multiplica n em $f11 por n em $f5 que é incrementado, guarda em $f11 o resultado
                add.s $f10, $f10, $f9               #incrementa a potencia em 1
                j Potencia                          #pula para potencia novamente
            MultiplicaHiperfatorial:
                mul.s $f4, $f4, $f11            #guarda o valor do novo hiperfatorial, fazendo a multiplicacao do valor calculado * o hiperfatorial de n-1:  (n^n) * H(n-1)
                add.s $f5, $f5, $f9             #incrementa n em 1
            c.le.s $f5, $f6		                #guarda o resultado boolean da condicao: n em $f5 que é incrementado <= que N de entrada em $f6
            bc1t Hiperfatorial_N_Maior_Que_0    #caso for true(verdadeiro) va para Hiperfatorial_N_Maior_Que_0
        RetornaHiperfatorial:
            jr $ra                              #retorna para a instrucao que chamou a funcao CalculaHiperfatorial

   