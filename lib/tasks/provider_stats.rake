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
            puts "importing #{provider_statistic.stat_type} #{provider_statistic.stat} for hospital id #{provider_statistic.provider_id}"
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
            puts "importing #{provider_statistic.stat_type} #{provider_statistic.stat} for hospital id #{provider_statistic.provider_id}"
            provider_statistic.save!
          end
        end
        puts 'Done!'
      end


      desc "Import hospital stats - admissions by type"
      task :admissions_by_type => :environment do
        require 'csv'

        ProviderStats.where("stat_type = 'Admissions by Type'").each do |d|
          d.delete
        end

        csv_text = File.read("db/import/hospital_stats_admissionsbytype.csv")
        csv = CSV.parse(csv_text, :headers => true)

        stats = [
          # obstetrics, gynecology, ICU (direct), ICU (transfer), pediatric, long term care, rehabilitation, acute mental illess, long term acute care
          {:cat => 'Admissions by Type', :stat_name => 'Obstetrics', :parse_token => 'obstetrics'},
          {:cat => 'Admissions by Type', :stat_name => 'Gynecology', :parse_token => 'gynecology'},
          {:cat => 'Admissions by Type', :stat_name => 'ICU (direct admissions)', :parse_token => 'icu_direct'},
          {:cat => 'Admissions by Type', :stat_name => 'ICU (transfers in)', :parse_token => 'icu_transfer'},
          {:cat => 'Admissions by Type', :stat_name => 'Pediatric', :parse_token => 'pediatric'},
          {:cat => 'Admissions by Type', :stat_name => 'Long Term Care', :parse_token => 'long_term_care'},
          {:cat => 'Admissions by Type', :stat_name => 'Rehabilitation', :parse_token => 'rehabilitation'},
          {:cat => 'Admissions by Type', :stat_name => 'Acute Mental Illness', :parse_token => 'acute_mental_illness'},
          {:cat => 'Admissions by Type', :stat_name => 'Neonatal ICU', :parse_token => 'neonatal_icu'},
          {:cat => 'Admissions by Type', :stat_name => 'Long Term Acute Care', :parse_token => 'long_term_acute_care'}
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
            puts "importing #{provider_statistic.stat_type} #{provider_statistic.stat} for hospital id #{provider_statistic.provider_id}"
            provider_statistic.save!
          end
        end
        puts 'Done!'
      end


      desc "Import hospital stats - outpatient revenue by payment type"
      task :outpatient_revenue => :environment do
        require 'csv'

        ProviderStats.where("stat_type = 'Outpatient Revenue by Payment Type'").each do |d|
          d.delete
        end

        csv_text = File.read("db/import/hospital_stats_revenueoutpatient.csv")
        csv = CSV.parse(csv_text, :headers => true)

        stats = [
          # Medicare, Medicaid, Other Public, Private Insurance, Private Payment, Total
          {:cat => 'Outpatient Revenue by Payment Type', :stat_name => 'Medicaid', :parse_token => 'medicaid'},
          {:cat => 'Outpatient Revenue by Payment Type', :stat_name => 'Medicare', :parse_token => 'medicare'},
          {:cat => 'Outpatient Revenue by Payment Type', :stat_name => 'Other Public Payment', :parse_token => 'other_public_payment'},
          {:cat => 'Outpatient Revenue by Payment Type', :stat_name => 'Private Insurance', :parse_token => 'private_insurance'},
          {:cat => 'Outpatient Revenue by Payment Type', :stat_name => 'Private Payment', :parse_token => 'private_payment'},
          {:cat => 'Outpatient Revenue by Payment Type', :stat_name => 'Total', :parse_token => 'total'}
        ]

        csv.each do |row|
          stats.each do |stat_info|
            provider_statistic = ProviderStats.new(
              :provider_id => row["hospital_id"],
              :stat_type => stat_info[:cat],
              :stat => stat_info[:stat_name],
              :value => row[stat_info[:parse_token]].gsub(/[^\d\.]/, '').to_f,
              :date_start => Date.parse(row["report_start_date"]),
              :date_end => Date.parse(row["report_end_date"])
            )
            puts "importing #{provider_statistic.stat_type} #{provider_statistic.stat} for hospital id hospital #{provider_statistic.provider_id}"
            provider_statistic.save!
          end
        end
        puts 'Done!'
      end


      desc "Import hospital stats - inpatient revenue by payment type"
      task :inpatient_revenue => :environment do
        require 'csv'

        ProviderStats.where("stat_type = 'Inpatient Revenue by Payment Type'").each do |d|
          d.delete
        end

        csv_text = File.read("db/import/hospital_stats_revenueinpatient.csv")
        csv = CSV.parse(csv_text, :headers => true)

        stats = [
          # Medicare, Medicaid, Other Public, Private Insurance, Private Payment, Total
          {:cat => 'Inpatient Revenue by Payment Type', :stat_name => 'Medicaid', :parse_token => 'medicaid'},
          {:cat => 'Inpatient Revenue by Payment Type', :stat_name => 'Medicare', :parse_token => 'medicare'},
          {:cat => 'Inpatient Revenue by Payment Type', :stat_name => 'Other Public Payment', :parse_token => 'other_public_payment'},
          {:cat => 'Inpatient Revenue by Payment Type', :stat_name => 'Private Insurance', :parse_token => 'private_insurance'},
          {:cat => 'Inpatient Revenue by Payment Type', :stat_name => 'Private Payment', :parse_token => 'private_payment'},
          {:cat => 'Inpatient Revenue by Payment Type', :stat_name => 'Total', :parse_token => 'total'}
        ]

        csv.each do |row|
          stats.each do |stat_info|
            provider_statistic = ProviderStats.new(
              :provider_id => row["hospital_id"],
              :stat_type => stat_info[:cat],
              :stat => stat_info[:stat_name],
              :value => row[stat_info[:parse_token]].gsub(/[^\d\.]/, '').to_f,
              :date_start => Date.parse(row["report_start_date"]),
              :date_end => Date.parse(row["report_end_date"])
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