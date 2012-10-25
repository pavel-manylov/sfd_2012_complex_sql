#coding: utf-8
FactoryGirl.define do
  factory :download_statistic do
    ip            1
    file_id       1
    created_at    {Time.zone.now}
    year_in_tz    {created_at.year}
    month_in_tz   {created_at.month}
    day_in_tz     {created_at.day}
    hour_in_tz    {created_at.hour}
    minute_in_tz  {created_at.min}
  end
end
