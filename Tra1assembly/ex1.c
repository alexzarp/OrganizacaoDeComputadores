// ; somatorio_10_100: Fazer um programa em linguagem assembly do RISC-V que, através de um laço, realiza a
// ; soma de todos os valores impares entre 10 e 100. 
#include <stdio.h>
// 2475
int main () {
    int s1 = 0;
    int s2 = 101;
    for (int s0 = 10; s0 < s2; s0++){
        if (s0 % 2 == 1){
            s1+=s0;
            printf("%d\n", s0);
        }
    }
    printf("%d\n", s1);
    return 0;
}