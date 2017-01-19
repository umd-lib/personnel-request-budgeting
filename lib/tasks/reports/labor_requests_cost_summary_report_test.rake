include ActionView::Helpers::NumberHelper

namespace :reports do
  desc 'Calculate values that should appear in the Labor Requests Cost Summary Report'
  task labor_requests_cost_summary_report_test: [:calculate_summary_page] do
  end

  desc 'Calculates and displays values that should appear on the summary worksheet'
  task calculate_summary_page: :environment do
    puts 'Summary_L_and_A Worksheet'
    total_annual_cost = LaborRequest.all.to_a.sum(&:annual_cost)
    nonop_cost = LaborRequest.sum(:nonop_funds)
    net_fy_request = total_annual_cost - nonop_cost
    puts "\tSummaryNetRequest: #{number_to_currency(net_fy_request)}"
  end
end
