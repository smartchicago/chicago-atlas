namespace :db do
  namespace :import do
    namespace :provider_stats do

      desc "Import all provider stats"
      task :all => :environment do
        Rake::Task["db:import:provider_stats:admissions_by_type"].invoke
        Rake::Task["db:import:provider_stats:inpatient_count"].invoke
        Rake::Task["db:import:provider_stats:inpatient_revenue"].invoke
        Rake::Task["db:import:provider_stats:medsurg_admissions_by_age"].invoke
        Rake::Task["db:import:provider_stats:outpatient_count"].invoke
        Rake::Task["db:import:provider_stats:outpatient_revenue"].invoke
        Rake::Task["db:import:provider_stats:admissions_by_race"].invoke
        Rake::Task["db:import:provider_stats:admissions_by_ethnicity"].invoke
        Rake::Task["db:import:provider_stats:cost_charity_care"].invoke
      end
      
      desc "Import hospital stats - inpatient count"
      task :inpatient_count => :environment do
        require 'csv'

        cat_name = 'Admissions by Payment Type - Inpatient'
        ProviderStats.where("stat_type = 'Admissions by Payment Type - Inpatient'").each do |d|
          d.delete
        end

        csv_text = File.read("db/import/hospital_stats_inpatientcount.csv")
        csv = CSV.parse(csv_text, :headers => true)

        stats = [
          # Medicare, Medicaid, Other Public, Private Insurance, Private Payment, Charity Care
          {:stat_name => 'Medicare', :parse_token => 'inpatient_count_medicare'},
          {:stat_name => 'Medicaid', :parse_token => 'inpatient_count_medicaid'},
          {:stat_name => 'Other Public', :parse_token => 'inpatient_count_other_public'},
          {:stat_name => 'Private Insurance', :parse_token => 'inpatient_count_private_insurance'},
          {:stat_name => 'Private Payment', :parse_token => 'inpatient_count_private_payment'},
          {:stat_name => 'Charity Care', :parse_token => 'inpatient_count_charity_care'}
        ]

        csv.each do |row|
          stats.each do |stat_info|
            provider_statistic = ProviderStats.new(
              :provider_id => row["hospital_id"],
              :stat_type => cat_name,
              :stat => stat_info[:stat_name],
              :value => row[stat_info[:parse_token]],
              :date_start => DateTime.new(row["year"].to_i, 1, 1),
              :date_end => DateTime.new(row["year"].to_i, 12, 31),
              :data_type => "count"
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

        cat_name = 'Admissions by Payment Type - Outpatient'
        ProviderStats.where("stat_type = 'Admissions by Payment Type - Outpatient'").each do |d|
          d.delete
        end

        csv_text = File.read("db/import/hospital_stats_outpatientcount.csv")
        csv = CSV.parse(csv_text, :headers => true)

        stats = [
          # Medicare, Medicaid, Other Public, Private Insurance, Private Payment, Charity Care
          {:stat_name => 'Medicare', :parse_token => 'outpatient_count_medicare'},
          {:stat_name => 'Medicaid', :parse_token => 'outpatient_count_medicaid'},
          {:stat_name => 'Other Public', :parse_token => 'outpatient_count_other_public'},
          {:stat_name => 'Private Insurance', :parse_token => 'outpatient_count_private_insurance'},
          {:stat_name => 'Private Payment', :parse_token => 'outpatient_count_private_payment'},
          {:stat_name => 'Charity Care', :parse_token => 'outpatient_count_charity_care'}
        ]

        csv.each do |row|
          stats.each do |stat_info|
            provider_statistic = ProviderStats.new(
              :provider_id => row["hospital_id"],
              :stat_type => cat_name,
              :stat => stat_info[:stat_name],
              :value => row[stat_info[:parse_token]],
              :date_start => DateTime.new(row["year"].to_i, 1, 1),
              :date_end => DateTime.new(row["year"].to_i, 12, 31),
              :data_type => "count"
            )
            puts "importing #{provider_statistic.stat_type} #{provider_statistic.stat} for hospital id #{provider_statistic.provider_id}"
            provider_statistic.save!
          end
        end
        puts 'Done!'
      end


      desc "Import hospital stats - admissions by race"
      task :admissions_by_race => :environment do
        require 'csv'

        cat_name = 'Admissions by Race'
        ProviderStats.where("stat_type = 'Admissions by Race'").each do |d|
          d.delete
        end

        csv_text = File.read("db/import/hospital_stats_admissionsbyrace.csv")
        csv = CSV.parse(csv_text, :headers => true)

        stats = [
          {:stat_name => 'White', :parse_token => 'white'},
          {:stat_name => 'Black', :parse_token => 'black'},
          {:stat_name => 'American Indian', :parse_token => 'american_indian'},
          {:stat_name => 'Asian', :parse_token => 'asian'},
          {:stat_name => 'Hawaiian/Pacific Islander', :parse_token => 'hawaii_pac_islander'},
          {:stat_name => 'Unknown', :parse_token => 'unknown'}
        ]

        csv.each do |row|
          stats.each do |stat_info|
            provider_statistic = ProviderStats.new(
              :provider_id => row["hospital_id"],
              :stat_type => cat_name,
              :stat => stat_info[:stat_name],
              :value => row[stat_info[:parse_token]],
              :date_start => DateTime.new(row["year"].to_i, 1, 1),
              :date_end => DateTime.new(row["year"].to_i, 12, 31),
              :data_type => "count"
            )
            puts "importing #{provider_statistic.stat_type} #{provider_statistic.stat} for hospital id #{provider_statistic.provider_id}"
            provider_statistic.save!
          end
        end
        puts 'Done!'
      end

      desc "Import hospital stats - admissions by ethnicity"
      task :admissions_by_ethnicity => :environment do
        require 'csv'

        cat_name = 'Admissions by Ethnicity'
        ProviderStats.where("stat_type = 'Admissions by Ethnicity'").each do |d|
          d.delete
        end

        csv_text = File.read("db/import/hospital_stats_admissionsbyethnicity.csv")
        csv = CSV.parse(csv_text, :headers => true)

        stats = [
          {:stat_name => 'Hispanic', :parse_token => 'hispanic'},
          {:stat_name => 'Non-hispanic', :parse_token => 'non_hispanic'},
          {:stat_name => 'Unknown', :parse_token => 'unknown'}
        ]

        csv.each do |row|
          stats.each do |stat_info|
            provider_statistic = ProviderStats.new(
              :provider_id => row["hospital_id"],
              :stat_type => cat_name,
              :stat => stat_info[:stat_name],
              :value => row[stat_info[:parse_token]],
              :date_start => DateTime.new(row["year"].to_i, 1, 1),
              :date_end => DateTime.new(row["year"].to_i, 12, 31),
              :data_type => "count"
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

        cat_name = 'Admissions by Type'
        ProviderStats.where("stat_type = 'Admissions by Type'").each do |d|
          d.delete
        end

        csv_text = File.read("db/import/hospital_stats_admissionsbytype.csv")
        csv = CSV.parse(csv_text, :headers => true)

        stats = [
          # obstetrics, gynecology, ICU (direct), ICU (transfer), pediatric, long term care, rehabilitation, acute mental illess, long term acute care
          {:stat_name => 'Medical/Surgical', :parse_token => 'medical_surgical'},
          {:stat_name => 'Obstetrics', :parse_token => 'obstetrics'},
          {:stat_name => 'Gynecology', :parse_token => 'gynecology'},
          {:stat_name => 'ICU (direct admissions)', :parse_token => 'icu_direct'},
          {:stat_name => 'ICU (transfers in)', :parse_token => 'icu_transfer'},
          {:stat_name => 'Pediatric', :parse_token => 'pediatric'},
          {:stat_name => 'Long Term Care', :parse_token => 'long_term_care'},
          {:stat_name => 'Rehabilitation', :parse_token => 'rehabilitation'},
          {:stat_name => 'Acute Mental Illness', :parse_token => 'acute_mental_illness'},
          {:stat_name => 'Neonatal ICU', :parse_token => 'neonatal_icu'},
          {:stat_name => 'Long Term Acute Care', :parse_token => 'long_term_acute_care'}
        ]

        csv.each do |row|
          stats.each do |stat_info|
            provider_statistic = ProviderStats.new(
              :provider_id => row["hospital_id"],
              :stat_type => cat_name,
              :stat => stat_info[:stat_name],
              :value => row[stat_info[:parse_token]],
              :date_start => DateTime.new(row["year"].to_i, 1, 1),
              :date_end => DateTime.new(row["year"].to_i, 12, 31),
              :data_type => "count"
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

        cat_name = 'Outpatient Revenue by Payment Type'
        ProviderStats.where("stat_type = 'Outpatient Revenue by Payment Type'").each do |d|
          d.delete
        end

        csv_text = File.read("db/import/hospital_stats_revenueoutpatient.csv")
        csv = CSV.parse(csv_text, :headers => true)

        stats = [
          # Medicare, Medicaid, Other Public, Private Insurance, Private Payment
          {:stat_name => 'Medicaid', :parse_token => 'medicaid'},
          {:stat_name => 'Medicare', :parse_token => 'medicare'},
          {:stat_name => 'Other Public Payment', :parse_token => 'other_public_payment'},
          {:stat_name => 'Private Insurance', :parse_token => 'private_insurance'},
          {:stat_name => 'Private Payment', :parse_token => 'private_payment'}
        ]

        csv.each do |row|
          stats.each do |stat_info|
            provider_statistic = ProviderStats.new(
              :provider_id => row["hospital_id"],
              :stat_type => cat_name,
              :stat => stat_info[:stat_name],
              :value => row[stat_info[:parse_token]].gsub(/[^\d\.]/, '').to_f,
              :date_start => Date.parse(row["report_start_date"]),
              :date_end => Date.parse(row["report_end_date"]),
              :data_type => "money"
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

        cat_name = 'Inpatient Revenue by Payment Type'
        ProviderStats.where("stat_type = 'Inpatient Revenue by Payment Type'").each do |d|
          d.delete
        end

        csv_text = File.read("db/import/hospital_stats_revenueinpatient.csv")
        csv = CSV.parse(csv_text, :headers => true)

        stats = [
          # Medicare, Medicaid, Other Public, Private Insurance, Private Payment
          {:stat_name => 'Medicaid', :parse_token => 'medicaid'},
          {:stat_name => 'Medicare', :parse_token => 'medicare'},
          {:stat_name => 'Other Public Payment', :parse_token => 'other_public_payment'},
          {:stat_name => 'Private Insurance', :parse_token => 'private_insurance'},
          {:stat_name => 'Private Payment', :parse_token => 'private_payment'}
        ]

        csv.each do |row|
          stats.each do |stat_info|
            provider_statistic = ProviderStats.new(
              :provider_id => row["hospital_id"],
              :stat_type => cat_name,
              :stat => stat_info[:stat_name],
              :value => row[stat_info[:parse_token]].gsub(/[^\d\.]/, '').to_f,
              :date_start => Date.parse(row["report_start_date"]),
              :date_end => Date.parse(row["report_end_date"]),
              :data_type => "money"
            )
            puts "importing #{provider_statistic.stat_type} #{provider_statistic.stat} for hospital id hospital #{provider_statistic.provider_id}"
            provider_statistic.save!
          end
        end
        puts 'Done!'
      end


      desc "Import hospital stats - Actual cost of charity care"
      task :cost_charity_care => :environment do
        require 'csv'

        cat_name = 'Actual Cost Charity Care'
        ProviderStats.where("stat_type = 'Actual Cost Charity Care'").each do |d|
          d.delete
        end

        csv_text = File.read("db/import/hospital_stats_cost_charity_care.csv")
        csv = CSV.parse(csv_text, :headers => true)

        stats = [
          # Medicare, Medicaid, Other Public, Private Insurance, Private Payment
          {:stat_name => 'Charity Care - Inpatient', :parse_token => 'actual_cost_inpatient_charity_care'},
          {:stat_name => 'Charity Care - Outpatient', :parse_token => 'actual_cost_outpatient_charity_care'}
        ]

        csv.each do |row|
          stats.each do |stat_info|
            provider_statistic = ProviderStats.new(
              :provider_id => row["hospital_id"],
              :stat_type => cat_name,
              :stat => stat_info[:stat_name],
              :value => row[stat_info[:parse_token]].gsub(/[^\d\.]/, '').to_f,
              :date_start => Date.parse(row["report_start_date"]),
              :date_end => Date.parse(row["report_end_date"]),
              :data_type => "money"
            )
            puts "importing #{provider_statistic.stat_type} #{provider_statistic.stat} for hospital id #{provider_statistic.provider_id}"
            provider_statistic.save!
          end
        end
        puts 'Done!'
      end


      desc "Import hospital stats - medical-surgical admissions by age"
      task :medsurg_admissions_by_age => :environment do
        require 'csv'

        cat_name = 'Medical-Surgical Admissions By Age'
        ProviderStats.where("stat_type = 'Medical-Surgical Admissions By Age'").each do |d|
          d.delete
        end

        csv_text = File.read("db/import/hospital_stats_admissionsbyage.csv")
        csv = CSV.parse(csv_text, :headers => true)

        stats = [
          # 0-14, 15-44, 45-64, 65-74, 75+
          {:stat_name => '0-14', :parse_token => '0_to_14'},
          {:stat_name => '15-44', :parse_token => '15_to_44'},
          {:stat_name => '45-64', :parse_token => '45_to_64'},
          {:stat_name => '65-74', :parse_token => '65_to_74'},
          {:stat_name => '75+', :parse_token => '75_and_up'}
        ]

        csv.each do |row|
          stats.each do |stat_info|
            provider_statistic = ProviderStats.new(
              :provider_id => row["hospital_id"],
              :stat_type => cat_name,
              :stat => stat_info[:stat_name],
              :value => row[stat_info[:parse_token]],
              :date_start => DateTime.new(row["year"].to_i, 1, 1),
              :date_end => DateTime.new(row["year"].to_i, 12, 31),
              :data_type => "count"
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