require 'open-uri'

dir = File.expand_path(File.dirname(__FILE__))
f_todos = File.new("#{dir}/todos.html", "w")
1.upto(7) do |i|
	print "Procesando página #{i} "
	html = open("http://www.clasificadospanorama.com/clasif.main.php?op=subrubrores&ID=29&tr=30&page=#{i}").read
	f = File.new("#{dir}/#{i}.html", "w")
	ult_url = ""
	html.scan(/getAviso_m\(([^)]+)\)/).uniq.map do |r|
		print '.'
		params = r[0].scan(/\d+/)
		url = "http://www.clasificadospanorama.com/clasif.main.php?" + 
					"op=aviso&ID=#{params[0]}&RubroID=#{params[1]}&SubRubroID=#{params[2]}&page=#{params[3]}" + 
					"&tr=#{params[4]}&claves=&origen="
		ult_url = url
		aviso = open(url).read
		aviso = aviso.gsub(/(<br \/>\n){2,}/, "")
		f.write "<hr/>"
		f.write(aviso)
		f_todos.write "<hr/>"
		f_todos.write(aviso)
	end
	print "\n"
	f.close
end
f_todos.close