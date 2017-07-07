class Parser
  attr_accessor :cloned_path
  attr_accessor :new_file_path
  attr_accessor :uploader_id
  attr_accessor :current_sheet

  def initialize(uploader_id)
    @sheet          =   Uploader.find(uploader_id)
    @cloned_path    =   @sheet.path
    @uploader_id    =   @sheet.id
    @current_sheet  =   @sheet
  end

  def parse(&block)
    download_file
    block.call
    delete_file
  end

  private
    def create_new_file_path
      @new_file_path = 'downloads/' + SecureRandom.hex(4) + ".xlsx"
    end

    def download_file
      create_new_file_path
      File.open(@new_file_path, 'wb') do |file|
        file.puts open(@cloned_path.to_s).read
      end
    end

    def delete_file
      File.delete(@new_file_path.to_s) if File.exist?(@new_file_path.to_s)
    end
end
