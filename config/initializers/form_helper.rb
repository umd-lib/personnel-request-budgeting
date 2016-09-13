# this patch add the ability to have multiple sort columns selected
# in the index view.
# rubocop:disable ClassAndModuleChildren
module Ransack::Helpers::FormHelper
  # rubocop:disable AbcSize
  def multi_sort_link(search_object, attribute, *args, &block)
    # first we extract any existing sorts in the params
    attr = []
    if params[:q] && params[:q][:s]
      # remove any sorts that are one the current attr
      attr =  Array.wrap(params[:q][:s]).reject { |v| v.match(/^#{attribute.to_s}/) }
    end

    if args[0].is_a?(Array)
      args[0] << attr # we just stick in our extracted sorts
    else
      args.unshift(attr << attribute.to_s) # we add our sorts to the list
    end
    # now we pass it to the original sort_link
    sort_link search_object, attribute, *args, &block
  end
end
