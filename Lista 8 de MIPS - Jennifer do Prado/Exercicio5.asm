.data
CPF: .space 16
entrada: .asciiz "Digite o CPF (no formato XXXXXXXXX-XX): "
valido: .asciiz "O CPF e valido."
invalido: .asciiz "O CPF e invalido."

.text
main:
    Estrutura:
        la $a0, entrada #passando a mensagem que estava na memoria na variavel "entrada" para o registrador de argumento $a0 (string a ser escrita)
        li $v0, 4       #usando o codigo SysCall para escrever strings
        syscall         #vai imprimir a mensagem que esta em $a0
        la $a0, CPF     #vai carregar o endereco da string CPF
        li $a1, 32      #passa o tamanho maximo da string
        li $v0, 8       #usando o codigo SysCall para leitura de string
        syscall         #vai ler a string
        jal VerificaCPF #pula para a funcao VerificaCPF
        li $v0, 10      #usando o codigo SysCall para finalizar o programa
        syscall         #finaliza o programa
        
    VerificaCPF:
        li $t0, 0                       #vai iniciar $t0 com 0
        move $t1, $a0                   #$t1 recebe endereco base da string
        li $t8, 10                      #inicia $t8 com 10
        li $t9, 11                      #inicia $t9 com 11
        AnalisaDigitos:
            lb $t4, ($t1)               #$t4 vai receber o caractere de endereco $t1 do vetor de string
            bge $t0, 9, VerificaTraco   #se o indice i for >= 9, va para VerificaTraco
            subi $t5, $t4, '0'          #$t5 recebe o caractere em $t4 convertido para int
            sub $t6, $t8, $t0           #$t6 vai receber a subtracao de 10 em $t8 - o indice i(que vai incrementando)
            mul $t7, $t5, $t6           #$t7 recebe a multiplicacao do numero do cpf que foi convertido * a subtracao calculada na instrucao acima
            add $t2, $t2, $t7           #vai incrementar $t7 em $t2
            addi $t6, $t6, 1            #vai incrementar 1 em $t6
            mul $t7, $t5, $t6           #$t7 vai receber a multiplicacao de $t5(um numero do cpf) * o valor em $t6
            add $t3, $t3, $t7           #vai incrementar $t7 em $t3
            j ProximoDigito             #pula para ProximoDigito


            VerificaTraco:
                bne $t0, 9, CalculaPrimeiroDigito   #se o indice i for != 9, va para CalculaPrimeiroDigito
                bne $t4, '-', CPF_Invalido          #se o caractere lido for != de um traco '-', va para CPF_Invalido
                j ProximoDigito                     #pula para ProximoDigito


            CalculaPrimeiroDigito:
                bne $t0, 10, CalculaSegundoDigito               #se o indice i for != 10, va para CalculaSegundoDigito
                div $t2, $t9                                    #faz a divisao do somatorio calculado por onze em $t9
                mfhi $t5                                        #o resto da divisao vai para $t5
                Digito1_Resultado_Menor_Que_2:
                    bge $t5, 2, Digito1_Resultado_Maior_Que_2   #se o resto da divisao em $t5 for >= 2, va para Digito1_Resultado_Maior_Que_2
                    li $s0, '0'                                 #inicia $s0 com o caractere '0'
                    j Verifica_Digito1CPF_Digito1Calc           #pula para Verifica_Digito1CPF_Digito1Calc
                Digito1_Resultado_Maior_Que_2:
                    sub $s0, $t9, $t5                           #guarda em $s0 a subtracao do 11 em $t9 - resto da divisao em $t5
                    sll $t5, $s0, 1                             #$t5 recebe valor em $s0 * 2
                    add $t3, $t3, $t5                           #vai incrementar em $t3 o valor calculado em $t5
                    addi $s0, $s0, '0'                          #vai converter o valor em $s0 para caractere
                Verifica_Digito1CPF_Digito1Calc:
                    bne $s0, $t4, CPF_Invalido                  #se o caractere em $s0 for != do caractere $t4 da string CPF, va para CPF_Invalido
                    j ProximoDigito                             #pula para ProximoDigito


            CalculaSegundoDigito:
                bne $t0, 11, VerificaQuebraDeLinha              #se o indice i for != 11, va para VerificaQuebraDeLinha
                div $t3, $t9                                    #vai dividir o somatorio em $t3 por 11
                mfhi $t5                                        #$t5 recebe o resto da divisao
                Digito2_Resultado_Menor_Que_2:
                    bge $t5, 2, Digito2_Resultado_Maior_Que_2   #se o resto da divisao em $t5 for >= 2, va para Digito2_Resultado_Maior_Que_2
                    li $s1, '0'                                 #inicia $s0 com o caractere '0'
                    j Verifica_Digito2CPF_Digito2Calc           #pula para Verifica_Digito2CPF_Digito2Calc
                Digito2_Resultado_Maior_Que_2:
                    sub $s1, $t9, $t5                           #guarda em $s1 a subtracao do 11 em $t9 - resto da divisao em $t5
                    addi $s1, $s1, '0'                          #vai converter o valor em $s1 para caractere
                Verifica_Digito2CPF_Digito2Calc:
                    bne $s1, $t4, CPF_Invalido                  #se o caractere em $s1 for != do caractere $t4 da string CPF, va para CPF_Invalido
                    j ProximoDigito                             #pula para ProximoDigito
            VerificaQuebraDeLinha:
                bne $t4, '\n', CPF_Invalido                     #se o caractere em string[i] for != '\n', va para CPF_Invalido
                j CPF_Valido                                    #pula para CPF_Valido


        ProximoDigito:
            addi $t0, $t0, 1            #vai incrementar o indice i em 1
            addi $t1, $t1, 1            #vai para o endereco do proximo caractere no vetor de string CPF
            bnez $t4, AnalisaDigitos    #se o ascii do caractere em $t4 for != de 0 va para AnalisaDigitos

        CPF_Invalido:
            la $a0, invalido            #passando a mensagem que estava na memoria na variavel "entradaN" para o registrador de argumento $a0 (string a ser escrita)
            li $v0, 4                   #usando o codigo SysCall para escrever strings
            syscall                     #vai imprimir a mensagem que esta em $a0
            jr $ra                      #vai retornar para a instrucao que chamou a funcao VerificaCPF

        CPF_Valido:
            la $a0, valido              #passando a mensagem que estava na memoria na variavel "entradaN" para o registrador de argumento $a0 (string a ser escrita)
            li $v0, 4                   #usando o codigo SysCall para escrever strings
            syscall                     #vai imprimir a mensagem que esta em $a0
            jr $ra                      #vai retornar para a instrucao que chamou a funcao VerificaCPF