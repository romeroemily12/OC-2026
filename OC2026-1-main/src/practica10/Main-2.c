#include <stdio.h>
#include <stdlib.h>

extern void set_bit(unsigned char *valor, unsigned char bit);
extern unsigned char get_bit(unsigned char valor, unsigned char bit);

void update_temp(int *temps);
void update_flags(int *temps,int *last, unsigned char *flags);
void print_estado(unsigned char flag);

int main(){

    unsigned char banderas[2] = {0,0};
    int ultima_lectura[2] = {25,25};
    int tem_sensores[2] = {25,25};

    int op;

    do{
        printf("\nSENSOR 1: %d°C", tem_sensores[0]);
        print_estado(banderas[0]);

        printf("\nSENSOR 2: %d°C", tem_sensores[1]);
        print_estado(banderas[1]);

        printf("\n\n[1] Actualizar\n[2] Salir\n");
        printf("Seleccionar opcion: ");
        scanf("%d", &op);

        if(op == 1){
            update_temp(tem_sensores);
            update_flags(tem_sensores, ultima_lectura, banderas);
        }

    }while(op != 2);

    return 0;
}

void update_temp(int *temps){
    for(int i = 0; i < 2; i++){
        int cambio = (rand() % 11) - 5;
        temps[i] = temps[i] + cambio;
    }
}


void update_flags(int *temps, int *last, unsigned char *flags){
    for(int i = 0; i < 2; i++){

        int dif = temps[i] - last[i];
        flags[i] = 0;

        if(dif == 0){
            set_bit(&flags[i], 0);
        }else{
            if(dif > 0)
                set_bit(&flags[i], 6);
            else
                set_bit(&flags[i], 5);

            int absd = dif > 0 ? dif : -dif;

            if(absd >= 3)
                set_bit(&flags[i], 4);
            else if(absd == 2)
                set_bit(&flags[i], 3);
            else if(absd == 1)
                set_bit(&flags[i], 2);
        }

        last[i] = temps[i];
    }
}

void print_estado(unsigned char flag){

    if(get_bit(flag,0)){
        printf("-");
    }
    else if(get_bit(flag,5)){

        if(get_bit(flag,4)) 
            printf("<<<");
        else if(get_bit(flag,3)) 
            printf("<<");
        else if(get_bit(flag,2)) 
            printf("<");
    }
    else if(get_bit(flag,6)){

        if(get_bit(flag,4)) 
            printf(">>>");
        else if(get_bit(flag,3)) 
            printf(">>");
        else if(get_bit(flag,2)) 
            printf(">");
    }
}