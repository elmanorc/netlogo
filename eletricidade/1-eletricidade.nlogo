; phet
breed [ atomos atomo ] ; também pode representar um íon
breed [ eletrons eletron ] ; apenas representa eletros

globals [
  eq ; carga do eletron
;;  velo-saida ; a velocidade com a qual um eletron sai de um atomo (agora ion)
  pot1 pot2  pot3 pot4 pot5
  potenciais
  ;carga-eletron ; a carga de um eletron!
  ;massa-eletron ; massa de um eletron
  massa-fe ; massa de um atomo de ferro
  k ; uma constante, para todos os elétrons
  ;k0 ;  a constante eletrostatica
  ;tick-part ; parte da tick executada depois de cada momento
]

atomos-own [
  potencial ; energia necessaria para ceder ume eletron
  eletrons-perdidos
]

eletrons-own [
  velocidade-x
  velocidade-y
  eletrons-perdidos
  father-atom
]

to setup
  clear-all
  
  ; para que o programa sempre gere os mesmos resultados!
  random-seed 100
 ; set tick-part 1
  
  
  ; valores e constantes
  ; que podemos mudar
;  set velo-saida 1.5
;  set k0 3
;  set carga-eletron -1
  
  
  ; inspirado nos potenciais do ferro
  set pot1 7.625
  set pot2 15.61
  set pot3 60.00
  set pot4 60.00
  set pot5 60.00
  
  set potenciais ( list 7.625 15.61 60.00 )
  
  ; formas e questões de visualização
  set-default-shape atomos "circle"
  set-default-shape eletrons "circle"
  
  ; crie átomos de forma organizada
  setup-atoms-square
  
  set k k0 * carga-eletron / massa-eletron ; permite que o usuário mude esse valores enquanto o modelo está em execução
    
  reset-ticks
end

to go

  ask eletrons [ go-eletrons ]
  ask atomos [  go-atomos ]
  tick-advance tick-part
  update-plots
  display
end

; lancem eletrons!
; e coma-os!
to go-atomos
  
  foreach sort eletrons in-radius 1.4 [
    ask ? [ die ]
    set eletrons-perdidos eletrons-perdidos - 1
    reset-potencial
  ]
  
  if ( (random 1500) / 100) > potencial [ ; veja isso aqui, tick-part esquisito
    let father self
    ask patch pxcor pycor [
      sprout-eletrons 1 [
        let ang random 360
        set velocidade-x velo-saida * cos ang * tick-part
        set velocidade-y velo-saida * sin ang * tick-part
        set size 0.6
        set color yellow
        set eletrons-perdidos -1
        forward 1.5
        let a velocidade-x
        set velocidade-x velocidade-y
        set velocidade-y a
        set velocidade-y ( - velocidade-y )
        ; definindo pai
        set father-atom father
      ]
    ]
    set eletrons-perdidos eletrons-perdidos + 1
    reset-potencial
  ]
end

; movam-se "desordenadamente"
; sejam atraido pelos cations
; fujam dos outros eletrons
; sejam englobados pelos atomos, se for o caso
to go-eletrons
  ; agora vamos calcular a aceleracao
  let ace-int-x 0
  let ace-int-y 0
  
;  foreach sort atomos [
;    let dist distance ?
;    if dist != 0
;    [ 
;      let intensidade ( k * [ carga ] of ? ) / (dist * dist) 
;      face ?
;      let ang towards ?
;      let int-x  intensidade * sin ang
;      let int-y  intensidade * cos ang
;      set ace-int-x ace-int-x + int-x
;      set ace-int-y ace-int-y + int-y
;    ]
;  ]
  
   foreach sort ( turtle-set other eletrons atomos ) [
     let dist distance ?
     if dist != 0
     [ 
       let intensidade ( k * carga-eletron ) / (dist * dist) 
       face ?
       let ang towards ?
       let int-x (  intensidade * sin ang )
       let int-y (  intensidade * cos ang )
       set ace-int-x ace-int-x + int-x
       set ace-int-y ace-int-y + int-y
     ]
   ]
  
  if ace-int-x != 0 or ace-int-y != 0
  [
    set velocidade-x velocidade-x + ace-int-x 
    set velocidade-y velocidade-y + ace-int-y
  ]
  
  ; para o tick-part
  set velocidade-x velocidade-x  * tick-part
  set velocidade-y velocidade-y  * tick-part
  
  setxy xcor + ( velocidade-x * tick-part ) ycor + ( velocidade-y * tick-part )
end

to-report carga
  report eletrons-perdidos * ( - carga-eletron )
end

to reset-potencial
  
  ifelse eletrons-perdidos < 0
    [ set potencial -1 ] [
  ifelse eletrons-perdidos < length potenciais 
    [ set potencial item eletrons-perdidos potenciais ]
    [ set potencial 60 ] ]
;    ifelse eletrons-perdidos = 0 [
;      set potencial pot1
;    ] [ ifelse eletrons-perdidos = 1 [
;      set potencial pot2
;    ] [ ifelse eletrons-perdidos = 2 [
;      set potencial pot3
;    ] [ ifelse eletrons-perdidos = 3 [
;      set potencial pot4
;    ] [ ifelse eletrons-perdidos = 4 [
;      set potencial pot5
;    ] [ 
;      set potencial eletrons-perdidos
;    ] ] ] ] ]
end

to-report calc-dist [ a b ]
  let d 0
  ask a [
    set d distance b
  ]
  report d
end

to setup-atoms-square
  ask patches with [ pxcor > ( - ( iron-size / 2 ) ) and pxcor < ( iron-size / 2 ) and pycor > ( - ( iron-size / 2 ) ) and pycor < ( iron-size / 2 ) ] [
    if remainder pxcor distance-between-atoms = 0 and remainder pycor distance-between-atoms = 0 [
      sprout-atomos 1 [
        set potencial pot1
        set color grey
        set size 3
      ]
    ]
  ]
end

to-report mean-distance-atoms
  if not any? eletrons [ report 0 ]
  report mean [ distance father-atom ] of eletrons
end
@#$#@#$#@
GRAPHICS-WINDOW
2
10
1035
1064
100
100
5.09
1
10
1
1
1
0
1
1
1
-100
100
-100
100
1
1
1
ticks
30.0

BUTTON
1117
332
1190
365
NIL
setup\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1049
331
1112
364
NIL
go\n
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
1196
332
1286
365
go-once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1085
535
1253
568
k0
k0
0
100
1000000000
1
1
NIL
HORIZONTAL

SLIDER
1083
577
1255
610
tick-part
tick-part
1e-2
1
1.0E-6
1e-2
1
NIL
HORIZONTAL

SLIDER
1089
636
1261
669
velo-saida
velo-saida
0
100
100
1
1
NIL
HORIZONTAL

SLIDER
1087
682
1259
715
massa-eletron
massa-eletron
0
100
1.0E-4
1
1
NIL
HORIZONTAL

SLIDER
1101
735
1273
768
carga-eletron
carga-eletron
0
100
1
1
1
NIL
HORIZONTAL

SLIDER
1094
418
1266
451
iron-size
iron-size
0
100
100
1
1
NIL
HORIZONTAL

SLIDER
1090
487
1325
520
distance-between-atoms
distance-between-atoms
0
100
12
1
1
NIL
HORIZONTAL

PLOT
1056
138
1256
288
distance from father
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot mean-distance-atoms"

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="30"/>
    <metric>mean map [ calc-dist atomo 0 ? ] sort eletrons</metric>
    <enumeratedValueSet variable="tick-part">
      <value value="0.02"/>
    </enumeratedValueSet>
    <steppedValueSet variable="k0" first="0" step="1000" last="10000"/>
    <steppedValueSet variable="velo-saida" first="0" step="100" last="1000"/>
  </experiment>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="25"/>
    <metric>mean map [ calc-dist atomo 0 ? ] sort turtles</metric>
    <steppedValueSet variable="tick-part" first="1.0E-4" step="1.0E-4" last="0.01"/>
    <enumeratedValueSet variable="k0">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="velo-saida">
      <value value="1000000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="25"/>
    <metric>mean map [ calc-dist atomo 0 ? ] sort eletrons</metric>
    <enumeratedValueSet variable="tick-part">
      <value value="0.1"/>
      <value value="0.01"/>
      <value value="0.001"/>
      <value value="1.0E-4"/>
      <value value="1.0E-5"/>
      <value value="1.0E-6"/>
      <value value="1.0E-7"/>
      <value value="1.0E-8"/>
      <value value="1.0E-9"/>
      <value value="1.0E-10"/>
      <value value="1.0E-11"/>
      <value value="1.0E-12"/>
      <value value="1.0E-13"/>
      <value value="1.0E-14"/>
      <value value="1.0E-15"/>
      <value value="1.0E-16"/>
      <value value="1.0E-17"/>
      <value value="1.0E-18"/>
      <value value="1.0E-19"/>
      <value value="1.0E-20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="k0">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="velo-saida">
      <value value="1000000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="tick-part-1e-5" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="25"/>
    <metric>mean map [ calc-dist atomo 0 ? ] sort eletrons</metric>
    <steppedValueSet variable="tick-part" first="1.0E-5" step="1.0E-6" last="1.0E-4"/>
    <enumeratedValueSet variable="k0">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="velo-saida">
      <value value="1000000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="massa" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>mean map [ calc-dist atomo 0 ? ] sort eletrons</metric>
    <steppedValueSet variable="massa-eletron" first="0.5" step="0.01" last="1.15"/>
    <enumeratedValueSet variable="velo-saida">
      <value value="1000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tick-part">
      <value value="1.0E-6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="k0">
      <value value="1000000"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="1"/>
    <metric>mean distance-to-father-atoms</metric>
    <steppedValueSet variable="distance-between-atoms" first="5" step="1" last="30"/>
    <enumeratedValueSet variable="k0">
      <value value="1000000000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="carga-eletron">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="velo-saida">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="massa-eletron">
      <value value="1.0E-4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="tick-part">
      <value value="1.0E-6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="iron-size">
      <value value="100"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
