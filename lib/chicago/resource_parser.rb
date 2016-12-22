class ResourceParser < Parser

  #Main engine for analyse of excel file
  def run
    parse do
      
    end
  end

  #initialize resource class
  def self.run(file_path)
    new_parser = ResourceParser.new(file_path).run
  end
end
