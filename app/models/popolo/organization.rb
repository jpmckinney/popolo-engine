#require 'concerns/date_handler'
module Popolo
  # A group with a common purpose or reason for existence that goes beyond the
  # set of people belonging to it.
  class Organization
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Tree
    include DateHandler

    store_in Popolo.storage_options_per_class.fetch(:Organization, Popolo.storage_options)

    # The relationships to which the organization is a party.
    has_many :memberships, class_name: 'Popolo::Membership', dependent: :destroy, inverse_of: :organization
    # Posts within the organization.
    has_many :posts, class_name: 'Popolo::Post', dependent: :destroy
    # Alternate or former names.
    embeds_many :other_names, as: :nameable, class_name: 'Popolo::OtherName'
    # Issued identifiers.
    embeds_many :identifiers, as: :identifiable, class_name: 'Popolo::Identifier'
    # Means of contacting the organization.
    embeds_many :contact_details, as: :contactable, class_name: 'Popolo::ContactDetail'
    # URLs to documents about the organization.
    embeds_many :links, as: :linkable, class_name: 'Popolo::Link'
    # URLs to source documents about the organization.
    embeds_many :sources, as: :linkable, class_name: 'Popolo::Link'

    # A primary name, e.g. a legally recognized name.
    field :name, type: String
    # An organization category, e.g. committee.
    field :classification, type: String
    # A date of founding.
    field :founding_date, type: DateString
    # A date of dissolution.
    field :dissolution_date, type: DateString
    # A URL of an image.
    field :image, type: String

    validate :date_formats
    # @note Add URL validation to match JSON Schema?

    def to_s
      name
    end

    def date_formats
      validate_date_for(:founding_date)
      validate_date_for(:dissolution_date)
    end

  end
end
