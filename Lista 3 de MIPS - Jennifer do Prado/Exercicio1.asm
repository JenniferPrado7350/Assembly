.data
ent1: .asciiz "Insira a string1: "
ent2: .asciiz "Insira a string2: "
test: .asciiz " é null "
test2: .asciiz " nao é null "
test3: .asciiz " S1 "
test4: .asciiz " S2 "
str1: .space 100
str2: .space 100
str3: .space 200

.text
main:   la $a0, ent1        #mensagem
        la $a1, str1        #endereço da string
        jal leitura         #leitura(mensagem, string)
        la $a0, ent2        #mensagem
        la $a1, str2        #mensagem
        jal leitura         #leitura(mensagem, string)
        la $a1, str1        #endereco da string 1
        la $a2, str2        #endereco da string 2
        la $a3, str3        #endereco da string 3
        jal intercala       #intercala(str1,str2,str3)
        move $a0, $v0       #move o retorno de string
        li $v0, 4           #codigo de impressao da string 
        syscall             #imprime a string intercalada
        li $v0, 10          #codigo para finalizar o programa
        syscall             #finaliza o programa

    leitura:    
        li $v0, 4           #codigo de impresssao da string
        syscall             #imprime a string
        move $a0, $a1       #endereço da string para leitura
        li $a1, 100         #Numero maximo  de caracteres
        li $v0, 8           #codigo de leitura da string
        syscall             #faz a leitura da string
        jr $ra              #retorna para a main

    intercala:
        move $t1, $a1       #endereco da string 1 em  $t1
        move $t2, $a2       #endereco da string 2 em  $t2
        move $t3, $a3       #endereco da string 3 em  $t3
        li $s3, 0           #verificador se a str1 ja atingiu o espaço total
        li $s4, 0           #verificador se a str2 ja atingiu o espaço total
        Iteracao:
            Verifica_str1:              #verifica se ainda há caractere em str1 para ser intercalado
                move $t4, $t1           #endereço da posição str1[i] em $t4
                addi $t4, $t4, 1        #vou para a proxima posição, str1[i+1]
                lb $s1, ($t4)           #carrego o caractere da posição str1[i+1] em $s1
                beqz $s1, Verifica_str2 #se o caractere em str1[i+1] for nulo, não adiciono a posição str1[i] em str3[k], pois str1[i] é o ultimo caractere da string1 que representa a quebra de linha
                lb $s1, ($t1)           #carrego o caractere da posição str1[i] em $s1
                sb $s1, ($t3)           #armazeno o caractere de $s1 em str3[k] 
                addi $t1, $t1, 1        #incremento a posição de str1, ou seja, str1[i+1]
                addi $t3, $t3, 1        #incremento a posição de str3, ou seja, str3[k+1]
                addi $s3, $s3, 1        #incremento o verificador se a str1 ja atingiu o espaço total, para contabilizar quanto espaço ela está ocupando até o momento atual da iteração

            Verifica_str2:              #verifica se ainda há caractere em str2 para ser intercalado
                move $t4, $t2           #endereço da posição str2[j] em $t4
                addi $t4, $t4, 1        #vou para a proxima posição, str2[j+1]
                lb $s2, ($t4)           #carrego o caractere da posição str2[j+1] em $s2
                beqz $s2, Verifica_Fim  #se o caractere em str2[j+1] for nulo, não adiciono a posição str2[j] em str3[k], pois str2[j] é o ultimo caractere da string2 que representa a quebra de linha
                lb $s2, ($t2)           #carrego o caractere da posição str2[j] em $s2
                sb $s2, ($t3)           #armazeno o caractere de $s2 em str3[k] 
                addi $t2, $t2, 1        #incremento a posição de str2, ou seja, str2[j+1]
                addi $t3, $t3, 1        #incremento a posição de str3, ou seja, str3[k+1]
                addi $s4, $s4, 1        #incremento o verificador se a str2 ja atingiu o espaço total, para contabilizar quanto espaço ela está ocupando até o momento atual da iteração
                
            Verifica_Fim:                           #função para verificar se ja acabou as strings 1 e 2
                li $s5, 100                         #guardo o espaço total da strings 1 e 2 em $s5
                bge	$s3, $s5, Acabou_Espaco_String	#se $s3(espaço atual da str1) >= 100(espaço maximo que ela pode ocupar) então vá para Acabou_Espaco_String
                Verifica_Fim_Nas_Duas_Strings:      #ainda não atingiu o espaço total, então vamos verificar se ja chegou ao fim das strings
                    move $t4, $t1                   #endereço de str1[i] em $t4
                    addi $t4, $t4, 1                #vou para a proxima posição, str1[i+1]
                    lb $s1, ($t4)                   #carrego o caractere da posição str1[i+1] em $s1
                    beqz $s1, Str1_Finalizada       #se o caractere em str1[i+1] for nulo, vou para Str1_Finalizada, pois str1[i] é o ultimo caractere da string1 que representa a quebra de linha, e portanto acabou a str1
                    j Iteracao                      #continuo as iterações, pois ainda não acabou a str1
                    Str1_Finalizada:                #agora que a str1 esta finalizada, vamos verificar se a str2 esta finalizada tambem
                        move $t4, $t2               #endereço da posição str2[j] em $t4
                        addi $t4, $t4, 1            #vou para a proxima posição, str2[j+1]
                        lb $s2, ($t4)               #carrego o caractere da posição str2[j+1] em $s2
                        beqz $s2, Retorna           #se o caractere em str2[j+1] for nulo, vou para Retorna, para retornar para a função main, pois str2[j] é o ultimo caractere da string2 que representa a quebra de linha
                        j Iteracao                  #continuo as iterações, pois ainda não acabou a str2
                            
        Retorna:
                move $v0, $a3               #endereço da string 3 em $v0 para retorno da função
                jr $ra                      #retorna para a função que a chamou

        Acabou_Espaco_String:
            bge	$s4, $s5, Retorna	        #se $s4(espaço atual da str2) >= 100(espaço maximo que ela pode ocupar) então vá para Retorna
            j Verifica_Fim_Nas_Duas_Strings #ainda não atingiu o espaço total da string, então verifica se as duas strings foram escritas totalmente