# this patch add the ability to have multiple sort columns selected
# in the index view.
# rubocop:disable ClassAndModuleChildren
module Ransack::Helpers::FormHelper
  # rubocop:disable AbcSize
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable PerceivedComplexity
  def multi_sort_link(search_object, attribute, *args, &block)
    attr = []
    # the .fields method uses a __ which should be swapped out here
    attribute = attribute.to_s.gsub('__', '_')

    # first we extract any existing sorts in the params
    attr = Array.wrap(params[:q][:s]).compact if params[:q] && params[:q][:s]

    # now scan and look to see if we're already sortin on this column
    if attr.any? { |a| a.match(/^#{attribute} /) }
      attr.map! { |v|  v =~ /^#{attribute} / ? attribute : v }
    else
      # so we just stick it in the end
      attr << attribute
    end

    # now we stick this in the args
    if args[0].is_a?(Array)
      args[0] << attr
    else
      args.unshift(attr)
    end

    # now we pass it to the original sort_link
    sort_link search_object, attribute, *args, &block
  end
end
