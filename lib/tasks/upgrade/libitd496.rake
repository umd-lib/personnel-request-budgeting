# lib/tasks/temporary/sample_data.rake
namespace :upgrade do
  desc 'Perform database upgrade tasks needed for LIBITD-496'
  task libitd496: [:libitd496_set_review_status_codes, :libitd496_set_default_review_status] do
  end

  desc 'sets Review Status codes'
  task libitd496_set_review_status_codes: :environment do
    names_to_codes = {
      'Under Review' => 'UnderReview',
      'Approved' => 'Approved',
      'Not Approved' => 'NotApproved',
      'Contingent' => 'Contingent'
    }

    puts 'Setting Review Status codes'
    ActiveRecord::Base.transaction do
      names_to_codes.each do |name, code|
        print "  #{name} : #{code}"
        review_status = ReviewStatus.find_by_name(name)
        review_status.code = code
        review_status.save!
        puts ' -- Done'
      end
    end
  end

  desc 'sets "Under Review" as default review status for personnel requests'
  task libitd496_set_default_review_status: :environment do
    default_review_status = ReviewStatus.find_by_code('UnderReview')
    puts "Setting default review status to: '#{default_review_status.name}'"
    ActiveRecord::Base.transaction do
      LaborRequest.find_each do |request|
        if request.review_status.nil?
          request.review_status = default_review_status
          request.review_status.save!
          print 'U'
        else
          print '.'
        end
      end
    end
    puts "\nDone."
  end
end
