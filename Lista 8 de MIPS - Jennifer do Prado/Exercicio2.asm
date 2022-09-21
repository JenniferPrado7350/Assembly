.data
entradaX: .asciiz "Entre com o valor real X: "
entradaN: .asciiz "Entre com o valor natural N: "
.align 2
quebraLinha: .asciiz "\n"
um: .float 1
.text

main:
    jal Leitura             #vai ler os valores de x e n
    move $a0, $s0           #guarda o inteiro N em $a0
    jal AproximaCossenoX    #vai encontrar a aproximacao do cosseno de x com N iteracoes
    ContinuaMain:           
        lw $a0, quebraLinha #passando a mensagem que estava na memoria na variavel "quebraLinha" para o registrador de argumento $a0
        li $v0, 11          #codigo para imprimir caractere
        syscall             #vai imprimir o caractere \n
        mov.s $f12, $f8		#move o valor do cosseno de X encontrado para $f12
        li $v0, 2           #codigo para imprimir float
        syscall             #imprime o float
    li $v0, 10              #codigo para finalizar o programa
	syscall                 #finaliza o programa


    Leitura:
        li $v0, 4               #usando o codigo SysCall para escrever strings
        la $a0, entradaX        #passando a mensagem que estava na memoria na variavel "entradaX" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        li $v0, 6				#codigo para ler float
        syscall                 #vai ler o float X
        mov.s $f2, $f0          #move para $f2 o float lido em $f0
        li $v0, 4               #usando o codigo SysCall para escrever strings
        la $a0, entradaN        #passando a mensagem que estava na memoria na variavel "entradaN" para o registrador de argumento $a0 (string a ser escrita)
        syscall                 #vai imprimir a mensagem que esta em $a0
        li $v0, 5				#codigo para ler inteiro
        syscall                 #vai ler o inteiro N
        move $s0, $v0           #move para $s0 o inteiro lido em $v0
        lw $a0, quebraLinha     #passando a mensagem que estava na memoria na variavel "quebraLinha" para o registrador de argumento $a0 
        li $v0, 11              #codigo para imprimir caractere
        syscall                 #vai imprimir o caractere \n(quebra de linha)
        jr $ra                  #retorna para a instrucao que chamou a funcao Leitura


    AproximaCossenoX:
        move $s7, $a0                   #valor de N em $s7
        move $s1, $s7                   #valor de N em $s1
        move $s6, $s7                   #valor de N em $s6
        mov.s $f4, $f2                  #valor de X em $f4
        subi $s1, $s1, 1                #N-1
        subi $s6, $s6, 1                #N-1
        subi $s7, $s7, 1                #N-1
        N_Termos:
            move $s7, $s1               #move valor de $s1 em $s7
            mov.s $f4, $f2              #move valor $f2 (x^2k) para $f4
            sub $sp,$sp,4               #abre 1 espaco na stack  
            sw $ra, 0($sp)              #guarda o retorno da funcao na stack
            sll $s6, $s6, 1             #$s6 = $s6 << 1
            jal Potenciacao             #pula para Potenciacao
            move $a0, $s6               #move valor em $s6 para $a0
            jal Fatorial                #pula para Fatorial
            move $s5, $v0               #guardo o valor (2k)! retornado da funcao Fatorial em $s5
            mtc1 $s5, $f6               #registrador do coprocessador 1 $f6 para o valor em $s5
            cvt.s.w $f6, $f6            #converte word para single precision 
            div.s $f4, $f4, $f6         #divide float em $f4 por $f6
            move $s6, $s1               #guarda em $s6 inteiro em $s1
            div $s6, $s6, 2             #divide $s6 por 2
            mfhi $t5                    #resto da divisão em $t5
            bnez $t5, K_Impar           #se o resto da divisao nao for igual a 0, va para K_Impar
            add.s $f8, $f8, $f4         #chegou aqui, o valor de k atual sera par, entao o termo deve ser positivo, adiciona o termo
            j ContinuaAproximacao       #pula para ContinuaAproximacao
            K_Impar:                    #chegou aqui, o valor de k atual sera impar, entao o termo deve ser negativo
                sub.s $f8, $f8, $f4     #subtraindo o termo
            ContinuaAproximacao:
                subi $s1, $s1, 1        #decrementa o termo N atual
                move $s6, $s1           #$s6 recebe valor de $s1
                bgtz $s6, N_Termos      #se $s6 > 0, va para N_Termos
                l.s $f14, um            #carrega em $f14 o float 1
                add.s $f8, $f8, $f14    #incrementa $f8 com o float 1
                j ContinuaMain          #pula para ContinuaMain


    Potenciacao:                            #vai calcular a potencia de x
        mov.s $f30,$f4                      #move para $f30 o float X real em $f4
        li $t0,1                            #inicia $t0 com 1
        P:  
            beq $t0,$s6, RetornaPotenciacao #se $t0 for = 2*K em $s6, va para RetornaPotenciacao
            mul.s $f30,$f30,$f4             #X*X
            add $t0,$t0,1                   #incrementa $t0
            j P                             #pula para P novamente
        RetornaPotenciacao:
            mov.s $f4, $f30                 #passa para $f4 o resultado da potencia X^(2*K)
            jr $ra                          #retorna para a instrucao que chamou Potenciacao


    Fatorial:                           #vai calcular o fatorial de 2*K
        li $t9, 1                       #inicia $t9 com o valor 1
        sub $sp,$sp,8                   #abre 2 espacos na stack
        sw $ra, 4($sp)                  #carrega na stack o retorno da funcao
        sw $a0, 0($sp)                  #carrega na stack o valor de N
        slt $t0, $a0,$t9                #verifica se N < 1
        beq $t0, $zero, ProxNumFatorial #caso $t0 for 0, ou seja, n >= 1, vai para ProxNumFatorial
        li $v0, 1                       #caso n < 1, inicia $v0 com o valor 1
        add $sp,$sp,8                   #libera 2 espaço da stack
        jr $ra                          #retorna para a instrucao que chamou Fatorial
    ProxNumFatorial:   
        sub $a0, $a0,1                  #decrementa valor de N
        jal Fatorial                    #pula para Fatorial novamente
        lw $a0, 0($sp)                  #recupera da stack o valor de N
        lw $ra, 4($sp)                  #recupera o retorno da funcao
        add $sp, $sp,8                  #libera 2 espaço da stack
        mul $v0, $a0, $v0               #$v0 recebe a multiplicacao N * Fatorial de N-1
        jr $ra                          #retorna para a instrucao que chamou ProxNumFatorial   


    