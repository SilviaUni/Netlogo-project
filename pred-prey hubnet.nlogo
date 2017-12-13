; Black screen in the interface tab: the Netlogo world, made up of agents.
; Agents types: observer, patches, turtles
; observer: he sees everything and he can change a variable in an observer (global) context.
; patches: the world is divided in several small square called patches. Patches can't move and they are identified with coordinates.
; turtles: the observer or patches can create turtles. They can move and they are identified by a number.
; Agents variables: location where the values are stored.
; Agents variables types: global, patch, turtle, link, local.







breed [predators predator]
;Creation of the predator breed, a new type of turtles.
breed [prey a-prey]
;Creation of the prey breed, another new type of turtles.
;students type pf variable to be able to amke a connection to hubnet
breed [students student]
predators-own[RPenergy dist P-age]
;Creation of 4 turtle variables for predators.
prey-own[RNenergy dist N-age]
;Creation of 3 turtle variables for prey.
globals [predators-dead prey-dead Nborn Pborn Nfactorsize Pfactorsize x y c1 c2]
;Creation of 6 globals variables.


;Sense of the names:
;predators-own:
;RPenergy    <-> energy that need Predator to Reproduce.
;dist        <-> distance between a predator and a prey
;P-age       <-> age in computer language (number of ticks) of the Predators

;prey-own:
;RNenergy    <-> energy that need prey to Reproduce.
;dist        <-> distance between a predator and a prey
;N-age       <-> age in computer language  (number of ticks) of the Prey


;globals: create in the Code
;predators-dead   <-> number of predators who are dead since the beginning of the simulation
;prey-dead        <-> number of prey who are dead since the beginning of the simulation
;Nborn            <-> number of prey who are born since the beginning of the simulation
;Pborn            <-> number of Predator who are born since the beginning of the simulation
;Nfactorsize      <-> a number to keep a value near 11 for the size of the prey whatever their energy.
;Pfactorsize      <-> a number to keep a value near 11 for the size of the Predators whatever their energy.

;globals: create in the Interface Buttons
;predators-number_initial
;Nspeed
;Nspeed
; etc ...

;students have an id and a step-size
students-own
[
  user-id
  step-size
]

;listening to clients for every tick


;listening for clients
to listen-clients
  while [
    hubnet-message-waiting?
   ]
  [
    hubnet-fetch-message
    ifelse hubnet-enter-message?
    [
      create-new-student
    ]
    [
      ifelse hubnet-exit-message?
      [
        remove-student
      ]
      [
        ask students with
        [
          user-id = hubnet-message-source
         ]
        [
          execute-command hubnet-message-tag
        ]
      ]
    ]
  ]
end

;creating a new user/player
to create-new-student
  create-students 1
  [
    set user-id hubnet-message-source
    set label user-id
    set step-size 1
    set breed predator 1
          set color black
          set breed a-prey 1
          set color white
          display
    set size 1
  ]
end

;removing an existing user/player
to remove-student
  ask students with
  [
    user-id = hubnet-message-source
  ]
  [
    die
  ]
end

;executing commands
to execute-command [command]
  if command = "step-size"
  [
    set step-size hubnet-message
    stop
  ]
  if students = 2
  [
    show "no more players allowed"
  ]
end

;make a move command
to execute-move [new-heading]
  set heading new-heading
  fd step-size
end

;hubnet activities
to startup
  hubnet-reset
end

to setup
   ;run the following code in the bottom named setup of the interface
   no-display
   ;don't display the following code on the black screen
   clear-all
   ;remove all the world
   setup-world-shape
   ;create a procedure named setup-world-shape to clarify the code: the code in this procedure change the shape of the world.
   setup-landscape
   ;create a procedure named setup-landscape to clarify the code which will create the landscape of the world.
   setup-predators
   ;create a procedure named setup-predators which will create the predators
   setup-prey
   ;create a procedure named setup-prey which will create the prey
   reset-ticks
   ;ticks <- 0
   display
   ;display the following code on the black screen
end

to setup-world-shape
;run the following code in -to setup-
;   set-patch-size 0.00000000000001
   ;the size of patches is now 0.00000000000001
 end

to setup-landscape
;run the following code in -to setup-
   ask patches with [pxcor > -170 and pxcor < 60 and pycor > -50 and pycor < 50] [ask turtles-here [set hidden? true]]
   ;the turtles precedently create are hidden from the black screen if they are situated in the center of the black screen, it's for the red sentence "sorry, you are dead" can be clearly lisible.
   ask patches [set pcolor green]
   ;the observer asks patches to turn green
end




to setup-predators
;run the following code in -to setup-
   set-default-shape predators "wolf"
   ;a predator will have a wolf shape by default.
   set Pfactorsize 1 + abs (predators-energy_to-reproduce - 10) / 5
   ;Pfactorsize = valeur absolue de ("predators-energy_to-reproduce" - 10) / 10
   create-predators predators-number_initial [setxy random-xcor random-ycor
                                         set color black
                                         set RPenergy 1
                                         set P-age random (15 + round (random (3) - random (3))) * 100
                                         set size 12 + RPenergy * Pfactorsize]
;create "predators-number_initial" turtles type predators [of random coordinate in the world
                                                          ;with a black color
                                                          ;with the minimum value of energy
                                                          ;with a random value of P-age in [0, ("predators-energy_to-reproduce" + or - a random value in [0, 4]) * 100]
                                                          ;with the size = 12 + RPenergy * Pfactorsize]

end




to setup-prey
;run the following code in -to setup-
    set-default-shape prey "sheep"
    ;a prey will have a sheep shape by default.
    set Nfactorsize 1 + abs (prey-energy_to-reproduce - 10) / 5
    ;Nfactorsize = valeur absolue de ("sheep-energy_to-reproduce" - 10) / 10
    create-prey prey-number_initial [setxy random-xcor random-ycor
                                        set color white
                                        set RNenergy 1
                                        set N-age random (15 + round (random (3) - random (3))) * 100
                                        set size 11 + RNenergy * Nfactorsize]
     ;create "prey-number_initial" turtles type prey [of random coordinate in the world
                                                ;with a white color
                                                ;with the minimum value of energy
                                                ;with a random value of N-age in [0, ("prey-energy_to-reproduce" + or - a random value in [0, 14]) * 100]
                                                ;size <- 11 + RNenergy * Nfactorsize]
 end


to GO
  listen-clients
  every 0.1
  [
    update-plots
    tick
  ]
  if ticks > max-time [stop]
;run the following code in the bottom named GO of the interface
   GO-movement
   ;create a procedure named GO-movement to clarify the code
   GO-Reproduction
   ;create a procedure named GO-R to clarify the code
   GO-death
   ;create a procedure named GO-death to clarify the code
   if count prey = 0 [clear-output
                      output-print "All the prey are dead."
                      output-print "The simulation is finished."
                      stop]
   ;stop the simulation if all the prey are dead
   if count predators = 0 [clear-output
                           output-print "All the predators are dead."
                           output-print "The simulation is finished."
                           stop]
   ;stop the simulation if all the predators are dead
   if ticks = 3 [clear-output]
   ;clear the text message in the Interface tab if the number of ticks is egal to 3
   tick
   ;ticks <- ticks + 1
end




to GO-movement
;run the following code in -GO-
   foreach sort predators [ ?1 -> ask prey [set dist distance ?1]
                           ask prey with-min [dist][ifelse dist < search-radius *  15
                                                          [ifelse dist < catch-dist  * 15
                                                                [set color red
                                                                ask ?1 [set RPenergy RPenergy + 1]]
                                                                [ask ?1 [face one-of prey with-min [dist]
                                                                        lt random 25 rt random 25
                                                                        forward Pspeed]]]
                                                    [ask ?1 [right random 50
                                                            left random  50
                                                            forward Pspeed
                                                            ]]]
                           ask ?1 [set P-age P-age + 1
                                  set size 12 + RPenergy * Pfactorsize ] ]
   ;foreach item in the list [(predator 0) (predator 1) (predator 2) ... (the last predator)] [ask all the prey [dist <- distance between predator 0 and them (dist is a prey variable like size but introduced by me in the code), ? take the value (predator 0) and run all the code in the [] of foreach sort prey [] then ? <- (predator 1) and repeat again all the code in the [] of foreach sort prey [], and so on]
                                                                                              ;ask prey which has the minimum dist [if dist of this prey < search-radius * catch-dist (in this case there is a single value possible of the minimum dist because the world is big, I can't wrote ask a-prey with-min [] because with-min works with agentset only)
                                                                                              ;[if dist < catch-dist
                                                                                              ;[the prey turns red
                                                                                               ;if the switcher blood in the interface tab is on On [creation of the local variable x which exists just in this [] and take a random value in [0, 1]
                                                                                              ;ask patches in the radius (3 + random 4)[take a color (red - x - 2)], pcolor is the color variable of patches, for turtles it's just color]
                                                                                             ;ask predator 0 [set his value of RPenergy to the value RPenergy + 1, when I create the Predator variable RPenergy, it takes the value 0 by default. So this variable counts the number of prey that have ate each predators.]]
                                                                                              ;[if dist < catch-dist is wrong, ask predator 0 [turn toward one of the prey which have the minimum value of dist by changing his variable called heading, I have to introduce one-of because even if prey with-min [dist] is an agentset which contains only one item, it's still an agentset and face can't accept agenset.
                                                                                                ;move forward Pspeed patch]]]
                                                                                                ;[if dist of this prey < search-radius is wrong, ask predator 0 [turn toward right with a random degree in [0, 49] <-> heading <- heading + random 50
                                                                                                                                                                                                                                         ;turn toward left with a random degree in [0, 49] <-> heading <- heading - random 50
                                                                                                                                                                                                                                         ;move forward Pspeed patch

                                                                                              ;ask predator 0 [set P-age P-age + 1
                                                                                                              ;set size 12 + RPenergy * Pfacorize (more predator 0 has energy, more he is big)]]
   foreach sort prey [ ?1 -> ask predators [set dist distance ?1]
                      ask predators with-min [dist] [ifelse dist < prey-dodge-radius * 4 + 11
                                                             [ask ?1 [set heading [heading] of one-of predators with-min [dist] lt random 35 rt random 35  fd Nspeed ]]
                                                             [ask ?1 [right random 50
                                                                     left random  50
                                                                     forward Nspeed]]]
                      ask prey with [distance ?1 < 100] [ifelse prey-dd = 0
                                                             []
                                                             [ifelse (distance ?1 < 10) and (RNenergy >=  1)
                                                                      [ask ?1 [ set RNenergy RNenergy - 0.05 * (1 + prey-dd)]]
                                                                      [ifelse (distance ?1 < 30) and (RNenergy  >=  1 )
                                                                            [ask ?1 [ set RNenergy RNenergy - 0.0025 *(1 + prey-dd)]]
                                                                            [ifelse (distance ?1 < 50) and (RNenergy   >=  1)
                                                                                  [ask ?1 [ set RNenergy RNenergy - 0.0017 *(1 + prey-dd)]]
                                                                                  [ifelse (distance ?1 < 100) and (RNenergy   >=  1)
                                                                                        [ask ?1 [ set RNenergy RNenergy - 0.0013 *(1 + prey-dd)]]
                                                                                        [set size 11 ]]]]]]
                      ask ?1 [set RNenergy RNenergy + 0.1
                             set N-age N-age + 1
                             set size 11 + (RNenergy  * Nfactorsize) ] ]
   ;foreach item in the list [(prey 0) (prey 1) (prey 2) ... (the last prey)][for each predator, their value of dist take the value of the distance between them and ? (? refers to an item in the list)
                                                                             ;[ask each predator who has the minimum distance with them and ? [if this distance is inferior to prey-dodge-radius * catch-dist
                                                                                                                                                 ;[the prey run away, if random 100 > 97.7, the predator who hunts him moves slowly in a random way for a while and the prey succeded his run-away] ]
                                                                                                                                                 ;[if not the prey move in a random way.]
                                                                             ;if prey-dd = 0 then nothing is done , if not then more they are prey near ?, more the RNenergy of ? decreases. if RNEnergy < 1 of ? then Rnenergy <- 1.
                                                                             ;ask prey ? [;set RNenergy RNenergy + 0.1 (imagine it's the energy taken by prey from grass)
                                                                                          ;set N-age N-age + 1
                                                                                          ;set size 12 + RNenergy * Nfacorize (more predator 0 has energy, more he is big)]]
end


to GO-death
;run the following code in -GO-
    foreach sort prey [ ?1 -> ask ?1 [if (color = red) [ask ?1 [set prey-dead  prey-dead +  1
                                                                      die]]] ]
   ;prey-dead count the number of prey who are dead since the begining of the simulation, this code is used in the monitor "Prey number dead" in the Interface tab.
   foreach sort predators[ ?1 -> ask ?1 [if  random-float 101 < predators-probability-die [ask ?1 [set predators-dead predators-dead + 1
           die]]] ]
   ;predators-dead count the number of prey who are dead since the begining of the simulation, this code is used in the monitor "Predators number dead" in the Interface tab.
end




to GO-Reproduction
;run the following code in -GO-
   foreach sort predators [ ?1 -> if [predators-energy_to-reproduce] of ?1 < [RPenergy] of ?1 [ask ?1 [hatch 1 [set P-age 0
                                                                                                      set RPenergy 1
                                                                                                      set Pborn Pborn + 1]
                                                                                      set RPenergy 1]] ]
   foreach sort prey [ ?1 -> if [prey-energy_to-reproduce ] of ?1 < [RNenergy] of ?1 [ask ?1 [hatch 1 [set N-age 0
                                                                                             set RNenergy 1
                                                                                             set Nborn Nborn + 1
                                                                                             set label ""
                                                                                             set label-color 33]
                                                                                    set RNenergy 1]] ]
  ;hatch: a new turtle born in the same place of its parent, its caracteristics are the same of the parent by default. The structure of the procedure hatch is:  hatch [change caracteristics of this baby].
  ;the code: set label "" allow a-prey (predators-number_initial + 23) to hatch one prey without your name in label.
end
@#$#@#$#@
GRAPHICS-WINDOW
680
10
1596
826
-1
-1
1.008
1
10
1
1
1
0
0
0
1
0
900
0
800
0
0
1
timesteps
30.0

BUTTON
395
150
505
210
setup
setup\n\n;setup: button to initialize the world,\n;run the code related to \"to setup\"\n;in the tab \"code\"
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
504
150
664
215
Start/Stop
GO\n\n;GO: button to start the simulation:\n;run the code related to \"to GO\" in the tab \"code\".\n\n;forever (checked): the code related to \"to GO\"\n;runs in loop until you click again on GO.\n\n;Disable until ticks start(checked):\n;prevent the user to start the simulation without\n;initialize the world (the ticks starts by taking\n;any value and the code related to \"to setup\"\n;put the value 0 to tick).
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
5
65
190
98
Pspeed
Pspeed
0
100
16.5
0.1
1
NIL
HORIZONTAL

SLIDER
200
65
383
98
Nspeed
Nspeed
0
100
47.0
0.1
1
NIL
HORIZONTAL

SLIDER
5
200
190
233
predators-energy_to-reproduce
predators-energy_to-reproduce
2
10
6.3
0.1
1
NIL
HORIZONTAL

SLIDER
200
200
383
233
prey-energy_to-reproduce
prey-energy_to-reproduce
2
10
2.0
0.1
1
NIL
HORIZONTAL

SLIDER
5
150
190
183
catch-dist
catch-dist
0
20
1.3
0.1
1
NIL
HORIZONTAL

SLIDER
5
117
190
150
search-radius
search-radius
0
20
3.3
0.1
1
NIL
HORIZONTAL

SLIDER
200
117
383
150
prey-dodge-radius
prey-dodge-radius
0
20
16.9
0.1
1
NIL
HORIZONTAL

SLIDER
5
10
190
43
predators-number_initial
predators-number_initial
1
200
14.0
1
1
NIL
HORIZONTAL

SLIDER
200
10
383
43
prey-number_initial
prey-number_initial
1
200
117.0
1
1
NIL
HORIZONTAL

PLOT
5
275
365
395
Number of predators
time (ticks)
Number 
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"predators" 1.0 0 -2674135 true "" "plot count predators"

PLOT
360
635
520
760
Predators energy 
Predators energy 
Frequency
10.0
10.0
0.0
3.0
true
false
"set-plot-x-range 0 (predators-energy_to-reproduce )\nset-plot-y-range 0 10" ""
PENS
"default" 0.1 1 -2674135 true "" "histogram [RPenergy] of predators"

PLOT
520
635
680
760
Prey energy 
Prey energy 
Frequency 
0.0
10.0
0.0
10.0
true
false
"set-plot-x-range 0 (prey-energy_to-reproduce)\nset-plot-y-range 0 10" ""
PENS
"default" 0.1 1 -16777216 true "" "histogram [RNenergy] of prey"

SLIDER
200
160
383
193
prey-dd
prey-dd
0
1
0.8
0.1
1
NIL
HORIZONTAL

MONITOR
390
460
516
505
Predators number
count predators
17
1
11

MONITOR
526
458
652
503
Prey number
count prey
17
1
11

MONITOR
390
504
516
549
Predators number dead
predators-dead
17
1
11

MONITOR
526
503
652
548
Prey number dead 
prey-dead
17
1
11

MONITOR
390
546
516
591
Predators born
Pborn
17
1
11

MONITOR
526
548
652
593
Prey born
Nborn
17
1
11

SLIDER
5
230
190
263
predators-probability-die
predators-probability-die
0
1
0.55
0.01
1
NIL
HORIZONTAL

TEXTBOX
198
233
348
251
__
11
0.0
1

TEXTBOX
222
236
372
277
Probability (in %) that each predator will die in any time-step.
10
0.0
1

MONITOR
460
410
610
455
Timesteps elapsed
ticks
17
1
11

TEXTBOX
395
65
680
166
1. Click 'setup' to initialize a simulation.\n2. Click 'Settings...' (above) to set boundaris and dimensions of the arena.\n3. Click Start/Stop to run or stop a simulation.\n\n
14
0.0
1

TEXTBOX
206
238
356
256
>
11
0.0
1

TEXTBOX
205
233
355
251
_
11
0.0
1

OUTPUT
395
210
665
350
12

TEXTBOX
413
16
673
40
Use this slider to choose the speed of the simulation.  
10
0.0
1

TEXTBOX
396
12
546
30
_
11
0.0
1

TEXTBOX
388
12
431
30
_
11
0.0
1

TEXTBOX
399
17
444
35
>
11
0.0
1

TEXTBOX
387
10
602
28
|
11
0.0
1

PLOT
5
510
364
850
 Number of predators versus number of prey 
Number of prey
Number of predators
0.0
10.0
0.0
10.0
true
false
"" "plotxy count prey count predators"
PENS
"pen-0" 1.0 0 -13345367 true "" ""

INPUTBOX
460
350
610
410
max-time
10000.0
1
0
Number

PLOT
5
390
365
510
Number of prey
Time (ticks)
Number
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count prey"

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
NetLogo 6.0.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
SLIDER
15
20
215
53
Specie Speed
Specie Speed
0.0
100.0
0
1.0
1
NIL
HORIZONTAL

SLIDER
10
70
212
103
Specie dodge/catch radious
Specie dodge/catch radious
0.0
100.0
0
1.0
1
NIL
HORIZONTAL

SLIDER
10
120
215
153
Initial number of species
Initial number of species
0.0
100.0
0
1.0
1
NIL
HORIZONTAL

SLIDER
10
170
210
203
Energy to reproduce
Energy to reproduce
0.0
100.0
0
1.0
1
NIL
HORIZONTAL

MONITOR
250
20
380
69
Number of preys
NIL
3
1

MONITOR
250
75
380
124
Number of predators
NIL
3
1

BUTTON
255
170
355
203
Make a move
NIL
NIL
1
T
OBSERVER
NIL
M

VIEW
420
10
1321
811
0
0
0
1
1
1
1
1
0
1
1
1
0
900
0
800

PLOT
-5
220
195
370
Number of predators
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

PLOT
205
220
405
370
Number of prey
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

PLOT
-5
400
195
550
Predators energy 
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

PLOT
205
400
405
550
Prey energy 
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

PLOT
55
560
375
725
 Number of predators versus number of prey 
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
1
@#$#@#$#@
