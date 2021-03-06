#!/usr/bin/ruby
require 'open-uri'

dir = File.expand_path(File.dirname(__FILE__))
f_todos = File.new("#{dir}/todos-terrenos.html", "w+")
HEADER = %Q{<!doctype html><html><head><meta charset="utf-8"><title>Untitled</title></head><body>}
FOOTER = %Q{</body></html>}
f_todos.write(HEADER)
total = 0
1.upto(9) do |i|
	print "Procesando página #{i} "
	html = open("http://www.clasificadospanorama.com/clasif.main.php?op=subrubrores&ID=29&tr=undefined&page=#{i}").read
	# terrenos
	# html = open("http://www.clasificadospanorama.com/clasif.main.php?op=subrubrores&ID=30&tr=undefined&page=#{i}").read
	f = File.new("#{dir}/#{i}.html", "w+")
	f.write(HEADER)
	ult_url = ""
	html.scan(/getAviso_m\(([^)]+)\)/).uniq.map do |r|
		total += 1
		print '.'
		params = r[0].scan(/\d+/)
		url = "http://www.clasificadospanorama.com/clasif.main.php?" + 
					"op=aviso&ID=#{params[0]}&RubroID=#{params[1]}&SubRubroID=#{params[2]}&page=#{params[3]}" + 
					"&tr=#{params[4]}&claves=undefined&origen=undefined"
		ult_url = url
		aviso = open(url).read
		if (aviso =~ /4216271/).nil? and (aviso =~ /FAVIAN HOYOS NEGOCIOS INMOBILIARIOS/i).nil?
			aviso.gsub!(/(<br \/>\n){2,}/, "")
			aviso.gsub!(%r#<table width="98%".*?</table>#m, "")
			aviso.gsub!(/<a.+onclick='filtrarBusqueda.+/i, "")
			aviso.gsub!(%r#<div id="CuadroAmpliada".*?</div>#im, "")
			f.write "<hr/>"
			f.write(aviso)
			f_todos.write "<hr/>"
			f_todos.write(aviso)
		end
	end
	print "\n"
	f.write(FOOTER)
	f.close
end
f_todos.write(FOOTER)
f_todos.close
puts "#{total} artículos procesados"