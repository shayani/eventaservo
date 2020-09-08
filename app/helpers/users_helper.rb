# frozen_string_literal: true

module UsersHelper
  def display_user(user)
    content_tag(:span) do
      concat display_user_image(user)
      concat user.name
    end
  end

  def display_user_image(user)
    image =
      if user.picture.attached?
        url_for(user.picture.variant(resize: '42x42'))
      elsif user.image?
        user.image
      else
        'nekonata.jpg'
      end
    image_tag image, size: 40, class: 'user-photo-rounded' if image
  end

  def display_user_image_profile(user)
    image =
      if user.picture.attached?
        url_for(user.picture.variant(resize: '162x162'))
      elsif user.image?
        user.image
      else
        'nekonata.jpg'
      end
    image_tag image, size: 162, class: 'profile-picture' if image
  end

end
