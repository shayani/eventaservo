# frozen_string_literal: true

module OrganizationsHelper
  def organization_logo(organization, size: :small)
    return unless organization.logo.attached?

    size = case size
           when :large then '128'
           when :medium then '48x48'
           else '20x20'
           end

    image_tag organization.logo.variant(resize: size), width: size
  end

  def display_organizations_for_event(event)
    content_tag(:div, class: 'organization-tags') do
      event.organizations.each do |organization|
        concat organization_tag(organization)
      end
    end
  end

  def organization_tag(organization)
    link_to organization_url(organization.short_name), class: 'tag' do
      content_tag(:div) do
        organization_logo(organization) +
          organization.short_name.upcase
      end
    end
  end
end