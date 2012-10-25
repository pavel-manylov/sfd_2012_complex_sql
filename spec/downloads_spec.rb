#coding: utf-8
require 'spec_helper'

describe "complex sql queries [downloads]" do
  include SpecHelper


  let(:download_statistics){
    [
        FactoryGirl.create(:download_statistic, :created_at=>Time.zone.parse("2012-03-01 12:10"), :file_id=>5, :ip=>3),
        FactoryGirl.create(:download_statistic, :created_at=>Time.zone.parse("2012-03-01 12:15"), :file_id=>5, :ip=>3),
        FactoryGirl.create(:download_statistic, :created_at=>Time.zone.parse("2012-03-01 12:16"), :file_id=>5, :ip=>3),
        FactoryGirl.create(:download_statistic, :created_at=>Time.zone.parse("2012-03-01 12:17"), :file_id=>5, :ip=>4),
        FactoryGirl.create(:download_statistic, :created_at=>Time.zone.parse("2012-03-02 05:19"), :file_id=>5, :ip=>8),
        FactoryGirl.create(:download_statistic, :created_at=>Time.zone.parse("2012-03-02 05:19"), :file_id=>6, :ip=>8)
    ]
  }

  before{ download_statistics }

  let(:da){ DownloadStatistic.arel_table }
  let(:queries){
    {
        active_record: DownloadStatistic.select([:file_id,
                                                 :year_in_tz,
                                                 :month_in_tz,
                                                 :day_in_tz,
                                                 Arel.star.count.as("hosts_count")]) \
                                        .from( DownloadStatistic.select([:file_id,
                                                                         :year_in_tz,
                                                                         :month_in_tz,
                                                                         :day_in_tz]) \
                                                                 .group(:file_id,
                                                                        :ip,
                                                                        :year_in_tz,
                                                                        :month_in_tz,
                                                                        :day_in_tz
                                                                 ).arel.as("t1")
                                        ) \
                                        .group(:file_id, :year_in_tz, :month_in_tz, :day_in_tz)
    }
  }

  specify{
    queries.first[1].to_a.map{|k|k.attributes}.should =~ [
        {:file_id=>5, :year_in_tz=>2012, :month_in_tz=>3, :day_in_tz=>1, :hosts_count=>2}.with_indifferent_access,
        {:file_id=>5, :year_in_tz=>2012, :month_in_tz=>3, :day_in_tz=>2, :hosts_count=>1}.with_indifferent_access,
        {:file_id=>6, :year_in_tz=>2012, :month_in_tz=>3, :day_in_tz=>2, :hosts_count=>1}.with_indifferent_access
    ]
  }

end