#!/usr/bin/ruby
require 'rake'

# Toma aleatoriamente una imagen de una carpeta y cambia el fondo de pantalla en una sesión gnome
files = Dir.glob("//home/admin/Imágenes/Wallpapers/Europa/*")
n = Random.rand(files.size)
sh "gsettings set org.gnome.desktop.background picture-uri file:/#{files[n]}"
# puts "Archivo #{n + 1} de #{files.size}: #{files[n]}"
