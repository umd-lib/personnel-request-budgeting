include ActionView::Helpers::NumberHelper

namespace :reports do
  desc 'Calculate values that should appear in the Salaried Contractor Requests Cost Summary Report'
  task contractor_requests_cost_summary_report_test: ['contractor_requests:calculate_summary_page'] do
  end

  namespace :contractor_requests do
    # Calculates and displays values that should appear on the summary worksheet
    task calculate_summary_page: :environment do
      puts 'Summary_Contractor Worksheet'
      total_annual_base_pay = ContractorRequest.all.to_a.sum(&:annual_base_pay)
      nonop_cost = ContractorRequest.sum(:nonop_funds)
      net_fy_request = total_annual_base_pay - nonop_cost
      puts "\tSummaryNetRequest: #{number_to_currency(net_fy_request)}"
    end
  end
end