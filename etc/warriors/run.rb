files = Dir["94nop/**/*.red"]
files = ["94nop/behemot.red", "94nop/candy2.red", "94nop/olivia.red"]

x = 0
count = 1
(0...files.size).each do |i|
  (i...files.size).each do |j|
    cmd = "-bkF 400 -r 10000 #{files[i]} #{files[j]}"
    t = Time.now
    pmars = `C:\\dev\\YaceReloaded.git\\vs\\x64\\Release\\YaceReloaded.exe #{cmd}`
    t_pmars = Time.now - t
=begin
    t = Time.now
    exmars = `exMARS.exe #{cmd}`
    t_exmars = Time.now - t
    
    speedup = t_pmars / t_exmars
    if pmars != exmars
      STDERR.puts "ERROR: #{pmars} vs #{exmars}"
    end
=end
    puts "#{t_pmars} #{files[i]} #{files[j]}"
    x += t_pmars
    count += 1
  end
end

x /= count
puts x