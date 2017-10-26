# add a dump method to return json for the users
class User < ActiveRecord::Base
  class << self
    # dumps json file of all users
    def dump
      self.includes( roles: %i[ unit department division ] ).all.map do |user|
          attrs = user.attributes
          attrs["admin"] = user.admin? 
          attrs["roles"] = user.roles.map do |role|
            if role.division
              role.division.name
            elsif role.department
              role.department.name
            elsif role.unit
              role.unit.name
            else
              nil
            end
          end.compact
          attrs
      end.to_json
    end
  end
end
