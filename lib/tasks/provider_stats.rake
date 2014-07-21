namespace :db do
  namespace :import do
    namespace :provider_stats do
      
      desc "Import hospital stats - inpatient count"
      task :inpatient_count => :environment do
        require 'csv'

        ProviderStats.where("stat_type = 'Admissions by Payment Type - Inpatient'").each do |d|
          d.delete
        end

        csv_text = File.read("db/import/hospital_stats_inpatientcount.csv")
        csv = CSV.parse(csv_text, :headers => true)

        stats = [
          # Medicare, Medicaid, Other Public, Private Insurance, Private Payment, Charity Care, Total
          {:cat => 'Admissions by Payment Type - Inpatient', :stat_name => 'Medicare', :parse_token => 'inpatient_count_medicare'},
          {:cat => 'Admissions by Payment Type - Inpatient', :stat_name => 'Medicaid', :parse_token => 'inpatient_count_medicaid'},
          {:cat => 'Admissions by Payment Type - Inpatient', :stat_name => 'Other Public', :parse_token => 'inpatient_count_other_public'},
          {:cat => 'Admissions by Payment Type - Inpatient', :stat_name => 'Private Insurance', :parse_token => 'inpatient_count_private_insurance'},
          {:cat => 'Admissions by Payment Type - Inpatient', :stat_name => 'Private Payment', :parse_token => 'inpatient_count_private_payment'},
          {:cat => 'Admissions by Payment Type - Inpatient', :stat_name => 'Charity Care', :parse_token => 'inpatient_count_charity_care'},
          {:cat => 'Admissions by Payment Type - Inpatient', :stat_name => 'Total', :parse_token => 'inpatient_count_total'}
        ]

        csv.each do |row|
          stats.each do |stat_info|
            provider_statistic = ProviderStats.new(
              :provider_id => row["hospital_id"],
              :stat_type => stat_info[:cat],
              :stat => stat_info[:stat_name],
              :value => row[stat_info[:parse_token]],
              :date_start => DateTime.new(row["year"].to_i, 1, 1),
              :date_end => DateTime.new(row["year"].to_i, 12, 31)
            )
            puts "importing #{provider_statistic.stat_type} #{provider_statistic.stat} for hospital id hospital #{provider_statistic.provider_id}"
            provider_statistic.save!
          end
        end
        puts 'Done!'
      end


      desc "Import hospital stats - outpatient count"
      task :outpatient_count => :environment do
        require 'csv'

        ProviderStats.where("stat_type = 'Admissions by Payment Type - Outpatient'").each do |d|
          d.delete
        end

        csv_text = File.read("db/import/hospital_stats_outpatientcount.csv")
        csv = CSV.parse(csv_text, :headers => true)

        stats = [
          # Medicare, Medicaid, Other Public, Private Insurance, Private Payment, Charity Care, Total
          {:cat => 'Admissions by Payment Type - Outpatient', :stat_name => 'Medicare', :parse_token => 'outpatient_count_medicare'},
          {:cat => 'Admissions by Payment Type - Outpatient', :stat_name => 'Medicaid', :parse_token => 'outpatient_count_medicaid'},
          {:cat => 'Admissions by Payment Type - Outpatient', :stat_name => 'Other Public', :parse_token => 'outpatient_count_other_public'},
          {:cat => 'Admissions by Payment Type - Outpatient', :stat_name => 'Private Insurance', :parse_token => 'outpatient_count_private_insurance'},
          {:cat => 'Admissions by Payment Type - Outpatient', :stat_name => 'Private Payment', :parse_token => 'outpatient_count_private_payment'},
          {:cat => 'Admissions by Payment Type - Outpatient', :stat_name => 'Charity Care', :parse_token => 'outpatient_count_charity_care'},
          {:cat => 'Admissions by Payment Type - Outpatient', :stat_name => 'Total', :parse_token => 'outpatient_count_total'}
        ]

        csv.each do |row|
          stats.each do |stat_info|
            provider_statistic = ProviderStats.new(
              :provider_id => row["hospital_id"],
              :stat_type => stat_info[:cat],
              :stat => stat_info[:stat_name],
              :value => row[stat_info[:parse_token]],
              :date_start => DateTime.new(row["year"].to_i, 1, 1),
              :date_end => DateTime.new(row["year"].to_i, 12, 31)
            )
            puts "importing #{provider_statistic.stat_type} #{provider_statistic.stat} for hospital id hospital #{provider_statistic.provider_id}"
            provider_statistic.save!
          end
        end
        puts 'Done!'
      end


    end
  end
end