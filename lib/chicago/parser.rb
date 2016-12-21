class Parser
  attr_accessor :cloned_path

  def initialize(file_path)
    cloned_path = file_path
  end

  def parse(&block)
    download_file
    block.call
    delete_file
  end

  private
    def download_file
      
    end

    def delete_file

    end
end
