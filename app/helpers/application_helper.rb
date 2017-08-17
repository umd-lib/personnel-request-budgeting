module ApplicationHelper
  # helper to toggle asc and desc ( for ordering )
  def switch_direction(direction)
    direction =~ /asc$/ ? [direction.gsub(/asc$/, 'desc'), 'arrow-up'] : [direction.gsub(/desc$/, 'asc'), 'arrow-down']
  end

  SORT_MAP = { hourly_rate: :hourly_rate_cents,
               annual_cost: 'number_of_positions * hourly_rate_cents * hours_per_week * number_of_weeks',
               nonop_funds: :nonop_funds_cents,
               annual_base_pay: :annual_base_pay_cents,
               organization__name: 'organizations.name',
               review_status__name: 'review_statuses.name' }.freeze

  # this is a helper to map certain view fields to what they should
  # actually be for sorting. e.g. hourly_rate needs to be hourly_rate_cents.
  # It :unsortable is returned, that means we can't sort on it.
  def map_sort(column)
    # the .fields method uses a __ which should be swapped out here
    SORT_MAP.with_indifferent_access[column] || column
  end

  def multi_sort_link(column, title, direction = 'arrow-up')
    # first we extract any existing sorts in the params
    attrs = Array.wrap(params[:sort]).compact

    # now scan and look to see if we're already sortin on this column
    index = attrs.index { |a| a.match(/^#{Regexp.escape(column)} /) }
    if index
      attrs[index], direction = switch_direction(attrs[index])
    else
      # so we just stick it in the end
      attrs << "#{column} asc"
    end
    link_to(title, params.merge(sort: attrs.compact), class: direction)
  end

  # Returns confirmation prompt text for delete action on the given object.
  #
  # @param [Object] object the object being deleted
  # @return [String] representing the text to show in the confirmation dialog.
  def confirm_delete_text(object)
    description = object.description if object.respond_to?(:description)

    if description.nil?
      t('confirm_delete_prompt.default')
    else
      t('confirm_delete_prompt.with_description', description: description)
    end
  end

  # here are some helpers to show what action we're using
  def edit?
    params[:action] == 'edit'
  end

  def show?
    params[:action] == 'show'
  end

  def new?
    params[:action] == 'new'
  end

  def create?
    params[:action] == 'create'
  end

  def update?
    params[:action] == 'update'
  end

  def edit_or_new?
    edit? || new? || create? || update?
  end

  def sorted?
    params[:sort].present?
  end # A view helper to make sure archived records point to the correct

  # route
  def show_polymorphic_url(object)
    method = if object.respond_to?(:source_class)
               "#{object.source_class.name.underscore}_url".intern
             else
               "#{object.class.name.underscore}_url".intern
             end
    send(method, object.id)
  end
end
