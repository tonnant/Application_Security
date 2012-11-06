desc "Input from flog then convert to ruby 18 spec"
task :convert do
  flog_temp = File.join(SRC, 'flog_temp')
  Dir.chdir(flog_temp)
  Dir.glob('**/*.rb') { |name| File.delete(name) }
  Dir.chdir(SRC)
  list = Dir.glob('lib/**/*.rb')
  list.each do |name|
    arr = IO.readlines(File.join(SRC, name))
    File.open(File.join(flog_temp, name), "wb:utf-8") do |f|
      arr.each do |line|
        line.gsub!(/:(nodoc|startdoc|stopdoc):/, "")
        line.gsub!(/(\w+):\s+/, ':\1 => ')
        line.gsub!(/[Ã©Ã¨Ã ÃªÃ®Ã´Ã¹Ã¯Ã¶Ã¼Ã«]/, "_")
        f.print line
      end
    end
  end
end
