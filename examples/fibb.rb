#puts$<.map{|l|i=l;q=5*i**2;(q+4,q-4).any?{|n|sqrt(n)%1==0}??y:?n}

puts $<.map { |l|i=l.to_i;q=5*i**2;[q+4,q-4].any?{|n|Math.sqrt(n)%1==0}??y:?n}
