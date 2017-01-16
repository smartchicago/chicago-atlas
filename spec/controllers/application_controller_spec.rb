require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  controller(described_class) do
    def index
      render plain: ''
    end
  end

end
