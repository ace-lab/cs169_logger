require "test/unit"
 
class TestLogger < Test::Unit::TestCase

    def test_a_file_created_testenv
        puts "Starting File Created - Test Environment"
        `rm -r ./planning-poker/.log_cs169`
        `cd planning-poker; RUBYOPT="-W0" bundle exec rspec; cd ..`
        dir = "./planning-poker/.log_cs169"
        assert(File.directory?(dir))
        files = Dir.foreach(dir).select { |x| File.file?("#{dir}/#{x}") }
        puts files
        assert_equal(1, files.count)

        file = files[0]
        file_str = IO.read("#{dir}/#{file}")
        assert(file_str.match(/cs169_testing, test\n.+\n--\n.+/m))
        `rm -r ./planning-poker/.log_cs169`
    end

    def test_e_adds_to_same_folder
        puts "Starting Logs add to same folder"
        `rm -r ./planning-poker/.log_cs169`
        dir = "./planning-poker/.log_cs169"
        `cd planning-poker; RUBYOPT="-W0" bundle exec rspec; cd ..`
        assert(File.directory?(dir))
        files = Dir.foreach(dir).select { |x| File.file?("#{dir}/#{x}") }
        assert_equal(1, files.count)
        `cd planning-poker; RUBYOPT="-W0" bundle exec rspec; cd ..`
        assert(File.directory?(dir))
        files = Dir.foreach(dir).select { |x| File.file?("#{dir}/#{x}") }
        assert_equal(2, files.count)
        `rm -r ./planning-poker/.log_cs169`
    end

    def test_b_file_name
        puts "Starting Filenames are of a certain pattern"
        `rm -r ./planning-poker/.log_cs169`
        dir = "./planning-poker/.log_cs169"
        `cd planning-poker; RUBYOPT="-W0" bundle exec rspec; cd ..`
        files = Dir.foreach(dir).select { |x| File.file?("#{dir}/#{x}") }
        file = files[0]
        assert(file.match(/(\d{10})_([a-z0-9]{40}).txt/))
        `rm -r ./planning-poker/.log_cs169`
    end

    def test_c_correct_file_content
        puts "Starting Files have a certain pattern"
        `rm -r ./planning-poker/.log_cs169`
        dir = "./planning-poker/.log_cs169"
        `cd planning-poker; RUBYOPT="-W0" bundle exec rspec; cd ..`
        files = Dir.foreach(dir).select { |x| File.file?("#{dir}/#{x}") }
        file = files[0]
        file_str = IO.read("#{dir}/#{file}")
        assert(file_str.match(/[a-z0-9_]+, [a-z]+\n.+\n--\n.+/m))
        `rm -r ./planning-poker/.log_cs169`
    end

    def test_d_file_created_devenv
        puts "Starting File Created - Dev Environment"
        `rm -r ./planning-poker/.log_cs169`
        pid = fork do 
            exec "cd planning-poker; rails server"
        end

        sleep 10
        f = File.new('./planning-poker/app/models/activity.rb', 'w')
        f.write("puts 'abcd'\n")
        f.close
        puts "changed file 1"
        sleep 10
        dir = "./planning-poker/.log_cs169"
        assert(File.directory?(dir))
        files = Dir.foreach(dir).select { |x| File.file?("#{dir}/#{x}") }
        puts "assertion file 1"
        puts files
        puts `cat ./planning-poker/.log_cs169/#{files[0]}`
        assert_equal(1, files.count)

        f = File.new('./planning-poker/app/models/activity.rb', 'w')
        f.write("puts 'efgh'\n")
        f.close
        puts "changed file 2"
        sleep 10

        assert(File.directory?(dir))
        files = Dir.foreach(dir).select { |x| File.file?("#{dir}/#{x}") }
        puts "assertion file 2"
        puts files
        puts `cat ./planning-poker/.log_cs169/#{files[0]}`
        puts `cat ./planning-poker/.log_cs169/#{files[1]}`
        assert_equal(2, files.count)

        Process.kill("HUP", pid)

        file = files[0]
        file_str = IO.read("#{dir}/#{file}")
        assert(file_str.match(/cs169_testing, development\n.+\n--\n.+/m))     

        `rm -r ./planning-poker/.log_cs169`
    end

end