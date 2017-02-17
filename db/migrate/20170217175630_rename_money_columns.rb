class RenameMoneyColumns < ActiveRecord::Migration
  def change
    rename_column :contractor_requests, :annual_base_pay, :annual_base_pay_cents
    rename_column :staff_requests, :annual_base_pay, :annual_base_pay_cents
    rename_column :labor_requests, :hourly_rate, :hourly_rate_cents
  end
end
