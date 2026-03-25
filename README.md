# Monoscopio VGA in QuickBASIC

Questo programma ricrea un monoscopio VGA 640×480, in stile anni ’80/’90.

---

## Funzionalità principali

- **Griglia 17×13** con proporzioni esatte  
- **Cerchio centrale** con barre colore  
- **Barra a 6 colori** con geometria corretta  
- **Barra dei grigi** con palette calibrata  
- **Pattern di definizione** (bande alternate)  
- **Zone di test** per riflessioni e basse frequenze  
- **Orologio digitale**  
- **Effetto di spegnimento CRT**  
- **Ottimizzazione estrema** per CPU lente

---

## Perché è utile anche oggi

Su molti sistemi moderni, DOSBox-X apre la finestra in **16:9**, deformando i programmi nati per il rapporto **4:3**.

Con questo monoscopio puoi:

1. avviare il programma in modalità finestra  
2. **stringere la finestra** trascinando il bordo sinistro o destro  
3. quando il cerchio centrale torna perfettamente rotondo,  
   hai ritrovato il rapporto 4:3 corretto  
4. da quel momento, ogni programma DOS avrà proporzioni fedeli

È un metodo semplice, analogico, affidabile.

---

## Ottimizzazione

Il programma è ottimizzato tramite:

- eliminazione totale di `PAINT`  
- uso di `LINE` e `LINE BF` per riempimenti rapidi  
- calcolo delle intersezioni del cerchio solo dove necessario  
- riduzione drastica delle chiamate grafiche  
- geometria precomputata e costanti ben definite

Il risultato è un monoscopio che gira fluido anche sull'8088 emulato.  

---

## Note tecniche

- Il cerchio è disegnato tramite riempimento per scanline con `CircleIntersections`.  
- Le barre colore laterali seguono la curvatura del cerchio.  
- Le barre centrali sono rettangolari, come nei generatori Philips.  
- La barra dei grigi usa due palette personalizzate (colori 10 e 11).  
- L’effetto CRT simula la chiusura del fascio tramite dissolvenza della palette.  
- L’orologio è aggiornato in tempo reale e funge da “screen saver” del monoscopio.

---

## Licenza

Libero utilizzo per studio, restauro, didattica e sperimentazione.
