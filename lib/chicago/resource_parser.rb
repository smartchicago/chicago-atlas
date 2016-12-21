class ResourceParser < Parser

  def run
    parse do
      @res = "wwwef"
      byebug
    end
  end

  def self.run(file_path)
    new_parser = ResourceParser.new(file_path).run
  end
end
