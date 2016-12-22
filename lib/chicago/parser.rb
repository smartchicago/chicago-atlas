class Parser
  attr_accessor :cloned_path
  attr_accessor :new_file_path

  def initialize(file_path)
    @cloned_path = file_path
  end

  def parse(&block)
    download_file
    block.call
    #delete_file
  end

  private
    def create_new_file_path
      @new_file_path = 'downloads/' + SecureRandom.hex(4) + ".xlsx"
    end

    def download_file
      create_new_file_path
      File.open(@new_file_path, 'wb') do |file|
        file.puts open(@cloned_path).read
      end
    end

    def delete_file
      File.delete(@new_file_path) if File.exist?(@new_file_path)
    end
end
