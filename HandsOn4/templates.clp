(deftemplate state
  (slot hpos)       ; atdoor | middle | atwindow
  (slot vpos)       ; onfloor | onbox
  (slot bpos)       ; box horizontal position
  (slot has))

(deftemplate banana
  (slot hpos))

(deftemplate plan-step
  (slot n (type INTEGER))
  (slot action)
  (multislot detail))

(deftemplate done
  (slot reason))