.data
entradaN: .asciiz "Entre com o numero N de alunos: "
mediaAluno: .asciiz "Media aritmetica das provas do aluno "
mediaClasse: .asciiz "Media da classe: "
Aprovados: .asciiz "Aprovados: "
Reprovados: .asciiz "Reprovados: "
entradaNota: .asciiz "Entre com a nota "
entradaAluno: .asciiz " do aluno "
doisPontos: .asciiz ": "
espaco: .asciiz " "
quebraLinha: .asciiz "\n"

.text

main: 

    Estrutura:
        li $t0, 3           #inicio $t0 com 3
        mtc1 $t0, $f7		#move para $f7 o valor em $t0 convertido para float
        cvt.s.w $f7, $f7    #converte word para single precision
        li $a2, 3		    #inicio $a2 com 3
        la $a0, entradaN    #passando a mensagem que estava na memoria na variavel "entradaN" para o registrador de argumento $a0 (string a ser escrita)
        li $v0, 4		    #codigo para imprimir string
        syscall			    #vai imprimir a string
        li $v0, 5		    #codigo para ler inteiro
        syscall			    #vai ler o inteiro N
        move $a1, $v0		#passa o valor em $v0 para $a1
        mtc1 $a1, $f13		#move para $f13 o valor em $a1 convertido para float
        cvt.s.w $f13, $f13  #converte word para single precision 
        mul $t0, $a1, $a2	#guardo em $t0 o valor em $a1 multiPercorreMatrizicado pelo valor em $a2
        mul $a0, $t0, 4		#guardo em $a0 o tamanho da matriz * 4
        li $v0, 9		    #codigo para alocação dinamica
        syscall			    #vai alocar a matriz
        li $t0, 0		    #inicio $t0 com 0
        move $a0, $v0		#passa o endereco da matriz para $a0
        jal Leitura		    #chama a funcao Leitura
        move $a0, $v0		#passa o endereco da matriz para $a0
        li $t5, 0		    #inicio $t5 com 0, sera o contador de alunos reprovados
        li $t6, 0		    #inicio $t6 com 0, sera o contador de alunos aprovados
        jal Verifica_Notas	#chama a funcao Verifica_Notas, vai fazer os calculos para as medias e aprovacoes e reprovacoes
        jal imprimeCalculos	#chama a funcao imprimeCalculos para imprimir os resultados
        li $v0, 10		    #codigo para finalizar o programa
        syscall			    #vai finalizar o programa

    indice:	
        mul $v0, $t0, $a2	#i * numeroColunas
        add $v0, $v0, $t1	#(i * numeroColunas) + j
        sll $v0, $v0, 2		#[(i * numeroColunas) + j] * 4 (inteiro)
        add $v0, $v0, $a3	#soma o endereço base de matriz
        jr $ra			    #retorna para o caller

    Leitura:
        subi $sp, $sp, 4	#abre 1 espaco na stack
        sw $ra, ($sp)		#guarda o retorno para a main na stack
        move $a3, $a0		#$a3 recebe o endereço base da matriz
    l:	la $a0, entradaNota	#passando a mensagem que estava na memoria na variavel "entradaNota" para o registrador de argumento $a0 (string a ser escrita)
        li $v0, 4		    #codigo para imprimir string
        syscall			    #vai imprimir a string
        move $a0, $t1		#passa para $a0 o valor de j
        addi $a0, $a0, 1	#incrementa o valor em $a0
        li $v0, 1		    #codigo para imprimir inteiro
        syscall			    #vai imprimir o valor j+1	
        la $a0, entradaAluno#passando a mensagem que estava na memoria na variavel "entradaAluno" para o registrador de argumento $a0 (string a ser escrita)
        li $v0, 4		    #codigo para imprimir string
        syscall			    #vai imprimir a string
        move $a0, $t0		#passa para $a0 o valor de i
        addi $a0, $a0, 1	#incrementa o valor em $a0
        li $v0, 1		    #codigo para imprimir inteiro
        syscall			    #vai imprimir o valor i+1
        la $a0, doisPontos	#passando a mensagem que estava na memoria na variavel "doisPontos" para o registrador de argumento $a0 (string a ser escrita)
        li $v0, 4		    #codigo para imprimir string
        syscall			    #vai imprimir a string
        li $v0, 6		    #codigo para ler float
        syscall			    #vai ler o float
        mov.s $f2, $f0		#$f2 recebe o valor lido $f0
        jal indice		    #vai calcular o endereço da matriz[i][j]
        s.s $f2, ($v0)		#carrega o float em $f2 na posicao de endereco $v0 da matriz
        addi $t1, $t1, 1	#incremento j
        blt $t1, $a2, l		#se o indice j for < numero de colunas va para l novamente
        li $t1, 0		    #inicio j com 0
        addi $t0, $t0, 1	#incremento i
        blt $t0, $a1, l		#se o indice i for < numero de linhas va para l novamente
        li $t0, 0		    #inicio i com 0
        lw $ra, ($sp)		#vai recuperar o retorno para a main na stack
        addi $sp, $sp, 4	#vai liberar o espaço na stack
        move $v0, $a3		#guarda o endereço da matriz para retorno
        jr $ra              #vai retornar para a instrucao que chamou a funcao Leitura

    Verifica_Notas:
        subi $sp, $sp, 4	            #abre 1 espaco na stack
        sw $ra, ($sp)		            #guarda o retorno para a main na stack
        move $a3, $a0		            #$a3 recebe o endereço base da matriz
        li $s0, 0		                #inicio $s0 com 0, sera a media da turma
        li $s1, 0		                #inicio $s1 com 0, sera o numero de reprovados
        li $s2, 0		                #inicio $s2 com 0, sera o numero de aprovados
        li $t4, 0		                #inicio $t4 com 0, sera auxiliar para a media do aluno
        mtc1 $t0, $f8		            #move para $f8 o valor em $t0(numero 0)convertido para float
        cvt.s.w $f8, $f8                #converte word para single precision
        la $a0, quebraLinha	            #passando a mensagem que estava na memoria na variavel "quebraLinha" para o registrador de argumento $a0
        li $v0, 4		                #codigo para imprimir string
        syscall			                #vai imprimir a string
        PercorreMatriz:	
            jal indice		                #vai calcular o endereço da matriz[i][j]
            l.s $f0, ($v0)		            #carrega em $f0 o float na posicao de endereco $v0 da matriz
            add.s $f3, $f3, $f0	            #adiciona em $f3(somatorio das 3 notas do aluno) o valor em $f3 + a nota x do aluno em $f0
            addi, $t1, $t1, 1	            #incrementa i
            blt $t1, $a2, PercorreMatriz	#se o indice i for < numero de linhas va para PercorreMatriz novamente
            div.s $f4, $f3, $f7	            #guarda em $f4 a divisao de $f3(somatorio das 3 notas do aluno) pelo float 3.0 em $f7
            mov.s $f12, $f4		            #passa a divisao em $f4 para $f12
            add.s $f8, $f8, $f4	            #adiciona em $f8(somatorio das medias de TODOS os alunos) o valor em $f8 + a media do aluno em $f4
            li $t2, 6		                #inicio $t2 com 6
            mtc1 $t2, $f9		            #move para $f9 o valor em $t2(numero 6)convertido para float
            cvt.s.w $f9, $f9                #converte word para single precision
            jal AnalisaAprovacao	        #pula para a funcao AnalisaAprovacao 
            la $a0, mediaAluno	            #passando a mensagem que estava na memoria na variavel "mediaAluno" para o registrador de argumento $a0 (string a ser escrita)
            li $v0, 4		                #codigo para imprimir string
            syscall			                #vai imprimir a string
            move $a0, $t0		            #carrega em $a0 o indice i
            addi $a0, $a0, 1	            #incrementa $a0
            li $v0, 1		                #codigo para imprimir inteiro
            syscall			                #vai imprimir o indice i
            la $a0, doisPontos	            #passando a mensagem que estava na memoria na variavel "doisPontos" para o registrador de argumento $a0 (string a ser escrita)
            li $v0, 4		                #codigo para imprimir string
            syscall			                #vai imprimir a string
            li $v0, 2		                #codigo para imprimir float
            syscall			                #vai imprimir a media          
            la $a0, espaco		            #passando a mensagem que estava na memoria na variavel "espaco" para o registrador de argumento $a0 
            li $v0, 4		                #codigo para imprimir string
            syscall			                #vai imprimir a string
            la $a0, quebraLinha	            #passando a mensagem que estava na memoria na variavel "quebraLinha" para o registrador de argumento $a0
            li $v0, 4		                #codigo para imprimir string
            syscall			                #vai imprimir a string
            li $t2, 0		                #inicio $t2 com 0
            mtc1 $t2, $f3		            #move para $f3 o valor em $t2(numero 0)convertido para float
            cvt.s.w $f3, $f3                #converte word para single precision
            li $t1, 0 		                #reinicio indice i com 0
            addi $t0, $t0, 1	            #incrementa j
            blt $t0, $a1, PercorreMatriz	#se o indice j for < numero de colunas va para PercorreMatriz novamente
            li $t0, 0		                #reinicio indice j com 0
            lw $ra, ($sp)		            #vai recuperar o endereço de retorno para a main na stack
            addi $sp, $sp, 4	            #vai liberar o espaço na stack
            move $v0, $a3		            #passa para $v0 o endereço base da matriz para retorno
            jr $ra 			                #vai retornar para a instrucao que chamou a funcao Verifica_Notas
        
            AnalisaAprovacao:
                c.lt.s $f4, $f9		        #guarda o resultado boolean da condicao: media do aluno em $f4 < que 6
                bc1t AlunoReprovado		    #caso for true(verdadeiro) va para AlunoReprovado  
                AlunoAprovado:
                    addi $t6, $t6, 1	    #incrementa o contador $t6 de Aprovados
                    jr $ra                  #vai retornar para a instrucao que chamou a funcao AnalisaAprovacao
                AlunoReprovado:
                    addi $t5, $t5, 1	    #incrementa o contador $t5 de Reprovados
                    jr $ra                  #vai retornar para a instrucao que chamou a funcao AnalisaAprovacao
        
    imprimeCalculos:
        div.s $f8, $f8, $f13	#vai guardar em $f8 a divisao de $f8(somatorio das medias de TODOS os alunos) por $f13(quantidade de alunos)
        la $a0, mediaClasse 	#passando a mensagem que estava na memoria na variavel "mediaClasse" para o registrador de argumento $a0 (string a ser escrita)
        li $v0, 4		        #codigo para imprimir string
        syscall			        #vai imprimir a string
        mov.s $f12, $f8		    #passa para $f12 a media da classe em $f8
        li $v0, 2		        #codigo para imprimir float
        syscall			        #vai imprimir a media da classe
        la $a0, quebraLinha	    #passando a mensagem que estava na memoria na variavel "quebraLinha" para o registrador de argumento $a0
        li $v0, 4		        #codigo para imprimir string
        syscall			        #vai imprimir a string
        la $a0, Reprovados      #passando a mensagem que estava na memoria na variavel "Reprovados" para o registrador de argumento $a0 (string a ser escrita)
        li $v0, 4		        #codigo para imprimir string
        syscall			        #vai imprimir a string
        move $a0, $t5		    #passa para $a0 o numero de reprovados em $t5
        li $v0, 1		        #codigo para imprimir inteiro
        syscall			        #vai imprimir o numero de reprovados
        la $a0, quebraLinha	    #passando a mensagem que estava na memoria na variavel "quebraLinha" para o registrador de argumento $a0
        li $v0, 4		        #codigo para imprimir string
        syscall			        #vai imprimir a string
        la $a0, Aprovados	    #passando a mensagem que estava na memoria na variavel "Aprovados" para o registrador de argumento $a0 (string a ser escrita)
        li $v0, 4		        #codigo para imprimir string
        syscall	                #vai imprimir a string
        move $a0, $t6		    #passa para $a0 o numero de aprovados em $t6
        li $v0, 1		        #codigo para imprimir inteiro
        syscall			        #vai imprimir o numero de aprovados
        jr $ra                  #vai retornar para a instrucao que chamou a funcao AnalisaAprovacao