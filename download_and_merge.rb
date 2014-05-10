#!/usr/bin/ruby
require 'open-uri'

dir = File.expand_path(File.dirname(__FILE__))
f_todos = File.new("#{dir}/todos.html", "w+")
HEADER = %Q{<!doctype html><html><head><meta charset="utf-8"><title>Untitled</title></head><body>}
FOOTER = %Q{</body></html>}
f_todos.write(HEADER)
1.upto(7) do |i|
	print "Procesando página #{i} "
	html = open("http://www.clasificadospanorama.com/clasif.main.php?op=subrubrores&ID=29&tr=30&page=#{i}").read
	f = File.new("#{dir}/#{i}.html", "w+")
	f.write(HEADER)
	ult_url = ""
	html.scan(/getAviso_m\(([^)]+)\)/).uniq.map do |r|
		print '.'
		params = r[0].scan(/\d+/)
		url = "http://www.clasificadospanorama.com/clasif.main.php?" + 
					"op=aviso&ID=#{params[0]}&RubroID=#{params[1]}&SubRubroID=#{params[2]}&page=#{params[3]}" + 
					"&tr=#{params[4]}&claves=&origen="
		ult_url = url
		aviso = open(url).read
		if (aviso =~ /4216271/).nil?
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
