# frozen_string_literal: true

module HomeHelper
  def aktivaj_filtroj?
    if params[:periodo].present? || params[:o].present?
      true
    else
      false
    end
  end

  def traduki_periodon(periodo)
    case periodo
    when 'hodiau' then 'Okazas hodiaŭ'
    when 'p7_tagojn' then 'Proksimajn 7 tagojn'
    when 'p30_tagojn' then 'Proksimajn 30 tagojn'
    when 'estontece' then 'Estontece'
    else periodo
    end
  end
end
