# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module PersonnelRequestController
  SORT_ORDER_NAME_MAP = {
    'division_code' => 'divisions.code',
    'department_code' => 'departments.code',
    'unit_code' => 'units.code',
    'employee_type_code' => 'employee_types.code',
    'request_type_code' => 'request_types.code'
  }.freeze

  def sort_results(q, results)
    sort_order_name = q.sorts[0].name
    sort_direction = q.sorts[0].dir

    sort_order_name = SORT_ORDER_NAME_MAP.fetch(sort_order_name, sort_order_name)
    sort_order = "#{sort_order_name} #{sort_direction}"

    table_name = results.table_name
    if sort_order_name == 'divisions.code'
      results = results.joins("LEFT OUTER JOIN departments on departments.id = #{table_name}.department_id")
      results = results.joins('LEFT OUTER JOIN divisions on departments.division_id = divisions.id')
    end
    results.order(sort_order)
  end
end
