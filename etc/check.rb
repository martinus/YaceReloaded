require "pp"

w = Dir["warriors/94nop/*.red"]
runs = 100
#app = "pmars-server.exe"
#app = "C:\\martin\\dev\\YaceReloaded\\vs\\x64\\Release\\YaceReloaded.exe"
app = "C:\\dev\\YaceReloaded.git\\vs\\x64\\Release\\YaceReloaded.exe"

h = Hash.new {|h,k| h[k] = 0}
loop do
	w.each do |w1|
		w.each do |w2|
			cmd = "#{app} -bkF 4000 -r #{runs} #{w1} #{w2} 2>nul"
			output = `#{cmd}`
      output.each_line do |l|
        k, val = l.split
        h[k] += val.to_i
      end
		end
    a = h.to_a.sort do |a,b|
      a[1] <=> b[1]
    end
    pp a
	end
end