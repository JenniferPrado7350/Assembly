.data                                                                           
        entradaN: .asciiz "Entre com o valor inteiro de N (N>0). "                                                              
        msg_erro: .asciiz "O valor digitado tem que ser inteiro e maior que 0.\n "                                              
        NaoPerfeito: .asciiz "\nN NAO e perfeito! "                                                                
        Perfeito: .asciiz "\nN e perfeito! "                                                          
.align 2

.text

.main: 
    N: 
        li $s0, 0                       #inicia $s0 com 0
        li $v0, 4                       #usando o codigo SysCall para escrever strings
        la $a0, entradaN                #passando a mensagem que estava na memoria na variavel "entradaN" para o registrador de argumento $a0
        syscall                         #vai imprimir a mensagem que esta em $a0
        li $v0, 5                       #usando o codigo SysCall para ler inteiros
        syscall                         #o inteiro de entrada "N" foi lido e esta em $v0
        ble $v0, 0, Erro                #caso o valor digitado que esta no registrador de valor $v0 for menor que o inteiro "0", v� para Erro
        add $s0, $v0, $zero             #guarda em $s0 o n�mero digitado "N" que esta em $v0

    Estrutura:
        jal Verifica_Perfeito   #funcao para verificar se perfeito
        li $v0, 10              #Codigo usado para finalizar o programa
        syscall                 #Programa finalizado

    Verifica_Perfeito:
	    li $t3, 1                               #carrega 1 em $t3 sera usado como contador
	    li $t4, 0                               #inicializa $t4 com 0, sera usado como o somatorio dos divisores
        li $t7, 0                               #inicio $t7 com 0 
        add $t7, $t7, $s0                       #passo valor de N para $t7
	    beq $t7, 1, Nao_Perfeito                #Se o valor lido for 1 o numero nao e perfeito
        DescobreDivisores:	
	        add $t3, $t3, 1                     #incremento do contador $t3
	        bge $t3, $t7, Resposta_Perfeito 	#se t3 for maior ou igual o valor lido vai pra resposta da funcao
	        div $t7, $t3                        #divide o valor lido pelo contador $t3 N/i
	        mfhi $t5                            #$t5 recebe o resto da divisao
	        beq $t5, $zero, Somatorio           #se $t5 for igual 0 vai pro label que soma os divisores
	        j DescobreDivisores                 #executa o DescobreDivisores novamente
            Somatorio:
	            add $t4, $t4, $t3               #incrementa o $t4(somatorio dos divisores) com o $t3(contador atual)
	            j DescobreDivisores             #executa o DescobreDivisores novamente 
        Resposta_Perfeito:
	        add $t4, $t4, 1                     #incrementa o $t4(somatorio dos divisores) em +1
	        beq $t4, $t7, E_Perfeito            #se o $t4 for igual ao valor lido, entao o $t7 � perfeito
            j Nao_Perfeito

        E_Perfeito:
            li $v0, 4                           #codigo SysCall para escrever string     
            la $a0, Perfeito                    #Carrega a mensagem que estava na memoria da variavel "Perfeito" para o registrador de argumento $a0
            syscall                             #Imprime o valor de $a0 na tela
            jr $ra                              #retorna para a instrucao que chamou a funcao Verifica_Perfeito

        Nao_Perfeito:
            li $v0, 4                           #codigo SysCall para escrever string     
            la $a0, NaoPerfeito                 #Carrega a mensagem que estava na memoria da variavel "NaoPerfeito" para o registrador de argumento $a0
            syscall                             #Imprime o valor de $a0 na tela
            jr $ra                              #retorna para a instrucao que chamou a funcao Verifica_Perfeito


    Erro:
        li $v0, 4                     #usando o codigo SysCall para escrever strings      
        la $a0, msg_erro              #passando a mensagem que estava na memoria na variavel "msg_erro" para o registrador $a0
        syscall                       #vai imprimir a mensagem que esta em $a0
        j N                           #Salta pro label de leitura do N novamente