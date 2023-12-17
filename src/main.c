#include <pic18fregs.h>
#include <delay.h>
#include <stdint.h>

#pragma config XINST = OFF
//#pragma config WDT = OFF

// Oscillator Selection bits (Internal oscillator, port function on RA6, EC used by USB (INTIO))
#pragma config FOSC = INTOSCIO_EC

#pragma config LVP = OFF
// Vari?veis globais
volatile unsigned int contador = 0;  // Vari?vel para armazenar o valor do cron?metro
volatile int TH;
volatile int TL;

void ConfigMCU() {
    // Configura??es espec?ficas para o PIC18F4550 e o PIC18F45K22
       ADCON1 |= 0x0F;  // Configura todos os pinos em PORTA e PORTB como digitais
    INTCON2bits.RBPU = 0; // Desabilita o resistor de pull-up global e ativa para RB0 e RB1
    //configura o port D como saida
    TRISD = 0;
    PORTD = 0;

    //configura as portas 0 e 1 de B como entradas
    TRISBbits.RB0 = 1;
    TRISBbits.RB1 = 1;
    PORTBbits.RB0 = 1;
    PORTBbits.RB1 = 1;
}

int display(int number) {
    // Assegura que apenas valores v?lidos sejam exibidos
    if (number < 0 || number > 9) {
        return 0x00;  // Desliga todos os segmentos se o n?mero n?o for reconhecido
    }

    // Exibi??o no display de 7 segmentos com base no valor do contador
    switch (number) {
        case 0: return 0x3F; break;  // 0
        case 1: return 0x06; break;  // 1
        case 2: return 0x5B; break;  // 2
        case 3: return 0x4F; break;  // 3
        case 4: return 0x66; break;  // 4
        case 5: return 0x6D; break;  // 5
        case 6: return 0x7D; break;  // 6
        case 7: return 0x07; break;  // 7
        case 8: return 0x7F; break;  // 8
        case 9: return 0x6F; break;  // 9
    }
}

// Configura??es globais de interrup??o
void SetupGeneralInterrupts()
{ //configuracao de interupcoes
  INTCONbits.GIEH = 1;
  INTCONbits.GIEL = 1;
  RCONbits.IPEN = 1;

//habilita e prioriza interrupcao de timer
  INTCONbits.TMR0IF = 0;
  INTCONbits.TMR0IE = 1;
  INTCON2bits.TMR0IP = 1;

//habilita e prioriza interrupcoes externas
  INTCONbits.INT0IF = 0;
  INTCON3bits.INT1IF = 0;
//INTCON.INT0IF = 0; nao e necessario pois INT0 sempre tem prioridade alta
  INTCON3bits.INT1IP = 1;
  INTCONbits.INT0IE = 1;
  INTCON3bits.INT1IE = 1;
//configura a interrupcao para ocorer na borda de subida
  INTCON2bits.INTEDG0 = 1;
  INTCON2bits.INTEDG1 = 1;

}


void high_isr(void) __interrupt(1) {
    if (INTCONbits.TMR0IF == 1) {
        contador++;
        if (contador >= 10) contador = 0; // Reseta o contador se chegar a 10
        LATD = display(contador);

        // Reinicia o Timer0
        T0CONbits.TMR0ON = 0;   // Desliga o Timer0 para reconfigura??o
        TMR0H = TH;
        TMR0L = TL;
        T0CONbits.TMR0ON = 1;   // Liga o Timer0 com novos valores

        INTCONbits.TMR0IF = 0; // Limpa a flag
    }

    // Verifica se a interrup??o foi causada pelo bot?o INT0 (RB0)
    if (INTCONbits.INT0IF == 1) {
        // Configura o Timer0 para 1 segundo
        TH = 0x0B;
        TL = 0xDC;

        // Reinicia o Timer0 com os novos valores
        T0CONbits.TMR0ON = 0;
        TMR0H = TH;
        TMR0L = TL;
        T0CONbits.TMR0ON = 1;

        INTCONbits.INT0IF = 0; // Limpa a flag de interrup??o do INT0
    }

    // Verifica se a interrup??o foi causada pelo bot?o INT1 (RB1)
    if (INTCON3bits.INT1IF == 1) {
        // Configura o Timer0 para 0.25 segundo
        TH = 0xC2;
        TL = 0xF7;

        // Reinicia o Timer0 com os novos valores
        T0CONbits.TMR0ON = 0;
        TMR0H = TH;
        TMR0L = TL;
        T0CONbits.TMR0ON = 1;

        INTCON3bits.INT1IF = 0; // Limpa a flag de interrup??o do INT1
    }
}

void main() {
    // Inicializa o microcontrolador com as configura??es espec?ficas
    ConfigMCU();

    // Configura e inicializa o Timer0 e suas interrup??es
    T0CON = 0B00000100; //TIMER_OFF, MOD_16BITS, TIMER, PRES_1:32

    // Configura as interrup??es gerais, incluindo INT0 e INT1
    SetupGeneralInterrupts();
    LATD = display(4);

    // Loop principal do programa
    while(1) {
    __asm
        CLRWDT
    __endasm;
        // Neste loop, a maior parte do trabalho ? feita pelas rotinas de interrup??o
        // O microcontrolador pode executar outras tarefas n?o cr?ticas aqui,
        // ou entrar em um estado de baixo consumo se aplic?vel.
    }
}
