object @image
attributes *image_attributes
attributes :viewable_type, :viewable_id
styles = Spree::Image.attachment_definitions[:attachment][:styles].call('Spree::Product')
styles.each do |k,v|
  node("#{k}_url") { |i| i.attachment.url(k) }
end
