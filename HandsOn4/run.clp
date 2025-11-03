(deffacts initial-world
  (banana (hpos middle))
  (state (hpos atdoor) (vpos onfloor) (bpos atwindow) (has hasnot))
)

(deffunction print-plan ()
  (printout t crlf "=== PLAN ===" crlf)
  (do-for-all-facts ((?ps plan-step)) TRUE
    (printout t ?ps:n ". " ?ps:action " " ?ps:detail crlf))
  (printout t "=============" crlf))

(deffunction world ()
  (reset)
  (run)
  (print-plan)
  (facts))