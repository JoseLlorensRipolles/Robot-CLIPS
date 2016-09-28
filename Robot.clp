(deffacts facts
	(Mapa 5 4 Mill 2 3 MaxB 3))

(defglobal ?*nod-gen* = 0)

(deffunction inicio ()
	(reset)
	(assert (Robot 1 3 0 Lamp 3 4 3 Lamp 4 2 2 Lamp 5 4 2 TotalB 7 Nivel 0 Mov init))
	(assert (Max-depth 30))
	)

(defrule moveUp
	(Mapa ?mx ?my $?)
	?f<-(Robot ?rx ?ry $?aux Nivel ?n Mov ?mov)
	(Max-depth ?maxD)
	(test (neq ?mov moveDown))
	(test (< ?n ?maxD))
	(test (< ?ry ?my))
=>
	(assert  (Robot ?rx (+ ?ry 1) $?aux Nivel (+ ?n 1) Mov moveUp))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
	)

(defrule moveDown
	(Mapa ?mx ?my $?)
	(Robot ?rx ?ry $?aux Nivel ?n Mov ?mov)
	(Max-depth ?maxD)
	(test (neq ?mov moveUp))
	(test (< ?n ?maxD))
	(test (> ?ry 1))
=>
	(assert  (Robot ?rx (- ?ry 1) $?aux Nivel (+ ?n 1)  Mov moveDown))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
	)

(defrule moveLeft
	(Mapa ?mx $?)
	(Robot ?rx $?aux Nivel ?n Mov ?mov)
	(Max-depth ?maxD)
	(test (neq ?mov moveRight))
	(test (< ?n ?maxD))
	(test (> ?rx 1))
=>
	(assert (Robot (- ?rx 1) $?aux Nivel (+ ?n 1)  Mov moveLeft))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
	)

(defrule moveRight
	(Mapa ?mx $?)
	(Robot ?rx $?aux Nivel ?n Mov ?mov)
	(Max-depth ?maxD)
	(test (neq ?mov moveLeft))
	(test (< ?n ?maxD))
	(test (< ?rx ?mx))
=>
	(assert (Robot (+ ?rx 1) $?aux Nivel (+ ?n 1)  Mov moveRight))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule chargeB
	(Mapa $? Mill ?mx ?my MaxB ?maxB)
	(Robot ?rx ?ry ?rb $?aux Nivel ?n Mov ?mov)
	(Max-depth ?maxD)
	(test (< ?n ?maxD))
	(test (and (= ?rx ?mx) (= ?ry ?my)))
	(test (< ?rb ?maxB))
=>
	(bind ?a (- ?maxB ?rb))
	(bind ?b (random 1 ?a))
	(assert (Robot ?rx ?ry (+ ?rb ?b) $?aux Nivel (+ ?n 1)  Mov chargeB))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
	)

(defrule repairLamp
	(Robot ?rx ?ry ?rb $?aux1 Lamp ?lx ?ly ?lb $?aux2 TotalB ?totB Nivel ?n Mov ?mov)
	(Max-depth ?maxD)
	(test (< ?n ?maxD))
	(test (and (= ?rx ?lx) (= ?ry ?ly)))
	(test (>= ?rb ?lb))
=>
	(assert (Robot ?rx ?ry (- ?rb ?lb) $?aux1 Lamp ?lx ?ly 0 $?aux2 TotalB (- ?totB ?lb) Nivel (+ ?n 1)  Mov repairLamp))
	(bind ?*nod-gen* (+ ?*nod-gen* 1)) 
	)

(defrule solved
	(declare (salience 100))
	(Robot ?rx ?ry ?rb $? TotalB ?totB Nivel ?n $?)
	(test (= ?rb 0))
	(test (= ?totB 0))
=>
	(halt)
	(printout t "Solved, level: " ?n "Nodes generated: " ?*nod-gen* crlf)
	)



