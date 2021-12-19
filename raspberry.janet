(import sh)

(def tmp_grammar
  '{:float (<- (* :d+ "." :d+ "'C"))
    :number (<- (* :d+ "'C"))
    :main (* :a+ "=" (choice :float :number) (any :s))})

# Add something that make this not run if we are not on a raspberry..
(defn get_tmp []
  (def tmp (sh/$< /opt/vc/bin/vcgencmd measure_temp))
  (get (peg/match tmp_grammar tmp) 0 :error))
