require "test/unit"
 
class TestLogger < Test::Unit::TestCase

    def test_file_created_testenv
        `cd planning-poker; bundle exec rspec; cd ..`
        dir = "./planning-poker/.log_cs169"
        assert(File.directory?(dir))
        files = Dir.foreach(dir).select { |x| File.file?("#{dir}/#{x}") }
        assert_equal(1, files.count)
        `rm -r ./planning-poker/.log_cs169`
    end

    def test_adds_to_same_folder
        dir = "./planning-poker/.log_cs169"
        `cd planning-poker; bundle exec rspec; cd ..`
        assert(File.directory?(dir))
        files = Dir.foreach(dir).select { |x| File.file?("#{dir}/#{x}") }
        assert_equal(1, files.count)
        `cd planning-poker; bundle exec rspec; cd ..`
        assert(File.directory?(dir))
        files = Dir.foreach(dir).select { |x| File.file?("#{dir}/#{x}") }
        assert_equal(2, files.count)
        `rm -r ./planning-poker/.log_cs169`
    end

    def test_file_name
        dir = "./planning-poker/.log_cs169"
        `cd planning-poker; bundle exec rspec; cd ..`
        files = Dir.foreach(dir).select { |x| File.file?("#{dir}/#{x}") }
        file = files[0]
        assert(file.match(/(\d{10})_([a-z0-9]{40}).txt/))
        `rm -r ./planning-poker/.log_cs169`
    end

    def test_correct_file_content
        dir = "./planning-poker/.log_cs169"
        `cd planning-poker; bundle exec rspec; cd ..`
        files = Dir.foreach(dir).select { |x| File.file?("#{dir}/#{x}") }
        file = files[0]
        file_str = IO.read("#{dir}/#{file}")
        assert(file_str.match(/[a-z0-9_]+, [a-z]+\n.+\n--\n.+/m))
        `rm -r ./planning-poker/.log_cs169`
    end

    def test_file_created_devenv

    end

end