class HealthyChicagoController < ApplicationController
  
  def home

  	@survey_text = 'Healthy Chicago Survey, Chicago Department of Public Health'
  	@survey_link = 'http://www.cityofchicago.org/city/en/depts/cdph/supp_info/clinical_health/healthy-chicago-survey.html'

  end

end
