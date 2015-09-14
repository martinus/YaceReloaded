# benchmark 2 warriors against each other.
w = Dir["warriors/94nop/*.red"]
w1 = "warriors/94nop/recon2.red"
w2 = "warriors/94nop/QuickSilver.red"

rounds = 1000
measurements = 500

#app = "pmars-server.exe"
#app = "C:\\martin\\dev\\YaceReloaded\\vs\\x64\\Release\\YaceReloaded.exe"
app = "C:\\dev\\YaceReloaded.git\\vs\\x64\\Release\\YaceReloaded.exe"

cmd = "#{app} -bkF 4000 -r #{rounds} #{w1} #{w2} 2>nul"


# We view our timing values as a series of random variables V that has been
# contaminated with occasional outliers due to cache misses, thread
# preemption, etcetera. To filter out the outliers, we search for the largest
# subset of V such that all its values are within three standard deviations
# of the mean.
#
# source: https://code.google.com/p/smhasher/source/browse/trunk/SpeedTest.cpp
# https://en.wikipedia.org/wiki/Algorithms_for_calculating_variance#Online_algorithm
def mean_without_outliers(data, maxStandardDeviationsFromMean)
	data = data.sort
	n = 0
	mean = 0.0
	m2 = 0.0
	
	data.each do |x|
		n += 1
		delta = x - mean
		mean += delta / n
		m2 += delta * (x - mean)
		
		variance = m2 / (n - 1)
		standard_deviation = Math::sqrt(variance)

		if (x > mean + standard_deviation * maxStandardDeviationsFromMean)
			# can't accept this number, remove it.
			return [mean - delta/n, n-1]
		end
	end
	return [mean, n]
end


times = []
printTime = Time.now
mean = 0
n = 0
measurements.times do
  t = Time.now
  output = `#{cmd}`
  diff = Time.now - t
  
  times.push(diff)
  mean, n = mean_without_outliers(times, 3)
  if printTime + 1 < Time.now
    puts "#{rounds/mean} rounds per second (using #{times.size} measurements, #{times.size - n} outliers, #{n} ok)"  
    printTime = Time.now
  end
end
puts "======"
puts "#{rounds/mean} rounds per second (using #{times.size} measurements, #{times.size - n} outliers, #{n} ok)"  
