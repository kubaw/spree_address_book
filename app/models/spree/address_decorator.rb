Spree::Address.class_eval do
  belongs_to :user, :class_name => Spree.user_class.to_s
  before_validation :create_address1
  attr_accessible :user_id, :deleted_at, :street, :house_no, :flat_no

  def self.required_fields
    validator = Spree::Address.validators.find{|v| v.kind_of?(ActiveModel::Validations::PresenceValidator)}
    validator ? validator.attributes : []
  end
  
  # TODO: look into if this is actually needed. I don't want to override methods unless it is really needed
  # can modify an address if it's not been used in an order
  def same_as?(other)
    return false if other.nil?
    attributes.except('id', 'updated_at', 'created_at', 'user_id') == other.attributes.except('id', 'updated_at', 'created_at', 'user_id')
  end
  
  # can modify an address if it's not been used in an completed order
  def editable?
    new_record? || (shipments.empty? && Spree::Order.complete.where("bill_address_id = ? OR ship_address_id = ?", self.id, self.id).count == 0)
  end

  def can_be_deleted?
    shipments.empty? && Spree::Order.where("bill_address_id = ? OR ship_address_id = ?", self.id, self.id).count == 0
  end

  def to_s
    [
      "#{firstname} #{lastname}",
      "#{address1}",
      "#{address2}",
      "#{zipcode} #{city}",
      "#{state || state_name}, #{country}"
    ].reject(&:empty?).join("<br/>").html_safe
  end

  # UPGRADE_CHECK if future versions of spree have a custom destroy function, this will break
  def destroy
    if can_be_deleted?
      super
    else
      update_column :deleted_at, Time.now
    end
  end

  private
    def create_address1
      self.address1 = ""
      self.address1 << self.street unless self.street.blank?
      self.address1 << " #{self.house_no}" unless self.house_no.blank?
      self.address1 << "/#{self.flat_no}" unless self.flat_no.blank?
    end
end
