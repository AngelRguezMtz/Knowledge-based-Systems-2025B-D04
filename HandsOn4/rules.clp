(defglobal ?*step* = 0)

(deffunction next-step ()
  (bind ?*step* (+ ?*step* 1))
  (return ?*step*))

(defrule print-initial
  (declare (salience 200))
  ?s <- (state (hpos ?h) (vpos ?v) (bpos ?b) (has ?has))
  (not (plan-step (n 1)))
  =>
  (printout t "[INIT] state: hpos=" ?h " vpos=" ?v " bpos=" ?b " has=" ?has crlf))

(defrule goal-eat
  (declare (salience 150))
  (state (has has))
  (not (done (reason goal)))
  =>
  (assert (plan-step (n (next-step)) (action eat) (detail "banana")))
  (assert (done (reason goal)))
  (printout t "[GOAL] Mono come la banana. Plan completado." crlf))

(defrule grasp-banana
  (declare (salience 120))
  ?s <- (state (hpos middle) (vpos onbox) (bpos middle) (has hasnot))
  (banana (hpos middle))
  =>
  (assert (plan-step (n (next-step)) (action grasp) (detail "banana")))
  (modify ?s (has has))
  (printout t "[ACT] grasp banana -> has=has" crlf))

(defrule climb-box
  (declare (salience 110))
  ?s <- (state (hpos middle) (vpos onfloor) (bpos middle) (has hasnot))
  =>
  (assert (plan-step (n (next-step)) (action climb) (detail "onto box at" middle)))
  (modify ?s (vpos onbox))
  (printout t "[ACT] climb box at middle" crlf))

(defrule push-box-to-middle
  (declare (salience 100))
  ?s <- (state (hpos ?p) (vpos onfloor) (bpos ?p&~middle) (has hasnot))
  =>
  (assert (plan-step (n (next-step)) (action push) (detail ?p "->" middle)))
  (modify ?s (hpos middle) (bpos middle))
  (printout t "[ACT] push box " ?p " -> middle (mono y caja ahora en middle)" crlf))

(defrule walk-to-box
  (declare (salience 90))
  ?s <- (state (hpos ?mh) (vpos onfloor) (bpos ?bh) (has hasnot))
  (test (neq ?mh ?bh))
  =>
  (assert (plan-step (n (next-step)) (action walk) (detail ?mh "->" ?bh)))
  (modify ?s (hpos ?bh))
  (printout t "[ACT] walk " ?mh " -> " ?bh crlf))