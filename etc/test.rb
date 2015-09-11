w = Dir["warriors/94nop/*.red"]

runs = 100
#app = "pmars-server.exe"
app = "C:\\martin\\dev\\YaceReloaded\\vs\\x64\\Release\\YaceReloaded.exe"

i = 0
w.each do |w1|
	w.each do |w2|
		cmd = "#{app} -bkF 4000 -r #{runs} #{w1} #{w2} 2>nul"
		output = `#{cmd}`
		puts output
	end
end