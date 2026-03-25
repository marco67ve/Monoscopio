' MONOSCOP.BAS
' By Marco da Venezia, 1990 (rev. 2026)

DECLARE SUB CRToff ()
DECLARE SUB Clock ()
DECLARE SUB CircleIntersections (y!, x1!, x2!)
DECLARE SUB InCircleMidArea ()
DECLARE SUB InCircleBotArea ()
DECLARE SUB InCircleTopArea ()
DECLARE SUB InCircleBGBar ()
DECLARE SUB InCircleGraysBar ()
DECLARE SUB InGrid8color ()
DECLARE SUB InCircle5defAreas ()
DECLARE SUB InCircle6colorAreas ()
DECLARE SUB FillCellRange (c1!, r1!, c2!, r2!, clr!)
DECLARE SUB DrawBlackCircle ()
DECLARE SUB DrawGraysBox ()
DECLARE SUB DrawGridLines ()
DECLARE SUB Countdown ()

CONST sq = 640 / 17 ' lato del quadrato per 17 celle in x
CONST xVGA = (640 - (17 * sq)) / 2 ' x del primo pixel
CONST yVGA = (480 - (13 * sq)) / 2 ' y  "    "     "
' Centro
CONST cx = 320
CONST cy = 240
' Raggio
CONST r = cy + 6 - sq / 2 ' circonferenza intersecata in 3,4 e 6,1

SCREEN 12

Countdown
' t0 = TIMER
DrawGraysBox
DrawGridLines
InGrid8color
DrawBlackCircle
InCircle6colorAreas
InCircle5defAreas
InCircleGraysBar
InCircleBGBar
InCircleTopArea
InCircleBotArea
InCircleMidArea
' t1 = TIMER
Clock
CRToff

SCREEN 0
' PRINT t1 - t0

SUB CircleIntersections (y, x1, x2)
    dy = y - cy
    dx = SQR(r * r - dy * dy)
    x1 = cx - dx
    x2 = cx + dx
END SUB

SUB Clock
    WHILE INKEY$ <> CHR$(27)
        COLOR 15: LOCATE 4, 37: PRINT TIME$
        IF clr = 7 THEN
            clr = 14
            mex$ = "V G A  T E S T"
        ELSE
            clr = 7
            mex$ = "Hit ESC to end"
        END IF
        COLOR clr: LOCATE 25, 34: PRINT mex$
        SLEEP 1
    WEND
END SUB

SUB Countdown
    CLS
    FOR i = 9 TO 0 STEP -1
        IF INKEY$ <> "" THEN EXIT SUB
        LOCATE 15, 40: PRINT i
        SLEEP 1
    NEXT
END SUB

SUB CRToff

    CLS
    LINE (0, 240)-(640, 240), 15
    FOR k = 63 TO 0 STEP -7
        PALETTE 15, k + 256 * k + 65536 * k
        t = TIMER: WHILE TIMER < t + .01: WEND
    NEXT
    
END SUB

SUB DrawBlackCircle
    FOR y = cy - r TO cy + r
        CircleIntersections y, x1, x2
        LINE (x1, y)-(x2, y), 0
    NEXT y
END SUB

SUB DrawGraysBox
   
    ' Calcolo area centrata
    x1 = xVGA
    y1 = yVGA
    x2 = x1 + (17 * sq)
    y2 = y1 + (13 * sq)

    ' Rettangolo grigio
    LINE (x1, y1)-(x2, y2), 8, BF

END SUB

SUB DrawGridLines
   
    x1 = xVGA
    y1 = yVGA
    x2 = x1 + (17 * sq)
    y2 = y1 + (13 * sq)

    ' Linee verticali (18 linee)
    FOR i = 0 TO 17
        x = x1 + (i * sq)
        LINE (x, y1)-(x, y2), 7
    NEXT i

    ' Linee orizzontali (14 linee)
    FOR j = 0 TO 13
        y = y1 + (j * sq)
        LINE (x1, y)-(x2, y), 7
    NEXT j

END SUB

SUB FillCellRange (c1, r1, c2, r2, clr)
    ' Calcola i pixel esatti dalle coordinate "a griglia"
    x1 = xVGA + 1 + (c1 - 1) * sq
    y1 = yVGA + 1 + (r1 - 1) * sq
    x2 = xVGA - 1 + (c2 - 1) * sq + sq
    y2 = yVGA - 1 + (r2 - 1) * sq + sq
    LINE (x1, y1)-(x2, y2), clr, BF
END SUB

SUB InCircle5defAreas

    ' Limiti verticali della zona
    yTop = cy + sq / 2
    yBot = cy + 2.5 * sq

    ' Limiti orizzontali interni al cerchio
    xLeft = cx - r + sq
    xRight = cx + r - sq

    w = xRight - xLeft

    ' Soglie di transizione (non perfettamente equidistanti se analogico)
    s1 = xLeft + w * .2
    s2 = xLeft + w * .4
    s3 = xLeft + w * .6
    s4 = xLeft + w * .8

    x = xLeft
    w = 5

    DO WHILE x < xRight

        ' Aggiornamento larghezza bande in base alla posizione
        IF x >= s1 THEN w = 4
        IF x >= s2 THEN w = 3
        IF x >= s3 THEN w = 2
        IF x >= s4 THEN w = 1

        ' Evita di sforare il bordo destro
        IF x + w - 1 > xRight THEN
            w = xRight - x + 1
        END IF
       
        ' Banda bianca
        LINE (x, yTop)-(x + w - 1, yBot), 15, BF
        
        ' Avanza: banda bianca + banda nera (stessa larghezza)
        x = x + 2 * w
        
    LOOP

END SUB

SUB InCircle6colorAreas

    ' --- Limiti verticali della fascia ---
    yTop = cy - 2.5 * sq
    yBot = cy - .5 * sq

    ' --- Calcolo dei limiti orizzontali fissi ---
    xM = r / 3
    xMleft = cx - r + xM
    xMright = cx + r - xM

    ' --- Ciclo verticale per riempire giallo e blu ---
    FOR y = yTop TO yBot
        CircleIntersections y, x1, x2

        ' Giallo (area sinistra)
        LINE (x1, y)-(xMleft, y), 14

        ' Blu (area destra)
        LINE (xMright, y)-(x2, y), 1
    NEXT y

    ' --- Aree centrali rettangolari (4 colori) ---
    ' Calcolo larghezza totale interna
    wTot = xMright - xMleft
    stepX = wTot / 4

    ' Verde
    LINE (xMleft, yTop)-(xMleft + stepX, yBot), 2, BF

    ' Ciano
    LINE (xMleft + stepX, yTop)-(xMleft + 2 * stepX, yBot), 3, BF

    ' Magenta
    LINE (xMleft + 2 * stepX, yTop)-(xMleft + 3 * stepX, yBot), 5, BF

    ' Rosso
    LINE (xMleft + 3 * stepX, yTop)-(xMright, yBot), 4, BF

END SUB

SUB InCircleBGBar

    ' Distanze verticali
    yTop = cy - 3.5 * sq
    yBot = cy - 2.5 * sq

    CircleIntersections yTop, x1, x2
   
    stepX = (x2 - x1) / 14
   
    ' Rettangoli grigi
    FOR i = 0 TO 13 STEP 2
        x = x1 + i * stepX
        LINE (x, yTop)-(x + stepX - 1, yBot - 1), 7, BF
    NEXT i

    ' Spicchio grigio
    FOR y = yTop TO yBot
        CircleIntersections y, x1, x2
        LINE (x + 2 * stepX, y)-(x2, y), 7
    NEXT y

END SUB

SUB InCircleBotArea
   
    yTop = cy + 3.5 * sq
    yBot = cy + 4.5 * sq
   
    FOR i = yTop TO yBot
        CircleIntersections i, x1, x2
        LINE (x1, i)-(x2, i), 15
    NEXT

    ' Yellow Areas
    FOR i = yBot TO cy + r
        CircleIntersections i, x1, x2
        LINE (x1, i + 1)-(x2, i + 1), 14
    NEXT

    ' Red area a distanza 6 celle
    yRA = cy + 6 * sq + 1
    FOR i = yRA TO cy + r
        CircleIntersections i, x1, x2
        LINE (x1, i + 1)-(x2, i + 1), 4
    NEXT
    CircleIntersections yRA, x1, x2
    LINE (cx - .5 * sq, yRA)-(cx + .5 * sq, cy + 4.5 * sq), 4, BF
   
    ' Reflection check
    LINE (cx - 3 * sq, yBot)-(cx + 3 * sq, yBot - sq), 0, BF
 
    ' Spillo
    LINE (cx - 2.5 * sq, yBot)-(cx - 2.5 * sq, yBot - sq), 15
    
END SUB

SUB InCircleGraysBar

    ' Limiti verticali della zona
    yTop = cy + 2.5 * sq
    yBot = cy + 3.5 * sq

    ' Limiti orizzontali interni al cerchio
    xLeft = cx - r + 2 * sq
    xRight = cx + r - 2 * sq

    stepX = (xRight - xLeft) / 4

    ' Colorazione delle 4 zone
    DIM clr(0 TO 3)
    clr(0) = 10: p10 = INT(63 * .2)
    clr(1) = 8
    clr(2) = 7
    clr(3) = 11: p11 = INT(63 * .8)
    PALETTE 10, p10 + p10 * 256 + p10 * 65536
    PALETTE 11, p11 + p11 * 256 + p11 * 65536
    FOR i = 0 TO 3
        x = xLeft + i * stepX
        LINE (x, yTop)-(x + stepX, yBot), clr(i), BF
    NEXT i
    
END SUB

SUB InCircleMidArea

    ' Banda verticale croce
    LINE (cx - sq / 2, cy - 1.5 * sq)-(cx + sq / 2, cy + 1.5 * sq), 0, BF

    ' linea vericale
    LINE (cx, cy - 1.5 * sq)-(cx, cy + 1.5 * sq)

    ' Linea centrale (diametro)
    LINE (cx - r, cy)-(cx + r, cy), 15

    ' Linee trasversali
    FOR i = 3 TO 14
        LINE (i * sq, cy - .5 * sq + 1)-(i * sq, cy + .5 * sq - 1), 15
    NEXT

END SUB

SUB InCircleTopArea
   
    yBot = cy - 4.5 * sq

    FOR i = cy - r TO yBot
        CircleIntersections i, x1, x2
        LINE (x1, i)-(x2, i), 15
    NEXT
    
    ' Reflection check
    LINE (cx - 3 * sq, yBot)-(cx + 3 * sq, yBot + sq), 15, BF

    ' Spillo
    LINE (cx - 2.5 * sq, yBot)-(cx - 2.5 * sq, yBot + sq), 0

    ' Low frequency check
    LINE (cx - 2 * sq, yBot)-(cx + 2 * sq, yBot - sq), 0, BF
    
END SUB

SUB InGrid8color

    FillCellRange 2, 2, 2, 6.5, 2      ' verde PROVVISIORIO
    FillCellRange 2, 7.5, 2, 12, 12    ' rosso intenso PROVVISIORIO
                                  
    FillCellRange 3, 2, 3, 3, 9        ' blu intenso
    FillCellRange 3, 11, 3, 12, 6      ' ocra

    FillCellRange 16, 2, 16, 6.5, 2    ' verde PROVVISIORIO
    FillCellRange 16, 7.5, 16, 12, 13  ' magenta intenso PROVVISIORIO

    FillCellRange 15, 2, 15, 3, 9      ' blu intenso
    FillCellRange 15, 11, 15, 12, 6    ' ocra

END SUB

