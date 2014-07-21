namespace :db do
  namespace :import do
    namespace :provider_stats do
      
      desc "Import hospital stats - inpatient count"
      task :inpatient_count => :environment do
        require 'csv'

        ProviderStats.where("stat_type = 'Inpatient Count'").each do |d|
          d.delete
        end

        csv_text = File.read("db/import/hospital_stats_inpatientcount.csv")
        csv = CSV.parse(csv_text, :headers => true)

        stats = [
          # Medicare, Medicaid, Other Public, Private Insurance, Private Payment, Charity Care, Total
          {:cat => 'Inpatient Count', :stat_name => 'Medicare', :parse_token => 'inpatient_count_medicare', :year => '2012'},
          {:cat => 'Inpatient Count', :stat_name => 'Medicaid', :parse_token => 'inpatient_count_medicaid'},
          {:cat => 'Inpatient Count', :stat_name => 'Other Public', :parse_token => 'inpatient_count_other_public'},
          {:cat => 'Inpatient Count', :stat_name => 'Private Insurance', :parse_token => 'inpatient_count_private_insurance'},
          {:cat => 'Inpatient Count', :stat_name => 'Private Payment', :parse_token => 'inpatient_count_private_payment'},
          {:cat => 'Inpatient Count', :stat_name => 'Charity Care', :parse_token => 'inpatient_count_charity_care'},
          {:cat => 'Inpatient Count', :stat_name => 'Total', :parse_token => 'inpatient_count_total'}
        ]

        csv.each do |row|
          stats.each do |stat_info|
            provider_statistic = ProviderStats.new(
              :src_id => row["hospital_id"],
              :stat_type => stat_info[:cat],
              :stat => stat_info[:stat_name],
              :value => row[stat_info[:parse_token]],
              :year => row["year"]
            )
            puts "importing #{provider_statistic.stat_type} #{provider_statistic.stat} for hospital id hospital #{provider_statistic.src_id}"
            provider_statistic.save!
          end
        end
        puts 'Done!'
      end



    end
  end
end